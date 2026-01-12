import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/audio_entity.dart';
import '../bloc/player/player_bloc.dart';

class FullPlayerPage extends StatelessWidget {
  const FullPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Music Player', style: TextStyle(color: AppColors.textPrimary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          final audio = state.currentAudio;
          if (audio == null) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Album Art
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: QueryArtworkWidget(
                          id: audio.id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: Container(
                            color: AppColors.surface,
                            child: const Icon(Icons.music_note, size: 100, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Title and Artist
                Text(
                  audio.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  audio.artist,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 30),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(Icons.favorite_border),
                    const SizedBox(width: 20),
                    _buildActionButton(Icons.share_outlined),
                    const SizedBox(width: 20),
                    _buildActionButton(Icons.file_download_outlined),
                  ],
                ),
                const Spacer(flex: 1),
                // Waveform Placeholder
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(30, (index) {
                      return Container(
                        width: 4,
                        height: (index % 2 == 0) ? 20 : 40,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                // Progress Bar
                Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: AppColors.surface,
                        thumbColor: AppColors.primary,
                        overlayColor: AppColors.primary.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: state.position.inSeconds.toDouble().clamp(0.0, state.duration.inSeconds.toDouble()),
                        max: state.duration.inSeconds.toDouble() > 0 
                            ? state.duration.inSeconds.toDouble() 
                            : 1.0,
                        onChanged: (value) {
                          context.read<PlayerBloc>().add(SeekEvent(Duration(seconds: value.toInt())));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(state.position), style: const TextStyle(color: AppColors.textSecondary)),
                          Text(_formatDuration(state.duration), style: const TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.repeat, color: AppColors.textSecondary),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous, size: 36, color: AppColors.textPrimary),
                      onPressed: () {}, // Add Previous Logic
                    ),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryLight,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          state.isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 36,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (state.isPlaying) {
                            context.read<PlayerBloc>().add(PauseEvent());
                          } else {
                            context.read<PlayerBloc>().add(ResumeEvent());
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, size: 36, color: AppColors.textPrimary),
                      onPressed: () {}, // Add Next Logic
                    ),
                    IconButton(
                      icon: const Icon(Icons.shuffle, color: AppColors.textSecondary),
                      onPressed: () {},
                    ),
                  ],
                ),
                const Spacer(flex: 2),
                // Lyrics Snippet
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    "I, I've been trying to fix my pride",
                    style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
      ),
      child: Icon(icon, color: AppColors.textPrimary),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? '${duration.inHours}:' : ''}$twoDigitMinutes:$twoDigitSeconds";
  }
}
