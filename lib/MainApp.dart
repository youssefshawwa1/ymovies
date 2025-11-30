import 'package:flutter/material.dart';
import './Home.dart';
import "./Sections.dart";
import "apiLinks.dart";
import "SearchPage.dart";

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  bool _isSearching = false;
  final List<Widget> _pages = [
    Home(),
    GridSection(
      key: ValueKey('movies'),
      url: links["allMovies"]["url"],
      type: "movie",
      title: links["allMovies"]["title"],
    ),
    GridSection(
      key: ValueKey('tvs'),
      url: links["allTvs"]["url"],
      type: "tv",
      title: links["allTvs"]["title"],
    ),
  ];

  Widget _buildNormalBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("YMOVIES", style: TextStyle(color: Colors.red)),
        IconButton(
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
          icon: Icon(Icons.search, color: Colors.white),
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        Expanded(
          child: TextField(
            autofocus: true,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
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
                // Optional: Close the search bar after navigation
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
        title: _isSearching ? _buildSearchBar() : _buildNormalBar(),
        actions: [
          // Optional: Add filter or other actions if needed
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.movie_creation),
            activeIcon: Icon(Icons.movie_creation_rounded),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.live_tv_outlined),
            activeIcon: Icon(Icons.live_tv),
            label: 'Series',
          ),
        ],
      ),
    );
  }
}

// Placeholder for pages that don't exist yet
class PlaceholderWidget extends StatelessWidget {
  final String title;

  const PlaceholderWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title\n\nComing Soon!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
