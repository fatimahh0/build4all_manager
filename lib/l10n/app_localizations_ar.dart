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
  String get owner_home_hello => 'مرحبًا،  👋';

  @override
  String get owner_home_subtitle => 'جاهز لإطلاق نسختك التالية؟';

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
  String get owner_request_title => 'طلب تطبيقك';

  @override
  String get owner_request_submit_hint => 'اختر مشروعًا، أضف اسم التطبيق، حمل الشعار (اختياري)، اختر سمة، ثم أرسل للبناء.';

  @override
  String get owner_request_project => 'المشروع';

  @override
  String get owner_request_appName => 'اسم التطبيق';

  @override
  String get owner_request_appName_hint => 'مثال: تطبيقي للمالك';

  @override
  String get owner_request_logo_url => 'رابط الشعار (اختياري)';

  @override
  String get owner_request_logo_url_hint => 'ألصق رابطًا عامًا أو استخدم الرفع';

  @override
  String get owner_request_upload_logo => 'رفع الشعار';

  @override
  String get owner_request_theme_pref => 'السمة';

  @override
  String get owner_request_theme_default => 'استخدام السمة الافتراضية';

  @override
  String get owner_request_submit => 'إرسال';

  @override
  String get owner_request_submitting => 'جارٍ الإرسال…';

  @override
  String get owner_request_submit_and_build => 'إرسال وبناء APK';

  @override
  String get owner_request_building => 'جارٍ بناء ملف APK…';

  @override
  String get owner_request_build_done => 'تم إنهاء بناء الـ APK.';

  @override
  String get owner_request_success => 'تم إرسال الطلب بنجاح.';

  @override
  String get owner_request_no_requests_yet => 'لا توجد طلبات بعد.';

  @override
  String get owner_request_my_requests => 'طلباتي';

  @override
  String get owner_request_error_choose_project => 'يرجى اختيار مشروع.';

  @override
  String get owner_request_error_app_name => 'يرجى إدخال اسم التطبيق.';

  @override
  String get common_download => 'تنزيل';

  @override
  String get common_download_apk => 'تنزيل APK';

  @override
  String get menuType => 'Menu Type';

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

  @override
  String get owner_nav_myapps => 'تطبيقاتي';

  @override
  String get common_search_hint => 'ابحث...';

  @override
  String get owner_home_search_hint => 'ابحث عن التطبيقات والطلبات والإرشادات';

  @override
  String get owner_home_chooseProject => 'اختر مشروعك';

  @override
  String get owner_proj_open => 'افتح المشروع';

  @override
  String get owner_proj_activities_title => 'الفعاليات';

  @override
  String get owner_proj_activities_desc => 'تذاكر، جداول، وأبرز الأحداث مصمّمة للتجارب أثناء التنقل.';

  @override
  String get owner_proj_ecom_title => 'التجارة الإلكترونية';

  @override
  String get owner_proj_ecom_desc => 'كتالوجات المنتجات وسلال الشراء وتدفّقات الدفع المطابقة لمتجرك.';

  @override
  String get owner_proj_gym_title => 'النادي الرياضي';

  @override
  String get owner_proj_gym_desc => 'خطط تدريب، حجوزات مواعيد، ومزايا العضوية في تطبيق واحد.';

  @override
  String get owner_proj_services_title => 'الخدمات';

  @override
  String get owner_proj_services_desc => 'عروض أسعار، مواعيد، وتحديثات للعميل متوافقة مع هويتك.';

  @override
  String get status_delivered => 'تم التسليم';

  @override
  String get status_in_production => 'قيد التنفيذ';

  @override
  String get status_approved => 'موافق عليه';

  @override
  String get status_pending => 'قيد الانتظار';

  @override
  String get status_rejected => 'مرفوض';

  @override
  String get owner_request_requested => 'تم الطلب';

  @override
  String timeago_days(int count) {
    return 'منذ $count يوم';
  }

  @override
  String timeago_hours(int count) {
    return 'منذ $count ساعة';
  }

  @override
  String timeago_minutes(int count) {
    return 'منذ $count دقيقة';
  }

  @override
  String get timeago_just_now => 'الآن';

  @override
  String get owner_proj_details_highlights => 'أبرز الميزات';

  @override
  String get owner_proj_details_screens => 'الشاشات والتدفّقات';

  @override
  String get owner_proj_details_modules => 'الوحدات المتضمَّنة';

  @override
  String get owner_proj_details_why => 'لماذا يحبّها الفرق';

  @override
  String get owner_proj_details_primaryCta => 'اطلب هذا التطبيق';

  @override
  String get owner_proj_details_secondaryCta => 'عرض النسخة التجريبية';

  @override
  String get owner_proj_details_create_title => 'أنشئ مشروعي';

  @override
  String get owner_proj_details_create_subtitle => 'أطلق نسختك المخصّصة خلال دقائق.';

  @override
  String get stat_reviews_hint => 'تقييم';

  @override
  String get stat_active_hint => 'نشر فعّال';

  @override
  String get stat_days_hint => 'أيام متوسّط التنفيذ';

  @override
  String get owner_proj_details_headline_activities => 'نظّم، احجز، وادر كل نشاط من مكان واحد.';

  @override
  String get owner_proj_details_subhead_activities => 'مثالي للأندية والمراكز بواجهات حجز وجداول مصقولة.';

  @override
  String get owner_proj_details_act_h1 => 'جداول حصص مع لوائح انتظار';

  @override
  String get owner_proj_details_act_h2 => 'محفظة ودعم الرصيد';

  @override
  String get owner_proj_details_act_h3 => 'تذكيرات دفعية للمشاركين';

  @override
  String get owner_proj_details_act_h4 => 'خلاصة تواصل مدمجة';

  @override
  String get owner_proj_details_act_s1_title => 'شبكة الجداول';

  @override
  String get owner_proj_details_act_s1_sub => 'تصفية بالمدرب والموقع بضغطة واحدة.';

  @override
  String get owner_proj_details_act_s2_title => 'تدفّق الحجز';

  @override
  String get owner_proj_details_act_s2_sub => 'دفع سلس مع بطاقات محفوظة.';

  @override
  String get owner_proj_details_act_m1 => 'جداول ديناميكية ومتعدّدة المواقع';

  @override
  String get owner_proj_details_act_m2 => 'سير ذاتية وتقييمات المدرّبين';

  @override
  String get owner_proj_details_act_m3 => 'عضويات بمستويات ومزايا';

  @override
  String get owner_proj_details_act_i1 => '78٪ من الأعضاء يحجزون عبر الهاتف خلال الأسبوع الأول.';

  @override
  String get owner_proj_details_act_i2 => 'تزداد الاستمرارية 24٪ بعد تفعيل التذكيرات.';

  @override
  String get owner_proj_details_headline_ecommerce => 'أطلق متجراً عالي التحويل يثق به عملاؤك.';

  @override
  String get owner_proj_details_subhead_ecommerce => 'للبيع المباشر: كتالوجات، حِزم، وإعادة شراء بنقرة.';

  @override
  String get owner_proj_details_ecom_h1 => 'كتالوج بصري مع وسائط غنيّة';

  @override
  String get owner_proj_details_ecom_h2 => 'ترشيحات ذكية للبيع الإضافي';

  @override
  String get owner_proj_details_ecom_h3 => 'تتبّع الطلب داخل التطبيق';

  @override
  String get owner_proj_details_ecom_h4 => 'محرك خصومات وولاء';

  @override
  String get owner_proj_details_ecom_s1_title => 'عرض المنتجات';

  @override
  String get owner_proj_details_ecom_s1_sub => 'صور ممتدّة مع عينات ألوان.';

  @override
  String get owner_proj_details_ecom_s2_title => 'السلة والدفع';

  @override
  String get owner_proj_details_ecom_s2_sub => 'دفع سريع مع عناوين محفوظة.';

  @override
  String get owner_proj_details_ecom_m1 => 'متغيرات ومنتجات مجمّعة غير محدودة';

  @override
  String get owner_proj_details_ecom_m2 => 'مزامنة المخزون مع Shopify/Woo';

  @override
  String get owner_proj_details_ecom_m3 => 'بطاقات هدايا وبرامج إحالة';

  @override
  String get owner_proj_details_ecom_i1 => 'يرتفع متوسط قيمة الطلب 32٪ مع الحزم.';

  @override
  String get owner_proj_details_ecom_i2 => 'يعيد العملاء الشراء أسرع بـ 2.1× عبر الهاتف.';

  @override
  String get owner_proj_details_headline_gym => 'امنح الأعضاء مدرّباً شخصياً في جيوبهم.';

  @override
  String get owner_proj_details_subhead_gym => 'تدريب هجين، باقات حصص، وتأجير معدات.';

  @override
  String get owner_proj_details_gym_h1 => 'تهيئة حسب الأهداف';

  @override
  String get owner_proj_details_gym_h2 => 'مراسلة المدرّب والبرامج';

  @override
  String get owner_proj_details_gym_h3 => 'مكتبة فيديوهات للتمارين';

  @override
  String get owner_proj_details_gym_h4 => 'لوحات تقدّم وتتبع';

  @override
  String get owner_proj_details_gym_s1_title => 'خطط التدريب';

  @override
  String get owner_proj_details_gym_s1_sub => 'خطط مُمرحلة بمنطق الاستراحة.';

  @override
  String get owner_proj_details_gym_s2_title => 'حصص مباشرة';

  @override
  String get owner_proj_details_gym_s2_sub => 'احجز حضورياً أو عبر الإنترنت.';

  @override
  String get owner_proj_details_gym_m1 => 'سوق مدرّبين مع التوفّر';

  @override
  String get owner_proj_details_gym_m2 => 'تسجيل التمارين ومزامنة الأجهزة';

  @override
  String get owner_proj_details_gym_m3 => 'خطط تغذية مع أهداف الماكروز';

  @override
  String get owner_proj_details_gym_i1 => 'المنضمون يكملون التهيئة يتحولون أسرع بـ3×.';

  @override
  String get owner_proj_details_gym_i2 => 'ينخفض التسرّب 19٪ عند تفعيل الرسائل.';

  @override
  String get owner_proj_details_headline_services => 'قدّم تجربة خِدمة بمستوى كونسيرج.';

  @override
  String get owner_proj_details_subhead_services => 'للوكالات والاستشارات ومقدمي الخدمات.';

  @override
  String get owner_proj_details_services_h1 => 'نوافذ حجز ذكية';

  @override
  String get owner_proj_details_services_h2 => 'مساحات عمل للعميل';

  @override
  String get owner_proj_details_services_h3 => 'تتبّع المهام والمعالم';

  @override
  String get owner_proj_details_services_h4 => 'فواتير مدمجة';

  @override
  String get owner_proj_details_services_s1_title => 'بوابة العميل';

  @override
  String get owner_proj_details_services_s1_sub => 'ملفات مشتركة، ملاحظات، وموافقات.';

  @override
  String get owner_proj_details_services_s2_title => 'تدفّق المواعيد';

  @override
  String get owner_proj_details_services_s2_sub => 'فواصل ونماذج معلومات مسبقة.';

  @override
  String get owner_proj_details_services_m1 => 'CRM للعميل بخطوط زمنية مشتركة';

  @override
  String get owner_proj_details_services_m2 => 'عقود رقمية وتوقيع إلكتروني';

  @override
  String get owner_proj_details_services_m3 => 'فواتير وإيصالات تلقائية';

  @override
  String get owner_proj_details_services_i1 => 'تُغلق المشاريع أسرع بـ 27٪ مع المساحات المشتركة.';

  @override
  String get owner_proj_details_services_i2 => 'الفوترة التلقائية تقلّل التأخير 43٪.';

  @override
  String get owner_proj_details_stat_reviews_hint => 'المراجعات';

  @override
  String get owner_proj_details_stat_active_hint => 'النشطات';

  @override
  String get owner_proj_details_stat_days_hint => 'الأيام';

  @override
  String get owner_projects_subtitle => 'Manage your projects and app builds seamlessly';

  @override
  String get copied => 'تم النسخ';

  @override
  String get settings => 'الإعدادات';

  @override
  String get security => 'الأمان';

  @override
  String get change_password => 'تغيير كلمة السر';

  @override
  String get support => 'الدعم';

  @override
  String get contact_us => 'تواصل معنا';

  @override
  String get owner_profile_edit => 'الحساب';

  @override
  String get edit_profile => 'تعديل الملف';

  @override
  String get billing => 'الفوترة';

  @override
  String get copy => 'نسخ';

  @override
  String get owner_proj_comingSoon => 'قريباً';
}
