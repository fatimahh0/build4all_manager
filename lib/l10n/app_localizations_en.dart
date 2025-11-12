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

  @override
  String get owner_nav_title => 'Owner';

  @override
  String get owner_nav_home => 'Home';

  @override
  String get owner_nav_projects => 'Projects';

  @override
  String get owner_nav_requests => 'Requests';

  @override
  String get owner_nav_profile => 'Profile';

  @override
  String get owner_home_title => 'Owner Home';

  @override
  String get owner_projects_title => 'Projects';

  @override
  String get owner_requests_title => 'Requests';

  @override
  String get owner_profile_title => 'Owner Profile';

  @override
  String get owner_home_hello => 'Hi, Owner 👋';

  @override
  String get owner_home_subtitle => 'Ready to launch your next app build?';

  @override
  String get owner_home_requestApp => 'Request My App';

  @override
  String get owner_home_myProjects => 'My Active Projects';

  @override
  String get owner_home_recentRequests => 'Recent requests';

  @override
  String get owner_home_noRecent => 'No recent requests';

  @override
  String get owner_home_viewAll => 'View all';

  @override
  String get tutorial_step1_title => 'Request your app';

  @override
  String get tutorial_step1_body => 'Pick a project, name your app, add notes, and submit the request.';

  @override
  String get tutorial_step2_title => 'Track approval';

  @override
  String get tutorial_step2_body => 'We’ll notify you when your request is approved or needs changes.';

  @override
  String get tutorial_step3_title => 'Download the APK';

  @override
  String get tutorial_step3_body => 'Once built, grab your APK directly from your dashboard.';

  @override
  String get owner_projects_searchHint => 'Search name or slug…';

  @override
  String get owner_projects_onlyReady => 'Only APK ready';

  @override
  String get owner_projects_emptyTitle => 'No projects yet';

  @override
  String get owner_projects_emptyBody => 'You don’t have any projects. Request your first app and we’ll build it for you.';

  @override
  String get owner_projects_building => 'Building…';

  @override
  String get owner_projects_ready => 'Ready';

  @override
  String get owner_projects_openInBrowser => 'Open';

  @override
  String get owner_request_title => 'Request Your App';

  @override
  String get owner_request_submit_hint => 'Pick a project, name your app, add a logo (optional), choose a theme, then submit to build.';

  @override
  String get owner_request_project => 'Project';

  @override
  String get owner_request_appName => 'App name';

  @override
  String get owner_request_appName_hint => 'e.g. My Owner App';

  @override
  String get owner_request_logo_url => 'Logo URL (optional)';

  @override
  String get owner_request_logo_url_hint => 'Paste a public URL or use Upload';

  @override
  String get owner_request_upload_logo => 'Upload logo file';

  @override
  String get owner_request_theme_pref => 'Theme';

  @override
  String get owner_request_theme_default => 'Use default theme';

  @override
  String get owner_request_submit => 'Submit';

  @override
  String get owner_request_submitting => 'Submitting…';

  @override
  String get owner_request_submit_and_build => 'Submit & Build APK';

  @override
  String get owner_request_building => 'Building APK…';

  @override
  String get owner_request_build_done => 'APK build completed.';

  @override
  String get owner_request_success => 'Request submitted successfully.';

  @override
  String get owner_request_no_requests_yet => 'No requests yet.';

  @override
  String get owner_request_my_requests => 'My Requests';

  @override
  String get owner_request_error_choose_project => 'Please choose a project.';

  @override
  String get owner_request_error_app_name => 'Please enter an app name.';

  @override
  String get common_download => 'Download';

  @override
  String get common_download_apk => 'Download APK';

  @override
  String get menuType => 'Menu Type';

  @override
  String get owner_profile_username => 'Username';

  @override
  String get owner_profile_name => 'Name';

  @override
  String get owner_profile_email => 'Email';

  @override
  String get owner_profile_business_id => 'Business ID';

  @override
  String get owner_profile_notify_items => 'Notify item updates';

  @override
  String get owner_profile_notify_feedback => 'Notify user feedback';

  @override
  String get owner_profile_not_set => 'Not set';

  @override
  String get owner_profile_tips => 'Keep your profile details up to date to personalize your experience.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get refresh => 'Refresh';

  @override
  String get logout => 'Logout';

  @override
  String get logout_confirm => 'Do you want to log out?';

  @override
  String get logged_out => 'Logged out';

  @override
  String get cancel => 'Cancel';

  @override
  String get owner_nav_myapps => 'My Apps';

  @override
  String get common_search_hint => 'Search...';

  @override
  String get owner_home_search_hint => 'Search apps, requests, guides';

  @override
  String get owner_home_chooseProject => 'Choose your project';

  @override
  String get owner_proj_open => 'Open project';

  @override
  String get owner_proj_activities_title => 'Activities';

  @override
  String get owner_proj_activities_desc => 'Ticketing, schedules, and event highlights crafted for experiences on the go.';

  @override
  String get owner_proj_ecom_title => 'E-commerce';

  @override
  String get owner_proj_ecom_desc => 'Product catalogs, carts, and checkout flows that mirror your storefront.';

  @override
  String get owner_proj_gym_title => 'Gym';

  @override
  String get owner_proj_gym_desc => 'Training plans, booking slots, and membership perks in one app.';

  @override
  String get owner_proj_services_title => 'Services';

  @override
  String get owner_proj_services_desc => 'Quotes, appointments, and customer updates tailored to your brand.';

  @override
  String get status_delivered => 'Delivered';

  @override
  String get status_in_production => 'In production';

  @override
  String get status_approved => 'Approved';

  @override
  String get status_pending => 'Pending';

  @override
  String get status_rejected => 'Rejected';

  @override
  String get owner_request_requested => 'Requested';

  @override
  String timeago_days(int count) {
    return '${count}d ago';
  }

  @override
  String timeago_hours(int count) {
    return '${count}h ago';
  }

  @override
  String timeago_minutes(int count) {
    return '${count}m ago';
  }

  @override
  String get timeago_just_now => 'just now';

  @override
  String get owner_proj_details_highlights => 'Highlights';

  @override
  String get owner_proj_details_screens => 'Screens & flows';

  @override
  String get owner_proj_details_modules => 'Modules included';

  @override
  String get owner_proj_details_why => 'Why teams love this template';

  @override
  String get owner_proj_details_primaryCta => 'Request this app';

  @override
  String get owner_proj_details_secondaryCta => 'Preview demo';

  @override
  String get owner_proj_details_create_title => 'Create my project';

  @override
  String get owner_proj_details_create_subtitle => 'Launch your customized version in minutes.';

  @override
  String get stat_reviews_hint => 'reviews';

  @override
  String get stat_active_hint => 'active deployments';

  @override
  String get stat_days_hint => 'days avg. turnaround';

  @override
  String get owner_proj_details_headline_activities => 'Plan, book, and manage every activity in one place.';

  @override
  String get owner_proj_details_subhead_activities => 'Perfect for studios, clubs, and programs with polished booking & schedules.';

  @override
  String get owner_proj_details_act_h1 => 'Class schedules with waitlists';

  @override
  String get owner_proj_details_act_h2 => 'Wallet & credits support';

  @override
  String get owner_proj_details_act_h3 => 'Push reminders for attendees';

  @override
  String get owner_proj_details_act_h4 => 'Embedded community feed';

  @override
  String get owner_proj_details_act_s1_title => 'Schedule grid';

  @override
  String get owner_proj_details_act_s1_sub => 'Filter by instructor & location with one tap.';

  @override
  String get owner_proj_details_act_s2_title => 'Booking flow';

  @override
  String get owner_proj_details_act_s2_sub => 'Frictionless checkout with saved cards.';

  @override
  String get owner_proj_details_act_m1 => 'Dynamic schedules & multi-location calendars';

  @override
  String get owner_proj_details_act_m2 => 'Instructor bios and ratings';

  @override
  String get owner_proj_details_act_m3 => 'Membership tiers with perks';

  @override
  String get owner_proj_details_act_i1 => '78% of members book via mobile within the first week.';

  @override
  String get owner_proj_details_act_i2 => 'Retention jumps 24% after enabling reminder pushes.';

  @override
  String get owner_proj_details_headline_ecommerce => 'Launch a high-converting storefront your shoppers trust.';

  @override
  String get owner_proj_details_subhead_ecommerce => 'For DTC brands: catalogs, bundles, and one-click reorders.';

  @override
  String get owner_proj_details_ecom_h1 => 'Visual catalog with rich media';

  @override
  String get owner_proj_details_ecom_h2 => 'Smart upsell recommendations';

  @override
  String get owner_proj_details_ecom_h3 => 'In-app order tracking';

  @override
  String get owner_proj_details_ecom_h4 => 'Discount & loyalty engine';

  @override
  String get owner_proj_details_ecom_s1_title => 'Product showcase';

  @override
  String get owner_proj_details_ecom_s1_sub => 'Full-bleed imagery with swatches.';

  @override
  String get owner_proj_details_ecom_s2_title => 'Cart & checkout';

  @override
  String get owner_proj_details_ecom_s2_sub => 'Accelerated checkout with saved addresses.';

  @override
  String get owner_proj_details_ecom_m1 => 'Unlimited product variants & bundles';

  @override
  String get owner_proj_details_ecom_m2 => 'Inventory sync with Shopify/Woo';

  @override
  String get owner_proj_details_ecom_m3 => 'Gift cards and referral rewards';

  @override
  String get owner_proj_details_ecom_i1 => 'Average order value lifts 32% with bundled offers.';

  @override
  String get owner_proj_details_ecom_i2 => 'Customers reorder 2.1× faster via the mobile channel.';

  @override
  String get owner_proj_details_headline_gym => 'Give members a personal coach in their pocket.';

  @override
  String get owner_proj_details_subhead_gym => 'Hybrid training, class packs, and equipment rentals.';

  @override
  String get owner_proj_details_gym_h1 => 'Goal-based onboarding';

  @override
  String get owner_proj_details_gym_h2 => 'Trainer messaging & programs';

  @override
  String get owner_proj_details_gym_h3 => 'Workout video library';

  @override
  String get owner_proj_details_gym_h4 => 'Progress tracking dashboards';

  @override
  String get owner_proj_details_gym_s1_title => 'Training plans';

  @override
  String get owner_proj_details_gym_s1_sub => 'Periodised plans with rest logic.';

  @override
  String get owner_proj_details_gym_s2_title => 'Live classes';

  @override
  String get owner_proj_details_gym_s2_sub => 'Book in-person or virtual sessions.';

  @override
  String get owner_proj_details_gym_m1 => 'Trainer marketplace with availability';

  @override
  String get owner_proj_details_gym_m2 => 'Workout logging & wearable sync';

  @override
  String get owner_proj_details_gym_m3 => 'Nutrition plans with macro targets';

  @override
  String get owner_proj_details_gym_i1 => 'Members completing onboarding convert 3× faster.';

  @override
  String get owner_proj_details_gym_i2 => 'Churn drops 19% when messaging is enabled.';

  @override
  String get owner_proj_details_headline_services => 'Deliver a concierge-grade service experience.';

  @override
  String get owner_proj_details_subhead_services => 'For agencies, consultancies, and service pros.';

  @override
  String get owner_proj_details_services_h1 => 'Smart booking windows';

  @override
  String get owner_proj_details_services_h2 => 'Client workspaces';

  @override
  String get owner_proj_details_services_h3 => 'Task & milestone tracker';

  @override
  String get owner_proj_details_services_h4 => 'Integrated invoicing';

  @override
  String get owner_proj_details_services_s1_title => 'Client portal';

  @override
  String get owner_proj_details_services_s1_sub => 'Shared files, notes, and approvals.';

  @override
  String get owner_proj_details_services_s2_title => 'Appointment flow';

  @override
  String get owner_proj_details_services_s2_sub => 'Buffers and intake forms.';

  @override
  String get owner_proj_details_services_m1 => 'Client CRM with shared timelines';

  @override
  String get owner_proj_details_services_m2 => 'Digital contracts & e-signatures';

  @override
  String get owner_proj_details_services_m3 => 'Automated invoice & receipt emails';

  @override
  String get owner_proj_details_services_i1 => 'Projects close 27% faster with shared workspaces.';

  @override
  String get owner_proj_details_services_i2 => 'Automated billing reduces late payments by 43%.';

  @override
  String get owner_proj_details_stat_reviews_hint => 'reviews';

  @override
  String get owner_proj_details_stat_active_hint => 'active deployments';

  @override
  String get owner_proj_details_stat_days_hint => 'days avg. turnaround';
}
