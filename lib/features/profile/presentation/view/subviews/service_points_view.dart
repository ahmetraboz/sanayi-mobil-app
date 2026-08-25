import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';

/// Hizmet Noktalarım (Anlaşmalı Yetkili Servisler Listesi)
class ServicePointsView extends StatelessWidget {
  const ServicePointsView({super.key});

  final List<Map<String, dynamic>> _points = const [
    {
      'name': 'SanayiGO Yetkili Maslak Servisi',
      'address': 'Atatürk Oto Sanayi Sitesi 2. Kısım No: 45, Sarıyer / İstanbul',
      'phone': '0212 285 00 11',
      'hours': '08:30 - 18:30',
      'rating': 4.9,
    },
    {
      'name': 'Master Auto Detailing & Bakım',
      'address': 'Büyükdere Cad. Oto Sanayi Girişi No: 12, Kağıthane / İstanbul',
      'phone': '0212 324 10 20',
      'hours': '09:00 - 19:00',
      'rating': 4.8,
    },
    {
      'name': 'Kartal Pro Garaj & Lastik Noktası',
      'address': 'Kartal Oto Sanayi Sitesi A Blok No: 18, Kartal / İstanbul',
      'phone': '0216 450 55 66',
      'hours': '08:30 - 18:00',
      'rating': 4.7,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Hizmet Noktalarım',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF1F5F9), height: 1),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.p20),
        itemCount: _points.length,
        itemBuilder: (context, index) {
          final p = _points[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(AppDimensions.p16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.r20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: AppDimensions.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        p['name'] as String,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                        const SizedBox(width: 3),
                        Text(
                          '${p['rating']}',
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(LucideIcons.mapPin, size: 14, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        p['address'] as String,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(LucideIcons.phone, size: 14, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 6),
                    Text(
                      p['phone'] as String,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    const Icon(LucideIcons.clock, size: 14, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(
                      p['hours'] as String,
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
