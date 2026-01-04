import 'package:flutter/material.dart';
import "apiLinks.dart";

//this model is for the card, it can be a tv or movie.
class CardItem {
  final int id;
  final String title;
  final String posterPath;
  final double rating;
  final String releaseDate;
  final String mediaType; // 'movie' or 'tv'
  final String? overview;
  final List<int>? genreIds;
  final int? seasons;
  final String? backdropPath;

  CardItem({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
    required this.releaseDate,
    required this.mediaType,
    this.overview,
    this.genreIds,
    this.seasons,
    this.backdropPath,
  });

  String get posterUrl => "${posterLink}${posterPath}";

  // Helper method to display media type
  String get typeDisplayName {
    return mediaType == "tv" ? 'TV' : 'MOVIE';
  }

  Color get color {
    switch (mediaType) {
      case "movie":
        return Colors.red.withOpacity(0.8);
      case "tv":
        return Colors.blue.withOpacity(0.8);
      default:
        return Colors.grey.withOpacity(0.8);
    }
  }

  int get releaseYear {
    return DateTime.parse(releaseDate).year;
  }

  IconData get icon {
    switch (mediaType) {
      case "movie":
        return Icons.movie;
      case "tv":
        return Icons.tv;
      default:
        return Icons.question_mark;
    }
  }

  //this static method, transforms the data from the api, and returns a list of CardItem.
  static List<CardItem> transform(data, type) {
    List<CardItem> items = [];
    for (var jsonItem in data) {
      if (jsonItem["poster_path"] == null ||
          jsonItem["poster_path"].toString().isEmpty) {
        continue;
      }

      final releaseDate =
          jsonItem["release_date"] ?? jsonItem["first_air_date"];
      if (releaseDate == null || releaseDate.toString().isEmpty) {
        continue;
      }

      items.add(
        CardItem(
          id: jsonItem["id"],
          title:
              jsonItem['title'] ??
              jsonItem["name"] ??
              jsonItem["original_name"] ??
              "Unknown",
          posterPath: jsonItem['poster_path'],
          rating: jsonItem["vote_average"]?.toDouble() ?? 0.0,
          releaseDate: releaseDate,
          mediaType: jsonItem['media_type'] ?? type,
          overview: jsonItem["overview"] ?? "",
          genreIds: List<int>.from(jsonItem["genre_ids"] ?? []),
        ),
      );
    }
    return items;
  }
}
