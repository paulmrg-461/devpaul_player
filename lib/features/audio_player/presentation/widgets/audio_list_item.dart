import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/audio_entity.dart';
import '../bloc/player/player_bloc.dart';
import '../bloc/player/player_event.dart';
import '../../../playlists/presentation/bloc/playlist_bloc.dart';

class AudioListItem extends StatelessWidget {
  final AudioEntity audio;

  const AudioListItem({super.key, required this.audio});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.music_note),
      title: Text(audio.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(audio.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: () {
        context.read<PlayerBloc>().add(PlayEvent(audio));
      },
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'add_to_playlist') {
            _showAddToPlaylistDialog(context);
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem<String>(
              value: 'add_to_playlist',
              child: Text('Add to Playlist'),
            ),
          ];
        },
      ),
    );
  }

  void _showAddToPlaylistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add to Playlist'),
          content: SizedBox(
            width: double.maxFinite,
            child: BlocBuilder<PlaylistBloc, PlaylistState>(
              builder: (context, state) {
                if (state is PlaylistLoaded) {
                  if (state.playlists.isEmpty) {
                    return const Text('No playlists available. Create one first.');
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = state.playlists[index];
                      return ListTile(
                        leading: const Icon(Icons.playlist_play),
                        title: Text(playlist.name),
                        onTap: () {
                          context.read<PlaylistBloc>().add(
                            AddAudioToPlaylistEvent(
                              playlistId: playlist.id,
                              audioId: audio.id,
                            ),
                          );
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added to ${playlist.name}')),
                          );
                        },
                      );
                    },
                  );
                } else if (state is PlaylistLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                   // Fallback if playlists not loaded or error
                   return const Text('Please go to Playlists tab to load playlists.');
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
