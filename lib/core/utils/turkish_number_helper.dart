/// Sayıları Türkçe metne çeviren yardımcı sınıf (Örn: 145000 -> Yüz Kırk Beş Bin)
class TurkishNumberHelper {
  TurkishNumberHelper._();

  static const List<String> _birler = ['', 'Bir', 'İki', 'Üç', 'Dört', 'Beş', 'Altı', 'Yedi', 'Sekiz', 'Dokuz'];
  static const List<String> _onlar = ['', 'On', 'Yirmi', 'Otuz', 'Kırk', 'Elli', 'Altmış', 'Yetmiş', 'Seksen', 'Doksan'];

  static String toTurkishWords(int number) {
    if (number == 0) return 'Sıfır';
    if (number < 0) return 'Eksi ${toTurkishWords(-number)}';

    String result = '';

    // Milyonlar
    if (number >= 1000000) {
      final milyon = number ~/ 1000000;
      if (milyon == 1) {
        result += 'Bir Milyon ';
      } else {
        result += '${_convertThreeDigits(milyon)} Milyon ';
      }
      number %= 1000000;
    }

    // Binler
    if (number >= 1000) {
      final bin = number ~/ 1000;
      if (bin == 1) {
        result += 'Bin ';
      } else {
        result += '${_convertThreeDigits(bin)} Bin ';
      }
      number %= 1000;
    }

    // Yüzler ve altı
    if (number > 0) {
      result += _convertThreeDigits(number);
    }

    return result.trim();
  }

  static String _convertThreeDigits(int number) {
    String str = '';
    final yuzler = number ~/ 100;
    final onlar = (number % 100) ~/ 10;
    final birler = number % 10;

    if (yuzler > 0) {
      if (yuzler == 1) {
        str += 'Yüz ';
      } else {
        str += '${_birler[yuzler]} Yüz ';
      }
    }

    if (onlar > 0) {
      str += '${_onlar[onlar]} ';
    }

    if (birler > 0) {
      str += '${_birler[birler]} ';
    }

    return str.trim();
  }
}
