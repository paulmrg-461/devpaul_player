import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/playlist_entity.dart';
import '../repositories/playlist_repository.dart';

class GetPlaylists implements UseCase<List<PlaylistEntity>, NoParams> {
  final PlaylistRepository repository;

  GetPlaylists(this.repository);

  @override
  Future<Either<Failure, List<PlaylistEntity>>> call(NoParams params) async {
    return await repository.getPlaylists();
  }
}
