import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';

/// Kayıtlı Adreslerim Ekranı
class UserAddressesView extends StatefulWidget {
  const UserAddressesView({super.key});

  @override
  State<UserAddressesView> createState() => _UserAddressesViewState();
}

class _UserAddressesViewState extends State<UserAddressesView> {
  final List<Map<String, String>> _addresses = [
    {
      'title': 'Ev Adresim',
      'address': 'Barbaros Mah. Ihlamur Sok. No: 14 D: 6, Ataşehir / İstanbul',
      'type': 'home',
    },
    {
      'title': 'İş Yeri / Ofis',
      'address': 'Büyükdere Cad. No: 122 K: 5, Levent / İstanbul',
      'type': 'work',
    },
  ];

  void _addNewAddress() {
    final titleController = TextEditingController();
    final addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Yeni Adres Ekle', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Adres Başlığı (Örn: Yazlık, Garaj)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Açık Adres', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () {
                  if (titleController.text.isNotEmpty && addressController.text.isNotEmpty) {
                    setState(() {
                      _addresses.add({
                        'title': titleController.text.trim(),
                        'address': addressController.text.trim(),
                        'type': 'other',
                      });
                    });
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Adresi Kaydet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        title: const Text('Adreslerim', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF1F5F9), height: 1),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.p20),
        itemCount: _addresses.length,
        itemBuilder: (context, index) {
          final a = _addresses[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(AppDimensions.p16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.r16),
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
                  child: Icon(
                    a['type'] == 'home'
                        ? LucideIcons.home
                        : a['type'] == 'work'
                            ? LucideIcons.briefcase
                            : LucideIcons.mapPin,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a['title']!, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      const SizedBox(height: 3),
                      Text(a['address']!, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.3)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 18, color: Color(0xFF94A3B8)),
                  onPressed: () {
                    setState(() => _addresses.removeAt(index));
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
            onPressed: _addNewAddress,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Yeni Adres Ekle', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
