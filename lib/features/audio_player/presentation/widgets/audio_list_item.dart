import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/audio_entity.dart';
import '../bloc/player/player_bloc.dart';
import '../../../playlists/presentation/bloc/playlist_bloc.dart';

class AudioListItem extends StatelessWidget {
  final AudioEntity audio;

  const AudioListItem({super.key, required this.audio});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.background,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: QueryArtworkWidget(
              id: audio.id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: const Icon(Icons.music_note, color: AppColors.primary),
            ),
          ),
        ),
        title: Text(
          audio.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          audio.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        onTap: () {
          context.read<PlayerBloc>().add(PlayEvent(audio));
        },
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
          color: AppColors.surface,
          onSelected: (value) {
            if (value == 'add_to_playlist') {
              _showAddToPlaylistDialog(context);
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'add_to_playlist',
                child: Text('Add to Playlist', style: TextStyle(color: AppColors.textPrimary)),
              ),
            ];
          },
        ),
      ),
    );
  }

  void _showAddToPlaylistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Add to Playlist', style: TextStyle(color: AppColors.textPrimary)),
          content: SizedBox(
            width: double.maxFinite,
            child: BlocBuilder<PlaylistBloc, PlaylistState>(
              builder: (context, state) {
                if (state is PlaylistLoaded) {
                  if (state.playlists.isEmpty) {
                    return const Text('No playlists available', style: TextStyle(color: AppColors.textSecondary));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = state.playlists[index];
                      return ListTile(
                        title: Text(playlist.name, style: const TextStyle(color: AppColors.textPrimary)),
                        onTap: () {
                          context.read<PlaylistBloc>().add(AddAudioToPlaylistEvent(playlistId: playlist.id, audioId: audio.id));
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added to ${playlist.name}')),
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        );
      },
    );
  }
}
