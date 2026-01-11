import 'package:equatable/equatable.dart';
import '../../domain/entities/audio_entity.dart';

abstract class AudioState extends Equatable {
  const AudioState();
  
  @override
  List<Object> get props => [];
}

class AudioInitial extends AudioState {}
class AudioLoading extends AudioState {}
class AudioLoaded extends AudioState {
  final List<AudioEntity> allSongs;
  final List<AudioEntity> filteredSongs;

  const AudioLoaded({
    required this.allSongs,
    required this.filteredSongs,
  });
  
  @override
  List<Object> get props => [allSongs, filteredSongs];
}
class AudioError extends AudioState {
  final String message;
  const AudioError(this.message);
  
  @override
  List<Object> get props => [message];
}
