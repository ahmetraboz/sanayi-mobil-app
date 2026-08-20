import 'package:flutter/material.dart';

/// Sanayi Mobil Uygulaması için Merkezi Renk Paleti (Turkuaz Odaklı)
class AppColors {
  AppColors._();

  // Ana Marka Renkleri (Turkuaz / Cyan Paleti)
  static const Color primary = Color(0xFF00A8B5); // Canlı Turkuaz
  static const Color primaryLight = Color(0xFF48CAE4); // Açık Turkuaz
  static const Color primaryDark = Color(0xFF00778A); // Koyu Turkuaz
  static const Color primaryContainer = Color(0xFFE0F7FA); // Çok açık turkuaz arkaplan

  // Vurgu & İkincil Renkler
  static const Color secondary = Color(0xFF0284C7); // Okyanus Mavisi
  static const Color secondaryLight = Color(0xFFBAE6FD);
  static const Color accent = Color(0xFF06B6D4); // Neon Cyan

  // Nötr Renkler & Yüzeyler
  static const Color background = Color(0xFFF8FAFC); // Modern Slate 50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);

  // Metin Renkleri
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textTertiary = Color(0xFF94A3B8); // Slate 400
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Durum Renkleri
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradient Tanımlamaları
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00C6FF),
      Color(0xFF0072FF),
    ],
  );

  static const LinearGradient turquoiseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00C9FF),
      Color(0xFF0096C7),
    ],
  );

  static const LinearGradient bannerOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0xCC051923),
    ],
  );
}
