// lib/features/owner/ownerhome/presentation/screens/owner_project_details_screen.dart
import 'package:build4all_manager/features/owner/ownerhome/presentation/specs/project_details_specs.dart';
import 'package:build4all_manager/features/owner/ownerrequests/presentation/screens/owner_requests_screen.dart';
import 'package:build4all_manager/shared/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';

import '../../data/static_project_models.dart';

class OwnerProjectDetailsScreen extends StatelessWidget {
  final ProjectTemplate tpl;
  final int ownerId;

  const OwnerProjectDetailsScreen({
    super.key,
    required this.tpl,
    required this.ownerId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final ux = Theme.of(context).extension<UiTokens>()!;
    final width = MediaQuery.of(context).size.width;

    final spec = themedSpecFor(context, tpl.kind);

    final pagePad = width >= 480
        ? const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
        : ux.pagePad;
    final radiusLg = ux.radiusLg;
    final radiusMd = ux.radiusMd;

    final int initialProjectId = _resolveProjectId(tpl.kind);
    final String? initialAppName = _prefillName(tpl.kind);

    return Scaffold(
      backgroundColor: cs.background,

      // NEW: top app bar with a back button instead of bottom nav
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cs.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: cs.onSurface,
          onPressed: () => Navigator.of(context).pop(),
          tooltip: l10n.owner_nav_home,
        ),
        title: Text(
          l10n.translate(tpl.titleKey),
          style: TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
      ),

      body: SafeArea(
        top: false, // we already have an AppBar
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ---------- Header ----------
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  pagePad.horizontal / 2,
                  pagePad.vertical,
                  pagePad.horizontal / 2,
                  0,
                ),
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [spec.headerStart, spec.headerEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(radiusLg + 4),
                  boxShadow: ux.cardShadow,
                ),
                child: DefaultTextStyle(
                  style: GoogleFonts.inter(color: Colors.white, height: 1.25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.18),
                          borderRadius: BorderRadius.circular(radiusMd),
                        ),
                        alignment: Alignment.center,
                        child: Text(spec.emoji,
                            style: const TextStyle(fontSize: 24)),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        spec.headline(l10n),
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        spec.subhead(l10n),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withOpacity(.92),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ---------- Stats (ALWAYS one row, 2 lines each) ----------
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  pagePad.horizontal / 2,
                  14,
                  pagePad.horizontal / 2,
                  0,
                ),
                child: _StatsRow(spec: spec, radius: radiusLg),
              ),
            ),

            // ---------- CTA ----------
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  pagePad.horizontal / 2,
                  14,
                  pagePad.horizontal / 2,
                  0,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(radiusLg),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OwnerRequestScreen(
                          ownerId: ownerId,
                          initialProjectId: initialProjectId,
                          initialAppName: initialAppName,
                        ),
                      ),
                    );
                  },
                  child: _CreateCtaCard(spec: spec, radius: radiusLg),
                ),
              ),
            ),

            // ---------- Highlights ----------
            _SectionTitle(
              padH: pagePad.horizontal / 2,
              title: spec.i18nHighlights(l10n),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  pagePad.horizontal / 2,
                  0,
                  pagePad.horizontal / 2,
                  0,
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: spec.highlights(l10n).map((txt) {
                    return _ChipPill(
                      text: txt,
                      bg: spec.chipBg,
                      fg: spec.accent,
                    );
                  }).toList(),
                ),
              ),
            ),

            // ---------- Screens ----------
            _SectionTitle(
              padH: pagePad.horizontal / 2,
              title: spec.i18nScreens(l10n),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 148,
                child: ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: pagePad.horizontal / 2),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, i) {
                    final s = spec.screens(l10n)[i];
                    return _MiniScreenCard(
                      title: s.title,
                      subtitle: s.subtitle,
                      bg: s.bg,
                      radius: radiusMd + 2,
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: spec.screens(l10n).length,
                ),
              ),
            ),

            // ---------- Modules ----------
            _SectionTitle(
              padH: pagePad.horizontal / 2,
              title: spec.i18nModules(l10n),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  pagePad.horizontal / 2,
                  0,
                  pagePad.horizontal / 2,
                  0,
                ),
                child: Column(
                  children: spec
                      .modules(l10n)
                      .map((m) => _ListTileCard(text: m, radius: radiusMd))
                      .toList(),
                ),
              ),
            ),

            // ---------- Insights ----------
            _SectionTitle(
              padH: pagePad.horizontal / 2,
              title: spec.i18nWhy(l10n),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  pagePad.horizontal / 2,
                  0,
                  pagePad.horizontal / 2,
                  20,
                ),
                child: Column(
                  children: spec.insights(l10n).map((i) {
                    return _InsightCard(
                      emoji: i.emoji,
                      text: i.text,
                      bubble: spec.accent,
                      radius: radiusMd,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
          ],
        ),
      ),
      // NOTE: bottomNavigationBar removed as requested
    );
  }
}

/* ---------------- helpers ---------------- */

int _resolveProjectId(String id) {
  switch (id) {
    case 'activities':
      return 1;
    case 'ecommerce':
      return 2;
    case 'gym':
      return 3;
    case 'services':
      return 4;
    default:
      return 0;
  }
}

String? _prefillName(String id) {
  switch (id) {
    case 'activities':
      return 'My Activities App';
    case 'ecommerce':
      return 'My Shop';
    case 'gym':
      return 'My Gym App';
    case 'services':
      return 'My Services App';
    default:
      return null;
  }
}

class _SectionTitle extends StatelessWidget {
  final double padH;
  final String title;
  const _SectionTitle({required this.padH, required this.title});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(padH, 18, padH, 10),
        child: Text(
          title,
          style: tt.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final ThemedProjectDetailsSpec spec;
  final double radius;
  const _StatsRow({required this.spec, required this.radius});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final ux = Theme.of(context).extension<UiTokens>()!;

    // map the hint keys to localized strings
    String _hint(String key) => switch (key) {
          'stat_reviews_hint' =>
            l10n.owner_proj_details_stat_reviews_hint, // "reviews"
          'stat_active_hint' =>
            l10n.owner_proj_details_stat_active_hint, // "Active deployments"
          'stat_days_hint' => l10n.owner_proj_details_stat_days_hint, // "days"
          _ => key,
        };

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: ux.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 4.8★ + "reviews"
          Expanded(
            child: _MetricItem(
              top: spec.stat1Title, // "4.8"
              hint: _hint(spec.stat1Hint), // "reviews"
              suffixStar: true,
            ),
          ),
          Expanded(
            child: _MetricItem(
              top: spec.stat2Title, // "3.6k"
              hint: _hint(spec.stat2Hint), // "Active deployments"
            ),
          ),
          Expanded(
            child: _MetricItem(
              // "10 days" on the FIRST line
              top: '${spec.stat3Title} ', // "10 days"
              // "Average turnaround" on SECOND line
              hint: _hint(spec.stat3Hint),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String top; // first line
  final String hint; // second line
  final bool suffixStar;

  const _MetricItem({
    required this.top,
    required this.hint,
    this.suffixStar = false,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // line 1 (scaled to fit, star inline if needed)
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                top,
                style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (suffixStar) ...[
                const SizedBox(width: 4),
                const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
              ],
            ],
          ),
        ),
        const SizedBox(height: 4),
        // line 2
        Text(
          hint,
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _CreateCtaCard extends StatelessWidget {
  final ThemedProjectDetailsSpec spec;
  final double radius;
  const _CreateCtaCard({required this.spec, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [spec.accent, spec.createEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: spec.accent.withOpacity(.28),
            blurRadius: 26,
            offset: const Offset(0, 16),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _Badge(text: '✨'),
          const SizedBox(width: 12),
          Expanded(
            child: DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(spec.i18nCreateTitle(AppLocalizations.of(context)!),
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(
                    spec.i18nCreateSubtitle(AppLocalizations.of(context)!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(.86),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _Badge(text: '➜', size: 32, fontSize: 18, opacity: .16),
        ],
      ),
    );
  }
}

class _ChipPill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const _ChipPill({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Text(text,
          style:
              TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _MiniScreenCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color bg;
  final double radius;
  const _MiniScreenCard({
    required this.title,
    required this.subtitle,
    required this.bg,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 168,
      padding: const EdgeInsets.all(16),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(radius)),
      child: DefaultTextStyle(
        style: tt.bodySmall!.copyWith(color: cs.onSurface.withOpacity(.85)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(subtitle, maxLines: 3, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _ListTileCard extends StatelessWidget {
  final String text;
  final double radius;
  const _ListTileCard({required this.text, required this.radius});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ux = Theme.of(context).extension<UiTokens>()!;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: ux.cardShadow,
      ),
      child: Text(text, style: TextStyle(color: cs.onSurface.withOpacity(.9))),
    );
  }
}

extension on SizedBox {
  EdgeInsets get flatten => EdgeInsets.zero;
  // helper to keep code compiles if you paste as-is
}

class _InsightCard extends StatelessWidget {
  final String emoji;
  final String text;
  final Color bubble;
  final double radius;
  const _InsightCard({
    required this.emoji,
    required this.text,
    required this.bubble,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ux = Theme.of(context).extension<UiTokens>()!;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: ux.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: bubble, borderRadius: BorderRadius.circular(12)),
            child: Text(emoji,
                style: const TextStyle(fontSize: 18, color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final double size;
  final double fontSize;
  final double opacity;
  const _Badge({
    required this.text,
    this.size = 50,
    this.fontSize = 22,
    this.opacity = .16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(16),
      ),
      child:
          Text(text, style: TextStyle(fontSize: fontSize, color: Colors.white)),
    );
  }
}

// tiny helper for dynamic title in AppBar
extension _L10nX on AppLocalizations {
  String translate(String key) {
    switch (key) {
      case 'owner_proj_activities_title':
        return owner_proj_activities_title;
      case 'owner_proj_ecom_title':
        return owner_proj_ecom_title;
      case 'owner_proj_gym_title':
        return owner_proj_gym_title;
      case 'owner_proj_services_title':
        return owner_proj_services_title;
      default:
        return key;
    }
  }
}
