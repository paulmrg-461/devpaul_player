import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/audio_entity.dart';
import '../repositories/audio_repository.dart';

class GetAudioFiles implements UseCase<List<AudioEntity>, NoParams> {
  final AudioRepository repository;

  GetAudioFiles(this.repository);

  @override
  Future<Either<Failure, List<AudioEntity>>> call(NoParams params) async {
    return await repository.getAudioFiles();
  }
}
