import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';

/// Kredi Kartlarım Ekranı
class UserCardsView extends StatefulWidget {
  const UserCardsView({super.key});

  @override
  State<UserCardsView> createState() => _UserCardsViewState();
}

class _UserCardsViewState extends State<UserCardsView> {
  final List<Map<String, String>> _cards = [
    {
      'bank': 'Garanti BBVA Bonus',
      'number': '•••• •••• •••• 4028',
      'expiry': '08/28',
      'brand': 'Mastercard',
    },
    {
      'bank': 'Yapı Kredi World',
      'number': '•••• •••• •••• 9152',
      'expiry': '11/27',
      'brand': 'Visa',
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
        title: const Text('Kredi Kartlarım', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF1F5F9), height: 1),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.p20),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final c = _cards[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(AppDimensions.p16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.r20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: AppDimensions.cardShadow,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.creditCard, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c['bank']!, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      const SizedBox(height: 3),
                      Text('${c['number']!} • ${c['expiry']!}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 18, color: Color(0xFF94A3B8)),
                  onPressed: () {
                    setState(() => _cards.removeAt(index));
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFE2E8F0)))),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r16)),
              elevation: 0,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kart ekleme alanı randevu ödeme adımında mevcuttur.'), behavior: SnackBarBehavior.floating),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Yeni Kart Ekle', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
