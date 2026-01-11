part of 'player_bloc.dart';

class PlayerState extends Equatable {
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final AudioEntity? currentAudio;

  const PlayerState({
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.currentAudio,
  });

  PlayerState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    AudioEntity? currentAudio,
    bool clearAudio = false,
  }) {
    return PlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      currentAudio: clearAudio ? null : (currentAudio ?? this.currentAudio),
    );
  }

  @override
  List<Object?> get props => [isPlaying, position, duration, currentAudio];
}
