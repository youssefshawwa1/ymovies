import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class Helper {
  static Future<Map<String, dynamic>> getData({required String url}) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  static Widget Loading() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.red),
            SizedBox(height: 16),
            Text("Loading...", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
