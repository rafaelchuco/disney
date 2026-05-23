import 'dart:convert';

import 'package:disney/core/network/api_exception.dart';
import 'package:disney/features/landing/data/models/omdb_movie.dart';
import 'package:http/http.dart' as http;

class OmdbService {
  OmdbService({http.Client? client}) : _client = client ?? http.Client();

  static const _apiKey = '18bc7fa3';
  static const _baseUrl = 'www.omdbapi.com';

  final http.Client _client;

  Future<List<OmdbMovie>> fetchCatalog() async {
    const queries = [
      'Marvel',
      'Star Wars',
      'Pixar',
      'Avengers',
      'Frozen',
      'Alien',
    ];

    final movies = <OmdbMovie>[];

    for (final query in queries) {
      final uri = Uri.https(
        _baseUrl,
        '/',
        <String, String>{
          'apikey': _apiKey,
          's': query,
          'type': 'movie',
        },
      );

      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        continue;
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final results = body['Search'];
      if (results is! List<dynamic>) {
        continue;
      }

      for (final item in results) {
        if (item is! Map<String, dynamic>) {
          continue;
        }

        final poster = item['Poster'] as String?;
        if (poster == null || poster == 'N/A' || poster.isEmpty) {
          continue;
        }

        movies.add(OmdbMovie.fromJson(item));
      }

      if (movies.length >= 20) {
        break;
      }
    }

    if (movies.isEmpty) {
      throw const ApiException('No se pudo cargar el catalogo en este momento.');
    }

    return movies;
  }
}
