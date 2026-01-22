import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Página de configurações
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection(context, 'Conta', [
            _SettingsItem(icon: Icons.person, title: 'Editar Perfil', onTap: () {}),
            _SettingsItem(icon: Icons.smoking_rooms, title: 'Dados de Fumo', subtitle: '20 cigarros/dia', onTap: () {}),
            _SettingsItem(icon: Icons.flag, title: 'Meta', subtitle: 'Parar completamente', onTap: () {}),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Notificações', [
            _SettingsItem(icon: Icons.notifications, title: 'Lembretes', trailing: Switch(value: true, onChanged: (_) {})),
            _SettingsItem(icon: Icons.wb_sunny, title: 'Check-in Matinal', subtitle: '08:00', onTap: () {}),
            _SettingsItem(icon: Icons.nightlight, title: 'Check-in Noturno', subtitle: '20:00', onTap: () {}),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Aparência', [
            _SettingsItem(icon: Icons.dark_mode, title: 'Tema Escuro', trailing: Switch(value: false, onChanged: (_) {})),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Premium', [
            _SettingsItem(icon: Icons.star, title: 'Assinar Premium', subtitle: 'Desbloquear todos recursos', iconColor: AppColors.warning, onTap: () {}),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Suporte', [
            _SettingsItem(icon: Icons.help, title: 'Ajuda & FAQ', onTap: () {}),
            _SettingsItem(icon: Icons.privacy_tip, title: 'Privacidade', onTap: () {}),
            _SettingsItem(icon: Icons.description, title: 'Termos de Uso', onTap: () {}),
          ]),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Sair da Conta', style: TextStyle(color: AppColors.error)),
            ),
          ),
          const SizedBox(height: 16),
          Center(child: Text('QuitNow Pro v1.0.0', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondaryLight))),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textSecondaryLight)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsItem({required this.icon, required this.title, this.subtitle, this.iconColor, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
