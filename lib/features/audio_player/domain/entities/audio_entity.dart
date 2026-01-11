import 'package:equatable/equatable.dart';

class AudioEntity extends Equatable {
  final int id;
  final String title;
  final String artist;
  final String? album;
  final String uri;
  final String path;
  final int duration;

  const AudioEntity({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    required this.uri,
    required this.path,
    required this.duration,
  });

  @override
  List<Object?> get props => [id, title, artist, album, uri, path, duration];
}
