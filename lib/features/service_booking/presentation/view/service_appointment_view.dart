import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_model.dart';
import '../../data/models/service_provider_model.dart';
import 'service_payment_view.dart';

/// Randevu Tarihi ve Saati Seçim Ekranı (MHRS / Hastane Tarzı Akıllı Aylık Takvim)
class ServiceAppointmentView extends StatefulWidget {
  final String serviceTitle;
  final VehicleModel selectedVehicle;
  final ServiceProviderModel selectedProvider;

  const ServiceAppointmentView({
    super.key,
    required this.serviceTitle,
    required this.selectedVehicle,
    required this.selectedProvider,
  });

  @override
  State<ServiceAppointmentView> createState() => _ServiceAppointmentViewState();
}

class _ServiceAppointmentViewState extends State<ServiceAppointmentView> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;
  String _selectedTimeSlot = '10:00';
  final TextEditingController _noteController = TextEditingController();

  final List<String> _allSlots = [
    '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00'
  ];

  // Mock Dolu Saatler
  final Set<String> _bookedSlots = {'09:30', '11:00', '14:00', '16:30'};

  final List<String> _monthNames = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];

  final List<String> _dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
    // Varsayılan: Eğer bugün pazar değilse bugün, pazarsa yarın
    _selectedDate = now.weekday == DateTime.sunday ? now.add(const Duration(days: 1)) : now;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedSelectedDate =
        '${_selectedDate.day} ${_monthNames[_selectedDate.month - 1]} ${_selectedDate.year}, ${_dayNames[_selectedDate.weekday - 1]}';
    final fullAppointmentString = '$formattedSelectedDate • $_selectedTimeSlot';

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
          'Randevu Takvimi',
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
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Servis ve Araç Özet Kartı ──────────────────────────────────
            Container(
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
                    child: const Icon(LucideIcons.store, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.selectedProvider.name,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.serviceTitle} • ${widget.selectedVehicle.plate}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── 2. Aylık Takvim Tablosu (Hastane / MHRS Stili) ─────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.r20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: AppDimensions.cardShadow,
              ),
              child: Column(
                children: [
                  // Ay ve Yıl Başlığı + İleri/Geri Okları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
                        onPressed: () {
                          setState(() {
                            _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
                          });
                        },
                      ),
                      Text(
                        '${_monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
                        onPressed: () {
                          setState(() {
                            _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Gün İsimleri Satırı (Pzt, Sal, Çar, Per, Cum, Cmt, Paz)
                  Row(
                    children: _dayNames.map((d) {
                      final isSunday = d == 'Paz';
                      return Expanded(
                        child: Center(
                          child: Text(
                            d,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSunday ? const Color(0xFFEF4444) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const Divider(height: 20, color: Color(0xFFF1F5F9)),

                  // Ayın Günleri Izgarası
                  _buildCalendarGrid(),

                  const SizedBox(height: 12),

                  // Takvim Bilgilendirme Lejandı
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CalendarLegendItem(color: AppColors.primary, label: 'Seçili'),
                      SizedBox(width: 14),
                      _CalendarLegendItem(color: AppColors.success, label: 'Müsait'),
                      SizedBox(width: 14),
                      _CalendarLegendItem(color: Color(0xFFCBD5E1), label: 'Pazar (Kapalı)'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── 4. Seçilen Günün Müsait Saatleri ───────────────────────────────
            Text(
              '$formattedSelectedDate - Müsait Saatler',
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allSlots.map((slot) => _buildTimeSlotChip(slot)).toList(),
            ),

            const SizedBox(height: 24),

            // ── 5. Servise Özel Not (Opsiyonel) ───────────────────────────────
            const Text(
              'Servise / Ustaya Notunuz (Opsiyonel)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.r16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: _noteController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Örn: Ön fren balatası kontrol edilsin, teslimatı 16:00 gibi yapabilirim...',
                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                ),
              ),
            ),
          ],
        ),
      ),

      // ── 6. Alt 'Ödeme Adımına Geç' Barı ─────────────────────────────────────
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServicePaymentView(
                    serviceTitle: widget.serviceTitle,
                    selectedVehicle: widget.selectedVehicle,
                    selectedProvider: widget.selectedProvider,
                    appointmentDateTime: fullAppointmentString,
                    customerNote: _noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null,
                  ),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ödeme Adımına Geç',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 18, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── TAKVİM TABLOSU OLUŞTURUCU ──────────────────────────────────────────────

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday; // 1: Pzt ... 7: Paz

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<Widget> dayWidgets = [];

    // Önceki aydan kalan boşluklar
    for (int i = 1; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox.shrink());
    }

    // Ayın günleri
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final isPast = date.isBefore(today);
      final isSunday = date.weekday == DateTime.sunday;
      final isSelected = _selectedDate.year == date.year &&
          _selectedDate.month == date.month &&
          _selectedDate.day == date.day;
      final isToday = date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;

      final bool isSelectable = !isPast && !isSunday;

      dayWidgets.add(
        GestureDetector(
          onTap: isSelectable
              ? () {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              : null,
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : isToday && !isSelected
                      ? AppColors.primaryContainer
                      : isSunday
                          ? const Color(0xFFF1F5F9)
                          : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.primary, width: 1.2)
                  : null,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected || isToday ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : isPast
                              ? const Color(0xFFCBD5E1)
                              : isSunday
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF0F172A),
                    ),
                  ),
                  if (isSelectable && !isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    )
                  else if (isSunday)
                    const Text(
                      'Kapalı',
                      style: TextStyle(fontSize: 7.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  // ─── SAAT KUTUCUĞU ──────────────────────────────────────────────────────────

  Widget _buildTimeSlotChip(String slot) {
    final isBooked = _bookedSlots.contains(slot);
    final isSelected = _selectedTimeSlot == slot;

    if (isBooked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(AppDimensions.r12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Text(
          slot,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFFCBD5E1),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _selectedTimeSlot = slot),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.r12),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFCBD5E1),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          slot,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ),
    );
  }
}

// ─── TAKVİM LEJAND BİLEŞENİ ──────────────────────────────────────────────────

class _CalendarLegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _CalendarLegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
