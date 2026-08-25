import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/core/utils/thousand_input_formatter.dart';
import 'package:sanayi_mobil_app/core/utils/turkish_number_helper.dart';
import 'package:sanayi_mobil_app/core/utils/turkish_plate_formatter.dart';
import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_model.dart';
import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_service_record_model.dart';
import 'widgets/vehicle_damage_diagram_sheet.dart';
import '../cubit/garage_cubit.dart';
import '../cubit/garage_state.dart';

/// Araç Detay Ekranı (2 Eşit Segmentli Temiz UI Mimarisi)
class VehicleDetailView extends StatefulWidget {
  final String vehicleId;

  const VehicleDetailView({super.key, required this.vehicleId});

  @override
  State<VehicleDetailView> createState() => _VehicleDetailViewState();
}

class _VehicleDetailViewState extends State<VehicleDetailView> {
  int _selectedTab = 0; // 0: Araç Bilgileri, 1: Hizmet Geçmişi

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GarageCubit, GarageState>(
      builder: (context, state) {
        final vehicle = state.vehicles.firstWhere(
          (v) => v.id == widget.vehicleId,
          orElse: () => VehicleModel(
            id: widget.vehicleId,
            plate: '34 SAN 2026',
            brand: 'Araç',
            model: '',
            year: '',
            mileage: 0,
          ),
        );

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
              'Araç Detay',
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
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. ÜST KİMLİK & TAMAMLAMA HALKASI ─────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Row(
                    children: [
                      // Logo & İlerleme Halkası
                      _VehicleAvatarWithRing(
                        completionRatio: vehicle.completionRatio,
                        vehicleType: vehicle.vehicleType,
                        brand: vehicle.brand,
                      ),

                      const SizedBox(width: 16),

                      // Araç Adı, Donanım & Plaka
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${vehicle.brand.toUpperCase()} ${vehicle.model}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${vehicle.variant ?? 'Standart'} • ${vehicle.year}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // TR Plaka Rozeti
                            _PlateBadge(plate: vehicle.plate),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── 2. EŞİT DAĞILIMLI SEGMENTED SEKME ÇUBUĞU ─────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(AppDimensions.r16),
                    ),
                    child: Row(
                      children: [
                        // Sekme 1: Araç Bilgileri
                        Expanded(
                          child: _SegmentTabItem(
                            title: 'Araç Bilgileri',
                            icon: LucideIcons.fileText,
                            isSelected: _selectedTab == 0,
                            onTap: () => setState(() => _selectedTab = 0),
                          ),
                        ),
                        const SizedBox(width: 4),

                        // Sekme 2: Hizmet Geçmişi
                        Expanded(
                          child: _SegmentTabItem(
                            title: 'Hizmet Geçmişi',
                            icon: LucideIcons.history,
                            badgeCount: vehicle.serviceRecords.length,
                            isSelected: _selectedTab == 1,
                            onTap: () => setState(() => _selectedTab = 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── 3. SEKME İÇERİĞİ ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _selectedTab == 0
                      ? _BilgilerTab(vehicle: vehicle)
                      : _GecmisTab(
                          vehicle: vehicle,
                          onAddService: () => _openAddServiceSheet(context, vehicle),
                        ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openAddServiceSheet(BuildContext context, VehicleModel vehicle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddServiceBottomSheet(
        vehicle: vehicle,
        onSave: (record) {
          context.read<GarageCubit>().addServiceRecord(
                vehicleId: vehicle.id,
                serviceName: record.serviceName,
                category: record.category,
                date: record.date,
                mileageAtService: record.mileageAtService,
                serviceProvider: record.serviceProvider,
                cost: record.cost,
                invoiceNo: record.invoiceNo,
                notes: record.notes,
                items: record.items,
              );
        },
      ),
    );
  }
}

// ─── SEGMENTED SEKME BUTONU ──────────────────────────────────────────────────

class _SegmentTabItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final int? badgeCount;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentTabItem({
    required this.title,
    required this.icon,
    this.badgeCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.r12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? const Color(0xFF0052FF) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B),
              ),
            ),
            if (badgeCount != null && badgeCount! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0052FF) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : const Color(0xFF334155),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── LOGO & TAMAMLAMA HALKASI ────────────────────────────────────────────────

class _VehicleAvatarWithRing extends StatelessWidget {
  final double completionRatio;
  final String vehicleType;
  final String brand;

  const _VehicleAvatarWithRing({
    required this.completionRatio,
    required this.vehicleType,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arka Plan Halkası
          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              value: completionRatio,
              strokeWidth: 4,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)), // Mor Halka
            ),
          ),

          // İç Daire Logo / İkon
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                vehicleType == 'motorcycle'
                    ? LucideIcons.bike
                    : vehicleType == 'commercial'
                        ? LucideIcons.truck
                        : LucideIcons.car,
                size: 28,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── TR PLAKA ROZETİ ──────────────────────────────────────────────────────────

class _PlateBadge extends StatelessWidget {
  final String plate;

  const _PlateBadge({required this.plate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: const BoxDecoration(
              color: Color(0xFF003399),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3),
                bottomLeft: Radius.circular(3),
              ),
            ),
            child: const Text(
              'TR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Text(
              plate,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SEKME 1: BİLGİLER
// ══════════════════════════════════════════════════════════════════════════════

class _BilgilerTab extends StatelessWidget {
  final VehicleModel vehicle;

  const _BilgilerTab({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── B. Genel Bilgiler Kartı ──────────────────────────────────────────
        const Text(
          'Genel Bilgiler',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.r20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: AppDimensions.cardShadow,
          ),
          child: Column(
            children: [
              // 1. Kilometre (Pencil Edit)
              _GeneralInfoRow(
                icon: LucideIcons.wrench,
                title: 'Kilometre',
                value: '${TurkishNumberHelper.formatWithDot(vehicle.mileage)} KM',
                isPencil: true,
                onTap: () => _showEditMileageDialog(context, vehicle),
              ),
              const _RowDivider(),

              // 2. Boya - Değişen - Tramer (Pencil Edit)
              _GeneralInfoRow(
                icon: LucideIcons.car,
                title: 'Boya - Değişen - Tramer',
                value: vehicle.tramerInfo ?? 'Tamamı orijinaldir',
                isPencil: true,
                onTap: () => _showTramerPickerSheet(context, vehicle),
              ),
              const _RowDivider(),

              // 3. Plaka (Pencil Edit)
              _GeneralInfoRow(
                icon: LucideIcons.fileText,
                title: 'Plaka',
                value: vehicle.plate,
                isPencil: true,
                onTap: () => _showEditPlateDialog(context, vehicle),
              ),
              const _RowDivider(),

              // 4. Şasi Numarası (Ekle > veya Kopyala)
              _GeneralInfoRow(
                icon: LucideIcons.fileText,
                title: 'Şasi Numarası',
                value: vehicle.chassisNumber,
                emptyLabel: 'Ekle',
                onTap: () => _showEditChassisDialog(context, vehicle),
              ),
              const _RowDivider(),

              // 5. Muayene Geçerlilik Tarihi (Ekle >)
              _GeneralInfoRow(
                icon: LucideIcons.calendar,
                title: 'Muayene Geçerlilik Tarihi',
                value: vehicle.inspectionDate,
                emptyLabel: 'Ekle',
                onTap: () => _showDatePickerModal(context, vehicle, 'Muayene'),
              ),
              const _RowDivider(),

              // 6. Trafik Sigortası Geçerlilik Tarihi (Ekle >)
              _GeneralInfoRow(
                icon: LucideIcons.calendar,
                title: 'Trafik Sigortası Geçerlilik Tarihi',
                value: vehicle.trafficInsuranceDate,
                emptyLabel: 'Ekle',
                onTap: () => _showDatePickerModal(context, vehicle, 'Trafik Sigortası'),
              ),
              const _RowDivider(),

              // 7. Kasko Geçerlilik Tarihi (Ekle >)
              _GeneralInfoRow(
                icon: LucideIcons.calendar,
                title: 'Kasko Geçerlilik Tarihi',
                value: vehicle.kaskoDate,
                emptyLabel: 'Ekle',
                onTap: () => _showDatePickerModal(context, vehicle, 'Kasko'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ── C. Fotoğraflar Bölümü ────────────────────────────────────────────
        const Text(
          'Fotoğraflar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.r20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: AppDimensions.cardShadow,
          ),
          child: vehicle.photos.isEmpty
              ? Column(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.image, size: 30, color: Color(0xFF94A3B8)),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Aracının fotoğrafı yok',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Aracına ait fotoğrafları buradan ekleyebilir, görüntüleyebilir ve ilan verirken kullanabilirsin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052FF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _showPhotoPickerSheet(context, vehicle),
                      child: const Text(
                        'Fotoğraf Ekle',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: vehicle.photos.length + 1,
                        itemBuilder: (ctx, i) {
                          if (i == vehicle.photos.length) {
                            return InkWell(
                              onTap: () => _showPhotoPickerSheet(context, vehicle),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 100,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFCBD5E1)),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.plus, color: Color(0xFF0052FF), size: 24),
                                    SizedBox(height: 4),
                                    Text('Ekle', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0052FF))),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(vehicle.photos[i]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),

        const SizedBox(height: 24),

        // ── D. Belgeler Bölümü ───────────────────────────────────────────────
        const Text(
          'Belgeler',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.r20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: AppDimensions.cardShadow,
          ),
          child: Column(
            children: [
              _DocumentRow(
                title: 'Ruhsat',
                isUploaded: vehicle.documents.containsKey('Ruhsat'),
                onTap: () => _handleDocAction(context, 'Ruhsat'),
              ),
              const _RowDivider(),
              _DocumentRow(
                title: 'Trafik Sigortası',
                isUploaded: vehicle.documents.containsKey('Trafik Sigortası'),
                onTap: () => _handleDocAction(context, 'Trafik Sigortası'),
              ),
              const _RowDivider(),
              _DocumentRow(
                title: 'Kasko',
                isUploaded: vehicle.documents.containsKey('Kasko'),
                onTap: () => _handleDocAction(context, 'Kasko'),
              ),
              const _RowDivider(),
              _DocumentRow(
                title: 'Muayene',
                isUploaded: vehicle.documents.containsKey('Muayene'),
                onTap: () => _handleDocAction(context, 'Muayene'),
              ),
              const _RowDivider(),
              _DocumentRow(
                title: 'Bakım',
                isUploaded: vehicle.documents.containsKey('Bakım'),
                onTap: () => _handleDocAction(context, 'Bakım'),
              ),
              const _RowDivider(),
              _DocumentRow(
                title: 'Ekspertiz Raporu',
                isUploaded: vehicle.documents.containsKey('Ekspertiz Raporu'),
                onTap: () => _handleDocAction(context, 'Ekspertiz Raporu'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleDocAction(BuildContext context, String docTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$docTitle belgesi için yükleme & görüntüleme penceresi açılıyor...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showPhotoPickerSheet(BuildContext context, VehicleModel vehicle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Araç Fotoğrafı Ekle', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(LucideIcons.camera, color: AppColors.primary),
                title: const Text('Fotoğraf Çek (Kamera)'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<GarageCubit>().updateVehicle(
                        vehicle.copyWith(photos: [
                          ...vehicle.photos,
                          'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=800&q=80',
                        ]),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fotoğraf başarıyla eklendi!'), behavior: SnackBarBehavior.floating),
                  );
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.image, color: AppColors.primary),
                title: const Text('Galeriden Seç'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<GarageCubit>().updateVehicle(
                        vehicle.copyWith(photos: [
                          ...vehicle.photos,
                          'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=800&q=80',
                        ]),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fotoğraf başarıyla eklendi!'), behavior: SnackBarBehavior.floating),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hızlı Tekil Düzenleme Dialogları ────────────────────────────────────────

  void _showEditMileageDialog(BuildContext context, VehicleModel vehicle) {
    final controller = TextEditingController(text: TurkishNumberHelper.formatWithDot(vehicle.mileage));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Kilometre Güncelle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        content: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            ThousandsSeparatorInputFormatter(),
          ],
          decoration: InputDecoration(
            hintText: '45.000',
            suffixText: 'KM',
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0052FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              final newMileage = ThousandsSeparatorInputFormatter.parseToInt(controller.text);
              if (newMileage > 0) {
                context.read<GarageCubit>().updateVehicle(vehicle.copyWith(mileage: newMileage));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Kaydet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTramerPickerSheet(BuildContext context, VehicleModel vehicle) {
    VehicleDamageDiagramSheet.show(
      context: context,
      initialSummary: vehicle.tramerInfo,
      onSave: (summary) {
        context.read<GarageCubit>().updateVehicle(vehicle.copyWith(tramerInfo: summary));
      },
    );
  }

  void _showEditPlateDialog(BuildContext context, VehicleModel vehicle) {
    final controller = TextEditingController(text: vehicle.plate);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Plaka Güncelle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        content: TextFormField(
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [TurkishPlateInputFormatter()],
          decoration: InputDecoration(
            hintText: '34 SAN 2026',
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0052FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<GarageCubit>().updateVehicle(vehicle.copyWith(plate: controller.text.trim()));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Kaydet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditChassisDialog(BuildContext context, VehicleModel vehicle) {
    final controller = TextEditingController(text: vehicle.chassisNumber ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Şasi Numarası (VIN)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        content: TextFormField(
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            hintText: 'Örn: WVWZZZCDZPW129841',
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0052FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              context.read<GarageCubit>().updateVehicle(
                    vehicle.copyWith(chassisNumber: controller.text.trim().toUpperCase()),
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Kaydet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDatePickerModal(BuildContext context, VehicleModel vehicle, String type) {
    final controller = TextEditingController(
      text: type == 'Muayene'
          ? (vehicle.inspectionDate ?? '14.11.2026')
          : type == 'Trafik Sigortası'
              ? (vehicle.trafficInsuranceDate ?? '05.10.2026')
              : (vehicle.kaskoDate ?? '05.10.2026'),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('$type Tarihi', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        content: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'GG.AA.YYYY (Örn: 14.11.2026)',
            prefixIcon: const Icon(LucideIcons.calendar, size: 20),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0052FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (type == 'Muayene') {
                context.read<GarageCubit>().updateVehicle(vehicle.copyWith(inspectionDate: controller.text.trim()));
              } else if (type == 'Trafik Sigortası') {
                context.read<GarageCubit>().updateVehicle(vehicle.copyWith(trafficInsuranceDate: controller.text.trim()));
              } else {
                context.read<GarageCubit>().updateVehicle(vehicle.copyWith(kaskoDate: controller.text.trim()));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Kaydet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── GENEL BİLGİLER SATIRI ────────────────────────────────────────────────────

class _GeneralInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final String emptyLabel;
  final bool isPencil;
  final VoidCallback onTap;

  const _GeneralInfoRow({
    required this.icon,
    required this.title,
    this.value,
    this.emptyLabel = 'Ekle',
    this.isPencil = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF64748B)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (hasValue) ...[
                    const SizedBox(height: 2),
                    Text(
                      value!,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isPencil)
              const Icon(LucideIcons.edit2, size: 16, color: Color(0xFF0052FF))
            else if (!hasValue)
              Row(
                children: [
                  Text(
                    emptyLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0052FF),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF0052FF)),
                ],
              )
            else
              const Icon(LucideIcons.edit2, size: 16, color: Color(0xFF0052FF)),
          ],
        ),
      ),
    );
  }
}

// ─── BELGELER SATIRI ─────────────────────────────────────────────────────────

class _DocumentRow extends StatelessWidget {
  final String title;
  final bool isUploaded;
  final VoidCallback onTap;

  const _DocumentRow({
    required this.title,
    required this.isUploaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Icon(LucideIcons.fileText, size: 20, color: Color(0xFF64748B)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  isUploaded ? 'Görüntüle' : 'Ekle',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isUploaded ? AppColors.success : const Color(0xFF0052FF),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: isUploaded ? AppColors.success : const Color(0xFF0052FF),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 50, color: Color(0xFFF1F5F9));
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SEKME 2: HİZMET GEÇMİŞİ (ZENGİN LİSTELEME & ÖZET)
// ══════════════════════════════════════════════════════════════════════════════

class _GecmisTab extends StatelessWidget {
  final VehicleModel vehicle;
  final VoidCallback onAddService;

  const _GecmisTab({
    required this.vehicle,
    required this.onAddService,
  });

  @override
  Widget build(BuildContext context) {
    final records = vehicle.serviceRecords;
    final totalSpent = records.fold<double>(0, (sum, item) => sum + item.cost);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Üst Harcama & Kayıt Özeti Kartı
        Container(
          padding: const EdgeInsets.all(AppDimensions.p16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.08),
                AppColors.primaryLight.withValues(alpha: 0.14),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.r20),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Toplam Alınan Hizmet',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${records.length} Kayıt',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 36, color: AppColors.primary.withValues(alpha: 0.2)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Toplam Harcama',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${TurkishNumberHelper.formatWithDot(totalSpent.toInt())} ₺',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Yeni Hizmet Ekle Butonu
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: onAddService,
            icon: const Icon(LucideIcons.plusCircle, size: 18, color: Colors.white),
            label: const Text(
              'Yeni Hizmet / Bakım Kaydı Ekle',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r16)),
              elevation: 0,
            ),
          ),
        ),

        const SizedBox(height: 18),

        // 3. Hizmet Kartları Listesi
        if (records.isEmpty)
          _buildEmptyServiceState(context)
        else
          ...records.map((record) => _ServiceRecordTimelineCard(record: record)),
      ],
    );
  }

  Widget _buildEmptyServiceState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.r20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.wrench, size: 36, color: AppColors.primary),
          ),
          const SizedBox(height: 14),
          const Text(
            'Henüz Hizmet Kaydı Yok',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          const Text(
            'Bu araca yapılan periyodik bakım, onarım ve oto kuaför kayıtları burada listelenir.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _ServiceRecordTimelineCard extends StatefulWidget {
  final VehicleServiceRecordModel record;

  const _ServiceRecordTimelineCard({required this.record});

  @override
  State<_ServiceRecordTimelineCard> createState() => _ServiceRecordTimelineCardState();
}

class _ServiceRecordTimelineCardState extends State<_ServiceRecordTimelineCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final record = widget.record;

    Color categoryColor = AppColors.primary;
    IconData categoryIcon = LucideIcons.wrench;
    String categoryName = 'Bakım & Servis';

    if (record.category == 'wash') {
      categoryColor = const Color(0xFF0284C7);
      categoryIcon = LucideIcons.sparkles;
      categoryName = 'Araç Yıkama';
    } else if (record.category == 'tires') {
      categoryColor = const Color(0xFFD97706);
      categoryIcon = LucideIcons.disc;
      categoryName = 'Lastik Hizmeti';
    } else if (record.category == 'repair') {
      categoryColor = const Color(0xFFDC2626);
      categoryIcon = LucideIcons.wrench;
      categoryName = 'Mekanik Onarım';
    } else if (record.category == 'expertise') {
      categoryColor = const Color(0xFF7C3AED);
      categoryIcon = LucideIcons.fileCheck;
      categoryName = 'Ekspertiz';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.r20),
        boxShadow: AppDimensions.cardShadow,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppDimensions.r12),
                      ),
                      child: Icon(categoryIcon, size: 20, color: categoryColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: categoryColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(AppDimensions.r6),
                                ),
                                child: Text(
                                  categoryName,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: categoryColor,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${TurkishNumberHelper.formatWithDot(record.cost.toInt())} ₺',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            record.serviceName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Servis Noktası
                Row(
                  children: [
                    const Icon(LucideIcons.mapPin, size: 13, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        record.serviceProvider,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Tarih & KM & Detay
                Row(
                  children: [
                    const Icon(LucideIcons.calendar, size: 13, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 6),
                    Text(
                      record.date,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                    const Text(' • ', style: TextStyle(color: Color(0xFF94A3B8))),
                    const Icon(LucideIcons.gauge, size: 13, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(
                      '${TurkishNumberHelper.formatWithDot(record.mileageAtService)} KM',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    if (record.items.isNotEmpty || record.notes != null)
                      InkWell(
                        onTap: () => setState(() => _isExpanded = !_isExpanded),
                        child: Row(
                          children: [
                            Text(
                              _isExpanded ? 'Gizle' : 'Detaylar',
                              style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700),
                            ),
                            Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16, color: AppColors.primary),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          if (_isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.p16),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (record.items.isNotEmpty) ...[
                    const Text('Yapılan İşlemler & Parçalar:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    ...record.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.checkCircle2, size: 12, color: AppColors.success),
                              const SizedBox(width: 6),
                              Text(item, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                            ],
                          ),
                        )),
                    const SizedBox(height: 6),
                  ],
                  if (record.notes != null && record.notes!.isNotEmpty) ...[
                    const Text('Servis Notu:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(record.notes!, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontStyle: FontStyle.italic)),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── YENİ HİZMET EKLEME MODAL SHEET ──────────────────────────────────────────

class _AddServiceBottomSheet extends StatefulWidget {
  final VehicleModel vehicle;
  final ValueChanged<VehicleServiceRecordModel> onSave;

  const _AddServiceBottomSheet({
    required this.vehicle,
    required this.onSave,
  });

  @override
  State<_AddServiceBottomSheet> createState() => _AddServiceBottomSheetState();
}

class _AddServiceBottomSheetState extends State<_AddServiceBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _serviceNameController = TextEditingController();
  final _serviceProviderController = TextEditingController();
  final _costController = TextEditingController();
  final _mileageController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();
  final _itemsController = TextEditingController();

  String _selectedCategory = 'maintenance';

  final List<Map<String, dynamic>> _categories = [
    {'id': 'maintenance', 'name': 'Periyodik Bakım', 'icon': LucideIcons.wrench},
    {'id': 'wash', 'name': 'Oto Yıkama / Kuaför', 'icon': LucideIcons.sparkles},
    {'id': 'tires', 'name': 'Lastik & Jant', 'icon': LucideIcons.disc},
    {'id': 'repair', 'name': 'Mekanik & Onarım', 'icon': LucideIcons.wrench},
    {'id': 'expertise', 'name': 'Ekspertiz', 'icon': LucideIcons.fileCheck},
    {'id': 'other', 'name': 'Diğer Hizmet', 'icon': LucideIcons.moreHorizontal},
  ];

  @override
  void initState() {
    super.initState();
    _mileageController.text = TurkishNumberHelper.formatWithDot(widget.vehicle.mileage);
    final now = DateTime.now();
    _dateController.text = '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}';
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _serviceProviderController.dispose();
    _costController.dispose();
    _mileageController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    _itemsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Drag Handle
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
          const SizedBox(height: 12),

          // Başlık
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Yeni Hizmet Kaydı Ekle',
                  style: TextStyle(
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

          const Divider(height: 16, color: Color(0xFFE2E8F0)),

          // Form Alanı
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hizmet Kategorisi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat['id'];
                        return ChoiceChip(
                          avatar: Icon(cat['icon'] as IconData, size: 14, color: isSelected ? Colors.white : AppColors.textPrimary),
                          label: Text(cat['name'] as String),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedCategory = cat['id'] as String);
                            }
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    const Text('Hizmet Başlığı / Açıklaması *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _serviceNameController,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen hizmet başlığı girin' : null,
                      decoration: InputDecoration(
                        hintText: 'Örn: 60.000 KM Periyodik Bakım',
                        prefixIcon: const Icon(LucideIcons.wrench, size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text('Servis / Usta Adı *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _serviceProviderController,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen servis noktası girin' : null,
                      decoration: InputDecoration(
                        hintText: 'Örn: SanayiGO Yetkili Servisi / Kartal Oto Sanayi',
                        prefixIcon: const Icon(LucideIcons.store, size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Toplam Tutar *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _costController,
                                keyboardType: TextInputType.number,
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'Tutar girin' : null,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  ThousandsSeparatorInputFormatter(),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Örn: 4.500',
                                  suffixText: '₺',
                                  prefixIcon: const Icon(LucideIcons.banknote, size: 18),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Hizmet Anı KM *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _mileageController,
                                keyboardType: TextInputType.number,
                                validator: (v) => (v == null || v.trim().isEmpty) ? 'KM girin' : null,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  ThousandsSeparatorInputFormatter(),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Örn: 45.000',
                                  suffixText: 'KM',
                                  prefixIcon: const Icon(LucideIcons.gauge, size: 18),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Text('Hizmet Tarihi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        hintText: 'GG.AA.YYYY',
                        prefixIcon: const Icon(LucideIcons.calendar, size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text('Değişen Parçalar / İşlemler (Virgülle Ayırın)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _itemsController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Örn: Motor Yağı, Yağ Filtresi, Polen Filtresi, Fren Balatası',
                        prefixIcon: const Icon(LucideIcons.listPlus, size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text('Özel Notlar & Açıklamalar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Ustanın önerileri, garanti süresi vb.',
                        prefixIcon: const Icon(LucideIcons.messageSquare, size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Kaydet Butonu
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 12 + MediaQuery.of(context).padding.bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r16)),
                  elevation: 0,
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final mileage = ThousandsSeparatorInputFormatter.parseToInt(_mileageController.text);
                    final cost = ThousandsSeparatorInputFormatter.parseToInt(_costController.text).toDouble();

                    final items = _itemsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();

                    final record = VehicleServiceRecordModel(
                      id: 'srv_${DateTime.now().millisecondsSinceEpoch}',
                      vehicleId: widget.vehicle.id,
                      serviceName: _serviceNameController.text.trim(),
                      category: _selectedCategory,
                      date: _dateController.text.trim(),
                      mileageAtService: mileage,
                      serviceProvider: _serviceProviderController.text.trim(),
                      cost: cost,
                      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
                      items: items,
                      status: 'completed',
                    );

                    widget.onSave(record);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Hizmet Kaydını Ekle',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
