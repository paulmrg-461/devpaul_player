import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:devpaul_player/core/usecase/usecase.dart';
import 'package:devpaul_player/features/audio_player/domain/entities/audio_entity.dart';
import 'package:devpaul_player/features/audio_player/domain/usecases/get_audio_files.dart';
import 'package:devpaul_player/features/audio_player/domain/usecases/request_permission.dart';
import 'package:devpaul_player/features/audio_player/presentation/bloc/audio_bloc.dart';
import 'package:devpaul_player/features/audio_player/presentation/bloc/audio_event.dart';
import 'package:devpaul_player/features/audio_player/presentation/bloc/audio_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAudioFiles extends Mock implements GetAudioFiles {}
class MockRequestPermission extends Mock implements RequestPermission {}
class FakeNoParams extends Fake implements NoParams {}

void main() {
  late AudioBloc audioBloc;
  late MockGetAudioFiles mockGetAudioFiles;
  late MockRequestPermission mockRequestPermission;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetAudioFiles = MockGetAudioFiles();
    mockRequestPermission = MockRequestPermission();
    audioBloc = AudioBloc(
      getAudioFiles: mockGetAudioFiles,
      requestPermission: mockRequestPermission,
    );
  });

  tearDown(() {
    audioBloc.close();
  });

  final tAudioList = [
    const AudioEntity(
      id: 1,
      title: 'Song One',
      artist: 'Artist A',
      album: 'Album X',
      uri: 'uri/1',
      duration: 100,
    ),
    const AudioEntity(
      id: 2,
      title: 'Song Two',
      artist: 'Artist B',
      album: 'Album Y',
      uri: 'uri/2',
      duration: 200,
    ),
  ];

  test('initial state should be AudioInitial', () {
    expect(audioBloc.state, equals(AudioInitial()));
  });

  group('LoadAudioFiles', () {
    test('should emit [AudioLoading, AudioLoaded] when permission granted and data gets loaded', () async {
      // arrange
      when(() => mockRequestPermission(any()))
          .thenAnswer((_) async => const Right(true));
      when(() => mockGetAudioFiles(any()))
          .thenAnswer((_) async => Right(tAudioList));
      
      // assert later
      final expected = [
        AudioLoading(),
        AudioLoaded(allSongs: tAudioList, filteredSongs: tAudioList),
      ];
      
      expectLater(audioBloc.stream, emitsInOrder(expected));
      
      // act
      audioBloc.add(LoadAudioFiles());
    });

    test('should emit [AudioLoading, AudioError] when permission denied', () async {
      // arrange
      when(() => mockRequestPermission(any()))
          .thenAnswer((_) async => const Right(false));
      
      // assert later
      final expected = [
        AudioLoading(),
        const AudioError("Permission denied"),
      ];
      
      expectLater(audioBloc.stream, emitsInOrder(expected));
      
      // act
      audioBloc.add(LoadAudioFiles());
    });
  });

  group('SearchAudioEvent', () {
    blocTest<AudioBloc, AudioState>(
      'should filter songs based on query',
      build: () {
        when(() => mockRequestPermission(any()))
            .thenAnswer((_) async => const Right(true));
        when(() => mockGetAudioFiles(any()))
            .thenAnswer((_) async => Right(tAudioList));
        return AudioBloc(
          getAudioFiles: mockGetAudioFiles,
          requestPermission: mockRequestPermission,
        );
      },
      act: (bloc) async {
        bloc.add(LoadAudioFiles());
        await Future.delayed(Duration.zero);
        bloc.add(const SearchAudioEvent('One'));
      },
      expect: () => [
        AudioLoading(),
        AudioLoaded(allSongs: tAudioList, filteredSongs: tAudioList),
        AudioLoaded(
          allSongs: tAudioList, 
          filteredSongs: [tAudioList[0]]
        ),
      ],
    );

    blocTest<AudioBloc, AudioState>(
      'should return all songs when query is empty',
      build: () {
        when(() => mockRequestPermission(any()))
            .thenAnswer((_) async => const Right(true));
        when(() => mockGetAudioFiles(any()))
            .thenAnswer((_) async => Right(tAudioList));
        return AudioBloc(
            getAudioFiles: mockGetAudioFiles,
            requestPermission: mockRequestPermission,
        );
      },
      act: (bloc) async {
        bloc.add(LoadAudioFiles());
        await Future.delayed(Duration.zero);
        bloc.add(const SearchAudioEvent('One')); // filter first
        bloc.add(const SearchAudioEvent('')); // then clear
      },
      expect: () => [
        AudioLoading(),
        AudioLoaded(allSongs: tAudioList, filteredSongs: tAudioList),
        AudioLoaded(allSongs: tAudioList, filteredSongs: [tAudioList[0]]),
        AudioLoaded(allSongs: tAudioList, filteredSongs: tAudioList),
      ],
    );
    
    blocTest<AudioBloc, AudioState>(
      'should be case insensitive',
      build: () {
        when(() => mockRequestPermission(any()))
            .thenAnswer((_) async => const Right(true));
        when(() => mockGetAudioFiles(any()))
            .thenAnswer((_) async => Right(tAudioList));
        return AudioBloc(
            getAudioFiles: mockGetAudioFiles,
            requestPermission: mockRequestPermission,
        );
      },
      act: (bloc) async {
        bloc.add(LoadAudioFiles());
        await Future.delayed(Duration.zero);
        bloc.add(const SearchAudioEvent('artist b')); 
      },
      expect: () => [
        AudioLoading(),
        AudioLoaded(allSongs: tAudioList, filteredSongs: tAudioList),
        AudioLoaded(allSongs: tAudioList, filteredSongs: [tAudioList[1]]),
      ],
    );
  });
}
