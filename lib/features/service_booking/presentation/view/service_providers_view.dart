import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/core/utils/turkish_number_helper.dart';
import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_model.dart';
import '../../data/models/service_provider_model.dart';
import 'service_appointment_view.dart';

/// Bayi / Servis Noktası ve Fiyat Seçim Ekranı
class ServiceProvidersView extends StatefulWidget {
  final String serviceTitle;
  final VehicleModel selectedVehicle;

  const ServiceProvidersView({
    super.key,
    required this.serviceTitle,
    required this.selectedVehicle,
  });

  @override
  State<ServiceProvidersView> createState() => _ServiceProvidersViewState();
}

class _ServiceProvidersViewState extends State<ServiceProvidersView> {
  int _selectedFilterIndex = 0; // 0: En Yakın, 1: En Yüksek Puan, 2: En Uygun Fiyat
  String? _selectedProviderId;

  // Mock Bayi Listesi
  late List<ServiceProviderModel> _providers;

  @override
  void initState() {
    super.initState();
    _initMockProviders();
    if (_providers.isNotEmpty) {
      _selectedProviderId = _providers.first.id;
    }
  }

  void _initMockProviders() {
    _providers = [
      ServiceProviderModel(
        id: 'prov_1',
        name: 'SanayiGO Yetkili Maslak Servisi',
        address: 'Atatürk Oto Sanayi Sitesi 2. Kısım No: 45',
        districtCity: 'Maslak, Sarıyer / İstanbul',
        distanceKm: 1.2,
        rating: 4.9,
        reviewCount: 142,
        price: _calculateBasePrice(widget.serviceTitle, 1.0),
        packageDescription: 'Orijinal parça, 1 yıl SanayiGO garantisi ve ücretsiz araç check-up.',
        imageUrl: 'https://images.unsplash.com/photo-1613214149922-f1809c99b414?auto=format&fit=crop&w=600&q=80',
        features: ['1 Yıl Garanti', 'Hızlı Teslimat', 'Ücretsiz Check-up'],
        latOffset: -30,
        lngOffset: 40,
      ),
      ServiceProviderModel(
        id: 'prov_2',
        name: 'Master Auto Detailing & Bakım',
        address: 'Büyükdere Cad. Oto Sanayi Girişi No: 12',
        districtCity: 'Seyrantepe, Kağıthane / İstanbul',
        distanceKm: 2.8,
        rating: 4.8,
        reviewCount: 98,
        price: _calculateBasePrice(widget.serviceTitle, 0.9),
        packageDescription: 'Premium işçilik, detaylı dezenfeksiyon ve usta onaylı teslimat.',
        imageUrl: 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?auto=format&fit=crop&w=600&q=80',
        features: ['VIP Alan', 'Kahve İkramı', 'Aynı Gün Teslim'],
        latOffset: 50,
        lngOffset: -60,
      ),
      ServiceProviderModel(
        id: 'prov_3',
        name: 'Kartal Pro Garaj & Lastik Noktası',
        address: 'Kartal Oto Sanayi Sitesi A Blok No: 18',
        districtCity: 'Kartal / İstanbul',
        distanceKm: 4.5,
        rating: 4.7,
        reviewCount: 76,
        price: _calculateBasePrice(widget.serviceTitle, 0.85),
        packageDescription: 'Ekonomik paket, bilgisayarlı arıza tespiti ve orijinal sarf malzeme.',
        imageUrl: 'https://images.unsplash.com/photo-1486006920555-c77dce18193b?auto=format&fit=crop&w=600&q=80',
        features: ['Ekonomik Fiyat', 'Rot-Balans Dahil'],
        latOffset: 80,
        lngOffset: 90,
      ),
    ];
  }

  double _calculateBasePrice(String title, double multiplier) {
    if (title.contains('Yıkama')) return 350.0 * multiplier;
    if (title.contains('Bakım')) return 2850.0 * multiplier;
    if (title.contains('Lastik')) return 800.0 * multiplier;
    if (title.contains('Ekspertiz')) return 1950.0 * multiplier;
    if (title.contains('Çekici')) return 1200.0 * multiplier;
    if (title.contains('Sigorta')) return 4500.0 * multiplier;
    return 650.0 * multiplier;
  }

  @override
  Widget build(BuildContext context) {
    final selectedProvider = _providers.firstWhere(
      (p) => p.id == _selectedProviderId,
      orElse: () => _providers.first,
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
        title: Text(
          widget.serviceTitle,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          // Sağ Üst Harita İkonu
          IconButton(
            icon: const Icon(LucideIcons.map, size: 22, color: AppColors.primary),
            tooltip: 'Haritada Gör',
            onPressed: () => _openMapModal(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF1F5F9), height: 1),
        ),
      ),
      body: Column(
        children: [
          // ── 1. Seçilen Araç Rozeti ──────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003399),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'TR',
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.selectedVehicle.plate,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const Text(' • ', style: TextStyle(color: Color(0xFF94A3B8))),
                Expanded(
                  child: Text(
                    '${widget.selectedVehicle.brand} ${widget.selectedVehicle.model}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // ── 2. Filtreleme Çipleri ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                _buildFilterChip('En Yakın', 0),
                const SizedBox(width: 8),
                _buildFilterChip('En Yüksek Puan', 1),
                const SizedBox(width: 8),
                _buildFilterChip('En Uygun Fiyat', 2),
              ],
            ),
          ),

          // ── 3. Bayi & Fiyat Listesi ──────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              itemCount: _providers.length,
              itemBuilder: (context, index) {
                final provider = _providers[index];
                final isSelected = provider.id == _selectedProviderId;

                return _ProviderCard(
                  provider: provider,
                  serviceTitle: widget.serviceTitle,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedProviderId = provider.id;
                    });
                  },
                  onInfoTap: () => _openProviderDetailModal(context, provider),
                );
              },
            ),
          ),
        ],
      ),

      // ── 4. Alt Devam Et Barı ────────────────────────────────────────────────
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
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Seçilen Fiyat', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                  const SizedBox(height: 2),
                  Text(
                    '${TurkishNumberHelper.formatWithDot(selectedProvider.price.toInt())} ₺',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: SizedBox(
                height: 50,
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
                        builder: (_) => ServiceAppointmentView(
                          serviceTitle: widget.serviceTitle,
                          selectedVehicle: widget.selectedVehicle,
                          selectedProvider: selectedProvider,
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Devam Et',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilterIndex == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primaryContainer,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
        color: isSelected ? AppColors.primary : const Color(0xFF64748B),
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
      ),
      onSelected: (val) {
        setState(() {
          _selectedFilterIndex = index;
          if (index == 0) {
            _providers.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
          } else if (index == 1) {
            _providers.sort((a, b) => b.rating.compareTo(a.rating));
          } else {
            _providers.sort((a, b) => a.price.compareTo(b.price));
          }
        });
      },
    );
  }

  void _openMapModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ServiceProvidersMapSheet(
        providers: _providers,
        selectedProviderId: _selectedProviderId,
        onProviderSelected: (id) {
          setState(() {
            _selectedProviderId = id;
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _openProviderDetailModal(BuildContext context, ServiceProviderModel provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ProviderDetailModalSheet(
        provider: provider,
        serviceTitle: widget.serviceTitle,
        onSelectPackage: () {
          setState(() {
            _selectedProviderId = provider.id;
          });
          Navigator.pop(ctx);
        },
      ),
    );
  }
}

// ─── BAYİ SEÇİM KARTI (YUVARLAK (i) HAKKINDA İKONUYLA) ────────────────────────

class _ProviderCard extends StatelessWidget {
  final ServiceProviderModel provider;
  final String serviceTitle;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onInfoTap;

  const _ProviderCard({
    required this.provider,
    required this.serviceTitle,
    required this.isSelected,
    required this.onTap,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.r20),
        border: Border.all(
          color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : AppDimensions.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.r20),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.r20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.p16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── SOL TARAF: Bayi Adı, Puanı ve Konumu ─────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        provider.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${provider.rating}',
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${provider.reviewCount} Değerlendirme)',
                            style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(LucideIcons.mapPin, size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              '${provider.distanceKm} km • ${provider.districtCity}',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // ── SAĞ TARAF: Sağ Üstte (i) İkonu, Sağ Ortada Fiyat ──────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sağ Üst Bilgi (i) İkonu
                    InkWell(
                      onTap: onInfoTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(
                          LucideIcons.info,
                          size: 15,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Sağ Orta Fiyat Rozeti
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(AppDimensions.r10),
                      ),
                      child: Text(
                        '${TurkishNumberHelper.formatWithDot(provider.price.toInt())} ₺',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: isSelected ? Colors.white : AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── HİZMET & BAYİ DETAYLARI MODAL SHEET ((i) İKONUNA TIKLANINCA AÇILAN) ──────

class _ProviderDetailModalSheet extends StatelessWidget {
  final ServiceProviderModel provider;
  final String serviceTitle;
  final VoidCallback onSelectPackage;

  const _ProviderDetailModalSheet({
    required this.provider,
    required this.serviceTitle,
    required this.onSelectPackage,
  });

  @override
  Widget build(BuildContext context) {
    // Hizmete göre dinamik detay maddeleri
    final List<String> packageItems = _getPackageItems(serviceTitle);

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
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
          const SizedBox(height: 14),

          // Modal Başlığı
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hizmet & Paket Detayları',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bayi & Puan Başlık Kartı
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(LucideIcons.store, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider.name,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${provider.rating} (${provider.reviewCount} Değerlendirme)',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Paket Kapsamı Başlığı
                  Row(
                    children: [
                      const Icon(LucideIcons.checkCircle2, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '$serviceTitle Kapsamı',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Maddeler Listesi
                  ...packageItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Color(0xFFDCFCE7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 12, color: AppColors.success),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 13.5, color: Color(0xFF334155), fontWeight: FontWeight.w500, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  // SanayiGO Güvence Notu
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(LucideIcons.shieldCheck, color: AppColors.primary, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SanayiGO Sabit Fiyat & Garanti Güvencesi',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Belirtilen fiyata tüm işçilik ve KDV dahildir. Serviste ek bir sürpriz masraf çıkarılmaz.',
                                style: TextStyle(fontSize: 11.5, color: Color(0xFF475569), height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Fiyat Bilgisi ve Seç Butonu
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Paket Tutarı', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                          const SizedBox(height: 2),
                          Text(
                            '${TurkishNumberHelper.formatWithDot(provider.price.toInt())} ₺',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            onPressed: onSelectPackage,
                            child: const Text(
                              'Bu Paketi Seç',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getPackageItems(String title) {
    if (title.contains('Yıkama')) {
      return [
        'Köpüklü pH nötr dış yıkama ve mikrofiber kurulama',
        'Detaylı iç süpürme, koltuk ve bagaj toz temizliği',
        'Torpido, kapı fitilleri ve plastik aksam koruyucu bakım',
        'Jant balata tozu arındırma ve lastik parlatma',
        'Camların iç ve dış silinmesi & lekesiz görüş',
        'Ozon ile araç içi antibakteriyel koku giderme',
      ];
    } else if (title.contains('Bakım')) {
      return [
        'Motor yağı ve yağ filtresi değişimi (Orijinal onaylı)',
        'Hava filtresi ve polen / klima filtresi yenileme',
        'Fren balataları, diskler ve hidrolik sıvı kontrolü',
        'Bilgisayarlı OBD-II arıza tespiti ve sıfırlama',
        '30 nokta mekanik, süspansiyon ve alt takım muayenesi',
        '1 Yıl / 20.000 KM SanayiGO parça ve işçilik garantisi',
      ];
    } else if (title.contains('Lastik')) {
      return [
        '4 adet lastik sökme, takma ve montaj işlemi',
        'Hassas lazerli 4 teker rot ve balans ayarı',
        'Subap değişimi ve nitrojen gazı basımı',
        'Lastik diş derinliği ve aşınma analiz raporu',
      ];
    } else if (title.contains('Ekspertiz')) {
      return [
        'Kaporta, boya kalınlık ölçümü ve şasi kontrolü',
        'Motor mekanik testleri ve dyno güç ölçümü',
        'Fren, süspansiyon ve yanal kayma testleri',
        'Tramer ve hasar kaydı sorgulama raporu',
        'TSE onaylı 15 sayfalık dijital ekspertiz sertifikası',
      ];
    }
    return [
      'Yetkili usta tarafından kapsamlı işlem ve kontrol',
      'Orijinal onaylı yedek parça ve malzeme garantisi',
      'SanayiGO sabit fiyat ve işlem güvencesi',
      'Servis sonrası dijital fatura ve garanti belgesi',
    ];
  }
}

// ─── HARİTA MODAL SHEET (SAĞ ÜST İKONDAN AÇILAN) ─────────────────────────────

class _ServiceProvidersMapSheet extends StatelessWidget {
  final List<ServiceProviderModel> providers;
  final String? selectedProviderId;
  final ValueChanged<String> onProviderSelected;

  const _ServiceProvidersMapSheet({
    required this.providers,
    this.selectedProviderId,
    required this.onProviderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bayi & Servis Konumları',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Harita Alanı
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: const Color(0xFFF1F5F9),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.mapPin, size: 48, color: AppColors.primary),
                        SizedBox(height: 10),
                        Text(
                          'Yakındaki Anlaşmalı Bayiler Haritası',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),

                // Mock Bayi Pinleri
                ...providers.map((p) {
                  final isSel = p.id == selectedProviderId;
                  return Align(
                    alignment: Alignment(p.latOffset / 100, p.lngOffset / 100),
                    child: GestureDetector(
                      onTap: () => onProviderSelected(p.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppDimensions.cardShadow,
                          border: Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.store, size: 14, color: isSel ? Colors.white : AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              '${p.name.split(' ').first} (${TurkishNumberHelper.formatWithDot(p.price.toInt())} ₺)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isSel ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
