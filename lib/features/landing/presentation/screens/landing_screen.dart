import 'package:disney/features/landing/data/models/omdb_movie.dart';
import 'package:disney/features/landing/presentation/providers/catalog_providers.dart';
import 'package:disney/features/landing/presentation/widgets/landing_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider);

    final movies = catalog.valueOrNull ?? const <OmdbMovie>[];
    final hasLoadingState = catalog.isLoading && movies.isEmpty;
    final errorMessage = catalog.hasError
        ? 'No se pudo actualizar el catalogo. Mostrando contenido disponible.'
        : null;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF03112B), Color(0xFF020814), Color(0xFF01040C)],
            stops: [0, 0.6, 1],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final isWide = width >= 720;
              final contentWidth = width > 1100 ? 1100.0 : width;

              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: contentWidth,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: isWide ? 16 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeroSection(movies: movies, isWide: isWide),
                        if (errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                            child: ErrorMessageBanner(message: errorMessage),
                          ),
                        const SizedBox(height: 14),
                        const NbaPromoSection(),
                        const SizedBox(height: 28),
                        const SectionTitle('Top 10 Hoy'),
                        TopTenSection(
                          movies: movies,
                          isLoading: hasLoadingState,
                        ),
                        const SizedBox(height: 28),
                        const SectionTitle('Que plan vas a elegir?'),
                        const PlansSection(),
                        const SizedBox(height: 28),
                        const SectionTitle('Recien agregados'),
                        RecentlyAddedSection(
                          movies: movies,
                          isLoading: hasLoadingState,
                        ),
                        const SizedBox(height: 28),
                        const SectionTitle('Cuando y donde quieras'),
                        const DevicesSection(),
                        const SizedBox(height: 28),
                        const SectionTitle('Preguntas frecuentes'),
                        const FaqSection(),
                        const SizedBox(height: 22),
                        const FooterSection(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
