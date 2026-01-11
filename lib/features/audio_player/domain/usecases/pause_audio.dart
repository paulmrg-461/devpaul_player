import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/player_repository.dart';

class PauseAudio implements UseCase<void, NoParams> {
  final PlayerRepository repository;

  PauseAudio(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.pause();
  }
}
