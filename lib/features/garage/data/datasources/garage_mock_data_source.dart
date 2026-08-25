import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_model.dart';
import 'package:sanayi_mobil_app/features/garage/data/models/vehicle_service_record_model.dart';

/// Garaj Mock Veri Kaynağı (Canlı Ekleme/Güncelleme/Silme ve Hizmet Geçmişi Destekli)
class GarageMockDataSource {
  final List<VehicleModel> _vehicles = [
    const VehicleModel(
      id: 'veh_001',
      plate: '34 SAN 2026',
      brand: 'Volkswagen',
      model: 'Golf',
      year: '2023',
      variant: '1.5 eTSI R-Line',
      vehicleType: 'car',
      mileage: 45250,
      lastMaintenanceKm: '45.000 KM',
      inspectionDate: '14.11.2026',
      isInsuranceActive: true,
      fuelType: 'Benzin (Mild Hybrid)',
      transmission: 'Otomatik (DSG)',
      color: 'Yunus Grisi',
      chassisNumber: 'WVWZZZCDZPW129841',
      enginePower: '150 HP',
      engineDisplacement: '1498 cc',
      trafficInsuranceDate: '05.10.2026',
      kaskoDate: '05.10.2026',
      tramerInfo: 'Tamamı orijinaldir',
      documents: {
        'Ruhsat': 'ruhsat_34san2026.pdf',
        'Trafik Sigortası': 'trafik_sigortasi_2026.pdf',
      },
      serviceRecords: [
        VehicleServiceRecordModel(
          id: 'srv_001',
          vehicleId: 'veh_001',
          serviceName: '45.000 KM Periyodik Bakım',
          category: 'maintenance',
          date: '12.05.2026',
          mileageAtService: 45000,
          serviceProvider: 'SanayiGO Yetkili Servis Merkezi - Kartal',
          cost: 3850.0,
          invoiceNo: 'SNY-2026-08941',
          notes: 'Motor yağı, filtreler ve fren hidrolik sıvısı yenilendi. Balatalar kontrol edildi.',
          items: [
            'Castrol EDGE 5W-30 LL Motor Yağı (4 Litre)',
            'Orijinal Yağ Filtresi',
            'Orijinal Hava Filtresi',
            'Aktif Karbonlu Polen Filtresi',
            'DOT-4 Fren Hidrolik Sıvısı',
            '30 Nokta Genel Güvenlik Kontrolü',
          ],
          status: 'completed',
        ),
        VehicleServiceRecordModel(
          id: 'srv_002',
          vehicleId: 'veh_001',
          serviceName: 'Yazlık Lastik Montajı & Balans Ayarı',
          category: 'tires',
          date: '02.04.2026',
          mileageAtService: 43200,
          serviceProvider: 'SanayiGO Michelin Bayii - Maslak',
          cost: 850.0,
          invoiceNo: 'SNY-2026-06120',
          notes: '4 adet kışlık lastik depolama oteline alındı, yazlık lastikler takıldı ve 4 teker rot-balans yapıldı.',
          items: [
            '4 Adet Lastik Sökme-Takma',
            'Ön & Arka Hassas Balans Ayarı',
            'Lastik Oteli Depolama (1 Sezon)',
          ],
          status: 'completed',
        ),
        VehicleServiceRecordModel(
          id: 'srv_003',
          vehicleId: 'veh_001',
          serviceName: 'Detaylı İç & Dış Nano Yıkama',
          category: 'wash',
          date: '20.03.2026',
          mileageAtService: 42800,
          serviceProvider: 'SanayiGO AutoSpa & Detailing - Bostancı',
          cost: 650.0,
          invoiceNo: 'SNY-2026-05441',
          notes: 'Seramik katkılı şampuan ile çift kova yıkama, deri koltuk bakımı ve ozonla dezenfeksiyon yapıldı.',
          items: [
            'Ph Nötr Çift Kova Dış Yıkama',
            'İç Detaylı Süpürme ve Toz Alma',
            'Deri ve Vinil Koruyucu Bakım',
            'Ozon Gazı ile Antibakteriyel Klima Temizliği',
          ],
          status: 'completed',
        ),
        VehicleServiceRecordModel(
          id: 'srv_004',
          vehicleId: 'veh_001',
          serviceName: 'Ön Fren Balata Değişimi',
          category: 'repair',
          date: '18.11.2025',
          mileageAtService: 36400,
          serviceProvider: 'SanayiGO Fren & Mekanik Servisi - Ümraniye',
          cost: 2100.0,
          invoiceNo: 'SNY-2025-11902',
          notes: 'Ön fren balataları aşındığı için Brembo marka orijinal parça ile yenilendi. Diskler taşlandı.',
          items: [
            'Brembo Ön Fren Balata Takımı',
            'Ön Fren Disk Yüzey Temizliği',
            'Fren Kaliper Piston Yağlaması',
          ],
          status: 'completed',
        ),
      ],
    ),
  ];

  Future<List<VehicleModel>> fetchVehicles() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_vehicles);
  }

  Future<VehicleModel> insertVehicle(VehicleModel vehicle) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _vehicles.add(vehicle);
    return vehicle;
  }

  Future<VehicleModel> updateVehicle(VehicleModel updatedVehicle) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _vehicles.indexWhere((v) => v.id == updatedVehicle.id);
    if (index != -1) {
      _vehicles[index] = updatedVehicle;
      return updatedVehicle;
    }
    _vehicles.add(updatedVehicle);
    return updatedVehicle;
  }

  Future<void> removeVehicle(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _vehicles.removeWhere((v) => v.id == vehicleId);
  }

  Future<VehicleServiceRecordModel> addServiceRecord(
    String vehicleId,
    VehicleServiceRecordModel record,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _vehicles.indexWhere((v) => v.id == vehicleId);
    if (index != -1) {
      final currentRecords = List<VehicleServiceRecordModel>.from(_vehicles[index].serviceRecords);
      currentRecords.insert(0, record);
      _vehicles[index] = _vehicles[index].copyWith(
        serviceRecords: currentRecords,
        lastMaintenanceKm: record.category == 'maintenance'
            ? '${record.mileageAtService} KM'
            : _vehicles[index].lastMaintenanceKm,
        mileage: record.mileageAtService > _vehicles[index].mileage
            ? record.mileageAtService
            : _vehicles[index].mileage,
      );
    }
    return record;
  }
}
