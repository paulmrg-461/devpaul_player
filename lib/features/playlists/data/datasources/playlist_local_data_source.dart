import 'package:on_audio_query/on_audio_query.dart';
import '../../../../core/errors/failure.dart';
import '../../../audio_player/data/models/audio_model.dart';
import '../models/playlist_model.dart';

abstract class PlaylistLocalDataSource {
  Future<List<PlaylistModel>> getPlaylists();
  Future<bool> createPlaylist(String name);
  Future<bool> addAudioToPlaylist(int playlistId, int audioId);
  Future<List<AudioModel>> getPlaylistAudios(int playlistId);
}

class PlaylistLocalDataSourceImpl implements PlaylistLocalDataSource {
  final OnAudioQuery audioQuery;

  PlaylistLocalDataSourceImpl({required this.audioQuery});

  @override
  Future<List<PlaylistModel>> getPlaylists() async {
    try {
      final playlists = await audioQuery.queryPlaylists(
        sortType: PlaylistSortType.DATE_ADDED,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      return playlists.map((e) => PlaylistModel.fromOnAudioQuery(e)).toList();
    } catch (e) {
      throw CacheFailure();
    }
  }

  @override
  Future<bool> createPlaylist(String name) async {
    try {
      return await audioQuery.createPlaylist(name);
    } catch (e) {
      throw CacheFailure();
    }
  }

  @override
  Future<bool> addAudioToPlaylist(int playlistId, int audioId) async {
    try {
      return await audioQuery.addToPlaylist(playlistId, audioId);
    } catch (e) {
      throw CacheFailure();
    }
  }

  @override
  Future<List<AudioModel>> getPlaylistAudios(int playlistId) async {
    try {
      final songs = await audioQuery.queryAudiosFrom(
        AudiosFromType.PLAYLIST,
        playlistId,
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        ignoreCase: true,
      );
      return songs.map((e) => AudioModel.fromModel(e)).toList();
    } catch (e) {
      throw CacheFailure();
    }
  }
}
