import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/audio_entity.dart';

class AudioListItem extends StatelessWidget {
  final AudioEntity audio;

  const AudioListItem({super.key, required this.audio});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.music_note),
      title: Text(audio.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(audio.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: () async {
        final player = sl<AudioPlayer>();
        try {
            await player.setAudioSource(AudioSource.uri(Uri.parse(audio.uri)));
            player.play();
        } catch (e) {
            if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error playing audio: $e")),
                );
            }
        }
      },
    );
  }
}
