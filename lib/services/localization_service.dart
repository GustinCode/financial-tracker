import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class LocalizationService {
  static const String _languageKey = 'selected_language';
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('pt', 'BR'), // Portuguese (Brazil)
    Locale('es', 'ES'), // Spanish (Spain)
    Locale('es', 'MX'), // Spanish (Mexico)
    Locale('en', 'US'), // English (United States)
    Locale('en', 'GB'), // English (United Kingdom)
  ];

  // Get saved locale from preferences
  static Future<Locale?> getSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      
      if (languageCode != null) {
        final parts = languageCode.split('_');
        if (parts.length == 2) {
          return Locale(parts[0], parts[1]);
        } else if (parts.length == 1) {
          return Locale(parts[0]);
        }
      }
    } catch (e) {
      debugPrint('Error loading saved locale: $e');
    }
    return null;
  }

  // Save locale to preferences
  static Future<void> saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = '${locale.languageCode}_${locale.countryCode ?? ''}';
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  // Get locale from language code string
  static Locale getLocaleFromCode(String code) {
    final parts = code.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    } else if (parts.length == 1) {
      return Locale(parts[0]);
    }
    return supportedLocales.first;
  }

  // Get language code string from locale
  static String getCodeFromLocale(Locale locale) {
    if (locale.countryCode != null) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }

  // Get display name for locale
  static String getDisplayName(Locale locale, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return locale.toString();
    
    switch ('${locale.languageCode}_${locale.countryCode ?? ''}') {
      case 'pt_BR':
        return l10n.portuguese;
      case 'es_ES':
        return l10n.spanishSpain;
      case 'es_MX':
        return l10n.spanishMexico;
      case 'en_US':
        return l10n.englishUS;
      case 'en_GB':
        return l10n.englishUK;
      default:
        return locale.toString();
    }
  }
}
