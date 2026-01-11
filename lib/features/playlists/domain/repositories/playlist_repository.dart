import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../audio_player/domain/entities/audio_entity.dart';
import '../entities/playlist_entity.dart';

abstract class PlaylistRepository {
  Future<Either<Failure, List<PlaylistEntity>>> getPlaylists();
  Future<Either<Failure, bool>> createPlaylist(String name);
  Future<Either<Failure, bool>> addAudioToPlaylist(int playlistId, int audioId);
  Future<Either<Failure, List<AudioEntity>>> getPlaylistAudios(int playlistId);
}
