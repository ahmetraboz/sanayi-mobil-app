/// Kullanıcı Profil Veri Modeli
class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String initials;
  final String referralCode;
  final double balance;
  final String? avatarUrl;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.initials,
    required this.referralCode,
    required this.balance,
    this.avatarUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      initials: json['initials'] as String,
      referralCode: json['referralCode'] as String,
      balance: (json['balance'] as num).toDouble(),
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'initials': initials,
      'referralCode': referralCode,
      'balance': balance,
      'avatarUrl': avatarUrl,
    };
  }
}
