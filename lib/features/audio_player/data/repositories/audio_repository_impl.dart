import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/audio_entity.dart';
import '../../domain/repositories/audio_repository.dart';
import '../datasources/audio_local_data_source.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioLocalDataSource localDataSource;

  AudioRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<AudioEntity>>> getAudioFiles() async {
    try {
      final result = await localDataSource.getAudioFiles();
      return Right(result);
    } catch (e) {
      return Left(AudioQueryFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> requestPermission() async {
    try {
      final result = await localDataSource.requestPermission();
      return Right(result);
    } catch (e) {
      return Left(PermissionFailure());
    }
  }
}
