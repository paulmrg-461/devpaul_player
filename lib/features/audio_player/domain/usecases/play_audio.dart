import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/audio_entity.dart';
import '../repositories/player_repository.dart';

class PlayAudio implements UseCase<void, AudioEntity> {
  final PlayerRepository repository;

  PlayAudio(this.repository);

  @override
  Future<Either<Failure, void>> call(AudioEntity params) async {
    return await repository.play(params);
  }
}
