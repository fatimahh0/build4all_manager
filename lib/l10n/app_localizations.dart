import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// App name shown in the login header
  ///
  /// In en, this message translates to:
  /// **'Build4All'**
  String get appTitle;

  /// Generic login title (not role-specific)
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInGeneralTitle;

  /// Validation: invalid email format
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get errEmailInvalid;

  /// Validation: empty email
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get errEmailRequired;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get lblEmail;

  /// No description provided for @hintEmail.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get hintEmail;

  /// Generic subtitle under the login title
  ///
  /// In en, this message translates to:
  /// **'Enter your details to continue'**
  String get signInGeneralSubtitle;

  /// Legal notice under the form
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our Terms & Privacy Policy'**
  String get termsNotice;

  /// Generic identifier label
  ///
  /// In en, this message translates to:
  /// **'Email / Phone / Username'**
  String get lblIdentifier;

  /// Generic identifier hint
  ///
  /// In en, this message translates to:
  /// **'you@example.com or +961xxxxxxxx or username'**
  String get hintIdentifier;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get lblPassword;

  /// Password hint text
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get hintPassword;

  /// Remember me checkbox label
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Forgot password action link
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Primary sign-in button label
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get btnSignIn;

  /// Text before the Sign Up link
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// Sign up action link
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Validation: empty identifier
  ///
  /// In en, this message translates to:
  /// **'Identifier is required'**
  String get errIdentifierRequired;

  /// Validation: empty password
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get errPasswordRequired;

  /// Validation: password too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get errPasswordMin;

  /// Accessibility label for toggling password visibility (show)
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPasswordLabel;

  /// Accessibility label for toggling password visibility (hide)
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePasswordLabel;

  /// No description provided for @nav_super_admin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get nav_super_admin;

  /// No description provided for @nav_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get nav_dashboard;

  /// No description provided for @nav_themes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get nav_themes;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @dashboard_title.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get dashboard_title;

  /// No description provided for @dashboard_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Build4All Manager'**
  String get dashboard_welcome;

  /// No description provided for @dashboard_hint.
  ///
  /// In en, this message translates to:
  /// **'Use the navigation on the left to manage themes and your profile.'**
  String get dashboard_hint;

  /// No description provided for @themes_title.
  ///
  /// In en, this message translates to:
  /// **'Theme Management'**
  String get themes_title;

  /// No description provided for @themes_add.
  ///
  /// In en, this message translates to:
  /// **'Add Theme'**
  String get themes_add;

  /// No description provided for @themes_name.
  ///
  /// In en, this message translates to:
  /// **'Theme Name'**
  String get themes_name;

  /// No description provided for @themes_menuType.
  ///
  /// In en, this message translates to:
  /// **'Menu Type'**
  String get themes_menuType;

  /// No description provided for @themes_setActive.
  ///
  /// In en, this message translates to:
  /// **'Set Active'**
  String get themes_setActive;

  /// No description provided for @themes_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get themes_active;

  /// No description provided for @themes_deactivate_all.
  ///
  /// In en, this message translates to:
  /// **'Deactivate All Themes'**
  String get themes_deactivate_all;

  /// No description provided for @themes_empty.
  ///
  /// In en, this message translates to:
  /// **'No themes yet. Create one.'**
  String get themes_empty;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profile_title;

  /// No description provided for @profile_firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get profile_firstName;

  /// No description provided for @profile_lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get profile_lastName;

  /// No description provided for @profile_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get profile_username;

  /// No description provided for @profile_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profile_email;

  /// No description provided for @profile_updated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profile_updated;

  /// No description provided for @profile_changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profile_changePassword;

  /// No description provided for @profile_currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get profile_currentPassword;

  /// No description provided for @profile_newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get profile_newPassword;

  /// No description provided for @profile_updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get profile_updatePassword;

  /// No description provided for @password_updated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully.'**
  String get password_updated;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @dash_total_projects.
  ///
  /// In en, this message translates to:
  /// **'Total Projects'**
  String get dash_total_projects;

  /// No description provided for @dash_active_projects.
  ///
  /// In en, this message translates to:
  /// **'Active Projects'**
  String get dash_active_projects;

  /// No description provided for @dash_inactive_projects.
  ///
  /// In en, this message translates to:
  /// **'Inactive Projects'**
  String get dash_inactive_projects;

  /// No description provided for @dash_recent_projects.
  ///
  /// In en, this message translates to:
  /// **'Recent Projects'**
  String get dash_recent_projects;

  /// No description provided for @dash_no_recent.
  ///
  /// In en, this message translates to:
  /// **'No recent projects yet.'**
  String get dash_no_recent;

  /// No description provided for @dash_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Build4All Manager'**
  String get dash_welcome;

  /// No description provided for @themes_confirm_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete this theme? This cannot be undone.'**
  String get themes_confirm_delete;

  /// No description provided for @themes_colors_section.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get themes_colors_section;

  /// No description provided for @err_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get err_required;

  /// No description provided for @common_more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get common_more;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @profile_details.
  ///
  /// In en, this message translates to:
  /// **'Profile details'**
  String get profile_details;

  /// No description provided for @profile_first_name.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get profile_first_name;

  /// No description provided for @profile_first_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get profile_first_name_hint;

  /// No description provided for @profile_last_name.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get profile_last_name;

  /// No description provided for @profile_last_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter last name'**
  String get profile_last_name_hint;

  /// No description provided for @profile_username_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get profile_username_hint;

  /// No description provided for @profile_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get profile_email_hint;

  /// No description provided for @profile_save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profile_save_changes;

  /// No description provided for @profile_change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profile_change_password;

  /// No description provided for @profile_current_password.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get profile_current_password;

  /// No description provided for @profile_new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get profile_new_password;

  /// No description provided for @profile_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get profile_confirm_password;

  /// No description provided for @profile_password_updated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get profile_password_updated;

  /// No description provided for @profile_password_hint.
  ///
  /// In en, this message translates to:
  /// **'For your security, use a strong unique password.'**
  String get profile_password_hint;

  /// No description provided for @profile_update_password.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get profile_update_password;

  /// No description provided for @profile_update_notifications.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get profile_update_notifications;

  /// No description provided for @profile_notify_items.
  ///
  /// In en, this message translates to:
  /// **'Item updates'**
  String get profile_notify_items;

  /// No description provided for @profile_notify_items_sub.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications when businesses update their items'**
  String get profile_notify_items_sub;

  /// No description provided for @profile_notify_feedback.
  ///
  /// In en, this message translates to:
  /// **'User feedback'**
  String get profile_notify_feedback;

  /// No description provided for @profile_notify_feedback_sub.
  ///
  /// In en, this message translates to:
  /// **'Get notified when users submit new feedback'**
  String get profile_notify_feedback_sub;

  /// No description provided for @common_security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get common_security;

  /// No description provided for @common_sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get common_sign_out;

  /// No description provided for @common_sign_out_hint.
  ///
  /// In en, this message translates to:
  /// **'End your current session'**
  String get common_sign_out_hint;

  /// No description provided for @common_sign_out_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get common_sign_out_confirm;

  /// No description provided for @common_signed_out.
  ///
  /// In en, this message translates to:
  /// **'Signed out'**
  String get common_signed_out;

  /// No description provided for @err_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get err_email;

  /// No description provided for @errPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errPasswordMismatch;

  /// No description provided for @err_unknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get err_unknown;

  /// No description provided for @signUpOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner Sign Up'**
  String get signUpOwnerTitle;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @completeProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get completeProfile;

  /// No description provided for @lblUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get lblUsername;

  /// No description provided for @hintUsername.
  ///
  /// In en, this message translates to:
  /// **'your.unique.name'**
  String get hintUsername;

  /// No description provided for @lblFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get lblFirstName;

  /// No description provided for @hintFirstName.
  ///
  /// In en, this message translates to:
  /// **'John'**
  String get hintFirstName;

  /// No description provided for @lblLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lblLastName;

  /// No description provided for @hintLastName.
  ///
  /// In en, this message translates to:
  /// **'Doe'**
  String get hintLastName;

  /// No description provided for @btnSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get btnSendCode;

  /// No description provided for @btnVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get btnVerify;

  /// No description provided for @btnCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get btnCreateAccount;

  /// No description provided for @errCodeSixDigits.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get errCodeSixDigits;

  /// No description provided for @errUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get errUsernameRequired;

  /// No description provided for @errFirstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get errFirstNameRequired;

  /// No description provided for @errLastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get errLastNameRequired;

  /// No description provided for @msgCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent'**
  String get msgCodeSent;

  /// No description provided for @msgWeWillSendCodeEmail.
  ///
  /// In en, this message translates to:
  /// **'We will send a 6-digit code to your email.'**
  String get msgWeWillSendCodeEmail;

  /// No description provided for @msgEnterCodeForEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {email}'**
  String msgEnterCodeForEmail(Object email);

  /// No description provided for @msgOwnerRegistered.
  ///
  /// In en, this message translates to:
  /// **'Owner registered successfully'**
  String get msgOwnerRegistered;

  /// No description provided for @owner_nav_title.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner_nav_title;

  /// No description provided for @owner_nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get owner_nav_home;

  /// No description provided for @owner_nav_projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get owner_nav_projects;

  /// No description provided for @owner_nav_requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get owner_nav_requests;

  /// No description provided for @owner_nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get owner_nav_profile;

  /// No description provided for @owner_home_title.
  ///
  /// In en, this message translates to:
  /// **'Owner Home'**
  String get owner_home_title;

  /// No description provided for @owner_projects_title.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get owner_projects_title;

  /// No description provided for @owner_requests_title.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get owner_requests_title;

  /// No description provided for @owner_profile_title.
  ///
  /// In en, this message translates to:
  /// **'Owner Profile'**
  String get owner_profile_title;

  /// No description provided for @owner_home_hello.
  ///
  /// In en, this message translates to:
  /// **'👋 Hi, Owner'**
  String get owner_home_hello;

  /// No description provided for @owner_home_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your apps easily'**
  String get owner_home_subtitle;

  /// No description provided for @owner_home_requestApp.
  ///
  /// In en, this message translates to:
  /// **'Request My App'**
  String get owner_home_requestApp;

  /// No description provided for @owner_home_myProjects.
  ///
  /// In en, this message translates to:
  /// **'My Active Projects'**
  String get owner_home_myProjects;

  /// No description provided for @owner_home_recentRequests.
  ///
  /// In en, this message translates to:
  /// **'Recent Requests'**
  String get owner_home_recentRequests;

  /// No description provided for @owner_home_noRecent.
  ///
  /// In en, this message translates to:
  /// **'No recent requests'**
  String get owner_home_noRecent;

  /// No description provided for @owner_home_viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get owner_home_viewAll;

  /// No description provided for @tutorial_step1_title.
  ///
  /// In en, this message translates to:
  /// **'Request your app'**
  String get tutorial_step1_title;

  /// No description provided for @tutorial_step1_body.
  ///
  /// In en, this message translates to:
  /// **'Pick a project, name your app, add notes, and submit the request.'**
  String get tutorial_step1_body;

  /// No description provided for @tutorial_step2_title.
  ///
  /// In en, this message translates to:
  /// **'Track approval'**
  String get tutorial_step2_title;

  /// No description provided for @tutorial_step2_body.
  ///
  /// In en, this message translates to:
  /// **'We’ll notify you when your request is approved or needs changes.'**
  String get tutorial_step2_body;

  /// No description provided for @tutorial_step3_title.
  ///
  /// In en, this message translates to:
  /// **'Download the APK'**
  String get tutorial_step3_title;

  /// No description provided for @tutorial_step3_body.
  ///
  /// In en, this message translates to:
  /// **'Once built, grab your APK directly from your dashboard.'**
  String get tutorial_step3_body;

  /// No description provided for @owner_projects_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name or slug…'**
  String get owner_projects_searchHint;

  /// No description provided for @owner_projects_onlyReady.
  ///
  /// In en, this message translates to:
  /// **'Only APK ready'**
  String get owner_projects_onlyReady;

  /// No description provided for @owner_projects_emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No projects yet'**
  String get owner_projects_emptyTitle;

  /// No description provided for @owner_projects_emptyBody.
  ///
  /// In en, this message translates to:
  /// **'You don’t have any projects. Request your first app and we’ll build it for you.'**
  String get owner_projects_emptyBody;

  /// No description provided for @owner_projects_building.
  ///
  /// In en, this message translates to:
  /// **'Building…'**
  String get owner_projects_building;

  /// No description provided for @owner_projects_ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get owner_projects_ready;

  /// No description provided for @owner_projects_openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get owner_projects_openInBrowser;

  /// No description provided for @owner_request_title.
  ///
  /// In en, this message translates to:
  /// **'Request Your App'**
  String get owner_request_title;

  /// No description provided for @owner_request_submit_hint.
  ///
  /// In en, this message translates to:
  /// **'Pick a project, name your app, add a logo (optional), choose a theme, then submit to build.'**
  String get owner_request_submit_hint;

  /// No description provided for @owner_request_project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get owner_request_project;

  /// No description provided for @owner_request_appName.
  ///
  /// In en, this message translates to:
  /// **'App name'**
  String get owner_request_appName;

  /// No description provided for @owner_request_appName_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. My Owner App'**
  String get owner_request_appName_hint;

  /// No description provided for @owner_request_logo_url.
  ///
  /// In en, this message translates to:
  /// **'Logo URL (optional)'**
  String get owner_request_logo_url;

  /// No description provided for @owner_request_logo_url_hint.
  ///
  /// In en, this message translates to:
  /// **'Paste a public URL or use Upload'**
  String get owner_request_logo_url_hint;

  /// No description provided for @owner_request_upload_logo.
  ///
  /// In en, this message translates to:
  /// **'Upload logo file'**
  String get owner_request_upload_logo;

  /// No description provided for @owner_request_theme_pref.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get owner_request_theme_pref;

  /// No description provided for @owner_request_theme_default.
  ///
  /// In en, this message translates to:
  /// **'Use default theme'**
  String get owner_request_theme_default;

  /// No description provided for @owner_request_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get owner_request_submit;

  /// No description provided for @owner_request_submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get owner_request_submitting;

  /// No description provided for @owner_request_submit_and_build.
  ///
  /// In en, this message translates to:
  /// **'Submit & Build APK'**
  String get owner_request_submit_and_build;

  /// No description provided for @owner_request_building.
  ///
  /// In en, this message translates to:
  /// **'Building APK…'**
  String get owner_request_building;

  /// No description provided for @owner_request_build_done.
  ///
  /// In en, this message translates to:
  /// **'APK build completed.'**
  String get owner_request_build_done;

  /// No description provided for @owner_request_success.
  ///
  /// In en, this message translates to:
  /// **'Request submitted successfully.'**
  String get owner_request_success;

  /// No description provided for @owner_request_no_requests_yet.
  ///
  /// In en, this message translates to:
  /// **'No requests yet.'**
  String get owner_request_no_requests_yet;

  /// No description provided for @owner_request_my_requests.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get owner_request_my_requests;

  /// No description provided for @owner_request_error_choose_project.
  ///
  /// In en, this message translates to:
  /// **'Please choose a project.'**
  String get owner_request_error_choose_project;

  /// No description provided for @owner_request_error_app_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter an app name.'**
  String get owner_request_error_app_name;

  /// No description provided for @common_download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get common_download;

  /// No description provided for @common_download_apk.
  ///
  /// In en, this message translates to:
  /// **'Download APK'**
  String get common_download_apk;

  /// No description provided for @menuType.
  ///
  /// In en, this message translates to:
  /// **'Menu Type'**
  String get menuType;

  /// No description provided for @owner_profile_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get owner_profile_username;

  /// No description provided for @owner_profile_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get owner_profile_name;

  /// No description provided for @owner_profile_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get owner_profile_email;

  /// No description provided for @owner_profile_business_id.
  ///
  /// In en, this message translates to:
  /// **'Business ID'**
  String get owner_profile_business_id;

  /// No description provided for @owner_profile_notify_items.
  ///
  /// In en, this message translates to:
  /// **'Notify item updates'**
  String get owner_profile_notify_items;

  /// No description provided for @owner_profile_notify_feedback.
  ///
  /// In en, this message translates to:
  /// **'Notify user feedback'**
  String get owner_profile_notify_feedback;

  /// No description provided for @owner_profile_not_set.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get owner_profile_not_set;

  /// No description provided for @owner_profile_tips.
  ///
  /// In en, this message translates to:
  /// **'Keep your profile details up to date to personalize your experience.'**
  String get owner_profile_tips;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to log out?'**
  String get logout_confirm;

  /// No description provided for @logged_out.
  ///
  /// In en, this message translates to:
  /// **'Logged out'**
  String get logged_out;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
