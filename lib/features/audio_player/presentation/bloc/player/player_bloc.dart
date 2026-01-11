import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../domain/entities/audio_entity.dart';
import '../../../domain/usecases/get_player_streams.dart';
import '../../../domain/usecases/pause_audio.dart';
import '../../../domain/usecases/play_audio.dart';
import '../../../domain/usecases/resume_audio.dart';
import '../../../domain/usecases/seek_audio.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final PlayAudio playAudio;
  final PauseAudio pauseAudio;
  final ResumeAudio resumeAudio;
  final SeekAudio seekAudio;
  final GetPlayerStreams getPlayerStreams;

  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playingSubscription;
  StreamSubscription? _currentAudioSubscription;

  PlayerBloc({
    required this.playAudio,
    required this.pauseAudio,
    required this.resumeAudio,
    required this.seekAudio,
    required this.getPlayerStreams,
  }) : super(const PlayerState()) {
    on<PlayEvent>(_onPlay);
    on<PauseEvent>(_onPause);
    on<ResumeEvent>(_onResume);
    on<SeekEvent>(_onSeek);
    on<UpdatePlayerStateEvent>(_onUpdateState);

    _initStreams();
  }

  void _initStreams() {
    _positionSubscription = getPlayerStreams.positionStream.listen((position) {
      add(UpdatePlayerStateEvent(position: position));
    });
    _durationSubscription = getPlayerStreams.durationStream.listen((duration) {
      add(UpdatePlayerStateEvent(duration: duration));
    });
    _playingSubscription = getPlayerStreams.isPlayingStream.listen((isPlaying) {
      add(UpdatePlayerStateEvent(isPlaying: isPlaying));
    });
    _currentAudioSubscription = getPlayerStreams.currentAudioStream.listen((audio) {
      add(UpdatePlayerStateEvent(currentAudio: audio));
    });
  }

  Future<void> _onPlay(PlayEvent event, Emitter<PlayerState> emit) async {
    await playAudio(event.audio);
  }

  Future<void> _onPause(PauseEvent event, Emitter<PlayerState> emit) async {
    await pauseAudio(NoParams());
  }

  Future<void> _onResume(ResumeEvent event, Emitter<PlayerState> emit) async {
    await resumeAudio(NoParams());
  }

  Future<void> _onSeek(SeekEvent event, Emitter<PlayerState> emit) async {
    await seekAudio(event.position);
  }

  void _onUpdateState(UpdatePlayerStateEvent event, Emitter<PlayerState> emit) {
    emit(state.copyWith(
      isPlaying: event.isPlaying,
      position: event.position,
      duration: event.duration,
      currentAudio: event.currentAudio,
    ));
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playingSubscription?.cancel();
    _currentAudioSubscription?.cancel();
    return super.close();
  }
}
