import 'package:flutter/material.dart';

enum AppLanguage {
  english('en', 'English', 'English', TextDirection.ltr),
  french('fr', 'Français', 'French', TextDirection.ltr),
  arabic('ar', 'العربية', 'Arabic', TextDirection.rtl);

  final String code;
  final String nativeName;
  final String englishName;
  final TextDirection textDirection;

  const AppLanguage(this.code, this.nativeName, this.englishName, this.textDirection);

  bool get isRtl => textDirection == TextDirection.rtl;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}
