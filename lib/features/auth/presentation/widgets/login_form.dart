import 'package:build4all_manager/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4all_manager/shared/widgets/app_text_field.dart';
import 'package:build4all_manager/shared/widgets/app_button.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  bool _remember = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailNode
      ..unfocus()
      ..dispose();
    _passwordNode
      ..unfocus()
      ..dispose();
    super.dispose();
  }

  String? _emailValidator(String? v, AppLocalizations l10n) {
    if (v == null || v.trim().isEmpty) return l10n.errEmailRequired;
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim());
    if (!ok) return l10n.errEmailInvalid;
    return null;
  }

  String? _passwordValidator(String? v, AppLocalizations l10n) {
    if (v == null || v.isEmpty) return l10n.errPasswordRequired;
    if (v.length < 6) return l10n.errPasswordMin;
    return null;
  }

  void _submit(AppLocalizations l10n) {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
          LoginSubmitted(_email.text.trim(), _password.text),
        );
    // TODO: persist _remember if you want
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: AutofillGroup(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Email
                            AppTextField(
                              controller: _email,
                              focusNode: _emailNode,
                              label: l10n.lblEmail,
                              hint: l10n.hintEmail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              prefix: const Icon(Icons.mail_outline),
                              autofillHints: const [AutofillHints.email],
                              validator: (v) => _emailValidator(v, l10n),
                              onSubmitted: (_) => _passwordNode.requestFocus(),
                            ),
                            const SizedBox(height: 14),

                            // Password
                            AppPasswordField(
                              controller: _password,
                              focusNode: _passwordNode,
                              label: l10n.lblPassword,
                              hint: l10n.hintPassword,
                              prefix: const Icon(Icons.lock_outline),
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              validator: (v) => _passwordValidator(v, l10n),
                              onSubmitted: (_) => _submit(l10n),
                            ),
                            const SizedBox(height: 10),

                            // Remember + Forgot
                            Row(
                              children: [
                                Checkbox(
                                  value: _remember,
                                  onChanged: (v) =>
                                      setState(() => _remember = v ?? true),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                Flexible(
                                  child: Text(
                                    l10n.rememberMe,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    // TODO: forgot password flow
                                  },
                                  child: Text(l10n.forgotPassword),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Sign in button (uses your AppButton API)
                            AppButton(
                              label: l10n.btnSignIn,
                              isBusy: state.loading,
                              expand: true,
                              trailing: const Icon(Icons.login_rounded),
                              onPressed:
                                  state.loading ? null : () => _submit(l10n),
                            ),
                            const SizedBox(height: 12),

                            // Error message (animated)
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child:
                                  (state.error == null || state.error!.isEmpty)
                                      ? const SizedBox.shrink()
                                      : Text(
                                          state.error!,
                                          key: ValueKey(state.error),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: cs.error,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                            ),
                            const SizedBox(height: 10),

                            // Sign up
                            TextButton(
                              onPressed: () {
                                // TODO: go to sign up
                              },
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: l10n.noAccount,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: cs.outline),
                                    ),
                                    TextSpan(
                                      text: ' ${l10n.signUp}',
                                      style: TextStyle(
                                        color: cs.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
