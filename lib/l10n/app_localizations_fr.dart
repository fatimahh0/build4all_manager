// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Build4All';

  @override
  String get signInGeneralTitle => 'Connectez-vous à votre compte';

  @override
  String get errEmailInvalid => 'Invalid email';

  @override
  String get errEmailRequired => 'Email is required';

  @override
  String get lblEmail => 'Email';

  @override
  String get hintEmail => 'you@example.com';

  @override
  String get signInGeneralSubtitle => 'Saisissez vos informations pour continuer';

  @override
  String get termsNotice => 'En continuant, vous acceptez nos Conditions et notre Politique de confidentialité';

  @override
  String get lblIdentifier => 'E-mail / Téléphone / Nom d’utilisateur';

  @override
  String get hintIdentifier => 'you@example.com ou +961xxxxxxxx ou nom d’utilisateur';

  @override
  String get lblPassword => 'Mot de passe';

  @override
  String get hintPassword => '•••••••••••';

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get btnSignIn => 'Se connecter';

  @override
  String get noAccount => 'Vous n’avez pas de compte ?';

  @override
  String get signUp => 'S’inscrire';

  @override
  String get errIdentifierRequired => 'L’identifiant est requis';

  @override
  String get errPasswordRequired => 'Le mot de passe est requis';

  @override
  String get errPasswordMin => '6 caractères minimum';

  @override
  String get showPasswordLabel => 'Afficher le mot de passe';

  @override
  String get hidePasswordLabel => 'Masquer le mot de passe';

  @override
  String get nav_super_admin => 'Super Admin';

  @override
  String get nav_dashboard => 'Tableau de bord';

  @override
  String get nav_themes => 'Thèmes';

  @override
  String get nav_profile => 'Profil';

  @override
  String get dashboard_title => 'Tableau de bord administrateur';

  @override
  String get dashboard_welcome => 'Bienvenue sur Build4All Manager';

  @override
  String get dashboard_hint => 'Utilisez la navigation à gauche pour gérer les thèmes et votre profil.';

  @override
  String get themes_title => 'Gestion des thèmes';

  @override
  String get themes_add => 'Ajouter un thème';

  @override
  String get themes_name => 'Nom du thème';

  @override
  String get themes_menuType => 'Type de menu';

  @override
  String get themes_setActive => 'Définir comme actif';

  @override
  String get themes_active => 'Actif';

  @override
  String get themes_deactivate_all => 'Désactiver tous les thèmes';

  @override
  String get themes_empty => 'Aucun thème pour le moment. Créez-en un.';

  @override
  String get profile_title => 'Mon profil';

  @override
  String get profile_firstName => 'Prénom';

  @override
  String get profile_lastName => 'Nom';

  @override
  String get profile_username => 'Nom d\'utilisateur';

  @override
  String get profile_email => 'E-mail';

  @override
  String get profile_updated => 'Profil mis à jour avec succès.';

  @override
  String get profile_changePassword => 'Changer le mot de passe';

  @override
  String get profile_currentPassword => 'Mot de passe actuel';

  @override
  String get profile_newPassword => 'Nouveau mot de passe';

  @override
  String get profile_updatePassword => 'Mettre à jour le mot de passe';

  @override
  String get password_updated => 'Mot de passe mis à jour avec succès.';

  @override
  String get common_save => 'Enregistrer';

  @override
  String get common_edit => 'Modifier';

  @override
  String get common_delete => 'Supprimer';

  @override
  String get common_cancel => 'Annuler';

  @override
  String get dash_total_projects => 'Projets au total';

  @override
  String get dash_active_projects => 'Projets actifs';

  @override
  String get dash_inactive_projects => 'Projets inactifs';

  @override
  String get dash_recent_projects => 'Projets récents';

  @override
  String get dash_no_recent => 'Aucun projet récent pour le moment.';

  @override
  String get dash_welcome => 'Welcome to Build4All Manager';

  @override
  String get themes_confirm_delete => 'Supprimer ce thème ? Cette action est irréversible.';

  @override
  String get themes_colors_section => 'Couleurs';

  @override
  String get err_required => 'Ce champ est obligatoire';

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
  String get common_security => 'Sécurité';

  @override
  String get common_sign_out => 'Se déconnecter';

  @override
  String get common_sign_out_hint => 'Terminer votre session actuelle';

  @override
  String get common_sign_out_confirm => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get common_signed_out => 'Déconnexion réussie';

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
