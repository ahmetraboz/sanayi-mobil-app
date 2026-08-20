import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/core/utils/thousand_input_formatter.dart';
import 'package:sanayi_mobil_app/core/utils/turkish_number_helper.dart';
import 'package:sanayi_mobil_app/core/utils/turkish_plate_formatter.dart';
import 'package:sanayi_mobil_app/core/widgets/searchable_picker_bottom_sheet.dart';
import '../cubit/garage_cubit.dart';
import '../cubit/garage_state.dart';

/// Araç Ekleme Ekranı (Otomatik Plaka & Kilometre Formatlamalı)
class AddVehicleView extends StatefulWidget {
  const AddVehicleView({super.key});

  @override
  State<AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<AddVehicleView> {
  final _formKey = GlobalKey<FormState>();

  String _selectedType = 'car'; // 'car', 'motorcycle', 'commercial'
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _variantController = TextEditingController();

  int _currentMileageNumber = 0;

  String? _selectedBrand;
  String? _selectedYear;
  String? _selectedModel;

  final List<String> _brands = [
    'Alfa Romeo',
    'Audi',
    'BMW',
    'Chery',
    'Citroën',
    'Cupra',
    'Dacia',
    'Fiat',
    'Ford',
    'Honda',
    'Hyundai',
    'Jeep',
    'Kia',
    'Land Rover',
    'Mercedes-Benz',
    'MG',
    'Mini',
    'Nissan',
    'Opel',
    'Peugeot',
    'Porsche',
    'Renault',
    'Seat',
    'Skoda',
    'Suzuki',
    'Tesla',
    'Togg',
    'Toyota',
    'Volkswagen',
    'Volvo',
  ];

  final Map<String, List<String>> _modelsByBrand = {
    'Volkswagen': ['Golf', 'Passat', 'Polo', 'Tiguan', 'T-Roc', 'Taigo', 'Caddy', 'Arteon', 'Touareg', 'ID.4'],
    'Renault': ['Clio', 'Megane', 'Captur', 'Austral', 'Symbol', 'Trafic', 'Kadjar', 'Talisman', 'Duster'],
    'Fiat': ['Egea Sedan', 'Egea Cross', 'Egea Hatchback', 'Fiorino', 'Doblo', 'Panda', '500', '500X', 'Ducato'],
    'Ford': ['Focus', 'Fiesta', 'Puma', 'Kuga', 'Tourneo Courier', 'Transit', 'Mondeo', 'EcoSport', 'Ranger'],
    'Toyota': ['Corolla', 'Yaris', 'C-HR', 'RAV4', 'Hilux', 'Auris', 'Corolla Cross', 'Land Cruiser'],
    'BMW': ['1 Serisi', '2 Serisi Gran Coupe', '3 Serisi', '4 Serisi Gran Coupe', '5 Serisi', '7 Serisi', 'X1', 'X3', 'X5', 'i4'],
    'Mercedes-Benz': ['A-Serisi', 'C-Serisi', 'E-Serisi', 'S-Serisi', 'CLA', 'GLA', 'GLB', 'GLC', 'GLE', 'EQB'],
    'Audi': ['A3 Sedan', 'A3 Sportback', 'A4 Sedan', 'A5 Sportback', 'A6 Sedan', 'Q2', 'Q3', 'Q5', 'Q7', 'e-tron'],
    'Hyundai': ['i20', 'i10', 'Elantra', 'Tucson', 'Bayon', 'Kona', 'Santa Fe', 'Ioniq 5', 'Staria'],
    'Honda': ['Civic Sedan', 'City', 'HR-V', 'CR-V', 'Jazz', 'ZR-V', 'Accord'],
    'Peugeot': ['208', '308', '408', '2008', '3008', '5008', 'Rifter', 'Partner'],
    'Opel': ['Corsa', 'Astra', 'Mokka', 'Grandland', 'Crossland', 'Insignia', 'Combo'],
    'Skoda': ['Octavia', 'Superb', 'Fabia', 'Kamiq', 'Karoq', 'Kodiaq', 'Scala'],
    'Togg': ['T10X V1', 'T10X V2'],
    'Cupra': ['Formentor', 'Leon', 'Ateca', 'Born'],
    'Volvo': ['XC40', 'XC60', 'XC90', 'S60', 'S90', 'V40', 'EX30'],
  };

  final List<String> _years = List.generate(27, (index) => (2026 - index).toString());

  @override
  void initState() {
    super.initState();
    _mileageController.addListener(() {
      final parsed = ThousandsSeparatorInputFormatter.parseToInt(_mileageController.text);
      if (parsed != _currentMileageNumber) {
        setState(() {
          _currentMileageNumber = parsed;
        });
      }
    });
  }

  @override
  void dispose() {
    _plateController.dispose();
    _mileageController.dispose();
    _variantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Araç Ekle',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocConsumer<GarageCubit, GarageState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.p20,
                vertical: AppDimensions.p12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Araç Tipi Seçimi
                  const Text(
                    'Araç tipi seçin',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _TypeSelectionCard(
                          icon: LucideIcons.car,
                          label: 'Otomobil',
                          isSelected: _selectedType == 'car',
                          onTap: () => setState(() => _selectedType = 'car'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TypeSelectionCard(
                          icon: LucideIcons.bike,
                          label: 'Motosiklet',
                          isSelected: _selectedType == 'motorcycle',
                          onTap: () => setState(() => _selectedType = 'motorcycle'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TypeSelectionCard(
                          icon: LucideIcons.truck,
                          label: 'H. Ticari',
                          isSelected: _selectedType == 'commercial',
                          onTap: () => setState(() => _selectedType = 'commercial'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 2. Plaka Alanı (Otomatik Akıllı Boşluk ve Büyük Harf Formatlama)
                  _buildInputLabel('Plaka'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _plateController,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      TurkishPlateInputFormatter(),
                    ],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: AppColors.textPrimary,
                    ),
                    decoration: _inputDecoration(
                      hintText: '34 SAN 2026',
                      prefixIcon: Icons.featured_play_list_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Lütfen aracınızın plakasını girin';
                      }
                      if (value.trim().length < 6) {
                        return 'Lütfen geçerli bir plaka formatı girin (örn: 34 ABC 123)';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // 3. Kilometre Alanı (Otomatik Binlik Nokta Ayracı + Canlı Okunuş)
                  _buildInputLabel('Kilometre'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mileageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      ThousandsSeparatorInputFormatter(),
                    ],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.textPrimary,
                    ),
                    decoration: _inputDecoration(
                      hintText: 'Örn: 45.000',
                      prefixIcon: Icons.speed_outlined,
                      suffixText: 'KM',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Lütfen güncel kilometreyi girin';
                      }
                      return null;
                    },
                  ),

                  // Canlı Okunuş & Doğrulama Rozeti
                  if (_currentMileageNumber > 0) ...[
                    const SizedBox(height: 8),
                    _buildMileageHelperBadge(_currentMileageNumber),
                  ],

                  const SizedBox(height: 16),

                  // 4. Marka Seçimi (Searchable Bottom Sheet)
                  AppPickerField(
                    label: 'Marka',
                    value: _selectedBrand,
                    hintText: 'Marka seçiniz',
                    prefixIcon: LucideIcons.car,
                    onTap: () async {
                      final selected = await SearchablePickerBottomSheet.show(
                        context: context,
                        title: 'Marka Seçiniz',
                        items: _brands,
                        selectedItem: _selectedBrand,
                        searchHint: 'Marka ara (örn: Volkswagen, BMW)...',
                      );

                      if (selected != null) {
                        setState(() {
                          _selectedBrand = selected;
                          _selectedModel = null; // Marka değişince model sıfırlanır
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // 5. Yıl Seçimi (Searchable Bottom Sheet)
                  AppPickerField(
                    label: 'Yıl',
                    value: _selectedYear,
                    hintText: 'Yıl seçiniz',
                    prefixIcon: LucideIcons.calendar,
                    onTap: () async {
                      final selected = await SearchablePickerBottomSheet.show(
                        context: context,
                        title: 'Model Yılı Seçiniz',
                        items: _years,
                        selectedItem: _selectedYear,
                        searchHint: 'Yıl ara (örn: 2023)...',
                      );

                      if (selected != null) {
                        setState(() {
                          _selectedYear = selected;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // 6. Model Seçimi (Searchable Bottom Sheet - Markaya Göre Filtreli)
                  AppPickerField(
                    label: 'Model',
                    value: _selectedModel,
                    hintText: _selectedBrand == null ? 'Önce marka seçiniz' : 'Model seçiniz',
                    prefixIcon: LucideIcons.tag,
                    onTap: () async {
                      if (_selectedBrand == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lütfen önce bir marka seçin.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      final availableModels = _modelsByBrand[_selectedBrand] ?? ['Standart Model'];

                      final selected = await SearchablePickerBottomSheet.show(
                        context: context,
                        title: '$_selectedBrand Modeli Seçiniz',
                        items: availableModels,
                        selectedItem: _selectedModel,
                        searchHint: 'Model ara (örn: Golf, Passat)...',
                      );

                      if (selected != null) {
                        setState(() {
                          _selectedModel = selected;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // 7. Araç Model Tipi / Paket
                  _buildInputLabel('Araç model tipi (Paket/Motor)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _variantController,
                    decoration: _inputDecoration(
                      hintText: 'Örn: 1.5 eTSI R-Line, 1.6 TDI',
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 8. Kaydet Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedBrand == null || _selectedYear == null || _selectedModel == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Lütfen Marka, Yıl ve Model seçimlerini tamamlayın.'),
                                      backgroundColor: AppColors.error,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }

                                final navigator = Navigator.of(context);
                                final mileage = ThousandsSeparatorInputFormatter.parseToInt(_mileageController.text);
                                final success = await context.read<GarageCubit>().addNewVehicle(
                                      plate: _plateController.text,
                                      brand: _selectedBrand!,
                                      model: _selectedModel!,
                                      year: _selectedYear!,
                                      variant: _variantController.text,
                                      vehicleType: _selectedType,
                                      mileage: mileage,
                                    );

                                if (success) {
                                  navigator.pop();
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.r16),
                        ),
                      ),
                      child: state.isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Text(
                              'Kaydet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMileageHelperBadge(int km) {
    final words = TurkishNumberHelper.toTurkishWords(km);
    final isVeryHigh = km > 450000;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isVeryHigh ? const Color(0xFFFEF3C7) : AppColors.primaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppDimensions.r12),
        border: Border.all(
          color: isVeryHigh ? const Color(0xFFF59E0B) : AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isVeryHigh ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
            size: 16,
            color: isVeryHigh ? const Color(0xFFD97706) : AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isVeryHigh ? '$words KM (Çok yüksek kilometre)' : '$words KM',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isVeryHigh ? const Color(0xFF92400E) : AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    IconData? prefixIcon,
    String? suffixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 14),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textTertiary, size: 20) : null,
      suffixText: suffixText,
      suffixStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.r12),
        borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.r12),
        borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.r12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}

class _TypeSelectionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeSelectionCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.r16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer.withValues(alpha: 0.5) : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.r16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider.withValues(alpha: 0.8),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppDimensions.cardShadow,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
