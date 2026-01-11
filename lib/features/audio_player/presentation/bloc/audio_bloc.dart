import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_audio_files.dart';
import '../../domain/usecases/request_permission.dart';
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
              (songs) => emit(AudioLoaded(allSongs: songs, filteredSongs: songs)),
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
        ));
      } else {
        final filtered = currentState.allSongs.where((song) {
          return song.title.toLowerCase().contains(query) || 
                 song.artist.toLowerCase().contains(query);
        }).toList();
        
        emit(AudioLoaded(
          allSongs: currentState.allSongs,
          filteredSongs: filtered,
        ));
      }
    }
  }
}
