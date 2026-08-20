import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';

/// iPhone Tarzı Dönen Çark Yıl Seçici (Cupertino Wheel Picker)
class CupertinoYearPickerBottomSheet extends StatefulWidget {
  final List<String> years;
  final String? initialYear;

  const CupertinoYearPickerBottomSheet({
    super.key,
    required this.years,
    this.initialYear,
  });

  static Future<String?> show({
    required BuildContext context,
    required List<String> years,
    String? initialYear,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CupertinoYearPickerBottomSheet(
        years: years,
        initialYear: initialYear,
      ),
    );
  }

  @override
  State<CupertinoYearPickerBottomSheet> createState() => _CupertinoYearPickerBottomSheetState();
}

class _CupertinoYearPickerBottomSheetState extends State<CupertinoYearPickerBottomSheet> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    final defaultIndex = widget.initialYear != null ? widget.years.indexOf(widget.initialYear!) : 0;
    _selectedIndex = defaultIndex >= 0 ? defaultIndex : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Sürükleme Çubuğu
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Üst Aksiyon Başlığı (Vazgeç / Başlık / Tamam)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Vazgeç',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                const Text(
                  'Model Yılı',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, widget.years[_selectedIndex]);
                  },
                  child: const Text(
                    'Tamam',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // iPhone Çarkı (CupertinoPicker)
          Expanded(
            child: CupertinoPicker(
              itemExtent: 44.0,
              scrollController: FixedExtentScrollController(initialItem: _selectedIndex),
              useMagnifier: true,
              magnification: 1.18,
              diameterRatio: 1.2,
              selectionOverlay: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(AppDimensions.r12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.2),
                ),
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: widget.years.map((year) {
                final isSelected = widget.years.indexOf(year) == _selectedIndex;

                return Center(
                  child: Text(
                    year,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
