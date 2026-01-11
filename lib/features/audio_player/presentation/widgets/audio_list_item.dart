import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/audio_entity.dart';
import '../bloc/player/player_bloc.dart';

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
    );
  }
}
