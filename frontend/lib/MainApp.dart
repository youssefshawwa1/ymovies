import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Home.dart';
import "./Sections.dart";
import "apiLinks.dart";
import "SearchPage.dart";
import './ProfilePage.dart';
import 'WatchlistProvider.dart';
import "LovedProvider.dart";
import "AuthProvider.dart";

class MainApp extends StatefulWidget {
  final Map<String, dynamic> userData;
  const MainApp({Key? key, required this.userData}) : super(key: key);
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  bool _isSearching = false;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final uid = widget.userData['userId'];
      if (uid != null) {
        Provider.of<WatchlistProvider>(
          context,
          listen: false,
        ).fetchWatchlist(uid);
      }
      if (uid != null) {
        Provider.of<LovedProvider>(context, listen: false).fetchLoved(uid);
      }
    });

    _pages = [
      Home(),
      GridSection(
        key: const ValueKey('movies'),
        url: links["allMovies"]["url"],
        type: "movie",
        title: links["allMovies"]["title"],
      ),
      GridSection(
        key: const ValueKey('tvs'),
        url: links["allTvs"]["url"],
        type: "tv",
        title: links["allTvs"]["title"],
      ),
      ProfilePage(),
    ];
  }

  Widget _buildNormalBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "YMOVIES",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
          icon: const Icon(Icons.search, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _isSearching = false;
            });
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        Expanded(
          child: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: 'Search movies and TV shows...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            onSubmitted: (query) {
              if (query.trim().isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(searchQuery: query),
                  ),
                );
                setState(() {
                  _isSearching = false;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: _isSearching ? _buildSearchBar() : _buildNormalBar(),
      ),
      body: IndexedStack(
        // 4. Tip: Use IndexedStack to keep scroll positions when switching tabs
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation_outlined),
            activeIcon: Icon(Icons.movie_creation_rounded),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv_outlined),
            activeIcon: Icon(Icons.live_tv),
            label: 'Series',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
