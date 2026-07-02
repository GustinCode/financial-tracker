import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String monthKeyFromDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$year-$month';
}

DateTime monthStart(DateTime date) => DateTime(date.year, date.month);

bool isSameMonth(DateTime a, DateTime b) => a.year == b.year && a.month == b.month;

String formatMonthLabel(DateTime date, Locale? locale) {
  return DateFormat('MMMM yyyy', locale?.toString() ?? 'en_US').format(date);
}