import 'package:build4all_manager/features/owner/common/domain/entities/owner_project.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:build4all_manager/l10n/app_localizations.dart';

class ProjectTile extends StatelessWidget {
  final OwnerProject project;
  const ProjectTile({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final ready = project.isApkReady;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(.5)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header row
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.apps_rounded, color: cs.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  project.projectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(project.slug,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: cs.onSurface.withOpacity(.65))),

          const Spacer(),
          Row(
            children: [
              Icon(
                  ready
                      ? Icons.download_done_rounded
                      : Icons.hourglass_top_rounded,
                  size: 16,
                  color: ready ? cs.primary : cs.tertiary),
              const SizedBox(width: 6),
              Text(
                ready
                    ? l10n.owner_projects_ready
                    : l10n.owner_projects_building,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: ready ? cs.primary : cs.tertiary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              if (ready)
                TextButton.icon(
                  onPressed: () async {
                    final urlStr = project.apkUrl!;
                    final uri = Uri.tryParse(urlStr);
                    if (uri != null && await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: Text(l10n.owner_projects_openInBrowser),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
