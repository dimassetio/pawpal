import 'package:intl/intl.dart';

String dateTimeFormatter(DateTime? date,
    {bool useSeparator = false, String? def}) {
  if (date is DateTime) {
    if (useSeparator) {
      return DateFormat('d MMM y | H.m').format(date);
    }
    return DateFormat('d MMM y H.m').format(date);
    // return "${DateFormat.yMMMMd('id').format(date)} ${DateFormat.Hm('id').format(date)}";
  } else
    return def ?? '';
}

String dateFormatter(DateTime? date) {
  if (date is DateTime) {
    return DateFormat('d MMM y').format(date);
  } else
    return '';
}

String getTimeCategory() {
  int hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) {
    return 'Morning'; // Pagi
  } else if (hour >= 12 && hour < 17) {
    return 'Afternoon'; // Siang
  } else if (hour >= 17 && hour < 20) {
    return 'Evening'; // Sore
  } else {
    return 'Night'; // Malam
  }
}

String currencyFormatter(int? amount, {String? locale, String? symbol}) {
  final format =
      NumberFormat.currency(locale: locale ?? 'id_ID', symbol: symbol ?? 'Rp');
  return format.format(amount ?? 0);
}
