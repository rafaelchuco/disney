import 'package:disney/features/landing/data/models/omdb_movie.dart';

abstract class CatalogRepository {
  Future<List<OmdbMovie>> fetchCatalog();
}
