import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/audio_entity.dart';

abstract class AudioRepository {
  Future<Either<Failure, List<AudioEntity>>> getAudioFiles();
  Future<Either<Failure, bool>> requestPermission();
}
