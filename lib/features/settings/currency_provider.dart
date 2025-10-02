import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _currencyKey = 'currencyCode';

// Supported currencies
const List<String> supportedCurrencies = ['KRW', 'USD', 'VND'];

final currencyProvider = StateNotifierProvider<CurrencyNotifier, String>((ref) {
  return CurrencyNotifier();
});

class CurrencyNotifier extends StateNotifier<String> {
  CurrencyNotifier() : super('KRW') { // Default to KRW
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_currencyKey) ?? 'KRW';
  }

  Future<void> changeCurrency(String newCurrencyCode) async {
    if (!supportedCurrencies.contains(newCurrencyCode) || state == newCurrencyCode) return;

    state = newCurrencyCode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currencyKey, newCurrencyCode);
    } catch (e) {
      debugPrint("Failed to save currency: $e");
    }
  }
}
