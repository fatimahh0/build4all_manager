import 'package:build4all_manager/shared/themes/theme_palette.dart';
import 'package:flutter/material.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';
import '../../data/static_project_models.dart';

class ProjectTemplateCard extends StatelessWidget {
  final ProjectTemplate tpl;
  final VoidCallback? onOpen;
  final bool isAvailable;

  const ProjectTemplateCard({
    super.key,
    required this.tpl,
    this.onOpen,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final tint = tpl.tint ?? _pickTintFor(tpl.kind, cs);

    final mutedFg = cs.onSurface.withOpacity(isAvailable ? .72 : .45);
    final borderColor = isAvailable
        ? cs.outlineVariant.withOpacity(.6)
        : cs.outlineVariant.withOpacity(.35);
    final chipBg = tint.withOpacity(isAvailable ? .12 : .06);
    final chipFg = isAvailable ? tint : tint.withOpacity(.45);

    final ctaText =
        isAvailable ? l10n.translate(tpl.ctaKey) : l10n.owner_proj_comingSoon;

    // 🔹 Make button size slightly adapt on very small screens (if needed later)
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 380;

    final buttonPadding = EdgeInsets.symmetric(
      horizontal: isCompact ? 8 : 10,
      vertical: isCompact ? 2 : 4,
    );
    final minButtonHeight = isCompact ? 30.0 : 34.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: tpl.icon, tint: tint, dimmed: !isAvailable),
          const SizedBox(height: 10),
          Text(
            l10n.translate(tpl.titleKey),
            style: tt.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: isAvailable ? cs.onSurface : cs.onSurface.withOpacity(.75),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              l10n.translate(tpl.descKey),
              style: tt.bodySmall?.copyWith(color: mutedFg),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),

          // 🔹 Smaller, compact, always clickable button (even for Coming soon)
          Align(
            alignment: Alignment.bottomLeft,
            child: TextButton(
              onPressed: onOpen, // ✅ ALWAYS open details
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, minButtonHeight),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor:
                    isAvailable ? tint : cs.onSurface.withOpacity(.45),
                textStyle: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Padding(
                padding: buttonPadding,
                child: Text('$ctaText →'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _pickTintFor(String id, ColorScheme cs) {
    switch (id) {
      case 'activities':
        return ProjectPalette.activities;
      case 'ecommerce':
        return ProjectPalette.ecommerce;
      case 'gym':
        return ProjectPalette.gym;
      case 'services':
        return ProjectPalette.services;
      default:
        return cs.primary;
    }
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color tint;
  final bool dimmed;
  const _IconBadge({
    required this.icon,
    required this.tint,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = tint.withOpacity(dimmed ? .06 : .12);
    final fg = dimmed ? tint.withOpacity(.45) : tint;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withOpacity(.35)),
      ),
      child: Icon(icon, size: 22, color: fg),
    );
  }
}

extension _L10nX on AppLocalizations {
  String translate(String key) {
    switch (key) {
      case 'owner_proj_activities_title':
        return owner_proj_activities_title;
      case 'owner_proj_activities_desc':
        return owner_proj_activities_desc;
      case 'owner_proj_ecom_title':
        return owner_proj_ecom_title;
      case 'owner_proj_ecom_desc':
        return owner_proj_ecom_desc;
      case 'owner_proj_gym_title':
        return owner_proj_gym_title;
      case 'owner_proj_gym_desc':
        return owner_proj_gym_desc;
      case 'owner_proj_services_title':
        return owner_proj_services_title;
      case 'owner_proj_services_desc':
        return owner_proj_services_desc;
      case 'owner_proj_open':
        return owner_proj_open;
      default:
        return key;
    }
  }
}
