import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';

/// Rabam Birebir "Konum Seç" Ekranı (Mock Interactive Harita + Arama + Pin)
class SelectLocationView extends StatefulWidget {
  final String initialLocation;

  const SelectLocationView({
    super.key,
    this.initialLocation = 'Meram, Konya',
  });

  @override
  State<SelectLocationView> createState() => _SelectLocationViewState();
}

class _SelectLocationViewState extends State<SelectLocationView> {
  late String _selectedLocation;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // Harita Pan Ofsetleri (Sürüklenebilir Mock Harita)
  Offset _mapOffset = const Offset(-80, -60);

  // Örnek İlçe & Şehir Listesi (Arama için)
  final List<String> _popularLocations = [
    'Meram, Konya',
    'Selçuklu, Konya',
    'Karatay, Konya',
    'Kadıköy, İstanbul',
    'Maslak, İstanbul',
    'Beşiktaş, İstanbul',
    'Ataşehir, İstanbul',
    'Ümraniye, İstanbul',
    'Çankaya, Ankara',
    'Yenimahalle, Ankara',
    'Bornova, İzmir',
    'Nilüfer, Bursa',
    'Muratpaşa, Antalya',
  ];

  late List<String> _filteredLocations;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    _filteredLocations = List.from(_popularLocations);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _isSearching = false;
        _filteredLocations = List.from(_popularLocations);
      } else {
        _isSearching = true;
        _filteredLocations = _popularLocations
            .where((loc) => loc.toLowerCase().contains(query))
            .toList();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 24, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Konum Seç',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF60A5FA),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF1F5F9), height: 1),
        ),
      ),
      body: Stack(
        children: [
          // ── 1. SÜRÜKLENEBİLİR VEKTÖREL HARİTA TABANI ──────────────────────
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _mapOffset += details.delta;
                  // Harita sürüklendikçe dinamik örnek lokasyon simülasyonu
                  if (_mapOffset.dx < -120) {
                    _selectedLocation = 'Meram, Konya';
                  } else if (_mapOffset.dx > 20) {
                    _selectedLocation = 'Selçuklu, Konya';
                  } else {
                    _selectedLocation = 'Karatay, Konya';
                  }
                });
              },
              child: ClipRect(
                child: CustomPaint(
                  painter: _StylizedMapPainter(offset: _mapOffset),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),

          // ── 2. MERKEZDE SABİT PİN (RABAM MAVİ İĞNE) ──────────────────────
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40), // Pin ucunu merkeze oturtmak için
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0052FF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0052FF).withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                  // Pin İğne Ucu & Gölgesi
                  Container(
                    width: 4,
                    height: 8,
                    color: const Color(0xFF0052FF),
                  ),
                  Container(
                    width: 14,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 3. ÜST ARAMA ÇUBUĞU & SÜRÜKLEME UYARISI ───────────────────────
          Positioned(
            top: 14,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Arama Kutusu
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.r12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'İlçe veya şehir ara',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(LucideIcons.search, size: 18, color: Color(0xFF94A3B8)),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: Color(0xFF94A3B8)),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Sürükleme İpucu Yazısı
                if (!_isSearching)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Konumu seçmek için haritayı sürükleyin',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── 4. ARAMA SONUÇLARI AÇILIR LİSTESİ ─────────────────────────────
          if (_isSearching)
            Positioned(
              top: 70,
              left: 20,
              right: 20,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 260),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.r16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shrinkWrap: true,
                  itemCount: _filteredLocations.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  itemBuilder: (context, index) {
                    final item = _filteredLocations[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(LucideIcons.mapPin, size: 16, color: Color(0xFF0052FF)),
                      title: Text(
                        item,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedLocation = item;
                          _searchController.clear();
                          _isSearching = false;
                        });
                      },
                    );
                  },
                ),
              ),
            ),

          // ── 5. SAĞ ALT MEVCUT KONUM (GPS) FAB BUTONU ─────────────────────
          Positioned(
            right: 20,
            bottom: 160,
            child: FloatingActionButton.small(
              heroTag: 'gps_btn',
              backgroundColor: Colors.white,
              elevation: 4,
              shape: const CircleBorder(),
              onPressed: () {
                setState(() {
                  _mapOffset = const Offset(-80, -60);
                  _selectedLocation = 'Meram, Konya';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mevcut GPS konumuna odaklanıldı.'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: const Icon(Icons.my_location, color: Color(0xFF0052FF), size: 20),
            ),
          ),

          // ── 6. ALT BİLGİ VE ONAY KARTI (RABAM BİREBİR) ─────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gri Seçilen Konum Kutusu
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Seçilen Konum',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _selectedLocation,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Konumu Onayla Butonu (Mavi / Rabam Stili)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052FF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context, _selectedLocation);
                      },
                      child: const Text(
                        'Konumu Onayla',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// VEKTÖREL STİLİZE HARİTA ÇİZİCİSİ (STREETS, BLOCKS, POIS)
// ══════════════════════════════════════════════════════════════════════════════

class _StylizedMapPainter extends CustomPainter {
  final Offset offset;

  _StylizedMapPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Harita Arka Planı (Açık Krem / Gri Harita Tonu)
    final bgPaint = Paint()..color = const Color(0xFFF8F9FA);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    // 2. Park / Yeşil Alanlar
    final parkPaint = Paint()..color = const Color(0xFFDCFCE7);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(320, 40, 160, 140), const Radius.circular(16)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(80, 440, 180, 160), const Radius.circular(16)), parkPaint);

    // 3. Yapı / Ada Blokları (Building Polygons)
    final blockPaint = Paint()..color = const Color(0xFFF1F5F9);
    for (double x = 40; x < 600; x += 90) {
      for (double y = 60; y < 700; y += 80) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 70, 60), const Radius.circular(8)),
          blockPaint,
        );
      }
    }

    // 4. İkincil Sokaklar (Sokak Çizgileri)
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final roadBorderPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke;

    // Çapraz ve Dikey Sokaklar
    final paths = [
      Path()..moveTo(0, 100)..lineTo(600, 500),
      Path()..moveTo(100, 0)..lineTo(200, 700),
      Path()..moveTo(300, 0)..lineTo(400, 700),
      Path()..moveTo(0, 300)..lineTo(600, 200),
      Path()..moveTo(0, 500)..lineTo(600, 400),
    ];

    for (final p in paths) {
      canvas.drawPath(p, roadBorderPaint);
      canvas.drawPath(p, roadPaint);
    }

    // 5. Ana Caddeler (Sarı / Turuncu Vurgulu Ana Yol - ALAKOVA CD.)
    final mainAvenueBorder = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke;

    final mainAvenueFill = Paint()
      ..color = const Color(0xFFFFFBEB)
      ..strokeWidth = 22
      ..style = PaintingStyle.stroke;

    final mainAvenuePath = Path()..moveTo(40, 0)..lineTo(240, 700);
    canvas.drawPath(mainAvenuePath, mainAvenueBorder);
    canvas.drawPath(mainAvenuePath, mainAvenueFill);

    // 6. Cadde & Sokak İsimleri (Text Labels)
    _drawRotatedText(canvas, 'ALAKOVA CD.', const Offset(100, 240), -0.9);
    _drawRotatedText(canvas, '15450. SK.', const Offset(210, 310), -0.7);
    _drawRotatedText(canvas, '15443. SK.', const Offset(260, 320), -0.7);
    _drawRotatedText(canvas, 'ALTINBAŞAK CD.', const Offset(320, 260), -0.7);

    // 7. Örnek POI İşareti (Alakova Unlu Mamulleri)
    final poiBg = Paint()..color = const Color(0xFFF97316);
    canvas.drawCircle(const Offset(160, 380), 9, poiBg);
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '🍞 Alakova Unlu Mamulleri',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, const Offset(175, 374));

    canvas.restore();
  }

  void _drawRotatedText(Canvas canvas, String text, Offset position, double radians) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(radians);
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF64748B),
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _StylizedMapPainter oldDelegate) {
    return oldDelegate.offset != offset;
  }
}
