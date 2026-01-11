import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:devpaul_player/core/usecase/usecase.dart';
import 'package:devpaul_player/features/audio_player/domain/entities/audio_entity.dart';
import 'package:devpaul_player/features/audio_player/domain/usecases/get_player_streams.dart';
import 'package:devpaul_player/features/audio_player/domain/usecases/pause_audio.dart';
import 'package:devpaul_player/features/audio_player/domain/usecases/play_audio.dart';
import 'package:devpaul_player/features/audio_player/domain/usecases/resume_audio.dart';
import 'package:devpaul_player/features/audio_player/domain/usecases/seek_audio.dart';
import 'package:devpaul_player/features/audio_player/presentation/bloc/player/player_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPlayAudio extends Mock implements PlayAudio {}
class MockPauseAudio extends Mock implements PauseAudio {}
class MockResumeAudio extends Mock implements ResumeAudio {}
class MockSeekAudio extends Mock implements SeekAudio {}
class MockGetPlayerStreams extends Mock implements GetPlayerStreams {}

class FakeAudioEntity extends Fake implements AudioEntity {}

void main() {
  late PlayerBloc playerBloc;
  late MockPlayAudio mockPlayAudio;
  late MockPauseAudio mockPauseAudio;
  late MockResumeAudio mockResumeAudio;
  late MockSeekAudio mockSeekAudio;
  late MockGetPlayerStreams mockGetPlayerStreams;

  setUpAll(() {
    registerFallbackValue(FakeAudioEntity());
  });

  setUp(() {
    mockPlayAudio = MockPlayAudio();
    mockPauseAudio = MockPauseAudio();
    mockResumeAudio = MockResumeAudio();
    mockSeekAudio = MockSeekAudio();
    mockGetPlayerStreams = MockGetPlayerStreams();

    when(() => mockGetPlayerStreams.isPlayingStream).thenAnswer((_) => Stream.value(false));
    when(() => mockGetPlayerStreams.positionStream).thenAnswer((_) => Stream.value(Duration.zero));
    when(() => mockGetPlayerStreams.durationStream).thenAnswer((_) => Stream.value(Duration.zero));
    when(() => mockGetPlayerStreams.currentAudioStream).thenAnswer((_) => Stream.value(null));

    playerBloc = PlayerBloc(
      playAudio: mockPlayAudio,
      pauseAudio: mockPauseAudio,
      resumeAudio: mockResumeAudio,
      seekAudio: mockSeekAudio,
      getPlayerStreams: mockGetPlayerStreams,
    );
  });

  tearDown(() {
    playerBloc.close();
  });

  const tAudio = AudioEntity(
    id: 1,
    title: 'Test Song',
    artist: 'Test Artist',
    uri: 'path/to/song',
    duration: 1000,
  );

  group('PlayerBloc', () {
    test('initial state is correct', () {
      expect(playerBloc.state, const PlayerState());
    });

    blocTest<PlayerBloc, PlayerState>(
      'calls PlayAudio usecase when PlayEvent is added',
      build: () {
        when(() => mockPlayAudio(any())).thenAnswer((_) async => const Right(null));
        return playerBloc;
      },
      act: (bloc) => bloc.add(const PlayEvent(tAudio)),
      verify: (_) {
        verify(() => mockPlayAudio(tAudio)).called(1);
      },
    );

    blocTest<PlayerBloc, PlayerState>(
      'emits updated state when UpdatePlayerStateEvent is added',
      build: () => playerBloc,
      act: (bloc) => bloc.add(const UpdatePlayerStateEvent(isPlaying: true)),
      expect: () => [
        const PlayerState(isPlaying: true),
      ],
    );
  });
}
