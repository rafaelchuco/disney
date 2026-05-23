import 'package:disney/features/landing/data/models/omdb_movie.dart';
import 'package:disney/features/landing/data/services/omdb_service.dart';
import 'package:disney/features/landing/domain/repositories/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl(this._service);

  final OmdbService _service;

  @override
  Future<List<OmdbMovie>> fetchCatalog() {
    return _service.fetchCatalog();
  }
}
