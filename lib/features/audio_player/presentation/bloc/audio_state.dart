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
  final Map<String, List<AudioEntity>> songsByArtist;
  final Map<String, List<AudioEntity>> songsByFolder;

  const AudioLoaded({
    required this.allSongs,
    required this.filteredSongs,
    this.songsByArtist = const {},
    this.songsByFolder = const {},
  });
  
  @override
  List<Object> get props => [allSongs, filteredSongs, songsByArtist, songsByFolder];
}
class AudioError extends AudioState {
  final String message;
  const AudioError(this.message);
  
  @override
  List<Object> get props => [message];
}
