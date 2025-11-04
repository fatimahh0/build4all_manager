import 'package:build4all_manager/features/owner/ownerprofile/domain/entities/owner_profile.dart';
import 'package:flutter/material.dart';

import 'package:build4all_manager/l10n/app_localizations.dart';

class ProfileInfoCard extends StatelessWidget {
  final OwnerProfile p;
  const ProfileInfoCard({super.key, required this.p});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    Widget row(String label, String value, {IconData? icon}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            if (icon != null) Icon(icon, size: 18, color: cs.primary),
            if (icon != null) const SizedBox(width: 8),
            Expanded(
                child: Text(label,
                    style:
                        tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
            const SizedBox(width: 8),
            Flexible(child: Text(value, textAlign: TextAlign.right)),
          ],
        ),
      );
    }

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outline.withOpacity(.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            row(l10n.owner_profile_username, p.username,
                icon: Icons.alternate_email),
            const Divider(height: 20),
            row(l10n.owner_profile_name, p.fullName.isEmpty ? '—' : p.fullName,
                icon: Icons.person_outline),
            const Divider(height: 20),
            row(l10n.owner_profile_email, p.email, icon: Icons.mail_outline),
          ],
        ),
      ),
    );
  }
}
