import 'package:build4all_manager/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/widgets/app_button.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../l10n/app_localizations.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _remember = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _emailValidator(String? v, AppLocalizations l10n) {
    if (v == null || v.trim().isEmpty) return l10n.errEmailRequired;
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
    if (!ok) return l10n.errEmailInvalid;
    return null;
  }

  String? _passwordValidator(String? v, AppLocalizations l10n) {
    if (v == null || v.isEmpty) return l10n.errPasswordRequired;
    if (v.length < 6) return l10n.errPasswordMin;
    return null;
  }

  void _submit(AppLocalizations l10n) {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    FocusScope.of(context).unfocus();
    context
        .read<AuthBloc>()
        .add(LoginSubmitted(_email.text.trim(), _password.text));
    // store _remember if you want (SharedPreferences)
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AutofillGroup(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextInput(
                  controller: _email,
                  label: l10n.lblEmail,
                  hint: l10n.hintEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.mail_outline,
                  validator: (v) => _emailValidator(v, l10n),
                ),
                const SizedBox(height: 14),
                AppTextInput(
                  controller: _password,
                  label: l10n.lblPassword,
                  hint: l10n.hintPassword,
                  prefixIcon: Icons.lock_outline,
                  obscure: true,
                  validator: (v) => _passwordValidator(v, l10n),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _remember,
                      onChanged: (v) => setState(() => _remember = v ?? true),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    Text(l10n.rememberMe),
                    const Spacer(),
                    TextButton(
                      onPressed: () {/* TODO: forgot flow */},
                      child: Text(l10n.forgotPassword),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AppButton(
                  text: l10n.btnSignIn,
                  loading: state.loading,
                  onPressed: () => _submit(l10n),
                ),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: state.error == null
                      ? const SizedBox.shrink()
                      : Text(
                          state.error!,
                          key: ValueKey(state.error),
                          style: TextStyle(color: cs.error),
                        ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {/* TODO: sign up */},
                  child: Text.rich(
                    TextSpan(children: [
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
                            color: cs.primary, fontWeight: FontWeight.w600),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
