import 'package:on_audio_query/on_audio_query.dart' as on_audio;
import '../../domain/entities/playlist_entity.dart';

class PlaylistModel extends PlaylistEntity {
  const PlaylistModel({
    required int id,
    required String name,
    required int numOfSongs,
  }) : super(id: id, name: name, numOfSongs: numOfSongs);

  factory PlaylistModel.fromOnAudioQuery(on_audio.PlaylistModel model) {
    return PlaylistModel(
      id: model.id,
      name: model.playlist,
      numOfSongs: model.numOfSongs,
    );
  }
}
