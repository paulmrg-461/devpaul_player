import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/playlist_repository.dart';

class AddAudioToPlaylist implements UseCase<bool, AddAudioToPlaylistParams> {
  final PlaylistRepository repository;

  AddAudioToPlaylist(this.repository);

  @override
  Future<Either<Failure, bool>> call(AddAudioToPlaylistParams params) async {
    return await repository.addAudioToPlaylist(params.playlistId, params.audioId);
  }
}

class AddAudioToPlaylistParams extends Equatable {
  final int playlistId;
  final int audioId;

  const AddAudioToPlaylistParams({required this.playlistId, required this.audioId});

  @override
  List<Object> get props => [playlistId, audioId];
}
