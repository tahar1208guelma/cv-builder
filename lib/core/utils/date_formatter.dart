import 'package:intl/intl.dart';

class DateFormatter {
  static String formatMonthYear(DateTime? date, {String lang = 'en'}) {
    if (date == null) return '';
    try {
      final formatter = DateFormat('MMM yyyy', lang);
      return formatter.format(date);
    } catch (_) {
      return '${date.month}/${date.year}';
    }
  }

  static String formatRange(String start, String end, bool isCurrent, {String lang = 'en', String presentText = 'Present'}) {
    if (start.isEmpty) return '';
    if (isCurrent) {
      return '$start - $presentText';
    }
    if (end.isEmpty) return start;
    return '$start - $end';
  }
}
