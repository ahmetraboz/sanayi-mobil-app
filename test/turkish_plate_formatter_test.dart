import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanayi_mobil_app/core/utils/turkish_plate_formatter.dart';

void main() {
  group('TurkishPlateInputFormatter Tests', () {
    final formatter = TurkishPlateInputFormatter();

    test('Standard plates formatting', () {
      final res = formatter.formatEditUpdate(
        const TextEditingValue(),
        const TextEditingValue(text: '34SAN2026'),
      );
      expect(res.text, '34 SAN 2026');
    });

    test('Entering multiple numbers in beginning drops excess numbers and captures letters', () {
      // User typed 123456 then SAN 2026 -> First 2 digits taken as city, excess numbers dropped, letters properly captured!
      final res = formatter.formatEditUpdate(
        const TextEditingValue(),
        const TextEditingValue(text: '349999SAN2026'),
      );
      expect(res.text, '34 SAN 2026');
    });

    test('Special Custom Plates (Long names)', () {
      final res = formatter.formatEditUpdate(
        const TextEditingValue(),
        const TextEditingValue(text: '34AHMET01'),
      );
      expect(res.text, '34 AHMET 01');
    });

    test('Only 2 digits at start', () {
      final res = formatter.formatEditUpdate(
        const TextEditingValue(),
        const TextEditingValue(text: '345678'),
      );
      expect(res.text, '34');
    });
  });
}
