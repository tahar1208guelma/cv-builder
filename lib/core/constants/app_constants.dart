class AppConstants {
  static const String appName = 'CV Builder';
  static const String appVersion = '1.0.0';

  // Supported CV and UI Languages
  static const String langEn = 'en';
  static const String langFr = 'fr';
  static const String langAr = 'ar';

  // Templates
  static const String templateProfessional = 'professional';
  static const String templateModern = 'modern';
  static const String templateAcademic = 'academic';
  static const String templateAts = 'ats_friendly';

  // Legacy template aliases for backward compatibility
  static const String templateClassic = 'classic';
  static const String templateMinimalist = 'minimalist';
  static const String templateExecutive = 'executive';

  // Storage Keys
  static const String prefsThemeModeKey = 'cv_builder_theme_mode';
  static const String prefsAppLangKey = 'cv_builder_app_language';
  static const String prefsDefaultCvLangKey = 'cv_builder_default_cv_language';
  static const String cvStorageDir = 'cv_builder_documents';
}
