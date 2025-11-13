// lib/features/owner/ownerprofile/presentation/widgets/profile_header.dart
import 'package:build4all_manager/features/owner/ownerprofile/domain/entities/owner_profile.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';
import 'package:build4all_manager/shared/widgets/top_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileHeader extends StatelessWidget {
  final OwnerProfile p;
  const ProfileHeader({super.key, required this.p});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    final name = (p.fullName.isEmpty ? p.username : p.fullName);
    final email = p.email;
  

    return LayoutBuilder(builder: (context, c) {
      final bool wide = c.maxWidth >= 720;
      final double coverH = wide ? 180 : 140;

      return Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: cs.outlineVariant.withOpacity(.6)),
        ),
        child: Column(
          children: [
            // ---------- Cover ----------
            SizedBox(
              height: coverH,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cs.primary.withOpacity(.35), cs.primaryContainer.withOpacity(.25)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // ---------- Avatar + info stacked ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _AvatarStrip(
                name: name,
                email: email,
               
                wide: wide,
                onCopyEmail: () async {
                  await Clipboard.setData(ClipboardData(text: email));
                  if (context.mounted) {
                    showTopToast(context, l10n.copied ?? 'Copied', type: ToastType.success);
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _AvatarStrip extends StatelessWidget {
  final String name;
  final String email;

  final bool wide;
  final VoidCallback onCopyEmail;

  const _AvatarStrip({
    required this.name,
    required this.email,
   
    required this.wide,
    required this.onCopyEmail,
  });

  String _initials(String s) {
    final parts = s.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final avatar = Container(
      width: wide ? 100 : 84,
      height: wide ? 100 : 84,
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(.12),
        border: Border.all(color: cs.primary.withOpacity(.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      transform: Matrix4.translationValues(0, -40, 0),
      child: Text(
        _initials(name),
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: wide ? 30 : 26,
          color: cs.primary,
        ),
      ),
    );

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      
      child: Row(
        mainAxisSize: MainAxisSize.min,
       
      ),
    );

    final info = Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                child: Text(email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Copy',
                onPressed: onCopyEmail,
                icon: const Icon(Icons.copy_rounded, size: 18),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 8),
          chip,
        ],
      ),
    );

    final actions = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: () {/* TODO: edit */},
          icon: const Icon(Icons.edit_rounded, size: 18),
          label: const Text('Edit profile'),
        ),
        FilledButton.icon(
          onPressed: () {/* TODO: connect billing */},
          icon: const Icon(Icons.account_balance_wallet_rounded, size: 18),
          label: const Text('Billing'),
        ),
      ],
    );

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatar,
          const SizedBox(width: 16),
          Expanded(child: info),
          const SizedBox(width: 16),
          actions,
        ],
      );
    }

    // narrow
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(alignment: Alignment.centerLeft, child: avatar),
        info,
        const SizedBox(height: 12),
        actions,
      ],
    );
  }
}
