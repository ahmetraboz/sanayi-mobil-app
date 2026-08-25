import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';

/// Canlı Destek & İletişim Ekranı
class SupportCenterView extends StatelessWidget {
  const SupportCenterView({super.key});

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
        title: const Text('Destek ve İletişim', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF1F5F9), height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.p20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.r20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: AppDimensions.cardShadow,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.headphones, color: AppColors.primary, size: 32),
                  ),
                  const SizedBox(height: 12),
                  const Text('Size Nasıl Yardımcı Olabiliriz?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('7/24 SanayiGO destek uzmanlarımız hizmetinizde.', style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
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
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(LucideIcons.messageCircle, color: Color(0xFF22C55E)),
                    title: const Text('WhatsApp Destek Hattı', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    subtitle: const Text('Anında canlı yanıt alın', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('WhatsApp destek hattı başlatılıyor...'), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56, color: Color(0xFFF1F5F9)),
                  ListTile(
                    leading: const Icon(LucideIcons.phoneCall, color: AppColors.primary),
                    title: const Text('Çağrı Merkezi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    subtitle: const Text('0850 308 00 00', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('0850 308 00 00 aranıyor...'), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56, color: Color(0xFFF1F5F9)),
                  ListTile(
                    leading: const Icon(LucideIcons.mail, color: Color(0xFF6366F1)),
                    title: const Text('E-Posta ile Ulaşın', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    subtitle: const Text('destek@sanayigo.com', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('E-posta uygulaması açılıyor...'), behavior: SnackBarBehavior.floating),
                      );
                    },
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
