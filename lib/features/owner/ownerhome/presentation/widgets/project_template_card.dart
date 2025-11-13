import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 6)),
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
          Align(
            alignment: Alignment.bottomLeft,
            child: OutlinedButton(
              onPressed: onOpen, // details screen will gate the CTA
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: const StadiumBorder(),
                side: BorderSide(color: chipFg),
                foregroundColor: chipFg,
                backgroundColor: chipBg,
              ),
              child: Text('$ctaText →'),
            ),
          ),
        ],
      ),
    );
  }

  Color _pickTintFor(String id, ColorScheme cs) {
    switch (id) {
      case 'activities':
        return cs.primary;
      case 'ecommerce':
        return cs.secondary;
      case 'gym':
        return cs.tertiary;
      case 'services':
        return cs.primaryContainer;
      default:
        return cs.primary;
    }
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color tint;
  final bool dimmed;
  const _IconBadge(
      {required this.icon, required this.tint, this.dimmed = false});

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
