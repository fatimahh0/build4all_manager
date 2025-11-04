import 'package:build4all_manager/core/network/dio_client.dart';
import 'package:build4all_manager/features/owner/ownerrequests/data/repositories/owner_requests_repository_impl.dart';
import 'package:build4all_manager/features/owner/ownerrequests/data/services/owner_requests_api.dart';
import 'package:build4all_manager/features/owner/ownerrequests/data/services/themes_api.dart';
import 'package:build4all_manager/features/owner/ownerrequests/domain/entities/theme_lite.dart';
import 'package:build4all_manager/features/owner/ownerrequests/presentation/cubit/owner_requests_cubit.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_request.dart';
import '../../domain/entities/project.dart';

class OwnerRequestScreen extends StatelessWidget {
  final int ownerId;
  const OwnerRequestScreen({super.key, required this.ownerId});

  @override
  Widget build(BuildContext context) {
    final dio = DioClient.ensure();
    final repo = OwnerRequestsRepositoryImpl(
      OwnerRequestsApi(dio),
      ThemesApi(dio),
    );

    return BlocProvider(
      create: (_) {
        final cubit = OwnerRequestsCubit(repo: repo, ownerId: ownerId);
        // Wire the concrete API so the cubit can call multipart upload
        cubit.setConcreteApi(OwnerRequestsApi(dio));
        cubit.init();
        return cubit;
      },
      child: const _OwnerRequestView(),
    );
  }
}

class _OwnerRequestView extends StatelessWidget {
  const _OwnerRequestView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<OwnerRequestsCubit, OwnerRequestsState>(
      listenWhen: (p, c) =>
          p.error != c.error || p.lastCreated != c.lastCreated,
      listener: (context, s) {
        if (s.error != null && s.error!.isNotEmpty) {
          final msg = switch (s.error) {
            '_ERR_NO_PROJECT_' => l10n.owner_request_error_choose_project,
            '_ERR_NO_APPNAME_' => l10n.owner_request_error_app_name,
            _ => s.error!,
          };
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
        }
        if (s.lastCreated != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.owner_request_success)),
          );
        }
      },
      builder: (context, s) {
        final cubit = context.read<OwnerRequestsCubit>();
        final cs = Theme.of(context).colorScheme;

        return Scaffold(
          appBar: AppBar(title: Text(l10n.owner_request_title)),
          body: SafeArea(
            child: s.loading
                ? const Center(child: CircularProgressIndicator())
                : LayoutBuilder(
                    builder: (ctx, bx) {
                      final isWide = bx.maxWidth >= 980;

                      // ---------- Left: Professional form (card, responsive) ----------
                      final form = ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: Card(
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side:
                                BorderSide(color: cs.outline.withOpacity(.25)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _HeroHeader(
                                  title: l10n.owner_request_title,
                                  subtitle: l10n.owner_request_submit_hint,
                                  icon: Icons.rocket_launch,
                                ),
                                const SizedBox(height: 16),

                                // Project dropdown (no grid)
                                DropdownButtonFormField<Project?>(
                                  value: s.selected,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: l10n.owner_request_project,
                                    border: const OutlineInputBorder(),
                                  ),
                                  items: s.projects.map((p) {
                                    return DropdownMenuItem<Project?>(
                                      value: p,
                                      child: Text(
                                        p.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: cubit.selectProject,
                                ),
                                const SizedBox(height: 12),

                                // App name
                                _TextField(
                                  label: l10n.owner_request_appName,
                                  hint: l10n.owner_request_appName_hint,
                                  initial: s.appName,
                                  onChanged: cubit.setAppName,
                                ),
                                const SizedBox(height: 12),

                                // Logo URL (optional)
                                _TextField(
                                  label: l10n.owner_request_logo_url,
                                  hint: l10n.owner_request_logo_url_hint,
                                  initial: s.logoUrl ?? '',
                                  onChanged: (v) => cubit.setLogoUrl(
                                      v.trim().isEmpty ? null : v.trim()),
                                  prefixIcon: const Icon(Icons.image_outlined),
                                ),
                                const SizedBox(height: 8),

                                // NEW: Upload file button + preview of the saved URL
                                Row(
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: s.uploadingLogo
                                          ? null
                                          : () => cubit.pickAndUploadLogo(),
                                      icon: s.uploadingLogo
                                          ? const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            )
                                          : const Icon(Icons.upload_file),
                                      label: Text(
                                        // Add this key to your l10n files
                                        l10n.owner_request_upload_logo,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    if ((s.logoUrl ?? '').isNotEmpty)
                                      Expanded(
                                        child: Tooltip(
                                          message: s.logoUrl!,
                                          child: Text(
                                            s.logoUrl!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Theme dropdown
                                _ThemePicker(
                                  themes: s.themes, // List<ThemeLite>
                                  selectedId: s.selectedThemeId,
                                  onChanged: cubit.setThemeId,
                                  label: l10n.owner_request_theme_pref,
                                ),
                                const SizedBox(height: 16),

                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed:
                                        s.submitting ? null : cubit.submitAuto,
                                    icon: s.submitting
                                        ? const SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          )
                                        : const Icon(Icons.send_rounded),
                                    label: Text(
                                      s.submitting
                                          ? l10n.owner_request_submitting
                                          : l10n.owner_request_submit,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                      // ---------- Right: Requests ----------
                      final requests = _SectionCard(
                        title: l10n.owner_request_my_requests,
                        child: _RequestsList(requests: s.myRequests),
                      );

                      if (isWide) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: SingleChildScrollView(child: form),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 3,
                                child: SingleChildScrollView(child: requests),
                              ),
                            ],
                          ),
                        );
                      }

                      // Mobile: one scroll, no overflow
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            form,
                            const SizedBox(height: 16),
                            requests,
                          ],
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}

/* -------------------------- Hero header -------------------------- */

class _HeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _HeroHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [cs.primary.withOpacity(.12), cs.secondary.withOpacity(.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: cs.outline.withOpacity(.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: tt.bodySmall?.copyWith(
                    color: tt.bodySmall?.color?.withOpacity(.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ------------------------- Theme picker ------------------------- */

class _ThemePicker extends StatelessWidget {
  final List<ThemeLite> themes;
  final int? selectedId;
  final ValueChanged<int?> onChanged;
  final String label;

  const _ThemePicker({
    required this.themes,
    required this.selectedId,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final items = <DropdownMenuItem<int?>>[
      DropdownMenuItem<int?>(
        value: null,
        child: Text(AppLocalizations.of(context)!.owner_request_theme_default),
      ),
      ...themes.map((t) {
        final nav = (t.menuType ?? '').isEmpty ? '' : ' – ${t.menuType}';
        final color = _primaryColorOf(t);
        return DropdownMenuItem<int?>(
          value: t.id,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (color != null)
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 8),
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              Flexible(
                child: Text('${t.name}$nav', overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        );
      }),
    ];

    return DropdownButtonFormField<int?>(
      value: selectedId,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  Color? _primaryColorOf(ThemeLite t) {
    final v = (t.valuesMobile)['primaryColor'];
    if (v is! String) return null;
    final hex = v.trim();
    if (!hex.startsWith('#')) return null;
    final clean = hex.substring(1);
    final int? rgb = int.tryParse(clean, radix: 16);
    if (rgb == null) return null;
    final hasAlpha = clean.length == 8;
    return Color((hasAlpha ? 0x00000000 : 0xFF000000) | rgb);
  }
}

/* ------------------------- Requests list ------------------------- */

class _RequestsList extends StatelessWidget {
  final List<AppRequest> requests;
  const _RequestsList({required this.requests});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (requests.isEmpty) {
      return _EmptyBox(text: l10n.owner_request_no_requests_yet);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final r = requests[i];
        return ListTile(
          leading: const Icon(Icons.description_outlined),
          title: Text(r.appName, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text([
            r.status,
            if (r.createdAt != null) _fmt(r.createdAt!),
          ].join(' • ')),
          trailing: _StatusChip(status: r.status),
        );
      },
    );
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final norm = status.toUpperCase();
    Color bg;
    switch (norm) {
      case 'APPROVED':
        bg = Colors.green;
        break;
      case 'REJECTED':
        bg = Colors.red;
        break;
      case 'PENDING':
      default:
        bg = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        norm,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/* ------------------------- Small helpers ------------------------- */

class _TextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String initial;
  final ValueChanged<String> onChanged;
  final Widget? prefixIcon;

  const _TextField({
    required this.label,
    this.hint,
    required this.initial,
    required this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initial,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final String text;
  const _EmptyBox({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: cs.surfaceContainerHighest.withOpacity(.4),
        border: Border.all(color: cs.outline.withOpacity(.3)),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
