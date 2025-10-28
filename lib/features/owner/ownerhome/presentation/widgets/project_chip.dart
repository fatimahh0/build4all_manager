import 'package:flutter/material.dart';
import '../../../common/domain/entities/owner_project.dart';

class ProjectChip extends StatelessWidget {
  final OwnerProject project;
  final VoidCallback? onTap;
  const ProjectChip({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant.withOpacity(.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.projectName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              project.slug,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: cs.onSurface.withOpacity(0.6)),
            ),
            const Spacer(),
            Row(children: [
              Icon(
                project.isApkReady
                    ? Icons.download_done_rounded
                    : Icons.hourglass_top_rounded,
                size: 16,
                color: project.isApkReady ? cs.primary : cs.tertiary,
              ),
              const SizedBox(width: 6),
              Text(
                project.isApkReady ? 'Ready' : 'Building…',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: project.isApkReady ? cs.primary : cs.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
