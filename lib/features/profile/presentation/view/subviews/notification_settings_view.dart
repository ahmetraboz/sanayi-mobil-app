import 'package:flutter/material.dart';
import 'package:sanayi_mobil_app/core/constants/app_colors.dart';
import 'package:sanayi_mobil_app/core/constants/app_dimensions.dart';

/// Bildirim Ayarları Ekranı
class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() => _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  bool _appointmentAlerts = true;
  bool _campaignAlerts = true;
  bool _smsAlerts = true;
  bool _emailNewsletter = false;

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
        title: const Text('Bildirim Ayarları', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF1F5F9), height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.p20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.r20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: AppDimensions.cardShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSwitchTile(
                'Randevu ve Servis Hatırlatıcıları',
                'Yaklaşan bakım ve randevu güncellemeleri',
                _appointmentAlerts,
                (val) => setState(() => _appointmentAlerts = val),
              ),
              const Divider(height: 1, indent: 20, color: Color(0xFFF1F5F9)),
              _buildSwitchTile(
                'Kampanya ve İndirimler',
                'Size özel kupon ve fırsat duyuruları',
                _campaignAlerts,
                (val) => setState(() => _campaignAlerts = val),
              ),
              const Divider(height: 1, indent: 20, color: Color(0xFFF1F5F9)),
              _buildSwitchTile(
                'SMS ile Bilgilendirme',
                'Kritik servis aşamalarında anlık SMS bildirimi',
                _smsAlerts,
                (val) => setState(() => _smsAlerts = val),
              ),
              const Divider(height: 1, indent: 20, color: Color(0xFFF1F5F9)),
              _buildSwitchTile(
                'E-Posta Bülteni',
                'Haftalık araç bakım ipuçları ve yenilikler',
                _emailNewsletter,
                (val) => setState(() => _emailNewsletter = val),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: value,
      activeThumbColor: AppColors.primary,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
    );
  }
}
