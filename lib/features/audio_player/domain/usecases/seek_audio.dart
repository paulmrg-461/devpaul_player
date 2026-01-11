import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/player_repository.dart';

class SeekAudio implements UseCase<void, Duration> {
  final PlayerRepository repository;

  SeekAudio(this.repository);

  @override
  Future<Either<Failure, void>> call(Duration params) async {
    return await repository.seek(params);
  }
}
