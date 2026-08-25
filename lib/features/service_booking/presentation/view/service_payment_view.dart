import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/core/utils/turkish_number_helper.dart';
import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_model.dart';
import 'package:sanayi_mobil_app/features/garage/presentation/cubit/garage_cubit.dart';
import '../../data/models/service_provider_model.dart';
import 'service_booking_success_modal.dart';

/// Adım 2: Ödeme ve Sipariş Onay Ekranı (Manuel Kart Bilgisi Girişi & Cüzdan)
class ServicePaymentView extends StatefulWidget {
  final String serviceTitle;
  final VehicleModel selectedVehicle;
  final ServiceProviderModel selectedProvider;
  final String appointmentDateTime;
  final String? customerNote;

  const ServicePaymentView({
    super.key,
    required this.serviceTitle,
    required this.selectedVehicle,
    required this.selectedProvider,
    required this.appointmentDateTime,
    this.customerNote,
  });

  @override
  State<ServicePaymentView> createState() => _ServicePaymentViewState();
}

class _ServicePaymentViewState extends State<ServicePaymentView> {
  int _selectedPaymentMethod = 0; // 0: Kredi/Banka Kartı Girişi, 1: SanayiGO Cüzdan

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();

  bool _saveCard = true;
  bool _isProcessing = false;
  double _couponDiscount = 0.0;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment(double totalPrice) async {
    // Kredi kartı seçiliyse formu doğrula
    if (_selectedPaymentMethod == 0) {
      if (!(_formKey.currentState?.validate() ?? false)) {
        return;
      }
    }

    final garageCubit = context.read<GarageCubit>();
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    // Garaj Cubit'e yeni randevu / hizmet kaydı olarak ekle
    garageCubit.addServiceRecord(
      vehicleId: widget.selectedVehicle.id,
      serviceName: widget.serviceTitle,
      category: 'service',
      date: widget.appointmentDateTime,
      mileageAtService: widget.selectedVehicle.mileage,
      serviceProvider: widget.selectedProvider.name,
      cost: totalPrice,
      notes: widget.customerNote ?? 'SanayiGO Mobil üzerinden online onaylı randevu oluşturuldu.',
      items: [widget.selectedProvider.packageDescription],
    );

    setState(() => _isProcessing = false);

    _showSuccessModal(totalPrice);
  }

  void _showSuccessModal(double totalPrice) {
    ServiceBookingSuccessModal.show(
      context,
      serviceTitle: widget.serviceTitle,
      vehiclePlate: widget.selectedVehicle.plate,
      providerName: widget.selectedProvider.name,
      appointmentDate: widget.appointmentDateTime,
      totalCost: totalPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    final basePrice = widget.selectedProvider.price;
    final standardDiscount = basePrice > 500 ? 50.0 : 0.0;
    final totalDiscount = standardDiscount + _couponDiscount;
    final totalPrice = (basePrice - totalDiscount).clamp(0.0, double.infinity);

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
          'Ödeme',
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
            // ── 1. Randevu & Hizmet Özeti Kartı ────────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppDimensions.p16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.r20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: AppDimensions.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Randevu Zamanı Vurgusu
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.calendarClock, color: AppColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.appointmentDateTime,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  _buildSummaryRow('Hizmet', widget.serviceTitle),
                  const SizedBox(height: 6),
                  _buildSummaryRow('Servis Noktası', widget.selectedProvider.name),
                  const SizedBox(height: 6),
                  _buildSummaryRow('Seçilen Araç', '${widget.selectedVehicle.plate} (${widget.selectedVehicle.brand} ${widget.selectedVehicle.model})'),
                  if (widget.customerNote != null) ...[
                    const SizedBox(height: 6),
                    _buildSummaryRow('Özel Not', widget.customerNote!),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── 2. Ödeme Yöntemi Seçimi ───────────────────────────────────────
            const Text(
              'Ödeme Yöntemi Seçin',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
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
                  // Seçenek 1: Kredi / Banka Kartı
                  _buildPaymentOption(
                    index: 0,
                    icon: LucideIcons.creditCard,
                    title: 'Kredi / Banka Kartı ile Ödeme',
                    subtitle: 'Visa, Mastercard, Troy ile güvenli 3D ödeme',
                    isFirst: true,
                  ),
                  const Divider(height: 1, indent: 50, color: Color(0xFFF1F5F9)),

                  // Seçenek 2: SanayiGO Cüzdan
                  _buildPaymentOption(
                    index: 1,
                    icon: LucideIcons.wallet,
                    title: 'SanayiGO Cüzdan Bakiyesi',
                    subtitle: 'Kullanılabilir Bakiye: 1.500,00 ₺',
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── 3. Kart Bilgisi Giriş Formu (Kredi Kartı Seçiliyken) ────────────
            if (_selectedPaymentMethod == 0)
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.p16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.r20),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    boxShadow: AppDimensions.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(LucideIcons.creditCard, color: AppColors.primary, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Kart Bilgilerini Girin',
                            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Kart Üzerindeki İsim
                      const Text('Kart Üzerindeki İsim *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _cardHolderController,
                        textCapitalization: TextCapitalization.characters,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Kart üzerindeki ismi girin' : null,
                        decoration: InputDecoration(
                          hintText: 'Örn: AHMET YILMAZ',
                          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          prefixIcon: const Icon(LucideIcons.user, size: 18, color: Color(0xFF94A3B8)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Kart Numarası (4'lü Boşluklu)
                      const Text('Kart Numarası *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          _CardNumberInputFormatter(),
                        ],
                        validator: (v) => (v == null || v.replaceAll(' ', '').length < 16) ? '16 haneli kart numarasını girin' : null,
                        decoration: InputDecoration(
                          hintText: '0000 0000 0000 0000',
                          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          prefixIcon: const Icon(LucideIcons.creditCard, size: 18, color: Color(0xFF94A3B8)),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('💳', style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Son Kullanma Tarihi & CVV (Yan Yana)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Son Kullanma (AA/YY) *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _cardExpiryController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                    _CardExpiryInputFormatter(),
                                  ],
                                  validator: (v) => (v == null || v.length < 5) ? 'AA/YY girin' : null,
                                  decoration: InputDecoration(
                                    hintText: '08/28',
                                    hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    prefixIcon: const Icon(LucideIcons.calendar, size: 18, color: Color(0xFF94A3B8)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                                const Text('CVV / CVC *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _cardCvvController,
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  validator: (v) => (v == null || v.length < 3) ? '3 haneli CVV' : null,
                                  decoration: InputDecoration(
                                    hintText: '•••',
                                    hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    prefixIcon: const Icon(LucideIcons.lock, size: 18, color: Color(0xFF94A3B8)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Kartı Hatırla Checkbox
                      InkWell(
                        onTap: () => setState(() => _saveCard = !_saveCard),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _saveCard,
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: (val) => setState(() => _saveCard = val ?? true),
                            ),
                            const Expanded(
                              child: Text(
                                'Kartımı sonraki işlemlerim için güvenle hatırla',
                                style: TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // ── 4. Kupon Kodu Alanı ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.r16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.ticket, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _couponController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: 'Kupon / İndirim Kodu Girin',
                        hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_couponController.text.trim().toUpperCase() == 'SANAYI50') {
                        setState(() => _couponDiscount = 50.0);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('50 ₺ indirim kuponu uygulandı!'), behavior: SnackBarBehavior.floating),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Örnek Kupon: SANAYI50'), behavior: SnackBarBehavior.floating),
                        );
                      }
                    },
                    child: const Text('Uygula', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── 5. Fiyat Dökümü Kartı ──────────────────────────────────────────
            const Text(
              'Ödeme Özeti',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(AppDimensions.p16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.r20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: AppDimensions.cardShadow,
              ),
              child: Column(
                children: [
                  _buildPriceRow('Hizmet Bedeli', '${TurkishNumberHelper.formatWithDot(basePrice.toInt())} ₺'),
                  const SizedBox(height: 8),
                  _buildPriceRow('Hizmet Güvence Bedeli', 'Ücretsiz', isFree: true),
                  if (totalDiscount > 0) ...[
                    const SizedBox(height: 8),
                    _buildPriceRow('Toplam İndirim', '-${TurkishNumberHelper.formatWithDot(totalDiscount.toInt())} ₺', isHighlight: true),
                  ],
                  const Divider(height: 20, color: Color(0xFFF1F5F9)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ödenecek Toplam Tutar',
                            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          Text('KDV Dahildir', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      ),
                      Text(
                        '${TurkishNumberHelper.formatWithDot(totalPrice.toInt())} ₺',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 256-Bit SSL Güvenlik Rozeti
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.lock, size: 13, color: Color(0xFF94A3B8)),
                  SizedBox(width: 6),
                  Text(
                    '256-Bit SSL ile %100 Güvenli Ödeme Altyapısı',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ── 6. Alt 'Ödemeyi Tamamla ve Onayla' Butonu ─────────────────────────
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
            onPressed: _isProcessing ? null : () => _handlePayment(totalPrice),
            child: _isProcessing
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.shieldCheck, size: 20, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Ödemeyi Tamamla (${TurkishNumberHelper.formatWithDot(totalPrice.toInt())} ₺)',
                        style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isSelected = _selectedPaymentMethod == index;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = index),
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(20) : Radius.zero,
        bottom: isLast ? const Radius.circular(20) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : const Color(0xFF64748B), size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : const Color(0xFFCBD5E1),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isHighlight = false, bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isHighlight ? AppColors.success : const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: isHighlight || isFree ? AppColors.success : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

// ─── KART NUMARASI FORMATLAYICI (0000 0000 0000 0000) ────────────────────────

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

// ─── SON KULLANMA FORMATLAYICI (AA/YY) ────────────────────────────────────────

class _CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex == 2 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
