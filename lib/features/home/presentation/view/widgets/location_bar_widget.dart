import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import '../select_location_view.dart';

/// Ana Sayfa Üst Konum Seçim Çubuğu
class LocationBarWidget extends StatefulWidget {
  final String initialLocation;
  final VoidCallback? onTap;

  const LocationBarWidget({
    super.key,
    this.initialLocation = 'Meram, Konya',
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
        onTap: widget.onTap ?? () => _openSelectLocationView(context),
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

  void _openSelectLocationView(BuildContext context) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectLocationView(
          initialLocation: _currentLocation,
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _currentLocation = result;
      });
    }
  }
}

