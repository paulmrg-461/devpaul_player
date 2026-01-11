import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/audio_entity.dart';

abstract class PlayerRepository {
  Future<Either<Failure, void>> play(AudioEntity audio);
  Future<Either<Failure, void>> pause();
  Future<Either<Failure, void>> resume();
  Future<Either<Failure, void>> seek(Duration position);
  
  Stream<Duration> get positionStream;
  Stream<Duration> get durationStream;
  Stream<bool> get isPlayingStream;
  Stream<AudioEntity?> get currentAudioStream;
}
