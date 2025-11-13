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
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final ready = project.isApkReady;

    final Color band = ready ? cs.primary : cs.tertiary;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant.withOpacity(.5)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 8)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ---------- Banner (icon, title, slug) ----------
          Container(
            height: 86,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [band.withOpacity(.18), band.withOpacity(.06)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: band.withOpacity(.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.apps_rounded, color: band, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.projectName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tt.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        project.slug,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tt.bodySmall
                            ?.copyWith(color: cs.onSurface.withOpacity(.65)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),

          // ---------- Body ----------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusPill(
                    ready: ready,
                    text: ready
                        ? l10n.owner_projects_ready
                        : l10n.owner_projects_building,
                    color: ready ? cs.primary : cs.tertiary,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      if (ready)
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () => _openApk(context),
                            icon: const Icon(Icons.download_rounded, size: 18),
                            label: Text(l10n.owner_projects_openInBrowser,
                                maxLines: 1),
                            style: TextButton.styleFrom(
                              foregroundColor: cs.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: Size.zero,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tt.labelMedium?.copyWith(
                                    color: cs.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
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

class _StatusPill extends StatelessWidget {
  final bool ready;
  final String text;
  final Color color;
  const _StatusPill(
      {required this.ready, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ready ? Icons.check_circle_rounded : Icons.hourglass_top_rounded,
              size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
