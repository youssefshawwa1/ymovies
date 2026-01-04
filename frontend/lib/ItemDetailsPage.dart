import 'package:flutter/material.dart';
import './apiKey/apiKey.dart';
import "./Helper.dart";
import "VideoPlayer.dart";
import './Sections.dart';
import "./CardItem.dart";
import 'package:provider/provider.dart';
import 'WatchlistProvider.dart';
import 'LovedProvider.dart';
import 'AuthProvider.dart';
import "global.dart";
import 'dart:convert';
import "apiLinks.dart";

class ItemDetailsPage extends StatefulWidget {
  final int id;
  final String type;
  const ItemDetailsPage({super.key, required this.id, required this.type});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> with RouteAware {
  Map<String, dynamic> _d = {};
  List<CardItem> _s = [];
  List<CardItem> _r = [];
  bool isloading = true;
  String error = '';
  bool _isPageVisible = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to the route observer
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this); // Clean up
    super.dispose();
  }

  // Called when a new route is pushed on top of this one
  @override
  void didPushNext() {
    setState(() {
      _isPageVisible = false;
    });
  }

  // Called when the top route is popped and this one becomes visible again
  @override
  void didPopNext() {
    setState(() {
      _isPageVisible = true;
    });
  }

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

      setState(() {
        _d = detailsData;
        _s = CardItem.transform(similar["results"], widget.type);
        _r = CardItem.transform(recomendation["results"], widget.type);
      });
    } catch (e) {
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _d["title"] ?? _d["name"] ?? _d["original_name"] ?? "Unknown",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
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
                      image: NetworkImage("${backDrop}${_d["backdrop_path"]}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    top: 90,
                    left: 50,
                    right: 50,
                    bottom: 30,
                  ),
                  child: _isPageVisible
                      ? VideoPlayerScreen(
                          videoUrl:
                              '${embedLink}/${widget.type}/${widget.id}&ds_lang=ar',
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
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
                                "${posterLink}${_d["poster_path"]}",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(width: 16),
                      // Title and Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _d["title"] ?? _d["name"] ?? "Unknown",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // --- WATCHLIST BUTTON START ---
                            Row(
                              children: [
                                // WATCHLIST BUTTON
                                Consumer<WatchlistProvider>(
                                  builder: (context, watchlist, child) {
                                    bool isInWatchlist = watchlist
                                        .watchlistItems
                                        .any(
                                          (item) =>
                                              item.id.toString() ==
                                              widget.id.toString(),
                                        );

                                    return ElevatedButton.icon(
                                      onPressed: () {
                                        final auth = Provider.of<AuthProvider>(
                                          context,
                                          listen: false,
                                        );
                                        if (auth.userData == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please login first",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        watchlist.toggleWatchlistRemote(
                                          CardItem(
                                            id: widget.id,
                                            title: _d["title"] ?? _d["name"],
                                            posterPath:
                                                "${posterLink}${_d["poster_path"]}",
                                            rating: _d["vote_average"],
                                            releaseDate:
                                                _d["release_date"] ??
                                                _d["first_air_date"] ??
                                                "Unknown",
                                            mediaType: widget.type,
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isInWatchlist
                                            ? Colors.grey[850]
                                            : Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                      ),
                                      icon: Icon(
                                        isInWatchlist ? Icons.check : Icons.add,
                                      ),
                                      label: Text(
                                        isInWatchlist
                                            ? "In Watchlist"
                                            : "Watchlist",
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                // LOVED (HEART) BUTTON
                                Consumer<LovedProvider>(
                                  builder: (context, lovedProv, child) {
                                    bool isLoved = lovedProv.lovedItems.any(
                                      (item) =>
                                          item.id.toString() ==
                                          widget.id.toString(),
                                    );

                                    return IconButton(
                                      onPressed: () {
                                        final auth = Provider.of<AuthProvider>(
                                          context,
                                          listen: false,
                                        );
                                        if (auth.userData == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please login first",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        lovedProv.toggleLovedRemote(
                                          CardItem(
                                            id: widget.id,
                                            title: _d["title"] ?? _d["name"],
                                            posterPath:
                                                "${posterLink}${_d["poster_path"]}",
                                            rating: _d["vote_average"],
                                            releaseDate:
                                                _d["release_date"] ??
                                                _d["first_air_date"] ??
                                                "Unknown",
                                            mediaType: widget.type,
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        isLoved
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isLoved
                                            ? Colors.red
                                            : Colors.white,
                                        size: 28,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            // --- WATCHLIST BUTTON END ---
                            const SizedBox(height: 8),
                            if (_d["tagline"] != null &&
                                _d["tagline"].isNotEmpty)
                              Text(
                                _d["tagline"],
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            const SizedBox(height: 8),
                            // Rating
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${_d["vote_average"]?.toStringAsFixed(1) ?? "N/A"}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  "${_d["vote_count"]} votes",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Released: ${_d["release_date"] ?? _d["first_air_date"] ?? "Unknown"}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            if (widget.type == "movie" && _d["runtime"] != null)
                              Text(
                                "Runtime: ${_d["runtime"]} min",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            if (widget.type == "tv")
                              Text(
                                "Seasons: ${_d["number_of_seasons"]}, Episodes: ${_d["number_of_episodes"]}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Genres
                  if (_d["genres"] != null && _d["genres"].isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: (_d["genres"] as List<dynamic>)
                          .map<Widget>(
                            (genre) => Chip(
                              label: Text(
                                genre["name"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              backgroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                          )
                          .toList(),
                    ),

                  const SizedBox(height: 16),
                  const Text(
                    "Overview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _d["overview"] ?? "No overview available",
                    style: const TextStyle(color: Colors.grey, height: 1.5),
                  ),

                  const SizedBox(height: 16),

                  // Production Companies
                  if (_d["production_companies"] != null &&
                      _d["production_companies"].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Production",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children:
                              (_d["production_companies"] as List<dynamic>)
                                  .map<Widget>(
                                    (company) => Chip(
                                      label: Text(
                                        company["name"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.grey[800],
                                      side: BorderSide(
                                        color: Colors.grey[700]!,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  HorizontalSection(
                    title: "Similar",
                    items: _s,
                    type: widget.type,
                    kind: "similar",
                    id: widget.id,
                  ),
                  const SizedBox(height: 16),
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
