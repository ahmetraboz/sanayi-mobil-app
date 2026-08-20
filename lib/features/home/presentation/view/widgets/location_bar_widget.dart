import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';

/// Ana Sayfa Üst Konum Seçim Çubuğu
class LocationBarWidget extends StatefulWidget {
  final String initialLocation;
  final VoidCallback? onTap;

  const LocationBarWidget({
    super.key,
    this.initialLocation = 'Maslak Mah. Atatürk Oto Sanayi, İstanbul',
    this.onTap,
  });

  @override
  State<LocationBarWidget> createState() => _LocationBarWidgetState();
}

class _LocationBarWidgetState extends State<LocationBarWidget> {
  late String _currentLocation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p20),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap ?? () => _showLocationPicker(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _isPressed ? const Color(0xFFF1F5F9) : Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.r16),
            border: Border.all(
              color: AppColors.divider.withValues(alpha: 0.8),
              width: 1,
            ),
            boxShadow: AppDimensions.cardShadow,
          ),
          child: Row(
            children: [
              // Konum İkon Rozeti
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.r12),
                ),
                child: const Icon(
                  LucideIcons.mapPin,
                  size: 17,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),

              // Konum Başlık & Adres
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'HİZMET BÖLGESİ',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary.withValues(alpha: 0.9),
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _currentLocation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Aşağı Ok
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Hizmet / Teslimat Konumu Seçin',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Size en yakın anlaşmalı usta, servis ve yol yardımı noktalarını listelemek için konum belirleyin.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),

                // Mevcut GPS Konumu
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(LucideIcons.navigation, color: AppColors.primary, size: 20),
                  ),
                  title: const Text(
                    'Mevcut GPS Konumumu Kullan',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Anlık konum tespiti', style: TextStyle(fontSize: 12)),
                  onTap: () {
                    setState(() {
                      _currentLocation = 'Kadıköy / İstanbul (Mevcut Konum)';
                    });
                    Navigator.pop(context);
                  },
                ),

                const Divider(height: 16),

                // Kayıtlı Sanayi Noktası
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(LucideIcons.mapPin, color: AppColors.textPrimary, size: 20),
                  ),
                  title: const Text(
                    'Maslak Atatürk Oto Sanayi Sitesi',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Sarıyer / İstanbul', style: TextStyle(fontSize: 12)),
                  onTap: () {
                    setState(() {
                      _currentLocation = 'Maslak Mah. Atatürk Oto Sanayi, İstanbul';
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
