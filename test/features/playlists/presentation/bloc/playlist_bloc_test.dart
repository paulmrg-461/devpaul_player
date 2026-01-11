import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:devpaul_player/core/usecase/usecase.dart';
import 'package:devpaul_player/features/playlists/domain/entities/playlist_entity.dart';
import 'package:devpaul_player/features/playlists/domain/usecases/add_audio_to_playlist.dart';
import 'package:devpaul_player/features/playlists/domain/usecases/create_playlist.dart';
import 'package:devpaul_player/features/playlists/domain/usecases/get_playlist_audios.dart';
import 'package:devpaul_player/features/playlists/domain/usecases/get_playlists.dart';
import 'package:devpaul_player/features/playlists/presentation/bloc/playlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPlaylists extends Mock implements GetPlaylists {}
class MockCreatePlaylist extends Mock implements CreatePlaylist {}
class MockAddAudioToPlaylist extends Mock implements AddAudioToPlaylist {}
class MockGetPlaylistAudios extends Mock implements GetPlaylistAudios {}

void main() {
  late PlaylistBloc playlistBloc;
  late MockGetPlaylists mockGetPlaylists;
  late MockCreatePlaylist mockCreatePlaylist;
  late MockAddAudioToPlaylist mockAddAudioToPlaylist;
  late MockGetPlaylistAudios mockGetPlaylistAudios;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetPlaylists = MockGetPlaylists();
    mockCreatePlaylist = MockCreatePlaylist();
    mockAddAudioToPlaylist = MockAddAudioToPlaylist();
    mockGetPlaylistAudios = MockGetPlaylistAudios();

    playlistBloc = PlaylistBloc(
      getPlaylists: mockGetPlaylists,
      createPlaylist: mockCreatePlaylist,
      addAudioToPlaylist: mockAddAudioToPlaylist,
      getPlaylistAudios: mockGetPlaylistAudios,
    );
  });

  tearDown(() {
    playlistBloc.close();
  });

  const tPlaylist = PlaylistEntity(id: 1, name: 'My Playlist', numOfSongs: 0);
  final tPlaylists = [tPlaylist];

  group('PlaylistBloc', () {
    test('initial state is PlaylistInitial', () {
      expect(playlistBloc.state, PlaylistInitial());
    });

    blocTest<PlaylistBloc, PlaylistState>(
      'emits [PlaylistLoading, PlaylistLoaded] when LoadPlaylistsEvent is added',
      build: () {
        when(() => mockGetPlaylists(any())).thenAnswer((_) async => Right(tPlaylists));
        return playlistBloc;
      },
      act: (bloc) => bloc.add(LoadPlaylistsEvent()),
      expect: () => [
        PlaylistLoading(),
        PlaylistLoaded(playlists: tPlaylists),
      ],
    );
  });
}
