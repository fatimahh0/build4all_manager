import 'package:flutter/material.dart';
import '../../domain/entities/admin_profile.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';

class ProfileHeader extends StatelessWidget {
  final AdminProfile me;
  const ProfileHeader({super.key, required this.me});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: cs.onPrimary.withOpacity(.12),
            child: Text(
              _initials(me.firstName, me.lastName),
              style: TextStyle(
                color: cs.onPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: cs.onPrimary,
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${me.firstName} ${me.lastName}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Text('@${me.username} • ${l10n.nav_super_admin}'),
                  Text(me.email),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String f, String l) =>
      '${(f.isNotEmpty ? f[0] : 'A')}${(l.isNotEmpty ? l[0] : 'U')}'
          .toUpperCase();
}
