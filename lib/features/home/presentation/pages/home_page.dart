import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../audio_player/presentation/bloc/audio_bloc.dart';
import '../../../audio_player/presentation/bloc/audio_event.dart';
import '../../../audio_player/presentation/bloc/audio_state.dart';
import '../../../audio_player/presentation/bloc/player/player_bloc.dart';
import '../../../audio_player/presentation/widgets/audio_list_item.dart';
import '../../../audio_player/presentation/widgets/mini_player.dart';
import '../../../playlists/presentation/bloc/playlist_bloc.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/home_banner.dart';
import '../widgets/home_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<PlayerBloc>()),
        BlocProvider(create: (context) => sl<PlaylistBloc>()..add(LoadPlaylistsEvent())),
        BlocProvider(create: (context) => sl<AudioBloc>()..add(LoadAudioFiles())),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const HomeHeader(),
                  const HomeBanner(),
                  const SizedBox(height: 20),
                  _buildSectionTabs(),
                  const SizedBox(height: 10),
                  _buildSectionTitle('Recommended'),
                  Expanded(
                    child: BlocBuilder<AudioBloc, AudioState>(
                      builder: (context, state) {
                        if (state is AudioLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is AudioLoaded) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 160), // Space for player & nav bar
                            itemCount: state.filteredSongs.length,
                            itemBuilder: (context, index) {
                              return AudioListItem(audio: state.filteredSongs[index]);
                            },
                          );
                        } else if (state is AudioError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 80, // Height of BottomNavBar
              child: const MiniPlayer(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildTabItem('Trending', true),
          _buildTabItem('Categories', false),
          _buildTabItem('Collections', false),
        ],
      ),
    );
  }

  Widget _buildTabItem(String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 4,
              width: 20,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'See all',
            style: TextStyle(
              color: AppColors.primaryLight,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
