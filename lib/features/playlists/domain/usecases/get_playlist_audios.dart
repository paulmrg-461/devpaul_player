import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../audio_player/domain/entities/audio_entity.dart';
import '../repositories/playlist_repository.dart';

class GetPlaylistAudios implements UseCase<List<AudioEntity>, GetPlaylistAudiosParams> {
  final PlaylistRepository repository;

  GetPlaylistAudios(this.repository);

  @override
  Future<Either<Failure, List<AudioEntity>>> call(GetPlaylistAudiosParams params) async {
    return await repository.getPlaylistAudios(params.playlistId);
  }
}

class GetPlaylistAudiosParams extends Equatable {
  final int playlistId;

  const GetPlaylistAudiosParams({required this.playlistId});

  @override
  List<Object> get props => [playlistId];
}
