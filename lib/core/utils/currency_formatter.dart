import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:so_vuon/features/settings/currency_provider.dart';

final currencyFormatterProvider = Provider<NumberFormat>((ref) {
  final currencyCode = ref.watch(currencyProvider);

  // Determine the locale based on the currency code for proper formatting
  String locale;
  switch (currencyCode) {
    case 'VND':
      locale = 'vi_VN';
      break;
    case 'USD':
      locale = 'en_US';
      break;
    case 'KRW':
    default:
      locale = 'ko_KR';
      break;
  }

  return NumberFormat.currency(locale: locale, symbol: currencyCode, decimalDigits: 0);
});
