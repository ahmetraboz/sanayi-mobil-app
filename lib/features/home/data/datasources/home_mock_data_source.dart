import '../models/campaign_banner_model.dart';
import '../models/service_category_model.dart';

/// Gerçekçi Mock Veri Kaynağı (Rabam Tasarımına Birebir Uygun)
class HomeMockDataSource {
  Future<List<CampaignBannerModel>> fetchBanners() async {
    // Gerçek API gecikmesini simüle etmek için kısa bir gecikme
    await Future.delayed(const Duration(milliseconds: 300));

    return const [
      CampaignBannerModel(
        id: 'banner_1',
        title: "Türkiye'nin her yerinde tertemiz bir sürüş!",
        subtitle: "5'li Yıkama 2.500 TL + 1.000 TL Yakıt Hediye!",
        discountCode: 'İND1000',
        priceHighlight: '300 TL',
        giftHighlight: '1.000 TL HEDİYE',
        badgeText: '5 AY GEÇERLİ',
        imageUrl: 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?auto=format&fit=crop&w=1200&q=80',
      ),
      CampaignBannerModel(
        id: 'banner_2',
        title: 'Periyodik Bakımda %30 İndirim Fırsatı!',
        subtitle: 'Yetkili ve uzman sanayi ustalarından güvenilir servis.',
        discountCode: 'BAKIM30',
        priceHighlight: '%30 İNDİRİM',
        giftHighlight: 'Ücretsiz Check-Up',
        badgeText: 'SINIRLI SÜRE',
        imageUrl: 'https://images.unsplash.com/photo-1486006920555-c77dce18193b?auto=format&fit=crop&w=1200&q=80',
      ),
      CampaignBannerModel(
        id: 'banner_3',
        title: 'Lastik Değişim ve Otel Hizmetleri',
        subtitle: '4 Lastik Alana Ücretsiz Balans ve 1 Sezon Lastik Oteli.',
        discountCode: 'LASTIK2026',
        priceHighlight: 'ÜCRETSİZ OTEL',
        giftHighlight: 'Balans Hediyeli',
        badgeText: 'YENİ SEZON',
        imageUrl: 'https://images.unsplash.com/photo-1578844251758-2f71da64c96f?auto=format&fit=crop&w=1200&q=80',
      ),
    ];
  }

  Future<List<ServiceCategoryModel>> fetchServices() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return const [
      ServiceCategoryModel(
        id: 'service_maintenance',
        title: 'Bakım',
        description: 'Periyodik ve mekanik araç bakımı',
        imageUrl: 'https://images.unsplash.com/photo-1486006920555-c77dce18193b?auto=format&fit=crop&w=600&q=80',
        isPopular: true,
      ),
      ServiceCategoryModel(
        id: 'service_wash',
        title: 'Araç\nYıkama',
        description: 'İç, dış ve detaylı oto kuaför',
        imageUrl: 'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?auto=format&fit=crop&w=600&q=80',
        isPopular: true,
      ),
      ServiceCategoryModel(
        id: 'service_tires',
        title: 'Lastik\nHizmetleri',
        description: 'Lastik değişimi, balans & otel',
        imageUrl: 'https://images.unsplash.com/photo-1578844251758-2f71da64c96f?auto=format&fit=crop&w=600&q=80',
      ),
      ServiceCategoryModel(
        id: 'service_fuel',
        title: 'Akaryakıt\nAlımı',
        description: 'İndirimli yakıt ve istasyon ağı',
        imageUrl: 'https://images.unsplash.com/photo-1545454675-3531b543be5d?auto=format&fit=crop&w=600&q=80',
      ),
      ServiceCategoryModel(
        id: 'service_packages',
        title: 'Avantajlı\nPaketler',
        description: 'Kombine sanayi tasarruf paketleri',
        imageUrl: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?auto=format&fit=crop&w=600&q=80',
        badge: 'Fırsat',
      ),
      ServiceCategoryModel(
        id: 'service_towing',
        title: 'Çekici &\nYol Yardım',
        description: '7/24 En yakın çekici ve kurtarıcı',
        imageUrl: 'https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&w=600&q=80',
      ),
      ServiceCategoryModel(
        id: 'service_insurance',
        title: 'Sigorta &\nKasko',
        description: 'Trafik sigortası ve kasko teklifleri',
        imageUrl: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=600&q=80',
      ),
      ServiceCategoryModel(
        id: 'service_expertise',
        title: 'Ekspertiz\nRaporu',
        description: 'TSE onaylı kapsamlı oto ekspertiz',
        imageUrl: 'https://images.unsplash.com/photo-1580273916550-e323be2ae537?auto=format&fit=crop&w=600&q=80',
      ),
    ];
  }
}
