// lib/features/owner/ownerprojects/presentation/widgets/project_tile.dart
import 'package:build4all_manager/features/owner/common/domain/entities/owner_project.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';

class ProjectTile extends StatelessWidget {
  final OwnerProject project;
  final String serverRootNoApi; // host without /api

  const ProjectTile({
    super.key,
    required this.project,
    required this.serverRootNoApi,
  });

  String _absUrl(String? maybe) {
    if (maybe == null || maybe.isEmpty) return '';
    final s = maybe.trim();
    if (s.startsWith('http://') || s.startsWith('https://')) return s;
    final base = serverRootNoApi.replaceAll(RegExp(r'/+$'), '');
    final rel = s.startsWith('/') ? s : '/$s';
    return '$base$rel';
  }

  Future<void> _openApk(BuildContext context) async {
    final urlStr = _absUrl(project.apkUrl);
    if (urlStr.isEmpty) return;
    final uri = Uri.tryParse(urlStr);
    if (uri == null) return;

    if (!await canLaunchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open: $urlStr')),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

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
              color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
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
              // Name clamped
              Expanded(
                child: Text(
                  project.projectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Slug clamped
          Text(
            project.slug,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: cs.onSurface.withOpacity(.65)),
          ),

          const Spacer(),

          // Footer row (status + action)
          Row(
            children: [
              Icon(
                ready
                    ? Icons.download_done_rounded
                    : Icons.hourglass_top_rounded,
                size: 16,
                color: ready ? cs.primary : cs.tertiary,
              ),
              const SizedBox(width: 6),
              // Status text clamped
              Expanded(
                child: Text(
                  ready
                      ? l10n.owner_projects_ready
                      : l10n.owner_projects_building,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: ready ? cs.primary : cs.tertiary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),

              // Action button kept tiny + flexible
              if (ready)
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _openApk(context),
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      label: Text(
                        l10n.owner_projects_openInBrowser,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        minimumSize: const Size(0, 0), // shrink
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
