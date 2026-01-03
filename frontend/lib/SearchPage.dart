import 'package:flutter/material.dart';
import "./CardItem.dart";
import './Helper.dart';
import 'apiLinks.dart';
import './Sections.dart';

class SearchPage extends StatelessWidget {
  final String searchQuery;

  const SearchPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridSection(
        url: "${links["search"]["url"]}query=${searchQuery}",
        type: "mixed", // or "multi" depending on your API
        title: "Search: '$searchQuery'",
      ),
    );
  }
}
