import 'package:build4all_manager/core/network/dio_client.dart';
import 'package:build4all_manager/features/owner/common/domain/entities/app_request.dart';
import 'package:build4all_manager/features/owner/ownerrequests/data/repositories/owner_requests_repository_impl.dart';
import 'package:build4all_manager/features/owner/ownerrequests/data/services/owner_requests_api.dart';
import 'package:build4all_manager/features/owner/ownerrequests/data/services/themes_api.dart';
import 'package:build4all_manager/features/owner/ownerrequests/domain/entities/theme_lite.dart';
import 'package:build4all_manager/features/owner/ownerrequests/presentation/cubit/owner_requests_cubit.dart';
import 'package:build4all_manager/features/owner/ownerrequests/presentation/cubit/owner_requests_state.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/project.dart';
import 'package:url_launcher/url_launcher.dart';

class OwnerRequestScreen extends StatelessWidget {
  final int ownerId;
  final int? initialProjectId; // 👈 from router extras
  final String? initialAppName; // 👈 from router extras

  const OwnerRequestScreen({
    super.key,
    required this.ownerId,
    this.initialProjectId,
    this.initialAppName,
  });

  @override
  Widget build(BuildContext context) {
    final dio = DioClient.ensure();
    final api = OwnerRequestsApi(dio);
    final repo = OwnerRequestsRepositoryImpl(api, ThemesApi(dio));

    return BlocProvider(
      create: (_) => OwnerRequestsCubit(repo: repo, ownerId: ownerId)
        ..setConcreteApi(api)
        ..init(),
      child: _OwnerRequestView(
        initialProjectId: initialProjectId,
        initialAppName: initialAppName,
      ),
    );
  }
}

/// Stateful so we can apply the initial selection **once** when data arrives.
class _OwnerRequestView extends StatefulWidget {
  final int? initialProjectId;
  final String? initialAppName;
  const _OwnerRequestView(
      {super.key, this.initialProjectId, this.initialAppName});

  @override
  State<_OwnerRequestView> createState() => _OwnerRequestViewState();
}

class _OwnerRequestViewState extends State<_OwnerRequestView> {
  bool _appliedInit = false; // ensure we only prefill once

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<OwnerRequestsCubit, OwnerRequestsState>(
      listenWhen: (p, c) =>
          p.error != c.error ||
          p.lastCreated != c.lastCreated ||
          p.builtApkUrl != c.builtApkUrl ||
          // also trigger when projects list appears (to apply init)
          (!_appliedInit && p.projects.isEmpty && c.projects.isNotEmpty),
      listener: (context, s) async {
        // 1) Apply initial project + name exactly once when projects loaded
        if (!_appliedInit && s.projects.isNotEmpty) {
          _appliedInit = true;
          final cubit = context.read<OwnerRequestsCubit>();

          if (widget.initialProjectId != null) {
            final p = s.projects.firstWhere(
              (p) => p.id == widget.initialProjectId,
              orElse: () => s.projects.first,
            );
            cubit.selectProject(p);
          }
          final prefillName = (widget.initialAppName ?? '').trim();
          if (prefillName.isNotEmpty) {
            cubit.setAppName(prefillName);
          }
        }

        // 2) Normal snackbars
        if (s.error != null && s.error!.isNotEmpty) {
          final msg = switch (s.error) {
            '_ERR_NO_PROJECT_' => l10n.owner_request_error_choose_project,
            '_ERR_NO_APPNAME_' => l10n.owner_request_error_app_name,
            _ => s.error!,
          };
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(msg)));
        }
        if (s.lastCreated != null &&
            (s.builtApkUrl == null || s.builtApkUrl!.isEmpty)) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.owner_request_success)));
        }
        if (s.builtApkUrl != null && s.builtApkUrl!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.owner_request_build_done),
              action: SnackBarAction(
                label: l10n.common_download,
                onPressed: () async {
                  final uri = Uri.parse(s.builtApkUrl!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ),
          );
        }
      },
      builder: (context, s) {
        final cubit = context.read<OwnerRequestsCubit>();
        final cs = Theme.of(context).colorScheme;

        final submitBtn = SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: s.submitting ? null : cubit.submitAutoOneShot,
            icon: s.submitting
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.rocket_launch),
            label: Text(s.submitting
                ? l10n.owner_request_submitting
                : l10n.owner_request_submit_and_build),
          ),
        );

        final builtChip = (s.builtApkUrl != null && s.builtApkUrl!.isNotEmpty)
            ? Align(
                alignment: Alignment.centerLeft,
                child: ActionChip(
                  avatar: const Icon(Icons.download_rounded, size: 18),
                  label: Text(l10n.common_download_apk),
                  onPressed: () async {
                    final uri = Uri.parse(s.builtApkUrl!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              )
            : const SizedBox.shrink();

        return Scaffold(
          appBar: AppBar(title: Text(l10n.owner_request_title)),
          body: SafeArea(
            child: s.loading
                ? const Center(child: CircularProgressIndicator())
                : LayoutBuilder(
                    builder: (ctx, bx) {
                      final isWide = bx.maxWidth >= 980;

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
                                      child: Text(p.name,
                                          overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                                  onChanged: cubit.selectProject,
                                ),
                                const SizedBox(height: 12),
                                _TextField(
                                  label: l10n.owner_request_appName,
                                  hint: l10n.owner_request_appName_hint,
                                  initial: s.appName,
                                  onChanged: cubit.setAppName,
                                ),
                                const SizedBox(height: 12),
                                _TextField(
                                  label: l10n.owner_request_logo_url,
                                  hint: l10n.owner_request_logo_url_hint,
                                  initial: s.logoUrl ?? '',
                                  onChanged: (v) => cubit.setLogoUrl(
                                      v.trim().isEmpty ? null : v.trim()),
                                  prefixIcon: const Icon(Icons.image_outlined),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: s.uploadingLogo
                                          ? null
                                          : cubit.pickLogoFile,
                                      icon: s.uploadingLogo
                                          ? const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2))
                                          : const Icon(Icons.upload_file),
                                      label:
                                          Text(l10n.owner_request_upload_logo),
                                    ),
                                    const SizedBox(width: 12),
                                    if ((s.logoFilePath ?? '').isNotEmpty)
                                      Expanded(
                                        child: Tooltip(
                                          message: s.logoFilePath!,
                                          child: Text(
                                            s.logoFilePath!
                                                .split(RegExp(r'[\\/]+'))
                                                .last,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ),
                                      )
                                    else if ((s.logoUrl ?? '').isNotEmpty)
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
                                _ThemePicker(
                                  themes: s.themes,
                                  selectedId: s.selectedThemeId,
                                  onChanged: cubit.setThemeId,
                                  label: l10n.owner_request_theme_pref,
                                ),
                                const SizedBox(height: 16),
                                submitBtn,
                                const SizedBox(height: 10),
                                builtChip,
                              ],
                            ),
                          ),
                        ),
                      );

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

/* ---------- helpers ---------- */

class _HeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const _HeroHeader(
      {required this.title, required this.subtitle, required this.icon});
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
                Text(subtitle,
                    style: tt.bodySmall?.copyWith(
                        color: tt.bodySmall?.color?.withOpacity(.75))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemePicker extends StatelessWidget {
  final List<ThemeLite> themes;
  final int? selectedId;
  final ValueChanged<int?> onChanged;
  final String label;
  const _ThemePicker(
      {required this.themes,
      required this.selectedId,
      required this.onChanged,
      required this.label});
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
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (color != null)
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            Flexible(
              child: Text('${t.name}$nav', overflow: TextOverflow.ellipsis),
            ),
          ]),
        );
      }),
    ];

    return DropdownButtonFormField<int?>(
      value: selectedId,
      isExpanded: true,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
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
          subtitle: Text([r.status, _fmt(r.createdAt)].join(' • ')),
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
      case 'DELIVERED':
      case 'APPROVED':
        bg = Colors.green;
        break;
      case 'REJECTED':
        bg = Colors.red;
        break;
      case 'IN_PRODUCTION':
        bg = Colors.orange;
        break;
      case 'PENDING':
      default:
        bg = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        norm,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}

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
      child: Center(child: Text(text, textAlign: TextAlign.center)),
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
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
