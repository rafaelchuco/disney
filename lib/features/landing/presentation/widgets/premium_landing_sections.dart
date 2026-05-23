import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:disney/core/constants/app_assets.dart';
import 'package:disney/features/landing/data/models/omdb_movie.dart';
import 'package:disney/features/landing/presentation/controllers/subscription_form_controller.dart';
import 'package:disney/features/landing/presentation/providers/catalog_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeroSection extends ConsumerStatefulWidget {
  const HeroSection({
    super.key,
    required this.movies,
    required this.isWide,
  });

  final List<OmdbMovie> movies;
  final bool isWide;

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final FocusNode _emailFocusNode;
  late final PageController _pageController;

  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();
    _pageController = PageController();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients) {
        return;
      }

      final next = (_currentIndex + 1) % AppAssets.heroCdnImages.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(subscriptionFormControllerProvider);
    final formController = ref.read(subscriptionFormControllerProvider.notifier);

    final horizontalPadding = widget.isWide ? 24.0 : 12.0;
    final heroHeight = widget.isWide ? 640.0 : 560.0;

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: heroHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: AppAssets.heroCdnImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: AppAssets.heroCdnImages[index],
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 500),
                placeholder: (context, _) => Image.asset(
                  AppAssets.localHeroImages[index],
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, _, __) => Image.asset(
                  AppAssets.localHeroImages[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        Container(
          height: heroHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x44000000), Color(0x99040714), Color(0xFF040714)],
              stops: [0.12, 0.55, 1],
            ),
          ),
        ),
        Positioned(
          top: 84,
          left: 12,
          right: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < AppAssets.heroCdnImages.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _currentIndex ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _currentIndex ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          top: 106,
          left: 0,
          right: 0,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 380),
            child: Text(
              AppAssets.heroLabels[_currentIndex],
              key: ValueKey(_currentIndex),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 10, horizontalPadding, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GlassHeader(isWide: widget.isWide),
              SizedBox(height: widget.isWide ? 260 : 185),
              Center(
                child: Image.asset(
                  AppAssets.disneyLogo,
                  height: widget.isWide ? 76 : 56,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Series exclusivas, exitos del cine,\nel deporte de ESPN y mas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: widget.isWide ? 30 : 24,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Ingresa tu correo para comenzar',
                  style: TextStyle(
                    color: Color(0xFFC0C0C0),
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(color: Color(0xFFB7B8BD), fontSize: 18),
                        validator: formController.validateEmail,
                        decoration: const InputDecoration(
                          hintText: 'Correo electronico',
                          hintStyle: TextStyle(color: Color(0xFFB7B8BD), fontSize: 18),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: formController.updateEmail,
                        onFieldSubmitted: (_) async {
                          await _submitForm(formController);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF02D6E8),
                          foregroundColor: const Color(0xFF02172A),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: formState.isSubmitting
                            ? null
                            : () async {
                                await _submitForm(formController);
                              },
                        child: formState.isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'SUSCRIBIRME AHORA',
                                  style: TextStyle(
                                    fontSize: 13,
                                    letterSpacing: 0.35,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              if (formState.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  formState.errorMessage!,
                  style: const TextStyle(color: Color(0xFFFFB6B6), fontSize: 11),
                ),
              ],
              if (formState.successMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  formState.successMessage!,
                  style: const TextStyle(color: Color(0xFF8EF2A9), fontSize: 11),
                ),
              ],
              const SizedBox(height: 11),
              const Center(
                child: Text(
                  'Ahorra desde 30% en Disney+ Premium Anual. Ver detalles de los planes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFC9D1E3),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submitForm(
    SubscriptionFormController formController,
  ) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() != true) {
      _emailFocusNode.requestFocus();
      return;
    }

    formController.updateEmail(_emailController.text);
    await formController.submit();
  }
}

class _GlassHeader extends StatelessWidget {
  const _GlassHeader({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          AppAssets.disneyLogo,
          height: isWide ? 38 : 30,
          fit: BoxFit.contain,
        ),
        const Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xCC000000),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF6F717B), width: 2),
              ),
              child: const Text(
                'INICIAR SESION',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFFAFAFA),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NbaPromoSection extends StatelessWidget {
  const NbaPromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A210D), Color(0xFF0A1020)],
          ),
          border: Border.all(color: const Color(0xFF3C2F16)),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                gradient: LinearGradient(
                  colors: [Color(0xFF9B7A2F), Color(0xFFE4C06A), Color(0xFF9B7A2F)],
                ),
              ),
              child: const Center(
                child: Text(
                  'FINAL DE CONFERENCIA',
                  style: TextStyle(
                    color: Color(0xFF0A1325),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.9,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'ESPN  |  Disney+',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Todo el deporte en tus manos por 26 al mes. No pagues dos o una y ahorra tu inversion '
                'y los eventos en vivo que te apasionan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFCAD2E7), fontSize: 12, height: 1.4),
              ),
            ),
            const SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF02D6E8),
                    foregroundColor: const Color(0xFF001426),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'SUSCRIBIRME AHORA',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const _MiniThumbRow(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _MiniThumbRow extends StatelessWidget {
  const _MiniThumbRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: AppAssets.heroCdnImages.length,
        separatorBuilder: (context, index) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: AppAssets.heroCdnImages[index],
              width: 74,
              fit: BoxFit.cover,
              placeholder: (context, _) => Image.asset(
                AppAssets.localHeroImages[index],
                width: 74,
                fit: BoxFit.cover,
              ),
              errorWidget: (context, _, __) => Image.asset(
                AppAssets.localHeroImages[index],
                width: 74,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 38,
          fontWeight: FontWeight.w700,
          height: 0.95,
        ),
      ),
    );
  }
}

class TopTenSection extends StatelessWidget {
  const TopTenSection({
    super.key,
    required this.movies,
    required this.isLoading,
  });

  final List<OmdbMovie> movies;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 228,
      child: isLoading
          ? const _CloudLoadingRow(cardWidth: 132)
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: movies.length > 10 ? 10 : movies.length,
              separatorBuilder: (context, index) => const SizedBox(width: 9),
              itemBuilder: (context, index) {
                return _RankedPosterCard(movie: movies[index], rank: index + 1);
              },
            ),
    );
  }
}

class _RankedPosterCard extends StatelessWidget {
  const _RankedPosterCard({
    required this.movie,
    required this.rank,
  });

  final OmdbMovie movie;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: movie.poster,
              width: 132,
              height: 210,
              fit: BoxFit.cover,
              placeholder: (context, _) => Container(
                width: 132,
                height: 210,
                color: const Color(0xFF13264A),
              ),
              errorWidget: (context, _, __) => Container(
                width: 132,
                height: 210,
                color: const Color(0xFF18284A),
                alignment: Alignment.center,
                child: const Icon(Icons.movie_filter_rounded, color: Colors.white60, size: 30),
              ),
            ),
          ),
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xCC020814),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$rank',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0xD9000000)],
                ),
              ),
              child: Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlansSection extends StatelessWidget {
  const PlansSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF08142D),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF213357)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Podras modificarlo o cancelarlo cuando quieras',
              style: TextStyle(color: Color(0xFFBFC8DE), fontSize: 12),
            ),
            SizedBox(height: 10),
            _PlanFeatureRow(
              label: 'Precio mensual',
              premium: 'PEN 39.90/mes',
              standard: 'PEN 26.90/mes',
            ),
            _PlanFeatureRow(
              label: 'Resolucion de imagen',
              premium: '4K Ultra HD',
              standard: '1080p Full HD',
            ),
            _PlanFeatureRow(
              label: 'Catalogo completo de ESPN y Disney+',
              premium: 'Si',
              standard: 'Si',
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanFeatureRow extends StatelessWidget {
  const _PlanFeatureRow({
    required this.label,
    required this.premium,
    required this.standard,
  });

  final String label;
  final String premium;
  final String standard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFFC5CEE4), fontSize: 12),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              premium,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              standard,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFD0D8EA), fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentlyAddedSection extends StatelessWidget {
  const RecentlyAddedSection({
    super.key,
    required this.movies,
    required this.isLoading,
  });

  final List<OmdbMovie> movies;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165,
      child: isLoading
          ? const _CloudLoadingRow(cardWidth: 190)
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: movies.length < 7 ? movies.length : 7,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final movie = movies[(index + 2) % movies.length];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 190,
                    child: CachedNetworkImage(
                      imageUrl: movie.poster,
                      fit: BoxFit.cover,
                      placeholder: (context, _) => Container(color: const Color(0xFF16284C)),
                      errorWidget: (context, _, __) => Container(
                        color: const Color(0xFF16284C),
                        alignment: Alignment.center,
                        child: const Icon(Icons.movie_creation_outlined, color: Colors.white60),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class DevicesSection extends StatelessWidget {
  const DevicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF09142A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E3156)),
        ),
        child: Column(
          children: [
            const Text(
              'Disfruta tus favoritos en cualquier momento y lugar',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: AppAssets.heroCdnImages[3],
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, _) => Image.asset(
                  AppAssets.localHeroImages[3],
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, _, __) => Image.asset(
                  AppAssets.localHeroImages[3],
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    const faqItems = [
      (
        'Que incluye Disney+?',
        'Incluye peliculas, series, Originals, documentales y eventos deportivos en vivo de ESPN.',
      ),
      (
        'Como puedo pagar?',
        'Puedes pagar con tarjeta de credito, debito o metodos locales habilitados segun tu pais.',
      ),
      (
        'Donde puedo ver Disney+?',
        'En Smart TV, celulares, tablets, navegadores y consolas compatibles.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (final item in faqItems)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF111B33),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF22365C)),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  title: Text(item.$1, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  children: [
                    Text(
                      item.$2,
                      style: const TextStyle(color: Color(0xFFC4CCE2), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    const footerLinks = [
      'Acerca de',
      'Politica de privacidad',
      'Acuerdo de suscripcion',
      'Ayuda',
      'Dispositivos compatibles',
      'Publicidad personalizada',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 26),
      decoration: const BoxDecoration(
        color: Color(0xFF030915),
        border: Border(top: BorderSide(color: Color(0xFF1B2D52))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final link in footerLinks)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Text(
                link,
                style: const TextStyle(color: Color(0xFFC8D0E3), fontSize: 12),
              ),
            ),
          const Divider(color: Color(0xFF1B2D52), height: 26),
          const SizedBox(height: 22),
          Center(
            child: Image.asset(
              AppAssets.disneyLogo,
              height: 36,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 11),
          const Text(
            '© 2026 Disney y sus marcas relacionadas son marcas comerciales de The Walt Disney Company y sus afiliadas.\n'
            'Los contenidos y eventos en vivo estan sujetos a disponibilidad regional y cambios sin previo aviso.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF8A98B8), fontSize: 10, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _CloudLoadingRow extends StatelessWidget {
  const _CloudLoadingRow({required this.cardWidth});

  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 4,
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        return Container(
          width: cardWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF13264A),
          ),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}

class ErrorMessageBanner extends StatelessWidget {
  const ErrorMessageBanner({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF351B28),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF6A304A)),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFFFFCBD9), fontSize: 12),
      ),
    );
  }
}
