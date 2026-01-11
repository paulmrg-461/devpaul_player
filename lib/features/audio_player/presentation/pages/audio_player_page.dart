import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../bloc/audio_bloc.dart';
import '../bloc/audio_event.dart';
import '../bloc/audio_state.dart';
import '../widgets/audio_list_item.dart';
import '../../domain/entities/audio_entity.dart';

class AudioPlayerPage extends StatelessWidget {
  const AudioPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AudioBloc>()..add(LoadAudioFiles()),
      child: const AudioPlayerView(),
    );
  }
}

class AudioPlayerView extends StatefulWidget {
  const AudioPlayerView({super.key});

  @override
  State<AudioPlayerView> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    context.read<AudioBloc>().add(const SearchAudioEvent(''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search songs...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  context.read<AudioBloc>().add(SearchAudioEvent(value));
                },
              )
            : const Text('DevPaul Player'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _stopSearch,
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _startSearch,
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Songs'),
            Tab(text: 'Artists'),
            Tab(text: 'Folders'),
          ],
        ),
      ),
      body: BlocBuilder<AudioBloc, AudioState>(
        builder: (context, state) {
          if (state is AudioLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AudioLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildSongsList(state.filteredSongs, state.allSongs.isEmpty),
                _buildGroupedList(context, state.songsByArtist, Icons.person),
                _buildGroupedList(context, state.songsByFolder, Icons.folder),
              ],
            );
          } else if (state is AudioError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSongsList(List<AudioEntity> songs, bool isEmpty) {
    if (songs.isEmpty) {
      return Center(
        child: Text(
          isEmpty 
            ? "No songs found on device" 
            : "No songs match your search",
        ),
      );
    }
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return AudioListItem(audio: songs[index]);
      },
    );
  }

  Widget _buildGroupedList(
    BuildContext context, 
    Map<String, List<AudioEntity>> groupedData,
    IconData icon,
  ) {
    if (groupedData.isEmpty) {
      return const Center(child: Text("No items found"));
    }
    
    final keys = groupedData.keys.toList()..sort();
    
    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];
        final songs = groupedData[key]!;
        
        return ListTile(
          leading: Icon(icon),
          title: Text(key),
          subtitle: Text('${songs.length} songs'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupDetailView(title: key, songs: songs),
              ),
            );
          },
        );
      },
    );
  }
}

class GroupDetailView extends StatelessWidget {
  final String title;
  final List<AudioEntity> songs;

  const GroupDetailView({
    super.key,
    required this.title,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return AudioListItem(audio: songs[index]);
        },
      ),
    );
  }
}
