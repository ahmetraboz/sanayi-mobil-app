import 'package:flutter/material.dart';

/// Ana Sayfa Hizmet Kategori Modeli
class ServiceCategoryModel {
  final String id;
  final String title;
  final String description;
  final IconData? iconData;
  final String imageUrl;
  final String? badge;
  final bool isPopular;

  const ServiceCategoryModel({
    required this.id,
    required this.title,
    required this.description,
    this.iconData,
    required this.imageUrl,
    this.badge,
    this.isPopular = false,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      badge: json['badge'] as String?,
      isPopular: json['isPopular'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'badge': badge,
      'isPopular': isPopular,
    };
  }
}
