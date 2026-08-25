import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';
import 'package:sanayi_mobil_app/features/profile/data/models/user_profile_model.dart';
import '../cubit/profile_cubit.dart';

/// Hesap Bilgileri Yönetim ve Düzenleme Ekranı (Hesabı Sil Butonlu)
class AccountInfoView extends StatefulWidget {
  final UserProfileModel user;

  const AccountInfoView({super.key, required this.user});

  @override
  State<AccountInfoView> createState() => _AccountInfoViewState();
}

class _AccountInfoViewState extends State<AccountInfoView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    context.read<ProfileCubit>().updateProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
        );

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hesap bilgileriniz başarıyla güncellendi.'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(LucideIcons.alertTriangle, color: AppColors.error, size: 24),
            SizedBox(width: 10),
            Text(
              'Hesabı Sil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.error),
            ),
          ],
        ),
        content: const Text(
          'Hesabınızı silmek istediğinize emin misiniz?\n\nBu işlem geri alınamaz. Kayıtlı araçlarınız, randevularınız ve SanayiGO cüzdan bakiyeniz kalıcı olarak silinecektir.',
          style: TextStyle(fontSize: 13.5, color: Color(0xFF475569), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProfileCubit>().deleteAccount();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hesabınız başarıyla silindi ve oturum kapatıldı.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Evet, Hesabımı Sil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Hesap Bilgileri',
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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Kullanıcı Bilgileri Formu ────────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppDimensions.p20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.r20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: AppDimensions.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ad Soyad
                    const Text('Ad Soyad', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Ad soyad boş bırakılamaz' : null,
                      decoration: InputDecoration(
                        hintText: 'Ad Soyad',
                        prefixIcon: const Icon(LucideIcons.user, size: 18, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // E-posta
                    const Text('E-posta Adresi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v == null || !v.contains('@')) ? 'Geçerli bir e-posta girin' : null,
                      decoration: InputDecoration(
                        hintText: 'ornek@email.com',
                        prefixIcon: const Icon(LucideIcons.mail, size: 18, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Telefon Numarası
                    const Text('Telefon Numarası', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Telefon numarası girin' : null,
                      decoration: InputDecoration(
                        hintText: '+90 5XX XXX XX XX',
                        prefixIcon: const Icon(LucideIcons.phone, size: 18, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Referans Kodu (Salt Okunur)
                    const Text('Referans / Davet Kodunuz', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.share2, size: 18, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Text(
                            widget.user.referralCode,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: 1),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: widget.user.referralCode));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Referans kodu panoya kopyalandı!'), behavior: SnackBarBehavior.floating),
                              );
                            },
                            child: const Text('Kopyala', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── 3. Değişiklikleri Kaydet Butonu ─────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r16)),
                    elevation: 0,
                  ),
                  onPressed: _isSaving ? null : _saveChanges,
                  child: _isSaving
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'Değişiklikleri Kaydet',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 32),

              // ── 4. Tehlikeli Bölge: Hesabı Sil Butonu ────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.p16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(AppDimensions.r20),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(LucideIcons.alertOctagon, color: AppColors.error, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Hesap Yönetimi ve Gizlilik',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.error),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Hesabınızı ve tüm verilerinizi SanayiGO platformundan kalıcı olarak kaldırmak için aşağıdaki butonu kullanabilirsiniz.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF7F1D1D), height: 1.3),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _showDeleteAccountDialog,
                        icon: const Icon(LucideIcons.trash2, size: 17),
                        label: const Text('Hesabımı Kalıcı Olarak Sil', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
