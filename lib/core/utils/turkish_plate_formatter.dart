import 'package:flutter/services.dart';

/// Türkiye Plaka Formatlayıcı (34abc123 -> 34 ABC 123)
class TurkishPlateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // 1. Türkçe karakterleri İngilizce eşdeğerine çevir ve büyük harf yap
    String raw = newValue.text
        .toUpperCase()
        .replaceAll('Ğ', 'G')
        .replaceAll('Ü', 'U')
        .replaceAll('Ş', 'S')
        .replaceAll('İ', 'I')
        .replaceAll('Ö', 'O')
        .replaceAll('Ç', 'C')
        .replaceAll(RegExp(r'[^A-Z0-9]'), ''); // Sadece harf ve rakamları tut

    if (raw.isEmpty) {
      return const TextEditingValue();
    }

    // 2. Maksimum plaka ham uzunluğu 8 karakterdir (örn: 34ABC1234)
    if (raw.length > 8) {
      raw = raw.substring(0, 8);
    }

    final formatted = _formatPlate(raw);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String _formatPlate(String raw) {
    final buffer = StringBuffer();

    // 1. Kısım: İl Kodu (İlk 2 rakam)
    int i = 0;
    while (i < raw.length && i < 2 && RegExp(r'\d').hasMatch(raw[i])) {
      buffer.write(raw[i]);
      i++;
    }

    if (i >= raw.length) return buffer.toString();

    // Eğer il kodundan sonra harfler başlıyorsa boşluk ekle
    if (buffer.length == 2 && RegExp(r'[A-Z]').hasMatch(raw[i])) {
      buffer.write(' ');
    }

    // 2. Kısım: Harf Grubu (1 - 3 Harf)
    int letterCount = 0;
    while (i < raw.length && letterCount < 3 && RegExp(r'[A-Z]').hasMatch(raw[i])) {
      buffer.write(raw[i]);
      i++;
      letterCount++;
    }

    if (i >= raw.length) return buffer.toString();

    // Eğer harflerden sonra rakamlar başlıyorsa boşluk ekle
    if (letterCount > 0 && RegExp(r'\d').hasMatch(raw[i])) {
      buffer.write(' ');
    }

    // 3. Kısım: Son Rakam Grubu (2 - 4 Rakam)
    int digitCount = 0;
    while (i < raw.length && digitCount < 4 && RegExp(r'\d').hasMatch(raw[i])) {
      buffer.write(raw[i]);
      i++;
      digitCount++;
    }

    return buffer.toString();
  }

  /// Geçerli bir Türk plakası mı kontrol eder
  static bool isValidTurkishPlate(String plate) {
    final clean = plate.trim().toUpperCase();
    // Regex: 01-81 il kodu, 1-3 harf, 2-4 rakam
    final regex = RegExp(r'^(0[1-9]|[1-7][0-9]|8[01])\s[A-Z]{1,3}\s\d{2,4}$');
    return regex.hasMatch(clean);
  }
}
