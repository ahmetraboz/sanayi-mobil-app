import 'package:flutter/services.dart';

/// Türkiye Plaka Formatlayıcı
/// Kural:
/// 1. İl Kodu: Tam olarak 2 rakam (01-81). 3. bir rakam yazılmasına izin verilmez, sadece harfe geçilebilir!
/// 2. Harf Grubu: 1-5 harf (Özel plaka destekli). Harf bitince rakama geçilebilir.
/// 3. Rakam Grubu: 2-4 rakam.
class TurkishPlateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Kullanıcı geri silme (Backspace) yapıyorsa serbest bırak
    if (oldValue.text.length > newValue.text.length) {
      return newValue;
    }

    // 1. Türkçe karakterleri standartlaştır ve büyük harfe çevir
    String clean = newValue.text
        .toUpperCase()
        .replaceAll('Ğ', 'G')
        .replaceAll('Ü', 'U')
        .replaceAll('Ş', 'S')
        .replaceAll('İ', 'I')
        .replaceAll('Ö', 'O')
        .replaceAll('Ç', 'C')
        .replaceAll(RegExp(r'[^A-Z0-9]'), ''); // Sadece harf ve rakam tut

    if (clean.isEmpty) {
      return const TextEditingValue();
    }

    // 2. Akıllı Plaka Dizilimini Oluştur
    final formatted = _buildSmartPlate(clean);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Karakterleri sırasıyla Plaka Kurallarına (2 Rakam + 1-5 Harf + 2-4 Rakam) göre yerleştirir
  static String _buildSmartPlate(String raw) {
    final buffer = StringBuffer();
    int index = 0;

    // 1. AŞAMA: İlk 2 Rakam (İl Kodu)
    int cityDigits = 0;
    while (index < raw.length && cityDigits < 2) {
      final char = raw[index];
      if (RegExp(r'\d').hasMatch(char)) {
        buffer.write(char);
        cityDigits++;
      }
      index++;
    }

    if (cityDigits == 0) return '';

    // İlk 2 rakamdan sonra gelen fazlalık rakamları atla, harfe kadar ilerle
    while (index < raw.length && RegExp(r'\d').hasMatch(raw[index])) {
      index++;
    }

    if (index >= raw.length) return buffer.toString();

    // 2. AŞAMA: Harf Grubu (1 - 5 Harf)
    int letterCount = 0;
    bool spaceAdded = false;

    while (index < raw.length && letterCount < 5) {
      final char = raw[index];
      if (RegExp(r'[A-Z]').hasMatch(char)) {
        if (!spaceAdded) {
          buffer.write(' ');
          spaceAdded = true;
        }
        buffer.write(char);
        letterCount++;
        index++;
      } else {
        // Rakam gelirse harf grubu bitmiştir
        break;
      }
    }

    if (letterCount == 0 || index >= raw.length) return buffer.toString();

    // 3. AŞAMA: Son Rakam Grubu (2 - 4 Rakam)
    int trailingDigits = 0;
    bool trailingSpaceAdded = false;

    while (index < raw.length && trailingDigits < 4) {
      final char = raw[index];
      if (RegExp(r'\d').hasMatch(char)) {
        if (!trailingSpaceAdded) {
          buffer.write(' ');
          trailingSpaceAdded = true;
        }
        buffer.write(char);
        trailingDigits++;
      }
      index++;
    }

    return buffer.toString();
  }
}
