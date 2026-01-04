import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import "apiLinks.dart";
import "CardItem.dart";

class WatchlistProvider with ChangeNotifier {
  final Set<int> _savedIds = {};
  List<CardItem> _watchlistItems = [];
  bool _isLoading = false;
  String? _userId;

  Set<int> get savedIds => _savedIds;
  List<CardItem> get watchlistItems => _watchlistItems;
  bool get isLoading => _isLoading;

  Future<void> fetchWatchlist(dynamic userId) async {
    _userId = userId.toString();
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('${apiLink}/watchlist.php?userId=$_userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          final List<dynamic> data = responseData['data'];
          List<CardItem> items = [];
          _savedIds.clear();

          _watchlistItems = data.reversed.map((item) {
            int id = int.parse(item['id'].toString());
            _savedIds.add(id);
            return CardItem(
              id: id,
              title: item["title"],
              posterPath: item["poster_path"],
              rating: double.parse(item["vote_average"].toString()),
              releaseDate: item["release_date"],
              mediaType: item["media_type"],
            );
          }).toList();
        }
      }
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isSaved(int id) => _savedIds.contains(id);

  Future<void> toggleWatchlistRemote(CardItem item) async {
    if (_userId == null) return;
    final int id = item.id;
    bool wasSaved = _savedIds.contains(id);

    if (wasSaved) {
      _savedIds.remove(id);
      _watchlistItems.removeWhere((element) => element.id == id);
      ;
    } else {
      _savedIds.add(id);
      _watchlistItems.insert(0, item);
    }
    notifyListeners();

    final url = Uri.parse('${apiLink}/toggle_watchlist.php');

    try {
      final response = await http.post(
        url,
        body: {
          'userId': _userId,
          'tmdbId': item.id.toString(),
          'title': item.title,
          'poster_path': item.posterUrl,
          'media_type': item.mediaType,
          'release_date': item.releaseDate ?? '',
          'vote_average': item.rating?.toString() ?? '0.0',
        },
      );
      final res = json.decode(response.body);
      if (res['success'] != true) throw Exception();
    } catch (e) {
      if (wasSaved) {
        _savedIds.add(id);
        _watchlistItems.add(item);
      } else {
        _savedIds.remove(id);
        _watchlistItems.removeWhere((element) => element.id == id);
      }
      notifyListeners();
    }
  }

  void clear() {
    _savedIds.clear();
    _watchlistItems.clear();
    _userId = null;
    notifyListeners();
  }
}
