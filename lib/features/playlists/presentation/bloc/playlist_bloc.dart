import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../audio_player/domain/entities/audio_entity.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/usecases/add_audio_to_playlist.dart';
import '../../domain/usecases/create_playlist.dart';
import '../../domain/usecases/get_playlist_audios.dart';
import '../../domain/usecases/get_playlists.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final GetPlaylists getPlaylists;
  final CreatePlaylist createPlaylist;
  final AddAudioToPlaylist addAudioToPlaylist;
  final GetPlaylistAudios getPlaylistAudios;

  PlaylistBloc({
    required this.getPlaylists,
    required this.createPlaylist,
    required this.addAudioToPlaylist,
    required this.getPlaylistAudios,
  }) : super(PlaylistInitial()) {
    on<LoadPlaylistsEvent>(_onLoadPlaylists);
    on<CreatePlaylistEvent>(_onCreatePlaylist);
    on<AddAudioToPlaylistEvent>(_onAddAudioToPlaylist);
    on<LoadPlaylistAudiosEvent>(_onLoadPlaylistAudios);
  }

  Future<void> _onLoadPlaylists(LoadPlaylistsEvent event, Emitter<PlaylistState> emit) async {
    emit(PlaylistLoading());
    final result = await getPlaylists(NoParams());
    result.fold(
      (failure) => emit(const PlaylistError(message: 'Error loading playlists')),
      (playlists) => emit(PlaylistLoaded(playlists: playlists)),
    );
  }

  Future<void> _onCreatePlaylist(CreatePlaylistEvent event, Emitter<PlaylistState> emit) async {
    final result = await createPlaylist(CreatePlaylistParams(name: event.name));
    result.fold(
      (failure) => emit(const PlaylistError(message: 'Error creating playlist')),
      (success) {
        if (success) {
          add(LoadPlaylistsEvent());
        } else {
           emit(const PlaylistError(message: 'Failed to create playlist'));
        }
      },
    );
  }

  Future<void> _onAddAudioToPlaylist(AddAudioToPlaylistEvent event, Emitter<PlaylistState> emit) async {
     final result = await addAudioToPlaylist(AddAudioToPlaylistParams(playlistId: event.playlistId, audioId: event.audioId));
     result.fold(
       (failure) => emit(const PlaylistError(message: 'Error adding song to playlist')),
       (success) => emit(const PlaylistOperationSuccess(message: 'Song added to playlist')),
     );
  }

  Future<void> _onLoadPlaylistAudios(LoadPlaylistAudiosEvent event, Emitter<PlaylistState> emit) async {
    emit(PlaylistLoading());
    final result = await getPlaylistAudios(GetPlaylistAudiosParams(playlistId: event.playlistId));
    result.fold(
      (failure) => emit(const PlaylistError(message: 'Error loading playlist songs')),
      (audios) => emit(PlaylistAudiosLoaded(audios: audios)),
    );
  }
}
