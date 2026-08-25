import 'package:flutter/material.dart';

/// Kampanya & Fırsat Banner Modeli
class CampaignBannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String? discountCode;
  final String? priceHighlight;
  final String? giftHighlight;
  final String? badgeText;
  final String imageUrl;
  final List<Color> gradientColors;

  // Detay sayfası alanları
  final String? detailTitle;
  final String? detailDescription;
  final List<String> detailSteps;
  final String ctaText;

  const CampaignBannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.discountCode,
    this.priceHighlight,
    this.giftHighlight,
    this.badgeText,
    required this.imageUrl,
    this.gradientColors = const [Color(0xFF0052D4), Color(0xFF4364F7), Color(0xFF6FB1FC)],
    this.detailTitle,
    this.detailDescription,
    this.detailSteps = const [],
    this.ctaText = 'Hizmet Al',
  });

  factory CampaignBannerModel.fromJson(Map<String, dynamic> json) {
    return CampaignBannerModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      discountCode: json['discountCode'] as String?,
      priceHighlight: json['priceHighlight'] as String?,
      giftHighlight: json['giftHighlight'] as String?,
      badgeText: json['badgeText'] as String?,
      imageUrl: json['imageUrl'] as String,
      detailTitle: json['detailTitle'] as String?,
      detailDescription: json['detailDescription'] as String?,
      detailSteps: (json['detailSteps'] as List<dynamic>?)?.cast<String>() ?? [],
      ctaText: json['ctaText'] as String? ?? 'Hizmet Al',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'discountCode': discountCode,
      'priceHighlight': priceHighlight,
      'giftHighlight': giftHighlight,
      'badgeText': badgeText,
      'imageUrl': imageUrl,
      'detailTitle': detailTitle,
      'detailDescription': detailDescription,
      'detailSteps': detailSteps,
      'ctaText': ctaText,
    };
  }
}
