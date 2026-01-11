part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

class PlayEvent extends PlayerEvent {
  final AudioEntity audio;
  const PlayEvent(this.audio);
  
  @override
  List<Object> get props => [audio];
}

class PauseEvent extends PlayerEvent {}

class ResumeEvent extends PlayerEvent {}

class SeekEvent extends PlayerEvent {
  final Duration position;
  const SeekEvent(this.position);
  
  @override
  List<Object> get props => [position];
}

class UpdatePlayerStateEvent extends PlayerEvent {
  final bool? isPlaying;
  final Duration? position;
  final Duration? duration;
  final AudioEntity? currentAudio;

  const UpdatePlayerStateEvent({
    this.isPlaying,
    this.position,
    this.duration,
    this.currentAudio,
  });
  
  @override
  List<Object?> get props => [isPlaying, position, duration, currentAudio];
}
