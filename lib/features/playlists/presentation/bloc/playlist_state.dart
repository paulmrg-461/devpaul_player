part of 'playlist_bloc.dart';

abstract class PlaylistState extends Equatable {
  const PlaylistState();
  
  @override
  List<Object?> get props => [];
}

class PlaylistInitial extends PlaylistState {}

class PlaylistLoading extends PlaylistState {}

class PlaylistLoaded extends PlaylistState {
  final List<PlaylistEntity> playlists;

  const PlaylistLoaded({required this.playlists});

  @override
  List<Object> get props => [playlists];
}

class PlaylistAudiosLoaded extends PlaylistState {
  final List<AudioEntity> audios;

  const PlaylistAudiosLoaded({required this.audios});

  @override
  List<Object> get props => [audios];
}

class PlaylistOperationSuccess extends PlaylistState {
  final String message;

  const PlaylistOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class PlaylistError extends PlaylistState {
  final String message;

  const PlaylistError({required this.message});

  @override
  List<Object> get props => [message];
}
