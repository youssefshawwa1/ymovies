import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider with ChangeNotifier {
  Map<String, dynamic> _links = {};
  Map<String, dynamic> _apiLinks = {};
  String _apiKey = "";
  String _backDrop = "";
  String _embedLink = "";
  String _posterLink = "";
  Map<String, dynamic> get links => _links;
  Map<String, dynamic> get apiLinks => _apiLinks;
  String get apiKey => _apiKey;
  String get backDrop => _backDrop;
  String get embedLink => _embedLink;
  String get posterLink => _posterLink;

  ConfigProvider() {
    loadConfigFromLocal();
  }

  // 1. Save to Local Storage
  Future<void> setConfig(Map<String, dynamic> fullConfig) async {
    _links = fullConfig['links'] ?? {};
    _apiLinks = fullConfig['apiLinks'] ?? {};
    _apiKey = fullConfig['apiKey'] ?? "";
    _backDrop = fullConfig["backDrop"] ?? "";
    _posterLink = fullConfig["posterLink"] ?? "";
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_config', jsonEncode(fullConfig));

    notifyListeners();
  }

  // 2. Load from Local Storage on Start
  Future<void> loadConfigFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedConfig = prefs.getString('app_config');

    if (savedConfig != null) {
      Map<String, dynamic> decoded = jsonDecode(savedConfig);
      _links = decoded['links'] ?? {};
      _apiLinks = decoded['apiLinks'] ?? {};
      _apiKey = decoded['apiKey'] ?? "";
      _embedLink = decoded["embedLink"] ?? "";
      _backDrop = decoded["backDrop"] ?? "";
      _posterLink = decoded["posterLink"] ?? "";
      notifyListeners();
    }
  }
}
