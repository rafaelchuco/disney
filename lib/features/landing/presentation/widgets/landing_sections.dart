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

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(subscriptionFormControllerProvider);
    final formController = ref.read(subscriptionFormControllerProvider.notifier);

    final heroImage = AppAssets.heroImages.first;

    final horizontalPadding = widget.isWide ? 24.0 : 12.0;

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: widget.isWide ? 620 : 520,
          child: Image.asset(
            heroImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: const Color(0xFF0C1635));
            },
          ),
        ),
        Container(
          height: widget.isWide ? 620 : 520,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x77000000), Color(0xCC020814), Color(0xFF020814)],
              stops: [0.15, 0.6, 1],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 10, horizontalPadding, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const DisneyLogo(),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xBB0C1325),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: const Text(
                      'INICIAR SESION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: widget.isWide ? 260 : 180),
              Center(
                child: Text(
                  'Disney+',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.isWide ? 44 : 35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: widget.isWide ? 16 : 8),
              Center(
                child: Text(
                  'Series exclusivas, exito del cine,\nel deporte de ESPN y mas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: widget.isWide ? 30 : 24,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Ingresa tu correo para comenzar',
                  style: TextStyle(
                    color: Color(0xFFB8C1D9),
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(color: Colors.white),
                  validator: formController.validateEmail,
                  decoration: const InputDecoration(
                    hintText: 'Correo electronico',
                    hintStyle: TextStyle(color: Color(0xFF97A5C5), fontSize: 13),
                  ),
                  onChanged: formController.updateEmail,
                  onFieldSubmitted: (_) async {
                    await _submitForm(formController);
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C7EF),
                    foregroundColor: const Color(0xFF001426),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
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
                      : const Text(
                          'SUSCRIBIRME AHORA',
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
              if (formState.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  formState.errorMessage!,
                  style: const TextStyle(
                    color: Color(0xFFFFB6B6),
                    fontSize: 11,
                  ),
                ),
              ],
              if (formState.successMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  formState.successMessage!,
                  style: const TextStyle(
                    color: Color(0xFF8EF2A9),
                    fontSize: 11,
                  ),
                ),
              ],
              const SizedBox(height: 11),
              const Center(
                child: Text(
                  'Ahora desde S/. 26 al mes | Terminos aplican',
                  style: TextStyle(
                    color: Color(0xFFC9D1E3),
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'Ver detalles de los planes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const BrandRow(),
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

class DisneyLogo extends StatelessWidget {
  const DisneyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.disneyLogo,
      height: 34,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Disney',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '+',
              style: TextStyle(
                color: Color(0xFF00C7EF),
                fontSize: 33,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}

class BrandRow extends StatelessWidget {
  const BrandRow({super.key});

  @override
  Widget build(BuildContext context) {
    const labels = ['Disney+', 'Pixar', 'MARVEL', 'STAR WARS', 'NAT GEO', 'hulu'];

    return SizedBox(
      height: 20,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return Text(
            labels[index],
            style: const TextStyle(
              color: Color(0xFFCED5E6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
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
                    backgroundColor: const Color(0xFF00C7EF),
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
            const MiniThumbRow(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class MiniThumbRow extends StatelessWidget {
  const MiniThumbRow({super.key});

  @override
  Widget build(BuildContext context) {
    const images = AppAssets.heroImages;

    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (context, index) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              images[index],
              width: 74,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 74,
                  color: const Color(0xFF12203D),
                  alignment: Alignment.center,
                  child: const Icon(Icons.sports_basketball, color: Colors.white70, size: 16),
                );
              },
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
          ? const CloudLoadingRow(cardWidth: 132)
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: movies.length > 10 ? 10 : movies.length,
              separatorBuilder: (context, index) => const SizedBox(width: 9),
              itemBuilder: (context, index) {
                return RankedPosterCard(movie: movies[index], rank: index + 1);
              },
            ),
    );
  }
}

class RankedPosterCard extends StatelessWidget {
  const RankedPosterCard({
    super.key,
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
            child: Image.network(
              movie.poster,
              width: 132,
              height: 210,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 132,
                  height: 210,
                  color: const Color(0xFF18284A),
                  alignment: Alignment.center,
                  child: const Icon(Icons.movie_filter_rounded, color: Colors.white60, size: 30),
                );
              },
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
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
          children: [
            const Text(
              'Podras modificarlo o cancelarlo cuando quieras',
              style: TextStyle(color: Color(0xFFBFC8DE), fontSize: 12),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                PlanPill(name: 'MAS POPULAR'),
                SizedBox(width: 8),
                PlanPill(name: 'ANUAL', subtle: true),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Expanded(child: PlanHeader(name: 'PREMIUM', active: true)),
                SizedBox(width: 8),
                Expanded(child: PlanHeader(name: 'ESTANDAR')),
              ],
            ),
            const SizedBox(height: 15),
            const PlanFeatureRow(
              label: 'Precio mensual',
              premium: 'PEN 39.90/mes',
              standard: 'PEN 26.90/mes',
            ),
            const PlanFeatureRow(
              label: 'Resolucion de imagen',
              premium: '4K Ultra HD',
              standard: '1080p Full HD',
            ),
            const PlanFeatureRow(
              label: 'Catalogo completo de ESPN y Disney+',
              premium: 'Si',
              standard: 'Si',
              boolCells: true,
            ),
            const PlanFeatureRow(
              label: 'Canales en vivo y eventos deportivos',
              premium: 'Si',
              standard: 'Si',
              boolCells: true,
            ),
            const PlanFeatureRow(
              label: 'Calidad de audio',
              premium: 'Hasta Dolby Atmos',
              standard: 'Hasta 5.1',
            ),
            const PlanFeatureRow(
              label: 'Dispositivos para ver simultaneamente',
              premium: '4',
              standard: '2',
            ),
            const PlanFeatureRow(
              label: 'Descarga para ver sin conexion',
              premium: 'Si',
              standard: 'Si',
              boolCells: true,
            ),
            const SizedBox(height: 12),
            const Text(
              '* El precio puede variar segun el metodo de pago y tu pais.\n'
              '** Algunas peliculas o canales no estan disponibles en toda la region.',
              style: TextStyle(color: Color(0xFF8E9BB9), fontSize: 10, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanPill extends StatelessWidget {
  const PlanPill({
    super.key,
    required this.name,
    this.subtle = false,
  });

  final String name;
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: subtle ? const Color(0xFF1A2641) : const Color(0xFF09385A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        name,
        style: TextStyle(
          color: subtle ? const Color(0xFFB9C4DD) : const Color(0xFF7DDFFF),
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class PlanHeader extends StatelessWidget {
  const PlanHeader({
    super.key,
    required this.name,
    this.active = false,
  });

  final String name;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: active
            ? const LinearGradient(colors: [Color(0xFF0ACCF2), Color(0xFF1681FF)])
            : null,
        color: active ? null : const Color(0xFF16233F),
      ),
      child: Text(
        name,
        style: TextStyle(
          color: active ? const Color(0xFF011223) : const Color(0xFFE6EEFF),
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          fontSize: 12,
        ),
      ),
    );
  }
}

class PlanFeatureRow extends StatelessWidget {
  const PlanFeatureRow({
    super.key,
    required this.label,
    required this.premium,
    required this.standard,
    this.boolCells = false,
  });

  final String label;
  final String premium;
  final String standard;
  final bool boolCells;

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
            child: boolCells
                ? BoolCell(enabled: premium.toLowerCase() == 'si')
                : Text(
                    premium,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
          ),
          SizedBox(
            width: 100,
            child: boolCells
                ? BoolCell(enabled: standard.toLowerCase() == 'si')
                : Text(
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

class BoolCell extends StatelessWidget {
  const BoolCell({
    super.key,
    required this.enabled,
  });

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Icon(
      enabled ? Icons.check : Icons.remove,
      color: enabled ? Colors.white : const Color(0xFF7A88A8),
      size: 18,
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
          ? const CloudLoadingRow(cardWidth: 190)
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
                    child: Image.network(
                      movie.poster,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF16284C),
                          alignment: Alignment.center,
                          child: const Icon(Icons.movie_creation_outlined, color: Colors.white60),
                        );
                      },
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
              child: Image.asset(
                AppAssets.heroImages[1],
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 160,
                    color: const Color(0xFF152648),
                    alignment: Alignment.center,
                    child: const Icon(Icons.connected_tv_rounded, color: Colors.white70, size: 42),
                  );
                },
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SocialCircle(icon: Icons.facebook_outlined),
              SocialCircle(icon: Icons.camera_alt_outlined),
              SocialCircle(icon: Icons.music_note_outlined),
              SocialCircle(icon: Icons.play_circle_outline),
            ],
          ),
          const SizedBox(height: 22),
          const Center(child: DisneyLogo()),
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

class SocialCircle extends StatelessWidget {
  const SocialCircle({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 33,
      width: 33,
      decoration: BoxDecoration(
        color: const Color(0xFF111D38),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFF273B66)),
      ),
      child: Icon(icon, size: 16, color: const Color(0xFFD8E0F2)),
    );
  }
}

class CloudLoadingRow extends StatelessWidget {
  const CloudLoadingRow({
    super.key,
    required this.cardWidth,
  });

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
