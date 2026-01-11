import '../entities/audio_entity.dart';
import '../repositories/player_repository.dart';

class GetPlayerStreams {
  final PlayerRepository repository;

  GetPlayerStreams(this.repository);

  Stream<bool> get isPlayingStream => repository.isPlayingStream;
  Stream<Duration> get positionStream => repository.positionStream;
  Stream<Duration> get durationStream => repository.durationStream;
  Stream<AudioEntity?> get currentAudioStream => repository.currentAudioStream;
}
