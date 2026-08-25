/// Kullanıcı Profil Veri Modeli
class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String initials;
  final String referralCode;
  final double balance;
  final String? avatarUrl;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '+90 532 123 45 67',
    required this.initials,
    required this.referralCode,
    required this.balance,
    this.avatarUrl,
  });

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? initials,
    String? referralCode,
    double? balance,
    String? avatarUrl,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      initials: initials ?? this.initials,
      referralCode: referralCode ?? this.referralCode,
      balance: balance ?? this.balance,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '+90 532 123 45 67',
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
      'phone': phone,
      'initials': initials,
      'referralCode': referralCode,
      'balance': balance,
      'avatarUrl': avatarUrl,
    };
  }
}
