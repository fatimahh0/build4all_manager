// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Build4All Manager';

  @override
  String get authLoginTitle => 'Super Admin Login';

  @override
  String get authUsername => 'Username or Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSigning => 'Signing in…';

  @override
  String get authError => 'Login failed';

  @override
  String get shellTabDashboard => 'Dashboard';

  @override
  String get shellTabProjects => 'Projects';

  @override
  String get shellTabThemes => 'Themes';

  @override
  String get signInTitle => 'Sign in to Super Admin';

  @override
  String get signInSubtitle => 'Manage projects, themes & clients';

  @override
  String get termsNotice => 'By continuing you agree to our Terms & Privacy Policy';

  @override
  String get lblEmail => 'Email';

  @override
  String get hintEmail => 'example@gmail.com';

  @override
  String get lblPassword => 'Password';

  @override
  String get hintPassword => '•••••••••••';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get btnSignIn => 'Sign In';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get errEmailRequired => 'Email is required';

  @override
  String get errEmailInvalid => 'Enter a valid email';

  @override
  String get errPasswordRequired => 'Password is required';

  @override
  String get errPasswordMin => 'Minimum 6 characters';

  @override
  String get showPasswordLabel => 'Show password';

  @override
  String get hidePasswordLabel => 'Hide password';
}
