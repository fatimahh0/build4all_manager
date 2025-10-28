import 'package:flutter/material.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(
            child: Text(
              l10n.owner_home_hello,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: cs.primary,
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ]),
        const SizedBox(height: 6),
        Text(
          l10n.owner_home_subtitle,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: cs.onSurface.withOpacity(0.7)),
        ),
      ],
    );
  }
}
