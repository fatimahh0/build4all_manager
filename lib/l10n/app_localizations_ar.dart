// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Build4All';

  @override
  String get signInGeneralTitle => 'سجّل الدخول إلى حسابك';

  @override
  String get errEmailInvalid => 'Invalid email';

  @override
  String get errEmailRequired => 'Email is required';

  @override
  String get lblEmail => 'Email';

  @override
  String get hintEmail => 'you@example.com';

  @override
  String get signInGeneralSubtitle => 'أدخل بياناتك للمتابعة';

  @override
  String get termsNotice => 'بمتابعتك أنت توافق على الشروط وسياسة الخصوصية';

  @override
  String get lblIdentifier => 'البريد / الهاتف / اسم المستخدم';

  @override
  String get hintIdentifier => 'you@example.com أو ‎+961xxxxxxxx‎ أو اسم المستخدم';

  @override
  String get lblPassword => 'كلمة المرور';

  @override
  String get hintPassword => '•••••••••••';

  @override
  String get rememberMe => 'تذكّرني';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get btnSignIn => 'تسجيل الدخول';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get errIdentifierRequired => 'الرجاء إدخال المُعرّف';

  @override
  String get errPasswordRequired => 'الرجاء إدخال كلمة المرور';

  @override
  String get errPasswordMin => 'الحد الأدنى 6 أحرف';

  @override
  String get showPasswordLabel => 'إظهار كلمة المرور';

  @override
  String get hidePasswordLabel => 'إخفاء كلمة المرور';

  @override
  String get nav_super_admin => 'المشرف العام';

  @override
  String get nav_dashboard => 'لوحة التحكم';

  @override
  String get nav_themes => 'السمات';

  @override
  String get nav_profile => 'الملف الشخصي';

  @override
  String get dashboard_title => 'لوحة تحكم المشرف';

  @override
  String get dashboard_welcome => 'مرحبًا بك في Build4All Manager';

  @override
  String get dashboard_hint => 'استخدم التنقل على اليسار لإدارة السمات وملفك.';

  @override
  String get themes_title => 'إدارة السمات';

  @override
  String get themes_add => 'إضافة سمة';

  @override
  String get themes_name => 'اسم السمة';

  @override
  String get themes_menuType => 'نوع القائمة';

  @override
  String get themes_setActive => 'تعيين كـ نشطة';

  @override
  String get themes_active => 'نشطة';

  @override
  String get themes_deactivate_all => 'تعطيل جميع السمات';

  @override
  String get themes_empty => 'لا توجد سمات بعد. أنشئ واحدة.';

  @override
  String get profile_title => 'ملفي الشخصي';

  @override
  String get profile_firstName => 'الاسم الأول';

  @override
  String get profile_lastName => 'اسم العائلة';

  @override
  String get profile_username => 'اسم المستخدم';

  @override
  String get profile_email => 'البريد الإلكتروني';

  @override
  String get profile_updated => 'تم تحديث الملف الشخصي بنجاح.';

  @override
  String get profile_changePassword => 'تغيير كلمة المرور';

  @override
  String get profile_currentPassword => 'كلمة المرور الحالية';

  @override
  String get profile_newPassword => 'كلمة المرور الجديدة';

  @override
  String get profile_updatePassword => 'تحديث كلمة المرور';

  @override
  String get password_updated => 'تم تحديث كلمة المرور بنجاح.';

  @override
  String get common_save => 'حفظ';

  @override
  String get common_edit => 'تعديل';

  @override
  String get common_delete => 'حذف';

  @override
  String get common_cancel => 'إلغاء';

  @override
  String get dash_total_projects => 'إجمالي المشاريع';

  @override
  String get dash_active_projects => 'المشاريع النشطة';

  @override
  String get dash_inactive_projects => 'المشاريع غير النشطة';

  @override
  String get dash_recent_projects => 'أحدث المشاريع';

  @override
  String get dash_no_recent => 'لا توجد مشاريع حديثة بعد.';

  @override
  String get dash_welcome => 'Welcome to Build4All Manager';

  @override
  String get themes_confirm_delete => 'هل تريد حذف هذه السمة؟ لا يمكن التراجع.';

  @override
  String get themes_colors_section => 'الألوان';

  @override
  String get err_required => 'هذا الحقل مطلوب';

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
  String get common_security => 'الأمان';

  @override
  String get common_sign_out => 'تسجيل الخروج';

  @override
  String get common_sign_out_hint => 'إنهاء الجلسة الحالية';

  @override
  String get common_sign_out_confirm => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get common_signed_out => 'تم تسجيل الخروج';

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
  String get owner_nav_title => 'المالك';

  @override
  String get owner_nav_home => 'الرئيسية';

  @override
  String get owner_nav_projects => 'المشاريع';

  @override
  String get owner_nav_requests => 'الطلبات';

  @override
  String get owner_nav_profile => 'الملف الشخصي';

  @override
  String get owner_home_title => 'واجهة المالك';

  @override
  String get owner_projects_title => 'المشاريع';

  @override
  String get owner_requests_title => 'الطلبات';

  @override
  String get owner_profile_title => 'ملف المالك';

  @override
  String get owner_home_hello => '👋 أهلاً، صاحب التطبيق';

  @override
  String get owner_home_subtitle => 'إدارة تطبيقاتك بسهولة';

  @override
  String get owner_home_requestApp => 'اطلب تطبيقي';

  @override
  String get owner_home_myProjects => 'مشاريعي النشطة';

  @override
  String get owner_home_recentRequests => 'الطلبات الأخيرة';

  @override
  String get owner_home_noRecent => 'لا توجد طلبات حديثة';

  @override
  String get owner_home_viewAll => 'عرض الكل';

  @override
  String get tutorial_step1_title => 'اطلب تطبيقك';

  @override
  String get tutorial_step1_body => 'اختر المشروع، سمِّ التطبيق، أضف ملاحظات، ثم أرسل الطلب.';

  @override
  String get tutorial_step2_title => 'تابع الموافقة';

  @override
  String get tutorial_step2_body => 'سنعلمك عند الموافقة أو إذا كانت هناك تعديلات مطلوبة.';

  @override
  String get tutorial_step3_title => 'حمّل ملف APK';

  @override
  String get tutorial_step3_body => 'بعد البناء، نزّل الـ APK مباشرةً من لوحة التحكم.';

  @override
  String get owner_projects_searchHint => 'ابحث بالاسم أو المعرّف…';

  @override
  String get owner_projects_onlyReady => 'فقط الجاهزة (APK)';

  @override
  String get owner_projects_emptyTitle => 'لا توجد مشاريع بعد';

  @override
  String get owner_projects_emptyBody => 'ليس لديك أي مشاريع حالياً. اطلب تطبيقك الأول وسنقوم ببنائه لك.';

  @override
  String get owner_projects_building => 'جارٍ الإنشاء…';

  @override
  String get owner_projects_ready => 'جاهز';

  @override
  String get owner_projects_openInBrowser => 'فتح';

  @override
  String get owner_request_title => 'طلب إنشاء تطبيق جديد';

  @override
  String get owner_request_project => 'المشروع';

  @override
  String get owner_request_appName => 'اسم التطبيق';

  @override
  String get owner_request_appName_hint => 'مثال: My Coffee';

  @override
  String get owner_request_logo_url => 'Logo URL (optional)';

  @override
  String get owner_request_logo_url_hint => 'https://example.com/logo.png';

  @override
  String get owner_request_theme_pref => 'تفضيل السمة (اختياري)';

  @override
  String get owner_request_theme_pref_hint => 'emerald / violet / amber ...';

  @override
  String get owner_request_theme_default => 'Default theme';

  @override
  String get owner_request_submit => 'إرسال الطلب';

  @override
  String get owner_request_submitting => 'جارٍ الإرسال...';

  @override
  String get owner_request_submit_hint => 'Your request is auto-approved. The build will start shortly.';

  @override
  String get owner_request_my_requests => 'طلباتي';

  @override
  String get owner_request_no_requests_yet => 'لا توجد طلبات بعد';

  @override
  String get owner_request_no_projects => 'No available projects.';

  @override
  String get owner_request_success => 'تم إنشاء الطلب. سيبدأ البناء قريباً.';

  @override
  String get owner_request_error_choose_project => 'رجاءً اختر مشروعاً';

  @override
  String get owner_request_error_app_name => 'اسم التطبيق مطلوب';

  @override
  String get menuType => 'Menu Type';

  @override
  String get owner_request_upload_logo => 'تحميل ملف الشعار';

  @override
  String get owner_profile_username => 'اسم المستخدم';

  @override
  String get owner_profile_name => 'الاسم';

  @override
  String get owner_profile_email => 'البريد الإلكتروني';

  @override
  String get owner_profile_business_id => 'معرّف النشاط التجاري';

  @override
  String get owner_profile_notify_items => 'إشعار بتحديثات العناصر';

  @override
  String get owner_profile_notify_feedback => 'إشعار بتعليقات المستخدمين';

  @override
  String get owner_profile_not_set => 'غير محدد';

  @override
  String get owner_profile_tips => 'احرص على تحديث معلومات ملفك الشخصي لتخصيص تجربتك.';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get refresh => 'تحديث';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logout_confirm => 'هل تريد تسجيل الخروج؟';

  @override
  String get logged_out => 'تم تسجيل الخروج';

  @override
  String get cancel => 'إلغاء';
}
