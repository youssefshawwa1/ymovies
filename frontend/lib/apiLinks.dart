import './apiKey/apiKey.dart';
// https://image.tmdb.org/t/p/original/backdrop path
//sizes original, w1280, w780, w300

//search : https://api.themoviedb.org/3/search/multi

//Recommendation: for movies: https://api.themoviedb.org/3/movie/{movie_id}/recommendations
//similar for movies: https://api.themoviedb.org/3/movie/{movie_id}/similar
//movie details: https://api.themoviedb.org/3/movie/{movie_id}

//recomendation for tvs: https://api.themoviedb.org/3/tv/{series_id}/recommendations
//similar for tvs: https://api.themoviedb.org/3/tv/{series_id}/similar
//tv details: https://api.themoviedb.org/3/tv/{series_id}

Map<String, dynamic> links = {
  "allMovies": {
    "url": "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey",
    "title": "Movies",
  },
  "allTvs": {
    "url": "https://api.themoviedb.org/3/discover/tv?api_key=$apiKey",
    "title": "TV Serieses",
  },
  "search": {
    "url":
        "https://api.themoviedb.org/3/search/multi?api_key=$apiKey&include_adult&language=en-US&",
    "title": "Search",
  },
  "details": {"url": "https://api.themoviedb.org/3/"},
  "more": {"url": "https://api.themoviedb.org/3/"},
};
Map<String, dynamic> apiLinks = {
  'tv': {
    "popular": {
      "url":
          "https://api.themoviedb.org/3/tv/popular?api_key=$apiKey&language=en-US",
      "title": "Popular Series",
    },
    "top_rated": {
      "url":
          'https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey&language=en-US',
      "title": "Top Rated Series",
    },
    "trending": {
      "url":
          "https://api.themoviedb.org/3/trending/tv/week?api_key=$apiKey&language=en-US",
      "title": "Trending Series",
    },
    "airing_today": {
      "url":
          "https://api.themoviedb.org/3/tv/airing_today?api_key=$apiKey&language=en-US",
      "title": "Airing Today",
    },
  },
  'movie': {
    "now_playing": {
      "url":
          "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey&language=en-US",
      "title": "Now Playing",
    },
    "popular": {
      "url":
          "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US",
      "title": "Popular Movies",
    },
    "top_rated": {
      "url":
          "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=en-US",
      "title": "Top Rated Movies",
    },
    "trending": {
      "url":
          "https://api.themoviedb.org/3/trending/movie/week?api_key=$apiKey&language=en-US",
      "title": "Trending Movies",
    },
  },
};
