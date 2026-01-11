import 'package:on_audio_query/on_audio_query.dart';
import '../models/audio_model.dart';

abstract class AudioLocalDataSource {
  Future<List<AudioModel>> getAudioFiles();
  Future<bool> requestPermission();
}

class AudioLocalDataSourceImpl implements AudioLocalDataSource {
  final OnAudioQuery audioQuery;

  AudioLocalDataSourceImpl({required this.audioQuery});

  @override
  Future<List<AudioModel>> getAudioFiles() async {
    try {
      List<SongModel> songs = await audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      return songs.map((e) => AudioModel.fromModel(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> requestPermission() async {
    return await audioQuery.permissionsRequest();
  }
}
