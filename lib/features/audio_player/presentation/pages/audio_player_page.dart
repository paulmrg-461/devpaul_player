import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../bloc/audio_bloc.dart';
import '../bloc/audio_event.dart';
import '../bloc/audio_state.dart';
import '../bloc/player/player_bloc.dart';
import '../widgets/audio_list_item.dart';
import '../widgets/mini_player.dart';

class AudioPlayerPage extends StatelessWidget {
  const AudioPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AudioBloc>()..add(LoadAudioFiles())),
        BlocProvider(create: (context) => sl<PlayerBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DevPaul Player'),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<AudioBloc, AudioState>(
                builder: (context, state) {
                  if (state is AudioLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AudioLoaded) {
                    if (state.songs.isEmpty) {
                       return const Center(child: Text("No songs found"));
                    }
                    return ListView.builder(
                      itemCount: state.songs.length,
                      itemBuilder: (context, index) {
                        return AudioListItem(audio: state.songs[index]);
                      },
                    );
                  } else if (state is AudioError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const MiniPlayer(),
          ],
        ),
      ),
    );
  }
}
