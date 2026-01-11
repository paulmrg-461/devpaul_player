part of 'playlist_bloc.dart';

abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object> get props => [];
}

class LoadPlaylistsEvent extends PlaylistEvent {}

class CreatePlaylistEvent extends PlaylistEvent {
  final String name;

  const CreatePlaylistEvent(this.name);

  @override
  List<Object> get props => [name];
}

class AddAudioToPlaylistEvent extends PlaylistEvent {
  final int playlistId;
  final int audioId;

  const AddAudioToPlaylistEvent({required this.playlistId, required this.audioId});

  @override
  List<Object> get props => [playlistId, audioId];
}

class LoadPlaylistAudiosEvent extends PlaylistEvent {
  final int playlistId;

  const LoadPlaylistAudiosEvent(this.playlistId);

  @override
  List<Object> get props => [playlistId];
}
