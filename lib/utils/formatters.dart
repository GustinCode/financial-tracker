import 'package:intl/intl.dart';
import 'constants.dart';

class Formatters {
  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      symbol: AppConstants.currencySymbol,
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat(AppConstants.dateTimeFormat).format(date);
  }
}




