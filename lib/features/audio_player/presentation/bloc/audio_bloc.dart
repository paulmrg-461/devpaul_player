import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_audio_files.dart';
import '../../domain/usecases/request_permission.dart';
import '../../domain/entities/audio_entity.dart';
import '../../../../core/usecase/usecase.dart';
import 'audio_event.dart';
import 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final GetAudioFiles getAudioFiles;
  final RequestPermission requestPermission;

  AudioBloc({
    required this.getAudioFiles,
    required this.requestPermission,
  }) : super(AudioInitial()) {
    on<LoadAudioFiles>(_onLoadAudioFiles);
    on<SearchAudioEvent>(_onSearchAudioEvent);
  }

  Future<void> _onLoadAudioFiles(LoadAudioFiles event, Emitter<AudioState> emit) async {
    emit(AudioLoading());
    final permissionResult = await requestPermission(NoParams());
    
    await permissionResult.fold(
      (failure) async => emit(const AudioError("Permission denied")),
      (granted) async {
        if (granted) {
            final result = await getAudioFiles(NoParams());
            result.fold(
              (failure) => emit(AudioError(failure.toString())),
              (songs) {
                final songsByArtist = _groupSongsByArtist(songs);
                final songsByFolder = _groupSongsByFolder(songs);
                
                emit(AudioLoaded(
                  allSongs: songs, 
                  filteredSongs: songs,
                  songsByArtist: songsByArtist,
                  songsByFolder: songsByFolder,
                ));
              },
            );
        } else {
            emit(const AudioError("Permission denied"));
        }
      },
    );
  }

  void _onSearchAudioEvent(SearchAudioEvent event, Emitter<AudioState> emit) {
    if (state is AudioLoaded) {
      final currentState = state as AudioLoaded;
      final query = event.query.toLowerCase();
      
      if (query.isEmpty) {
        emit(AudioLoaded(
          allSongs: currentState.allSongs,
          filteredSongs: currentState.allSongs,
          songsByArtist: currentState.songsByArtist,
          songsByFolder: currentState.songsByFolder,
        ));
      } else {
        final filtered = currentState.allSongs.where((song) {
          return song.title.toLowerCase().contains(query) || 
                 song.artist.toLowerCase().contains(query);
        }).toList();
        
        emit(AudioLoaded(
          allSongs: currentState.allSongs,
          filteredSongs: filtered,
          songsByArtist: currentState.songsByArtist,
          songsByFolder: currentState.songsByFolder,
        ));
      }
    }
  }

  Map<String, List<AudioEntity>> _groupSongsByArtist(List<AudioEntity> songs) {
    final Map<String, List<AudioEntity>> grouped = {};
    for (var song in songs) {
      final artist = song.artist.isEmpty ? "Unknown Artist" : song.artist;
      if (!grouped.containsKey(artist)) {
        grouped[artist] = [];
      }
      grouped[artist]!.add(song);
    }
    return grouped;
  }

  Map<String, List<AudioEntity>> _groupSongsByFolder(List<AudioEntity> songs) {
    final Map<String, List<AudioEntity>> grouped = {};
    for (var song in songs) {
      if (song.path.isEmpty) continue;
      
      // Simple folder extraction
      final parts = song.path.split('/');
      if (parts.length > 1) {
        // Remove the file name to get the folder
        parts.removeLast();
        // Get the last part as the folder name
        final folderName = parts.last;
        
        if (folderName.isEmpty) continue;

        if (!grouped.containsKey(folderName)) {
          grouped[folderName] = [];
        }
        grouped[folderName]!.add(song);
      }
    }
    return grouped;
  }
}
