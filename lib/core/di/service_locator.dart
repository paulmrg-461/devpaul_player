import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../features/audio_player/data/datasources/audio_local_data_source.dart';
import '../../features/audio_player/data/repositories/audio_repository_impl.dart';
import '../../features/audio_player/data/repositories/player_repository_impl.dart';
import '../../features/audio_player/domain/repositories/audio_repository.dart';
import '../../features/audio_player/domain/repositories/player_repository.dart';
import '../../features/audio_player/domain/usecases/get_audio_files.dart';
import '../../features/audio_player/domain/usecases/get_player_streams.dart';
import '../../features/audio_player/domain/usecases/pause_audio.dart';
import '../../features/audio_player/domain/usecases/play_audio.dart';
import '../../features/audio_player/domain/usecases/request_permission.dart';
import '../../features/audio_player/domain/usecases/resume_audio.dart';
import '../../features/audio_player/domain/usecases/seek_audio.dart';
import '../../features/audio_player/presentation/bloc/audio_bloc.dart';
import '../../features/audio_player/presentation/bloc/player/player_bloc.dart';
import '../../features/playlists/data/datasources/playlist_local_data_source.dart';
import '../../features/playlists/data/repositories/playlist_repository_impl.dart';
import '../../features/playlists/domain/repositories/playlist_repository.dart';
import '../../features/playlists/domain/usecases/add_audio_to_playlist.dart';
import '../../features/playlists/domain/usecases/create_playlist.dart';
import '../../features/playlists/domain/usecases/get_playlist_audios.dart';
import '../../features/playlists/domain/usecases/get_playlists.dart';
import '../../features/playlists/presentation/bloc/playlist_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Audio Player
  // Bloc
  sl.registerFactory(
    () => AudioBloc(
      getAudioFiles: sl(),
      requestPermission: sl(),
    ),
  );
  sl.registerFactory(
    () => PlayerBloc(
      playAudio: sl(),
      pauseAudio: sl(),
      resumeAudio: sl(),
      seekAudio: sl(),
      getPlayerStreams: sl(),
    ),
  );
  sl.registerFactory(
    () => PlaylistBloc(
      getPlaylists: sl(),
      createPlaylist: sl(),
      addAudioToPlaylist: sl(),
      getPlaylistAudios: sl(),
    ),
  );

  // Use cases - Audio Player
  sl.registerLazySingleton(() => GetAudioFiles(sl()));
  sl.registerLazySingleton(() => RequestPermission(sl()));
  sl.registerLazySingleton(() => PlayAudio(sl()));
  sl.registerLazySingleton(() => PauseAudio(sl()));
  sl.registerLazySingleton(() => ResumeAudio(sl()));
  sl.registerLazySingleton(() => SeekAudio(sl()));
  sl.registerLazySingleton(() => GetPlayerStreams(sl()));

  // Use cases - Playlists
  sl.registerLazySingleton(() => GetPlaylists(sl()));
  sl.registerLazySingleton(() => CreatePlaylist(sl()));
  sl.registerLazySingleton(() => AddAudioToPlaylist(sl()));
  sl.registerLazySingleton(() => GetPlaylistAudios(sl()));

  // Repository
  sl.registerLazySingleton<AudioRepository>(
    () => AudioRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<PlayerRepository>(
    () => PlayerRepositoryImpl(audioPlayer: sl()),
  );
  sl.registerLazySingleton<PlaylistRepository>(
    () => PlaylistRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AudioLocalDataSource>(
    () => AudioLocalDataSourceImpl(audioQuery: sl()),
  );
  sl.registerLazySingleton<PlaylistLocalDataSource>(
    () => PlaylistLocalDataSourceImpl(audioQuery: sl()),
  );

  // External
  sl.registerLazySingleton(() => OnAudioQuery());
  sl.registerLazySingleton(() => AudioPlayer());
}
