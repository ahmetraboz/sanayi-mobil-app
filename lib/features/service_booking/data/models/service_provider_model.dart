/// Bayi / Servis Sağlayıcı Veri Modeli
class ServiceProviderModel {
  final String id;
  final String name;
  final String address;
  final String districtCity;
  final double distanceKm;
  final double rating;
  final int reviewCount;
  final double price;
  final String packageDescription;
  final String imageUrl;
  final List<String> features;
  final double latOffset;
  final double lngOffset;

  const ServiceProviderModel({
    required this.id,
    required this.name,
    required this.address,
    required this.districtCity,
    required this.distanceKm,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.packageDescription,
    required this.imageUrl,
    this.features = const [],
    this.latOffset = 0,
    this.lngOffset = 0,
  });
}
