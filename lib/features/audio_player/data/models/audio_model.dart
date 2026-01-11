import 'package:on_audio_query/on_audio_query.dart';
import '../../domain/entities/audio_entity.dart';

class AudioModel extends AudioEntity {
  const AudioModel({
    required super.id,
    required super.title,
    required super.artist,
    super.album,
    required super.uri,
    required super.duration,
  });

  factory AudioModel.fromModel(SongModel model) {
    return AudioModel(
      id: model.id,
      title: model.title,
      artist: model.artist ?? "Unknown Artist",
      album: model.album,
      uri: model.uri ?? "",
      duration: model.duration ?? 0,
    );
  }
}
