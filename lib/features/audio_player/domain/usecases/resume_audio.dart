import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/player_repository.dart';

class ResumeAudio implements UseCase<void, NoParams> {
  final PlayerRepository repository;

  ResumeAudio(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.resume();
  }
}
