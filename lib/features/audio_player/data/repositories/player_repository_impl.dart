import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/audio_entity.dart';
import '../../domain/repositories/player_repository.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final AudioPlayer audioPlayer;
  
  // Cache current audio to emit in stream
  final BehaviorSubject<AudioEntity?> _currentAudioSubject = BehaviorSubject<AudioEntity?>.seeded(null);

  PlayerRepositoryImpl({required this.audioPlayer});

  @override
  Stream<AudioEntity?> get currentAudioStream => _currentAudioSubject.stream;

  @override
  Stream<Duration> get durationStream => audioPlayer.durationStream.map((d) => d ?? Duration.zero);

  @override
  Stream<bool> get isPlayingStream => audioPlayer.playerStateStream.map((state) => state.playing);

  @override
  Stream<Duration> get positionStream => audioPlayer.positionStream;

  @override
  Future<Either<Failure, void>> play(AudioEntity audio) async {
    try {
      _currentAudioSubject.add(audio);
      await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audio.uri)));
      await audioPlayer.play();
      return const Right(null);
    } catch (e) {
      return Left(AudioQueryFailure(e.toString())); // Reusing existing failure for simplicity
    }
  }

  @override
  Future<Either<Failure, void>> pause() async {
    try {
      await audioPlayer.pause();
      return const Right(null);
    } catch (e) {
      return Left(AudioQueryFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resume() async {
    try {
      await audioPlayer.play();
      return const Right(null);
    } catch (e) {
      return Left(AudioQueryFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> seek(Duration position) async {
    try {
      await audioPlayer.seek(position);
      return const Right(null);
    } catch (e) {
      return Left(AudioQueryFailure(e.toString()));
    }
  }
}
