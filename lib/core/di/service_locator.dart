import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../features/audio_player/data/datasources/audio_local_data_source.dart';
import '../../features/audio_player/data/repositories/audio_repository_impl.dart';
import '../../features/audio_player/domain/repositories/audio_repository.dart';
import '../../features/audio_player/domain/usecases/get_audio_files.dart';
import '../../features/audio_player/domain/usecases/request_permission.dart';
import '../../features/audio_player/presentation/bloc/audio_bloc.dart';

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

  // Use cases
  sl.registerLazySingleton(() => GetAudioFiles(sl()));
  sl.registerLazySingleton(() => RequestPermission(sl()));

  // Repository
  sl.registerLazySingleton<AudioRepository>(
    () => AudioRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AudioLocalDataSource>(
    () => AudioLocalDataSourceImpl(audioQuery: sl()),
  );

  // External
  sl.registerLazySingleton(() => OnAudioQuery());
  sl.registerLazySingleton(() => AudioPlayer());
}
