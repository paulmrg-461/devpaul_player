import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/playlist_repository.dart';

class CreatePlaylist implements UseCase<bool, CreatePlaylistParams> {
  final PlaylistRepository repository;

  CreatePlaylist(this.repository);

  @override
  Future<Either<Failure, bool>> call(CreatePlaylistParams params) async {
    return await repository.createPlaylist(params.name);
  }
}

class CreatePlaylistParams extends Equatable {
  final String name;

  const CreatePlaylistParams({required this.name});

  @override
  List<Object> get props => [name];
}
