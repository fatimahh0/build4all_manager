import 'package:flutter/material.dart';
import '../../domain/entities/project_summary.dart';

class ProjectListTile extends StatelessWidget {
  final ProjectSummary p;
  final VoidCallback? onTap;
  const ProjectListTile({super.key, required this.p, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: Icon(
        p.active ? Icons.check_circle : Icons.pause_circle_filled,
        color: p.active ? cs.primary : cs.outline,
      ),
      title: Text(p.name),
      subtitle: Text(
        p.description?.trim().isNotEmpty == true ? p.description! : '—',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _fmt(p.updatedAt),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
