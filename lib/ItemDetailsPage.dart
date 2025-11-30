import 'package:flutter/material.dart';
import './apiKey/apiKey.dart';
import "./Helper.dart";
import 'apiLinks.dart';
import "VideoPlayer.dart";
import './Sections.dart';
import "./CardItem.dart";

class ItemDetailsPage extends StatefulWidget {
  final int id;
  final String type;
  const ItemDetailsPage({super.key, required this.id, required this.type});
  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  Map<String, dynamic> _d = {};
  List<CardItem> _s = [];
  List<CardItem> _r = [];
  bool isloading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isloading = true;
    });
    try {
      // Fetch main details
      final detailsData = await Helper.getData(
        url:
            "${links["details"]["url"]}${widget.type}/${widget.id}?api_key=$apiKey",
      );
      final recomendation = await Helper.getData(
        url:
            "${links["more"]["url"]}${widget.type}/${widget.id}/recommendations?api_key=$apiKey",
      );
      final similar = await Helper.getData(
        url:
            "${links["more"]["url"]}${widget.type}/${widget.id}/similar?api_key=$apiKey",
      );
      print(
        "${links["more"]["url"]}${widget.type}/${widget.id}/similar?api_key=$apiKey",
      );
      print(
        "${links["more"]["url"]}${widget.type}/${widget.id}/recommendations?api_key=$apiKey",
      );
      // Fetch cast
      // final castData = await Helper.getData(
      //   url:
      //       "${links["details"]["url"]}${widget.type}/${widget.id}/credits?api_key=$apiKey",
      // );

      setState(() {
        _d = detailsData;
        _s = CardItem.transform(similar["results"], widget.type);
        _r = CardItem.transform(recomendation["results"], widget.type);

        // _cast = castData["cast"] ?? [];
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        error = 'Error: $e';
      });
    } finally {
      setState(() {
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
      return Scaffold(body: Center(child: Text(error)));
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          _d["title"] ?? _d["name"] ?? _d["original_name"] ?? "Unknown",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),

      //       VideoPlayerScreen(
      //   videoUrl: "https://vidsrc-embed.ru/embed/tv/${widget.id}",
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Backdrop Image
            if (_d["backdrop_path"] != null)
              GestureDetector(
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://image.tmdb.org/t/p/w1280${_d["backdrop_path"]}",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: 90,
                    left: 50,
                    right: 50,
                    bottom: 30,
                  ),
                  child: VideoPlayerScreen(
                    videoUrl:
                        'https://vidsrc-embed.ru/embed/${widget.type}/${widget.id}',
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster and Basic Info Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      if (_d["poster_path"] != null)
                        Container(
                          width: 120,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500${_d["poster_path"]}",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      SizedBox(width: 16),
                      // Title and Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _d["title"] ?? _d["name"] ?? "Unknown",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Tagline
                            if (_d["tagline"] != null &&
                                _d["tagline"].isNotEmpty)
                              Text(
                                _d["tagline"],
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            SizedBox(height: 8),
                            // Rating
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  "${_d["vote_average"]?.toStringAsFixed(1) ?? "N/A"}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 16),
                                Text(
                                  "${_d["vote_count"]} votes",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Release Date
                            Text(
                              "Released: ${_d["release_date"] ?? _d["first_air_date"] ?? "Unknown"}",
                              style: TextStyle(color: Colors.grey),
                            ),
                            // Runtime for movies
                            if (widget.type == "movie" && _d["runtime"] != null)
                              Text(
                                "Runtime: ${_d["runtime"]} min",
                                style: TextStyle(color: Colors.grey),
                              ),
                            // Seasons/Episodes for TV
                            if (widget.type == "tv")
                              Text(
                                "Seasons: ${_d["number_of_seasons"]}, Episodes: ${_d["number_of_episodes"]}",
                                style: TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Genres
                  if (_d["genres"] != null && _d["genres"].isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: (_d["genres"] as List<dynamic>)
                          .map<Widget>(
                            (genre) => Chip(
                              label: Text(
                                genre["name"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              backgroundColor: Colors.red,
                              side: BorderSide(
                                color: Colors.red,
                              ), // Grey border
                            ),
                          )
                          .toList(),
                    ),

                  SizedBox(height: 16),

                  Text(
                    "Overview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _d["overview"] ?? "No overview available",
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),

                  SizedBox(height: 16),

                  // Production Companies
                  if (_d["production_companies"] != null &&
                      _d["production_companies"].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Production",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children:
                              (_d["production_companies"] as List<dynamic>)
                                  .map<Widget>(
                                    (company) => Chip(
                                      label: Text(
                                        company["name"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.grey[800],
                                      side: BorderSide(
                                        color: const Color.fromARGB(
                                          255,
                                          66,
                                          66,
                                          66,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  HorizontalSection(
                    title: "Similar",
                    items: _s,
                    type: widget.type,
                    kind: "similar",
                    id: widget.id,
                  ),
                  SizedBox(height: 16),
                  HorizontalSection(
                    title: "Recommendations",
                    items: _r,
                    type: widget.type,
                    kind: "recommendations",
                    id: widget.id,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
