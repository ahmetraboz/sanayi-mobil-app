import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';

/// SanayiGO Hakkında Ekranı
class AboutSanayiGoView extends StatelessWidget {
  const AboutSanayiGoView({super.key});

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
        title: const Text('SanayiGO Hakkında', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF1F5F9), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.p20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.r20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: AppDimensions.cardShadow,
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(LucideIcons.wrench, color: AppColors.primary, size: 36),
                  ),
                  const SizedBox(height: 14),
                  const Text('SanayiGO Mobil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('Sürüm 1.0.0 (1)', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  const SizedBox(height: 16),
                  const Text(
                    'SanayiGO, araç sahipleri ile Türkiye\'nin en güvenilir ve yetkili oto sanayi servislerini tek bir dijital platformda buluşturan yeni nesil mobil otomotiv ekosistemidir.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.r20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                children: [
                  ListTile(
                    title: Text('Kullanıcı Sözleşmesi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                  ),
                  Divider(height: 1, indent: 16, color: Color(0xFFF1F5F9)),
                  ListTile(
                    title: Text('KVKK Aydınlatma Metni', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                  ),
                  Divider(height: 1, indent: 16, color: Color(0xFFF1F5F9)),
                  ListTile(
                    title: Text('Gizlilik ve Çerez Politikası', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
