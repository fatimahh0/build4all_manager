import 'package:build4all_manager/features/owner/ownerprofile/domain/entities/owner_profile.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final OwnerProfile p;
  const ProfileHeader({super.key, required this.p});

  String _initials(OwnerProfile p) {
    final f = p.firstName.isNotEmpty ? p.firstName[0] : '';
    final l = p.lastName.isNotEmpty ? p.lastName[0] : '';
    final both = (f + l).toUpperCase();
    return both.isEmpty ? p.username.substring(0, 1).toUpperCase() : both;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: cs.primaryContainer,
          child: Text(
            _initials(p),
            style: tt.titleMedium?.copyWith(
              color: cs.onPrimaryContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.fullName.isEmpty ? p.username : p.fullName,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(p.email,
                  style: tt.bodySmall
                      ?.copyWith(color: tt.bodySmall?.color?.withOpacity(.75))),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: cs.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            p.role,
            style: tt.labelSmall?.copyWith(
              color: cs.onSecondaryContainer,
              fontWeight: FontWeight.w700,
              letterSpacing: .3,
            ),
          ),
        ),
      ],
    );
  }
}
