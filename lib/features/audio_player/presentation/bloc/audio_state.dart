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
  final List<AudioEntity> songs;
  const AudioLoaded(this.songs);
  
  @override
  List<Object> get props => [songs];
}
class AudioError extends AudioState {
  final String message;
  const AudioError(this.message);
  
  @override
  List<Object> get props => [message];
}
