import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../audio_player/presentation/widgets/audio_list_item.dart';
import '../../domain/entities/playlist_entity.dart';
import '../bloc/playlist_bloc.dart';

class PlaylistDetailPage extends StatelessWidget {
  final PlaylistEntity playlist;

  const PlaylistDetailPage({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PlaylistBloc>()..add(LoadPlaylistAudiosEvent(playlist.id)),
      child: Scaffold(
        appBar: AppBar(title: Text(playlist.name)),
        body: BlocBuilder<PlaylistBloc, PlaylistState>(
          builder: (context, state) {
            if (state is PlaylistLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlaylistAudiosLoaded) {
              if (state.audios.isEmpty) {
                return const Center(child: Text('No songs in this playlist'));
              }
              return ListView.builder(
                itemCount: state.audios.length,
                itemBuilder: (context, index) {
                  return AudioListItem(audio: state.audios[index]);
                },
              );
            } else if (state is PlaylistError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
