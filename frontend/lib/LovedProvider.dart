import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "CardItem.dart";
import "apiLinks.dart";

class LovedProvider with ChangeNotifier {
  final Set<int> _lovedIds = {};
  List<CardItem> _lovedItems = [];
  bool _isLoading = false;
  String? _userId;

  Set<int> get lovedIds => _lovedIds;
  List<CardItem> get lovedItems => _lovedItems;
  bool get isLoading => _isLoading;

  // Check if an item is loved
  bool isLoved(int id) => _lovedIds.contains(id);

  // 1. FETCH: Loads the "Loved" list from the database
  Future<void> fetchLoved(dynamic userId) async {
    _userId = userId.toString();
    _isLoading = true;
    notifyListeners();

    // Note: I've updated the filename to loved.php to match your new naming
    final url = Uri.parse('$apiLink/loved.php?userId=$_userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final List<dynamic> data = responseData['data'];
          _lovedIds.clear();
        }
      }
    } catch (e) {
      print("Error fetching loved items: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. TOGGLE: Handles the Heart icon press
  Future<void> toggleLovedRemote(CardItem item) async {
    if (_userId == null) return;
    final int id = item.id;
    bool wasLoved = _lovedIds.contains(id);

    // --- Step A: Optimistic UI Update ---
    if (wasLoved) {
      _lovedIds.remove(id);
      _lovedItems.removeWhere((element) => element.id == id);
    } else {
      _lovedIds.add(id);
      _lovedItems.insert(0, item);
    }
    notifyListeners();

    // --- Step B: Background Sync ---
    final url = Uri.parse('$apiLink/toggle_loved.php');
    try {
      print(item.mediaType);
      final response = await http.post(
        url,
        body: {
          'userId': _userId,
          'tmdbId': item.id.toString(),
          'title': item.title,
          'poster_path':
              item.posterUrl, // Ensure your CardItem has posterUrl getter
          'media_type': item.mediaType,
          'release_date': item?.releaseDate ?? '',
          'vote_average': item.rating?.toString() ?? '0.0',
        },
      );
      print(response.body);
      final res = json.decode(response.body);
      if (res['success'] != true) throw Exception();
    } catch (e) {
      print("Sync Error (Loved): $e");
      // Rollback on failure
      if (wasLoved) {
        _lovedIds.add(id);
        _lovedItems.insert(0, item);
      } else {
        _lovedIds.remove(id);
        _lovedItems.removeWhere((element) => element.id == id);
      }
      notifyListeners();
    }
  }

  void clear() {
    _lovedIds.clear();
    _lovedItems.clear();
    _userId = null;
    notifyListeners();
  }
}
