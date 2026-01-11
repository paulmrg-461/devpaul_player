import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/audio_repository.dart';

class RequestPermission implements UseCase<bool, NoParams> {
  final AudioRepository repository;

  RequestPermission(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.requestPermission();
  }
}
