import 'package:equatable/equatable.dart';

class PlaylistEntity extends Equatable {
  final int id;
  final String name;
  final int numOfSongs;

  const PlaylistEntity({
    required this.id,
    required this.name,
    required this.numOfSongs,
  });

  @override
  List<Object?> get props => [id, name, numOfSongs];
}
