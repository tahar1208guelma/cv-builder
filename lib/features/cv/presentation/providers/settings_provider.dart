import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_locale.dart';

class SettingsState {
  final AppLanguage appLanguage;
  final String defaultCvLanguage;
  final ThemeMode themeMode;

  const SettingsState({
    this.appLanguage = AppLanguage.english,
    this.defaultCvLanguage = AppConstants.langEn,
    this.themeMode = ThemeMode.system,
  });

  SettingsState copyWith({
    AppLanguage? appLanguage,
    String? defaultCvLanguage,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      appLanguage: appLanguage ?? this.appLanguage,
      defaultCvLanguage: defaultCvLanguage ?? this.defaultCvLanguage,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(AppConstants.prefsAppLangKey) ?? 'en';
    final defaultCvLang = prefs.getString(AppConstants.prefsDefaultCvLangKey) ?? AppConstants.langEn;
    final themeIndex = prefs.getInt(AppConstants.prefsThemeModeKey) ?? ThemeMode.system.index;

    state = state.copyWith(
      appLanguage: AppLanguage.fromCode(langCode),
      defaultCvLanguage: defaultCvLang,
      themeMode: ThemeMode.values[themeIndex.clamp(0, ThemeMode.values.length - 1)],
    );
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = state.copyWith(appLanguage: language);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefsAppLangKey, language.code);
  }

  Future<void> setDefaultCvLanguage(String langCode) async {
    state = state.copyWith(defaultCvLanguage: langCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefsDefaultCvLangKey, langCode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefsThemeModeKey, mode.index);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
