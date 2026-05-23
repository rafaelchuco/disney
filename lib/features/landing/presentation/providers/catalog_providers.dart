import 'package:disney/features/landing/data/repositories/catalog_repository_impl.dart';
import 'package:disney/features/landing/data/models/omdb_movie.dart';
import 'package:disney/features/landing/data/services/omdb_service.dart';
import 'package:dio/dio.dart';
import 'package:disney/features/landing/domain/repositories/catalog_repository.dart';
import 'package:disney/features/landing/presentation/controllers/subscription_form_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

final omdbServiceProvider = Provider<OmdbService>((ref) {
  return OmdbService(client: ref.watch(dioProvider));
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepositoryImpl(ref.watch(omdbServiceProvider));
});

final catalogProvider = FutureProvider<List<OmdbMovie>>((ref) {
  return ref.watch(catalogRepositoryProvider).fetchCatalog();
});

final subscriptionFormControllerProvider =
    StateNotifierProvider<SubscriptionFormController, SubscriptionFormState>(
  (ref) {
    return SubscriptionFormController();
  },
);
