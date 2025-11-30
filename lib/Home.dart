import 'package:flutter/material.dart';
import "Sections.dart";

import "./Helper.dart";
import "./apiLinks.dart";
import "./CardItem.dart";

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> _d = {
    "movie": {
      "popular": <CardItem>[],
      "top_rated": <CardItem>[],
      "trending": <CardItem>[],
      "now_playing": <CardItem>[],
    },
    "tv": {
      "popular": <CardItem>[],
      "top_rated": <CardItem>[],
      "trending": <CardItem>[],
      "airing_today": <CardItem>[],
    },
  };
  bool isloading = true;
  String error = '';
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      for (var key in apiLinks.keys) {
        for (var k in apiLinks[key].keys) {
          final data = await Helper.getData(url: apiLinks[key][k]["url"]);
          setState(() {
            _d[key][k] = CardItem.transform(data["results"], key);
          });
        }
      }
      setState(() {
        isloading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        error = 'Error: $e';
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Helper.Loading();
    }

    if (error.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text("Error: $error"),
              SizedBox(height: 16),
              ElevatedButton(onPressed: _fetchData, child: Text("Retry")),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HorizontalSection(
              title: apiLinks["movie"]["now_playing"]["title"],
              items: _d["movie"]["now_playing"],
              type: 'movie',
              kind: "now_playing",
            ),
            HorizontalSection(
              title: apiLinks["movie"]["trending"]["title"],
              items: _d["movie"]["trending"],
              type: 'movie',
              kind: "trending",
            ),
            HorizontalSection(
              title: apiLinks["movie"]["popular"]["title"],
              items: _d["movie"]["popular"],
              type: 'movie',
              kind: "popular",
            ),
            HorizontalSection(
              title: apiLinks["movie"]["top_rated"]["title"],
              items: _d["movie"]["top_rated"],
              type: 'movie',
              kind: "top_rated",
            ),
            HorizontalSection(
              title: apiLinks["tv"]["airing_today"]["title"],
              items: _d["tv"]["airing_today"],
              type: 'tv',
              kind: "airing_today",
            ),
            HorizontalSection(
              title: apiLinks["tv"]["trending"]["title"],
              items: _d["tv"]["trending"],
              type: 'tv',
              kind: "trending",
            ),
            HorizontalSection(
              title: apiLinks["tv"]["popular"]["title"],
              items: _d["tv"]["popular"],
              type: 'tv',
              kind: "popular",
            ),
            HorizontalSection(
              title: apiLinks["tv"]["top_rated"]["title"],
              items: _d["tv"]["top_rated"],
              type: 'tv',
              kind: "top_rated",
            ),
          ],
        ),
      ),
    );
  }
}
