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
  String get errEmailInvalid => 'Invalid email';

  @override
  String get errEmailRequired => 'Email is required';

  @override
  String get lblEmail => 'Email';

  @override
  String get hintEmail => 'you@example.com';

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
  String get hintPassword => 'Your password';

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
  String get errPasswordMin => 'Password must be at least 6 characters';

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

  @override
  String get profile_details => 'Profile details';

  @override
  String get profile_first_name => 'First name';

  @override
  String get profile_first_name_hint => 'Enter first name';

  @override
  String get profile_last_name => 'Last name';

  @override
  String get profile_last_name_hint => 'Enter last name';

  @override
  String get profile_username_hint => 'Enter username';

  @override
  String get profile_email_hint => 'Enter email';

  @override
  String get profile_save_changes => 'Save changes';

  @override
  String get profile_change_password => 'Change password';

  @override
  String get profile_current_password => 'Current password';

  @override
  String get profile_new_password => 'New password';

  @override
  String get profile_confirm_password => 'Confirm password';

  @override
  String get profile_password_updated => 'Password updated successfully';

  @override
  String get profile_password_hint => 'For your security, use a strong unique password.';

  @override
  String get profile_update_password => 'Update password';

  @override
  String get profile_update_notifications => 'Update';

  @override
  String get profile_notify_items => 'Item updates';

  @override
  String get profile_notify_items_sub => 'Receive notifications when businesses update their items';

  @override
  String get profile_notify_feedback => 'User feedback';

  @override
  String get profile_notify_feedback_sub => 'Get notified when users submit new feedback';

  @override
  String get common_security => 'Security';

  @override
  String get common_sign_out => 'Sign out';

  @override
  String get common_sign_out_hint => 'End your current session';

  @override
  String get common_sign_out_confirm => 'Are you sure you want to sign out?';

  @override
  String get common_signed_out => 'Signed out';

  @override
  String get err_email => 'Please enter a valid email';

  @override
  String get errPasswordMismatch => 'Passwords do not match';

  @override
  String get err_unknown => 'Something went wrong';

  @override
  String get signUpOwnerTitle => 'Owner Sign Up';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get completeProfile => 'Complete Profile';

  @override
  String get lblUsername => 'Username';

  @override
  String get hintUsername => 'your.unique.name';

  @override
  String get lblFirstName => 'First name';

  @override
  String get hintFirstName => 'John';

  @override
  String get lblLastName => 'Last name';

  @override
  String get hintLastName => 'Doe';

  @override
  String get btnSendCode => 'Send Code';

  @override
  String get btnVerify => 'Verify';

  @override
  String get btnCreateAccount => 'Create account';

  @override
  String get errCodeSixDigits => 'Enter the 6-digit code';

  @override
  String get errUsernameRequired => 'Username is required';

  @override
  String get errFirstNameRequired => 'First name is required';

  @override
  String get errLastNameRequired => 'Last name is required';

  @override
  String get msgCodeSent => 'Verification code sent';

  @override
  String get msgWeWillSendCodeEmail => 'We will send a 6-digit code to your email.';

  @override
  String msgEnterCodeForEmail(Object email) {
    return 'Enter the 6-digit code sent to $email';
  }

  @override
  String get msgOwnerRegistered => 'Owner registered successfully';
}
