import 'package:build4all_manager/core/network/dio_client.dart';
import 'package:build4all_manager/features/owner/common/domain/entities/app_request.dart';
import 'package:build4all_manager/features/owner/ownerrequests/data/repositories/owner_requests_repository_impl.dart';
import 'package:build4all_manager/features/owner/ownerrequests/data/services/owner_requests_api.dart';
import 'package:build4all_manager/features/owner/ownerrequests/data/services/themes_api.dart';
import 'package:build4all_manager/features/owner/ownerrequests/domain/entities/theme_lite.dart';
import 'package:build4all_manager/features/owner/ownerrequests/presentation/cubit/owner_requests_cubit.dart';
import 'package:build4all_manager/features/owner/ownerrequests/presentation/cubit/owner_requests_state.dart';
import 'package:build4all_manager/l10n/app_localizations.dart';
import 'package:build4all_manager/shared/themes/app_theme.dart'; // UiTokens
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

// === shared UI ===
import 'package:build4all_manager/shared/widgets/app_button.dart';
import 'package:build4all_manager/shared/widgets/app_text_field.dart';
import 'package:build4all_manager/shared/widgets/top_toast.dart';

import '../../domain/entities/project.dart';

class OwnerRequestScreen extends StatelessWidget {
  final int ownerId;
  final int? initialProjectId;
  final String? initialAppName;

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

class _OwnerRequestView extends StatefulWidget {
  final int? initialProjectId;
  final String? initialAppName;
  const _OwnerRequestView(
      {super.key, this.initialProjectId, this.initialAppName});

  @override
  State<_OwnerRequestView> createState() => _OwnerRequestViewState();
}

class _OwnerRequestViewState extends State<_OwnerRequestView> {
  bool _appliedInit = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final ux = Theme.of(context).extension<UiTokens>()!;
    final width = MediaQuery.of(context).size.width;
    final pagePad = width >= 480
        ? const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
        : ux.pagePad;

    return BlocConsumer<OwnerRequestsCubit, OwnerRequestsState>(
      listenWhen: (p, c) =>
          p.error != c.error ||
          p.lastCreated != c.lastCreated ||
          p.builtApkUrl != c.builtApkUrl ||
          (!_appliedInit && p.projects.isEmpty && c.projects.isNotEmpty),
      listener: (context, s) async {
        // prefill once
        if (!_appliedInit && s.projects.isNotEmpty) {
          _appliedInit = true;
          final c = context.read<OwnerRequestsCubit>();
          if (widget.initialProjectId != null) {
            final p = s.projects.firstWhere(
              (p) => p.id == widget.initialProjectId,
              orElse: () => s.projects.first,
            );
            c.selectProject(p);
          }
          final name = (widget.initialAppName ?? '').trim();
          if (name.isNotEmpty) c.setAppName(name);
        }

        // toasts (no SnackBars)
        if (s.error != null && s.error!.isNotEmpty) {
          final msg = switch (s.error) {
            '_ERR_NO_PROJECT_' => l10n.owner_request_error_choose_project,
            '_ERR_NO_APPNAME_' => l10n.owner_request_error_app_name,
            _ => s.error!,
          };
          showTopToast(context, msg, type: ToastType.error, haptics: true);
        }
        if (s.lastCreated != null &&
            (s.builtApkUrl == null || s.builtApkUrl!.isEmpty)) {
          showTopToast(context, l10n.owner_request_success,
              type: ToastType.success, haptics: true);
        }
        if (s.builtApkUrl != null && s.builtApkUrl!.isNotEmpty) {
          showTopToast(context, l10n.owner_request_build_done,
              type: ToastType.success, haptics: true);
        }
      },
      builder: (context, s) {
        final tt = Theme.of(context).textTheme;

        // hero
        final hero = Container(
          margin: EdgeInsets.fromLTRB(pagePad.horizontal / 2, pagePad.vertical,
              pagePad.horizontal / 2, 12),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cs.primary.withOpacity(.12),
                cs.secondary.withOpacity(.08)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(ux.radiusLg + 4),
            border: Border.all(color: cs.outline.withOpacity(.16)),
            boxShadow: ux.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(.16),
                  borderRadius: BorderRadius.circular(ux.radiusMd),
                ),
                child: Icon(Icons.rocket_launch, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DefaultTextStyle(
                  style: tt.bodyMedium!
                      .copyWith(color: cs.onSurface.withOpacity(.85)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.owner_request_title,
                          style: tt.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(l10n.owner_request_submit_hint,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

        // form
        final form = ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ux.radiusLg),
              side: BorderSide(color: cs.outline.withOpacity(.22)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: s.loading
                  ? const SizedBox(
                      height: 240,
                      child: Center(child: CircularProgressIndicator()))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<Project?>(
                          value: s.selected,
                          isExpanded: true,
                          decoration: const InputDecoration(
                                  border: OutlineInputBorder())
                              .copyWith(labelText: l10n.owner_request_project),
                          items: s.projects
                              .map((p) => DropdownMenuItem<Project?>(
                                    value: p,
                                    child: Text(p.name,
                                        overflow: TextOverflow.ellipsis),
                                  ))
                              .toList(),
                          onChanged:
                              context.read<OwnerRequestsCubit>().selectProject,
                        ),
                        const SizedBox(height: 12),

                        // shared input
                        AppTextField(
                          label: l10n.owner_request_appName,
                          hint: l10n.owner_request_appName_hint,
                          initialValue: s.appName,
                          prefix: const Icon(Icons.edit_outlined),
                          onChanged:
                              context.read<OwnerRequestsCubit>().setAppName,
                          filled: true,
                          size: AppInputSize.md,
                          margin: const EdgeInsets.only(top: 0),
                        ),
                        const SizedBox(height: 12),

                        AppTextField(
                          label: l10n.owner_request_logo_url,
                          hint: l10n.owner_request_logo_url_hint,
                          initialValue: s.logoUrl ?? '',
                          prefix: const Icon(Icons.image_outlined),
                          onChanged: (v) => context
                              .read<OwnerRequestsCubit>()
                              .setLogoUrl(v.trim().isEmpty ? null : v.trim()),
                          filled: true,
                          size: AppInputSize.md,
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            AppButton(
                              onPressed: s.uploadingLogo
                                  ? null
                                  : context
                                      .read<OwnerRequestsCubit>()
                                      .pickLogoFile,
                              type: AppButtonType.outline,
                              size: AppButtonSize.sm,
                              leading: s.uploadingLogo
                                  ? null
                                  : const Icon(Icons.upload_file),
                              isBusy: s.uploadingLogo,
                              label: l10n.owner_request_upload_logo,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _UploadPathPreview(
                                    path: s.logoFilePath, url: s.logoUrl)),
                          ],
                        ),
                        const SizedBox(height: 12),

                        _ThemePicker(
                          themes: s.themes,
                          selectedId: s.selectedThemeId,
                          onChanged:
                              context.read<OwnerRequestsCubit>().setThemeId,
                          label: l10n.owner_request_theme_pref,
                        ),
                        const SizedBox(height: 16),

                        // shared primary button
                        AppButton(
                          onPressed: s.submitting
                              ? null
                              : context
                                  .read<OwnerRequestsCubit>()
                                  .submitAutoOneShot,
                          isBusy: s.submitting,
                          expand: true,
                          type: AppButtonType.primary,
                          size: AppButtonSize.lg,
                          leading: const Icon(Icons.rocket_launch),
                          label: l10n.owner_request_submit_and_build,
                          semanticLabel: l10n.owner_request_submit_and_build,
                        ),
                        const SizedBox(height: 10),

                        // built APK quick action
                        if ((s.builtApkUrl ?? '').isNotEmpty)
                          AppButton(
                            onPressed: () async {
                              final uri = Uri.parse(s.builtApkUrl!);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                showTopToast(context, l10n.common_download,
                                    type: ToastType.info);
                              }
                            },
                            type: AppButtonType.secondary,
                            size: AppButtonSize.md,
                            leading: const Icon(Icons.download_rounded),
                            label: l10n.common_download_apk,
                          ),
                      ],
                    ),
            ),
          ),
        );

        final requests = _SectionCard(
          title: l10n.owner_request_my_requests,
          child: _RequestsList(requests: s.myRequests),
        );

        // layout
        final content = LayoutBuilder(
          builder: (ctx, bx) {
            final isWide = bx.maxWidth >= 980;
            if (isWide) {
              return Padding(
                padding: EdgeInsets.fromLTRB(pagePad.horizontal / 2, 0,
                    pagePad.horizontal / 2, pagePad.vertical),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 2,
                        child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [form])),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 3,
                        child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [requests])),
                  ],
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.fromLTRB(pagePad.horizontal / 2, 0,
                  pagePad.horizontal / 2, pagePad.vertical),
              child: Column(
                  children: [form, const SizedBox(height: 16), requests]),
            );
          },
        );

        return Scaffold(
          backgroundColor: cs.background,
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(child: hero),
                SliverToBoxAdapter(child: content),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* ========== helpers / shared pieces ========== */

class _UploadPathPreview extends StatelessWidget {
  final String? path;
  final String? url;
  const _UploadPathPreview({required this.path, required this.url});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hasPath = (path ?? '').isNotEmpty;
    final hasUrl = !hasPath && (url ?? '').isNotEmpty;
    if (!hasPath && !hasUrl) return const SizedBox.shrink();

    final text = hasPath ? (path!.split(RegExp(r'[\\/]+')).last) : url!;
    return Tooltip(
      message: hasPath ? path! : url!,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: tt.bodySmall,
      ),
    );
  }
}

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
          child:
              Text(AppLocalizations.of(context)!.owner_request_theme_default)),
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
                        BoxDecoration(color: color, shape: BoxShape.circle)),
              Flexible(
                  child:
                      Text('${t.name}$nav', overflow: TextOverflow.ellipsis)),
            ],
          ),
        );
      }),
    ];

    return DropdownButtonFormField<int?>(
      value: selectedId,
      isExpanded: true,
      decoration: const InputDecoration(border: OutlineInputBorder())
          .copyWith(labelText: label),
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
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    if (requests.isEmpty) {
      return _EmptyBox(text: l10n.owner_request_no_requests_yet);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requests.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: cs.outlineVariant.withOpacity(.3)),
      itemBuilder: (_, i) {
        final r = requests[i];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          leading: Container(
            height: 38,
            width: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: cs.primary.withOpacity(.10),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.description_outlined, color: cs.primary),
          ),
          title: Text(r.appName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
          subtitle: Text('${r.status} • ${_fmt(r.createdAt)}'),
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
    final cs = Theme.of(context).colorScheme;
    final norm = status.toUpperCase();
    late final Color bg;
    late final Color fg;
    switch (norm) {
      case 'DELIVERED':
      case 'APPROVED':
        bg = Colors.green.withOpacity(.18);
        fg = Colors.green.shade800;
        break;
      case 'REJECTED':
        bg = Colors.red.withOpacity(.18);
        fg = Colors.red.shade800;
        break;
      case 'IN_PRODUCTION':
        bg = Colors.orange.withOpacity(.18);
        fg = Colors.orange.shade800;
        break;
      case 'PENDING':
      default:
        bg = cs.surfaceContainerHighest.withOpacity(.5);
        fg = cs.onSurface.withOpacity(.8);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(norm,
          style:
              TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final String text;
  const _EmptyBox({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ux = Theme.of(context).extension<UiTokens>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ux.radiusLg),
        color: cs.surfaceContainerHighest.withOpacity(.4),
        border: Border.all(color: cs.outline.withOpacity(.3)),
        boxShadow: ux.cardShadow,
      ),
      child: Center(child: Text(text, textAlign: TextAlign.center)),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _SectionCard({
    required this.title,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final ux = Theme.of(context).extension<UiTokens>()!;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ux.radiusLg),
        side: BorderSide(color: cs.outline.withOpacity(.22)),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
