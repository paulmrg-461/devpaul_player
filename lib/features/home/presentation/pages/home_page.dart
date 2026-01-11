import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../audio_player/presentation/bloc/player/player_bloc.dart';
import '../../../audio_player/presentation/pages/audio_player_page.dart';
import '../../../audio_player/presentation/widgets/mini_player.dart';
import '../../../playlists/presentation/bloc/playlist_bloc.dart';
import '../../../playlists/presentation/pages/playlists_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const AudioPlayerPage(),
    const PlaylistsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<PlayerBloc>()),
        BlocProvider(create: (context) => sl<PlaylistBloc>()..add(LoadPlaylistsEvent())),
      ],
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),
            const MiniPlayer(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.music_note), label: 'Songs'),
            NavigationDestination(icon: Icon(Icons.playlist_play), label: 'Playlists'),
          ],
        ),
      ),
    );
  }
}
