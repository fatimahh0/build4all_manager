// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Build4All';

  @override
  String get signInGeneralTitle => 'Sign in to your account';

  @override
  String get errEmailInvalid => 'Invalid email format';

  @override
  String get errEmailRequired => 'Email is required';

  @override
  String get lblEmail => 'Email';

  @override
  String get hintEmail => 'email';

  @override
  String get signInGeneralSubtitle => 'Enter your details to continue';

  @override
  String get termsNotice => 'By continuing you agree to our Terms & Privacy Policy';

  @override
  String get lblIdentifier => 'Email / Phone / Username';

  @override
  String get hintIdentifier => 'you@example.com or +961xxxxxxxx or username';

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
  String get errIdentifierRequired => 'Identifier is required';

  @override
  String get errPasswordRequired => 'Password is required';

  @override
  String get errPasswordMin => 'Minimum 6 characters';

  @override
  String get showPasswordLabel => 'Show password';

  @override
  String get hidePasswordLabel => 'Hide password';

  @override
  String get nav_super_admin => 'Super Admin';

  @override
  String get nav_dashboard => 'Dashboard';

  @override
  String get nav_themes => 'Themes';

  @override
  String get nav_profile => 'Profile';

  @override
  String get dashboard_title => 'Admin Dashboard';

  @override
  String get dashboard_welcome => 'Welcome to Build4All Manager';

  @override
  String get dashboard_hint => 'Use the navigation on the left to manage themes and your profile.';

  @override
  String get themes_title => 'Theme Management';

  @override
  String get themes_add => 'Add Theme';

  @override
  String get themes_name => 'Theme Name';

  @override
  String get themes_menuType => 'Menu Type';

  @override
  String get themes_setActive => 'Set Active';

  @override
  String get themes_active => 'Active';

  @override
  String get themes_deactivate_all => 'Deactivate All Themes';

  @override
  String get themes_empty => 'No themes yet. Create one.';

  @override
  String get profile_title => 'My Profile';

  @override
  String get profile_firstName => 'First Name';

  @override
  String get profile_lastName => 'Last Name';

  @override
  String get profile_username => 'Username';

  @override
  String get profile_email => 'Email';

  @override
  String get profile_updated => 'Profile updated successfully.';

  @override
  String get profile_changePassword => 'Change Password';

  @override
  String get profile_currentPassword => 'Current Password';

  @override
  String get profile_newPassword => 'New Password';

  @override
  String get profile_updatePassword => 'Update Password';

  @override
  String get password_updated => 'Password updated successfully.';

  @override
  String get common_save => 'Save';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get dash_total_projects => 'Total Projects';

  @override
  String get dash_active_projects => 'Active Projects';

  @override
  String get dash_inactive_projects => 'Inactive Projects';

  @override
  String get dash_recent_projects => 'Recent Projects';

  @override
  String get dash_no_recent => 'No recent projects yet.';

  @override
  String get dash_welcome => 'Welcome to Build4All Manager';

  @override
  String get themes_confirm_delete => 'Delete this theme? This cannot be undone.';

  @override
  String get themes_colors_section => 'Colors';

  @override
  String get err_required => 'This field is required';

  @override
  String get common_more => 'More';

  @override
  String get common_retry => 'Retry';
}
