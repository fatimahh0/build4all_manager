// lib/features/owner/ownerhome/presentation/widgets/project_template_card.dart
import 'package:go_router/go_router.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';
import '../../data/static_project_models.dart';
import 'package:flutter/material.dart';

class ProjectTemplateCard extends StatelessWidget {
  final ProjectTemplate tpl;
  final VoidCallback? onOpen;
  final bool comingSoon; // visual only

  const ProjectTemplateCard({
    super.key,
    required this.tpl,
    this.onOpen,
    this.comingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final tint = tpl.tint ?? _pickTintFor(tpl.kind, cs); // always colored

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant.withOpacity(.6)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: tpl.icon, tint: tint),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.translate(tpl.titleKey),
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (comingSoon)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: cs.outlineVariant.withOpacity(.32),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Soon',
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurface.withOpacity(.7),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              l10n.translate(tpl.descKey),
              style:
                  tt.bodySmall?.copyWith(color: cs.onSurface.withOpacity(.72)),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomLeft,
            child: OutlinedButton(
              onPressed:
                  onOpen ?? () => context.push('/owner/project/${tpl.id}'),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: const StadiumBorder(),
                side: BorderSide(color: tint.withOpacity(.6)),
                foregroundColor: tint,
              ),
              child: Text('${l10n.translate(tpl.ctaKey)} →'),
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
  const _IconBadge({required this.icon, required this.tint});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: tint.withOpacity(.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withOpacity(.35)),
      ),
      child: Icon(icon, size: 22, color: tint),
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
