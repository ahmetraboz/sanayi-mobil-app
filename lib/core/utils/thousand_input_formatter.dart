import 'package:flutter/services.dart';

/// Sayıları otomatik binlik ayracıyla (145.000) formatlayan TextInputFormatter
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Sadece rakamları al
    final cleanDigits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanDigits.isEmpty) {
      return const TextEditingValue();
    }

    // Maksimum 7 hane sınırı (Örn: 9.999.999 km)
    final truncatedDigits = cleanDigits.length > 7 ? cleanDigits.substring(0, 7) : cleanDigits;

    // Binlik formatlama (145000 -> 145.000)
    final formatted = _formatWithDots(truncatedDigits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String _formatWithDots(String digits) {
    final chars = digits.split('').reversed.toList();
    final buffer = StringBuffer();

    for (int i = 0; i < chars.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(chars[i]);
    }

    return buffer.toString().split('').reversed.join('');
  }

  /// Sayıyı noktalı formata dönüştürür (145000 -> 145.000)
  static String format(int number) {
    return _formatWithDots(number.toString());
  }

  /// Sayısal değere dönüştürür (145.000 -> 145000)
  static int parseToInt(String text) {
    final clean = text.replaceAll('.', '').trim();
    return int.tryParse(clean) ?? 0;
  }
}
