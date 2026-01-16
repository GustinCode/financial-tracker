import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Formatters {
  // Get currency symbol based on locale
  static String _getCurrencySymbol(Locale? locale) {
    if (locale == null) return 'R\$';
    
    switch ('${locale.languageCode}_${locale.countryCode ?? ''}') {
      case 'pt_BR':
        return 'R\$';
      case 'es_ES':
      case 'es_MX':
        return '\$';
      case 'en_US':
        return '\$';
      case 'en_GB':
        return '£';
      default:
        return 'R\$';
    }
  }

  static String formatCurrency(double value, [Locale? locale]) {
    final symbol = _getCurrencySymbol(locale);
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
      locale: locale?.toString() ?? 'pt_BR',
    );
    return formatter.format(value);
  }

  static String formatDate(DateTime date, [Locale? locale]) {
    // Default date format based on locale
    String dateFormat;
    if (locale == null) {
      dateFormat = 'dd/MM/yyyy';
    } else {
      switch ('${locale.languageCode}_${locale.countryCode ?? ''}') {
        case 'pt_BR':
          dateFormat = 'dd/MM/yyyy';
          break;
        case 'es_ES':
        case 'es_MX':
          dateFormat = 'dd/MM/yyyy';
          break;
        case 'en_US':
          dateFormat = 'MM/dd/yyyy';
          break;
        case 'en_GB':
          dateFormat = 'dd/MM/yyyy';
          break;
        default:
          dateFormat = 'dd/MM/yyyy';
      }
    }
    return DateFormat(dateFormat, locale?.toString() ?? 'pt_BR').format(date);
  }

  static String formatDateTime(DateTime date, [Locale? locale]) {
    String dateTimeFormat;
    if (locale == null) {
      dateTimeFormat = 'dd/MM/yyyy HH:mm';
    } else {
      switch ('${locale.languageCode}_${locale.countryCode ?? ''}') {
        case 'pt_BR':
          dateTimeFormat = 'dd/MM/yyyy HH:mm';
          break;
        case 'es_ES':
        case 'es_MX':
          dateTimeFormat = 'dd/MM/yyyy HH:mm';
          break;
        case 'en_US':
          dateTimeFormat = 'MM/dd/yyyy hh:mm a';
          break;
        case 'en_GB':
          dateTimeFormat = 'dd/MM/yyyy HH:mm';
          break;
        default:
          dateTimeFormat = 'dd/MM/yyyy HH:mm';
      }
    }
    return DateFormat(dateTimeFormat, locale?.toString() ?? 'pt_BR').format(date);
  }

  // Helper method to get locale from context
  static Locale? getLocaleFromContext(BuildContext context) {
    return Localizations.localeOf(context);
  }
}







