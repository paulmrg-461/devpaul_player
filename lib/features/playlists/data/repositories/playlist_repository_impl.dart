import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../audio_player/domain/entities/audio_entity.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../datasources/playlist_local_data_source.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final PlaylistLocalDataSource localDataSource;

  PlaylistRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<PlaylistEntity>>> getPlaylists() async {
    try {
      final result = await localDataSource.getPlaylists();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> createPlaylist(String name) async {
    try {
      final result = await localDataSource.createPlaylist(name);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> addAudioToPlaylist(int playlistId, int audioId) async {
    try {
      final result = await localDataSource.addAudioToPlaylist(playlistId, audioId);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<AudioEntity>>> getPlaylistAudios(int playlistId) async {
    try {
      final result = await localDataSource.getPlaylistAudios(playlistId);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
