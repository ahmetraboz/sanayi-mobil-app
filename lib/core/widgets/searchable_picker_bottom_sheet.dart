import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';

/// Arama Çubuklu Modern Seçim Modalı (Searchable Bottom Sheet)
class SearchablePickerBottomSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? selectedItem;
  final String searchHint;
  final bool showSearch;

  const SearchablePickerBottomSheet({
    super.key,
    required this.title,
    required this.items,
    this.selectedItem,
    this.searchHint = 'Ara...',
    this.showSearch = true,
  });

  static Future<String?> show({
    required BuildContext context,
    required String title,
    required List<String> items,
    String? selectedItem,
    String searchHint = 'Ara...',
    bool showSearch = true,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchablePickerBottomSheet(
        title: title,
        items: items,
        selectedItem: selectedItem,
        searchHint: searchHint,
        showSearch: showSearch,
      ),
    );
  }

  @override
  State<SearchablePickerBottomSheet> createState() => _SearchablePickerBottomSheetState();
}

class _SearchablePickerBottomSheetState extends State<SearchablePickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.items);
      } else {
        _filteredItems = widget.items.where((item) => item.toLowerCase().contains(query)).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final screenHeight = mediaQuery.size.height;

    return Container(
      height: screenHeight * 0.75,
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Sürükleme Çubuğu
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Başlık ve Kapatma Butonu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Arama Çubuğu
          if (widget.showSearch && widget.items.length > 5) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(AppDimensions.r12),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 13.5),
                    prefixIcon: const Icon(LucideIcons.search, color: AppColors.textSecondary, size: 18),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: AppColors.textSecondary),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
            ),
          ],

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Liste Elemanları
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.searchX, size: 36, color: AppColors.textTertiary),
                        SizedBox(height: 10),
                        Text(
                          'Sonuç bulunamadı',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredItems.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                      color: Color(0xFFF8FAFC),
                    ),
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected = item == widget.selectedItem;

                      return InkWell(
                        onTap: () => Navigator.pop(context, item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Dokunulduğunda Bottom Sheet Açan Şık Seçim Kutucuğu
class AppPickerField extends StatelessWidget {
  final String label;
  final String? value;
  final String hintText;
  final IconData? prefixIcon;
  final VoidCallback onTap;

  const AppPickerField({
    super.key,
    required this.label,
    this.value,
    required this.hintText,
    this.prefixIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.r12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.r12),
              border: Border.all(
                color: hasValue ? AppColors.primary.withValues(alpha: 0.5) : AppColors.divider.withValues(alpha: 0.8),
                width: hasValue ? 1.2 : 1.0,
              ),
              boxShadow: AppDimensions.cardShadow,
            ),
            child: Row(
              children: [
                if (prefixIcon != null) ...[
                  Icon(
                    prefixIcon,
                    size: 20,
                    color: hasValue ? AppColors.primary : AppColors.textTertiary,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    hasValue ? value! : hintText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: hasValue ? FontWeight.w700 : FontWeight.w400,
                      color: hasValue ? AppColors.textPrimary : AppColors.textTertiary,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
