import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
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

String timeFormatter(DateTime? date) {
  if (date is DateTime) {
    return DateFormat('H.m').format(date);
  } else
    return '';
}

bool isSameDay(DateTime? date1, DateTime? date2) {
  if (date1 == null || date2 == null) {
    return false;
  }
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
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
  final format = NumberFormat.currency(
      locale: locale ?? 'id_ID', symbol: symbol ?? 'Rp', decimalDigits: 0);
  return format.format(amount ?? 0);
}

int currencyDeformatter(String value) {
  return int.parse(value.replaceAll('Rp', '').replaceAll('.', ''));
}

GeoPoint posToGeo(Position pos) {
  return GeoPoint(pos.latitude, pos.longitude);
}

Position geoToPost(GeoPoint geo) {
  return Position.fromMap({
    'latitude': geo.latitude,
    'longitude': geo.longitude,
  });
}

class CurrrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    int value = int.parse(newValue.text);

    final formatter =
        NumberFormat.simpleCurrency(locale: "ID", decimalDigits: 0);

    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}

String petGenderName(int value) {
  switch (value) {
    case 10:
      return "Male";
    case 30:
      return "Female";
    default:
      return "Unknown";
  }
}
