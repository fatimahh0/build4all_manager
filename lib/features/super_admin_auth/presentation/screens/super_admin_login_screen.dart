import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecases/is_super_admin_usecase.dart';
import '../../domain/usecases/login_super_admin_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../../super_admin_auth/data/datasources/jwt_local_datasource.dart';
import '../../../super_admin_auth/data/repositories/auth_repository_impl.dart';
import '../../../super_admin_auth/data/services/auth_api.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';
import '../../../../l10n/app_localizations.dart';

class SuperAdminLoginScreen extends StatelessWidget {
  const SuperAdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final IAuthRepository repo = AuthRepositoryImpl(
      api: AuthApi(),
      jwtStore: JwtLocalDataSource(),
    );

    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => AuthBloc(
        loginUseCase: LoginSuperAdminUseCase(repo),
        logoutUseCase: LogoutUseCase(repo),
        isSuperAdminUseCase: IsSuperAdminUseCase(repo),
      ),
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (p, c) =>
            p.isSuperAdmin != c.isSuperAdmin || c.error != null,
        listener: (context, state) {
          if (state.isSuperAdmin) {
            context.go('/super-admin');
          } else if (state.error != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        child: Scaffold(
          backgroundColor: cs.surface,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, cts) {
                final isWide = cts.maxWidth >= 900;
                final cardMaxWidth = isWide ? 560.0 : 480.0;

                return Stack(
                  children: [
                    _Header(title: l10n.appTitle),
                    // scrollable content to avoid overflow on small devices + keyboard
                    Align(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          top: isWide ? 120 : 140,
                          left: 16,
                          right: 16,
                          bottom: 24,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: cardMaxWidth),
                          child: _FrostedCard(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(24, 28, 24, 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Hero(
                                        tag: 'brand',
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                              cs.primary.withOpacity(.12),
                                          child: Text(
                                            'B4',
                                            style: TextStyle(
                                              color: cs.primary,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    l10n.signInTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    l10n.signInSubtitle,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: cs.outline),
                                  ),
                                  const SizedBox(height: 20),
                                  const Divider(height: 1),
                                  const SizedBox(height: 20),
                                  const LoginForm(), // uses l10n internally too
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.termsNotice,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: cs.outline),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 260,
      child: Stack(
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, cs.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(36)),
            ),
          ),
          Positioned(
            top: 24,
            left: -30,
            child: _Blob(color: Colors.white.withOpacity(.08), size: 120),
          ),
          Positioned(
            top: 0,
            right: -18,
            child: _Blob(color: Colors.white.withOpacity(.10), size: 90),
          ),
          Positioned.fill(
            top: 18,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: cs.onPrimary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .2,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(.4), blurRadius: 24, spreadRadius: 2)
            ]),
      );
}

class _FrostedCard extends StatelessWidget {
  final Widget child;
  const _FrostedCard({required this.child});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surface.withOpacity(.92),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 24,
                  offset: Offset(0, 10)),
            ],
            border: Border.all(color: cs.outlineVariant.withOpacity(.5)),
          ),
          child: child,
        ),
      ),
    );
  }
}
