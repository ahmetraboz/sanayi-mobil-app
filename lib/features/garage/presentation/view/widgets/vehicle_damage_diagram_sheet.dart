import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';

/// Araç Parça Hasar Durumu
enum DamageStatus {
  original('Orijinal', Color(0xFFE8EDF5), Color(0xFF94A3B8)),
  localPainted('Lokal Boyalı', Color(0xFFFDE68A), Color(0xFFD97706)),
  painted('Boyalı', Color(0xFFFDBA74), Color(0xFFEA580C)),
  changed('Değişmiş', Color(0xFFFCA5A5), Color(0xFFDC2626)),
  repaired('Tamir Görmüş', Color(0xFFA7F3D0), Color(0xFF059669)),
  processed('İşlem Görmüş', Color(0xFFDDD6FE), Color(0xFF7C3AED));

  final String label;
  final Color fillColor;
  final Color borderColor;

  const DamageStatus(this.label, this.fillColor, this.borderColor);
}

/// Birebir Rabam Açılmış Ekspertiz Şeması Modalı
class VehicleDamageDiagramSheet extends StatefulWidget {
  final String? initialSummary;
  final ValueChanged<String> onSave;

  const VehicleDamageDiagramSheet({
    super.key,
    this.initialSummary,
    required this.onSave,
  });

  static Future<String?> show({
    required BuildContext context,
    String? initialSummary,
    required ValueChanged<String> onSave,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VehicleDamageDiagramSheet(
        initialSummary: initialSummary,
        onSave: onSave,
      ),
    );
  }

  @override
  State<VehicleDamageDiagramSheet> createState() => _VehicleDamageDiagramSheetState();
}

class _VehicleDamageDiagramSheetState extends State<VehicleDamageDiagramSheet> {
  late Map<String, DamageStatus> _partStatuses;
  bool _isAllOriginal = true;
  String? _selectedPartKey;

  static const Map<String, String> _partNames = {
    'on_tampon': 'Ön Tampon',
    'on_kaput': 'Motor Kaputu',
    'tavan': 'Tavan',
    'bagaj': 'Bagaj Kapağı',
    'arka_tampon': 'Arka Tampon',
    'sol_on_camurluk': 'Sol Ön Çamurluk',
    'sol_on_kapi': 'Sol Ön Kapı',
    'sol_arka_kapi': 'Sol Arka Kapı',
    'sol_arka_camurluk': 'Sol Arka Çamurluk',
    'sag_on_camurluk': 'Sağ Ön Çamurluk',
    'sag_on_kapi': 'Sağ Ön Kapı',
    'sag_arka_kapi': 'Sağ Arka Kapı',
    'sag_arka_camurluk': 'Sağ Arka Çamurluk',
  };

  @override
  void initState() {
    super.initState();
    _partStatuses = {for (final key in _partNames.keys) key: DamageStatus.original};

    if (widget.initialSummary != null &&
        widget.initialSummary != 'Tamamı orijinaldir' &&
        widget.initialSummary!.isNotEmpty) {
      _isAllOriginal = false;
    }
  }

  void _onPartTapped(String partKey) {
    setState(() {
      _selectedPartKey = partKey;
    });

    final partName = _partNames[partKey] ?? partKey;
    final currentStatus = _partStatuses[partKey] ?? DamageStatus.original;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    partName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Parçanın hasar / boya durumunu belirleyin:',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              ...DamageStatus.values.map((status) {
                final isSelected = status == currentStatus;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  leading: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: status.fillColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: status.borderColor, width: 2),
                    ),
                  ),
                  title: Text(
                    status.label,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary, size: 20)
                      : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _partStatuses[partKey] = status;
                      _checkAllOriginal();
                    });
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _checkAllOriginal() {
    final allOrig = _partStatuses.values.every((s) => s == DamageStatus.original);
    setState(() {
      _isAllOriginal = allOrig;
    });
  }

  void _toggleAllOriginal(bool? value) {
    if (value == true) {
      setState(() {
        _isAllOriginal = true;
        _partStatuses = {for (final key in _partNames.keys) key: DamageStatus.original};
      });
    } else {
      setState(() {
        _isAllOriginal = false;
      });
    }
  }

  String _calculateSummary() {
    if (_isAllOriginal || _partStatuses.values.every((s) => s == DamageStatus.original)) {
      return 'Tamamı orijinaldir';
    }

    int paintedCount = 0;
    int localCount = 0;
    int changedCount = 0;
    int repairedCount = 0;

    _partStatuses.forEach((key, status) {
      if (status == DamageStatus.painted) paintedCount++;
      if (status == DamageStatus.localPainted) localCount++;
      if (status == DamageStatus.changed) changedCount++;
      if (status == DamageStatus.repaired || status == DamageStatus.processed) repairedCount++;
    });

    List<String> parts = [];
    if (changedCount > 0) parts.add('$changedCount Değişen');
    if (paintedCount > 0) parts.add('$paintedCount Boyalı');
    if (localCount > 0) parts.add('$localCount Lokal Boyalı');
    if (repairedCount > 0) parts.add('$repairedCount Onarımlı');

    if (parts.isEmpty) return 'Tamamı orijinaldir';
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.94,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Sürükleme Çubuğu
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

          // Başlık Çubuğu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Boya - Değişen - Tramer',
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

          const Divider(height: 8, color: Color(0xFFE2E8F0)),

          // Gövde
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Column(
                children: [
                  // 1. Bilgilendirme Kutusu
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.r12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(LucideIcons.info, size: 16, color: Color(0xFF64748B)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Değiştirmek istediğin parçayı seçerek durumunu güncelleyebilirsin.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 2. Birebir Rabam Ekspertiz Şeması
                  Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.r20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: AppDimensions.cardShadow,
                      ),
                      child: _RabamExplodedCarDiagram(
                        partStatuses: _partStatuses,
                        selectedPartKey: _selectedPartKey,
                        onPartTapped: _onPartTapped,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 3. Renk Açıklamaları (Legend)
                  _buildLegend(),

                  const SizedBox(height: 14),

                  // 4. "Tüm parçaları orijinaldir" Checkbox'ı
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.r12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isAllOriginal,
                          activeColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: _toggleAllOriginal,
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            'Aracın tüm parçaları orijinaldir',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Kaydet Butonu
          Container(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 10 + MediaQuery.of(context).padding.bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final summary = _calculateSummary();
                  widget.onSave(summary);
                  Navigator.pop(context, summary);
                },
                child: const Text(
                  'Kaydet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem(DamageStatus.original),
            const SizedBox(width: 10),
            _legendItem(DamageStatus.localPainted),
            const SizedBox(width: 10),
            _legendItem(DamageStatus.painted),
            const SizedBox(width: 10),
            _legendItem(DamageStatus.changed),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem(DamageStatus.repaired),
            const SizedBox(width: 12),
            _legendItem(DamageStatus.processed),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(DamageStatus status) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: status.fillColor,
            shape: BoxShape.circle,
            border: Border.all(color: status.borderColor, width: 1.2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          status.label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// RABAM BİREBİR AÇILMIŞ EKSPERTİZ ŞEMASI ÇİZİCİSİ (EXPLODED VEHICLE BLUEPRINT)
// ══════════════════════════════════════════════════════════════════════════════

class _RabamExplodedCarDiagram extends StatelessWidget {
  final Map<String, DamageStatus> partStatuses;
  final String? selectedPartKey;
  final ValueChanged<String> onPartTapped;

  const _RabamExplodedCarDiagram({
    required this.partStatuses,
    this.selectedPartKey,
    required this.onPartTapped,
  });

  @override
  Widget build(BuildContext context) {
    const double canvasWidth = 290;
    const double canvasHeight = 400;

    return Center(
      child: GestureDetector(
        onTapUp: (details) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final localOffset = box.globalToLocal(details.globalPosition);

          final hitKey = _findHitPartKey(localOffset, canvasWidth, canvasHeight);
          if (hitKey != null) {
            onPartTapped(hitKey);
          }
        },
        child: CustomPaint(
          size: const Size(canvasWidth, canvasHeight),
          painter: _RabamExplodedCarPainter(
            partStatuses: partStatuses,
            selectedPartKey: selectedPartKey,
          ),
        ),
      ),
    );
  }

  String? _findHitPartKey(Offset offset, double width, double height) {
    final paths = _RabamExplodedCarPainter.generatePartPaths(width, height);
    for (final entry in paths.entries) {
      if (entry.value.contains(offset)) {
        return entry.key;
      }
    }
    return null;
  }
}

class _RabamExplodedCarPainter extends CustomPainter {
  final Map<String, DamageStatus> partStatuses;
  final String? selectedPartKey;

  _RabamExplodedCarPainter({
    required this.partStatuses,
    this.selectedPartKey,
  });

  static Map<String, Path> generatePartPaths(double w, double h) {
    final paths = <String, Path>{};
    final cx = w * 0.5;

    // ── 1. ÖN VE ARKA TAMPONLAR ──────────────────────────────────────────────
    // Ön Tampon (Pill bar)
    paths['on_tampon'] = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, h * 0.05), width: w * 0.38, height: h * 0.055),
        const Radius.circular(8),
      ));

    // Arka Tampon (Pill bar)
    paths['arka_tampon'] = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, h * 0.94), width: w * 0.38, height: h * 0.055),
        const Radius.circular(8),
      ));

    // ── 2. MERKEZ GÖVDE SÜTUNU (KAPUT + TAVAN + BAGAJ) ───────────────────────
    // Ön Kaput (Öne doğru daralan, burun kavisli)
    paths['on_kaput'] = Path()
      ..moveTo(cx - w * 0.17, h * 0.12)
      ..cubicTo(cx - w * 0.15, h * 0.10, cx + w * 0.15, h * 0.10, cx + w * 0.17, h * 0.12)
      ..cubicTo(cx + w * 0.22, h * 0.20, cx + w * 0.22, h * 0.32, cx + w * 0.21, h * 0.40)
      ..lineTo(cx - w * 0.21, h * 0.40)
      ..cubicTo(cx - w * 0.22, h * 0.32, cx - w * 0.22, h * 0.20, cx - w * 0.17, h * 0.12)
      ..close();

    // Tavan (Gövde ortası, ince bel kavisli)
    paths['tavan'] = Path()
      ..moveTo(cx - w * 0.205, h * 0.41)
      ..lineTo(cx + w * 0.205, h * 0.41)
      ..cubicTo(cx + w * 0.225, h * 0.48, cx + w * 0.225, h * 0.58, cx + w * 0.205, h * 0.65)
      ..lineTo(cx - w * 0.205, h * 0.65)
      ..cubicTo(cx - w * 0.225, h * 0.58, cx - w * 0.225, h * 0.48, cx - w * 0.205, h * 0.41)
      ..close();

    // Bagaj Kapağı (Arkaya doğru daralan, arka kavisli)
    paths['bagaj'] = Path()
      ..moveTo(cx - w * 0.205, h * 0.66)
      ..lineTo(cx + w * 0.205, h * 0.66)
      ..cubicTo(cx + w * 0.22, h * 0.74, cx + w * 0.22, h * 0.82, cx + w * 0.17, h * 0.87)
      ..cubicTo(cx + w * 0.15, h * 0.89, cx - w * 0.15, h * 0.89, cx - w * 0.17, h * 0.87)
      ..cubicTo(cx - w * 0.22, h * 0.82, cx - w * 0.22, h * 0.74, cx - w * 0.205, h * 0.66)
      ..close();

    // ── 3. SOL YAN AÇILMIŞ PROFİL (GERÇEK ARAÇ YAN SİLUETİ) ───────────────────
    // Sol Ön Çamurluk (Ön Burun + Ön Tekerlek Yuvası Çanağı)
    paths['sol_on_camurluk'] = Path()
      ..moveTo(cx - w * 0.44, h * 0.15)
      ..cubicTo(cx - w * 0.45, h * 0.13, cx - w * 0.41, h * 0.13, cx - w * 0.38, h * 0.14)
      ..cubicTo(cx - w * 0.33, h * 0.16, cx - w * 0.28, h * 0.23, cx - w * 0.25, h * 0.31)
      ..lineTo(cx - w * 0.44, h * 0.31)
      ..lineTo(cx - w * 0.44, h * 0.23)
      // Tekerlek yuvası iç kavis çanağı
      ..arcToPoint(
        Offset(cx - w * 0.44, h * 0.15),
        radius: Radius.circular(w * 0.10),
        clockwise: false,
      )
      ..close();

    // Sol Ön Kapı (A-Sütunu kavisli yan cam çerçeveli panel)
    paths['sol_on_kapi'] = Path()
      ..moveTo(cx - w * 0.45, h * 0.32)
      ..lineTo(cx - w * 0.24, h * 0.32)
      ..lineTo(cx - w * 0.23, h * 0.49)
      ..lineTo(cx - w * 0.45, h * 0.49)
      ..close();

    // Sol Arka Kapı (B/C-Sütunu kavisli yan cam çerçeveli panel)
    paths['sol_arka_kapi'] = Path()
      ..moveTo(cx - w * 0.45, h * 0.50)
      ..lineTo(cx - w * 0.23, h * 0.50)
      ..lineTo(cx - w * 0.24, h * 0.67)
      ..lineTo(cx - w * 0.45, h * 0.67)
      ..close();

    // Sol Arka Çamurluk (Arka Tekerlek Yuvası Çanağı + Arka Stop Kuyruğu)
    paths['sol_arka_camurluk'] = Path()
      ..moveTo(cx - w * 0.44, h * 0.68)
      ..lineTo(cx - w * 0.25, h * 0.68)
      ..cubicTo(cx - w * 0.28, h * 0.76, cx - w * 0.33, h * 0.83, cx - w * 0.38, h * 0.85)
      ..cubicTo(cx - w * 0.41, h * 0.86, cx - w * 0.45, h * 0.86, cx - w * 0.44, h * 0.84)
      // Arka tekerlek yuvası iç kavis çanağı
      ..arcToPoint(
        Offset(cx - w * 0.44, h * 0.76),
        radius: Radius.circular(w * 0.10),
        clockwise: false,
      )
      ..lineTo(cx - w * 0.44, h * 0.68)
      ..close();

    // ── 4. SAĞ YAN AÇILMIŞ PROFİL (SİMETRİK GERÇEK ARAÇ YAN SİLUETİ) ─────────
    // Sağ Ön Çamurluk
    paths['sag_on_camurluk'] = Path()
      ..moveTo(cx + w * 0.44, h * 0.15)
      ..cubicTo(cx + w * 0.45, h * 0.13, cx + w * 0.41, h * 0.13, cx + w * 0.38, h * 0.14)
      ..cubicTo(cx + w * 0.33, h * 0.16, cx + w * 0.28, h * 0.23, cx + w * 0.25, h * 0.31)
      ..lineTo(cx + w * 0.44, h * 0.31)
      ..lineTo(cx + w * 0.44, h * 0.23)
      // Tekerlek yuvası
      ..arcToPoint(
        Offset(cx + w * 0.44, h * 0.15),
        radius: Radius.circular(w * 0.10),
        clockwise: true,
      )
      ..close();

    // Sağ Ön Kapı
    paths['sag_on_kapi'] = Path()
      ..moveTo(cx + w * 0.45, h * 0.32)
      ..lineTo(cx + w * 0.24, h * 0.32)
      ..lineTo(cx + w * 0.23, h * 0.49)
      ..lineTo(cx + w * 0.45, h * 0.49)
      ..close();

    // Sağ Arka Kapı
    paths['sag_arka_kapi'] = Path()
      ..moveTo(cx + w * 0.45, h * 0.50)
      ..lineTo(cx + w * 0.23, h * 0.50)
      ..lineTo(cx + w * 0.24, h * 0.67)
      ..lineTo(cx + w * 0.45, h * 0.67)
      ..close();

    // Sağ Arka Çamurluk
    paths['sag_arka_camurluk'] = Path()
      ..moveTo(cx + w * 0.44, h * 0.68)
      ..lineTo(cx + w * 0.25, h * 0.68)
      ..cubicTo(cx + w * 0.28, h * 0.76, cx + w * 0.33, h * 0.83, cx + w * 0.38, h * 0.85)
      ..cubicTo(cx + w * 0.41, h * 0.86, cx + w * 0.45, h * 0.86, cx + w * 0.44, h * 0.84)
      // Arka tekerlek yuvası
      ..arcToPoint(
        Offset(cx + w * 0.44, h * 0.76),
        radius: Radius.circular(w * 0.10),
        clockwise: true,
      )
      ..lineTo(cx + w * 0.44, h * 0.68)
      ..close();

    return paths;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w * 0.5;

    final paths = generatePartPaths(w, h);

    // 1. TÜM PARÇALARI ÇİZME
    paths.forEach((key, path) {
      final status = partStatuses[key] ?? DamageStatus.original;
      final isSelected = key == selectedPartKey;

      final fillPaint = Paint()
        ..color = status.fillColor
        ..style = PaintingStyle.fill;

      final strokePaint = Paint()
        ..color = isSelected ? const Color(0xFF2563EB) : (status == DamageStatus.original ? const Color(0xFFCBD5E1) : status.borderColor)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 2.5 : 1.2;

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    });

    // 2. İÇ DETAY ÇİZGİLERİ (Ön Far Bölmeleri, Arka Stoplar, Cam Çerçeveleri)
    final detailStroke = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Ön Burun / Izgara Çizgisi
    canvas.drawLine(Offset(cx - w * 0.14, h * 0.16), Offset(cx + w * 0.14, h * 0.16), detailStroke);
    canvas.drawLine(Offset(cx - w * 0.05, h * 0.105), Offset(cx - w * 0.05, h * 0.16), detailStroke);
    canvas.drawLine(Offset(cx + w * 0.05, h * 0.105), Offset(cx + w * 0.05, h * 0.16), detailStroke);

    // Ön Cam Ayırıcı Çizgi (Windshield)
    canvas.drawLine(Offset(cx - w * 0.19, h * 0.33), Offset(cx + w * 0.19, h * 0.33), detailStroke);

    // Arka Cam Ayırıcı Çizgi
    canvas.drawLine(Offset(cx - w * 0.19, h * 0.73), Offset(cx + w * 0.19, h * 0.73), detailStroke);

    // Arka Stop / Bagaj Uç Bölmesi
    canvas.drawLine(Offset(cx - w * 0.14, h * 0.83), Offset(cx + w * 0.14, h * 0.83), detailStroke);
    canvas.drawLine(Offset(cx - w * 0.05, h * 0.83), Offset(cx - w * 0.05, h * 0.88), detailStroke);
    canvas.drawLine(Offset(cx + w * 0.05, h * 0.83), Offset(cx + w * 0.05, h * 0.88), detailStroke);

    // 3. TAVAN SUNROOF HALKASI
    final sunroofStroke = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(Offset(cx, h * 0.58), 13, sunroofStroke);

    // 4. SOL & SAĞ YAN CAM ÇERÇEVE ÇİZGİLERİ (A-B-C Sütunları)
    // Sol kapı camları
    final solCamPath = Path()
      ..moveTo(cx - w * 0.41, h * 0.34)
      ..lineTo(cx - w * 0.28, h * 0.34)
      ..lineTo(cx - w * 0.28, h * 0.47)
      ..lineTo(cx - w * 0.41, h * 0.47)
      ..close();
    canvas.drawPath(solCamPath, detailStroke);

    final solArkaCamPath = Path()
      ..moveTo(cx - w * 0.41, h * 0.52)
      ..lineTo(cx - w * 0.28, h * 0.52)
      ..lineTo(cx - w * 0.28, h * 0.65)
      ..lineTo(cx - w * 0.41, h * 0.65)
      ..close();
    canvas.drawPath(solArkaCamPath, detailStroke);

    // Sağ kapı camları
    final sagCamPath = Path()
      ..moveTo(cx + w * 0.41, h * 0.34)
      ..lineTo(cx + w * 0.28, h * 0.34)
      ..lineTo(cx + w * 0.28, h * 0.47)
      ..lineTo(cx + w * 0.41, h * 0.47)
      ..close();
    canvas.drawPath(sagCamPath, detailStroke);

    final sagArkaCamPath = Path()
      ..moveTo(cx + w * 0.41, h * 0.52)
      ..lineTo(cx + w * 0.28, h * 0.52)
      ..lineTo(cx + w * 0.28, h * 0.65)
      ..lineTo(cx + w * 0.41, h * 0.65)
      ..close();
    canvas.drawPath(sagArkaCamPath, detailStroke);
  }

  @override
  bool shouldRepaint(covariant _RabamExplodedCarPainter oldDelegate) {
    return oldDelegate.partStatuses != partStatuses || oldDelegate.selectedPartKey != selectedPartKey;
  }
}
