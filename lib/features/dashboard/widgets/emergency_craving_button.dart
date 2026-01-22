import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';

/// Botão de emergência para crises de vontade
class EmergencyCravingButton extends StatelessWidget {
  const EmergencyCravingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          _showEmergencyOptions(context);
        },
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded),
        label: const Text(
          'Crise de Vontade',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    );
  }

  void _showEmergencyOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _EmergencyOptionsSheet(),
    );
  }
}

class _EmergencyOptionsSheet extends StatelessWidget {
  const _EmergencyOptionsSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          const Icon(Icons.favorite, color: AppColors.error, size: 48),
          const SizedBox(height: 16),
          Text('Está com muita vontade?', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('A vontade é passageira. Escolha uma ação:', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondaryLight), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          _EmergencyOption(icon: Icons.self_improvement, title: 'Exercício de Respiração', subtitle: '5 minutos para acalmar', color: Colors.blue, onTap: () => Navigator.pop(context)),
          const SizedBox(height: 12),
          _EmergencyOption(icon: Icons.psychology, title: 'Reestruturação Cognitiva', subtitle: 'Mude seus pensamentos', color: Colors.green, onTap: () => Navigator.pop(context)),
          const SizedBox(height: 12),
          _EmergencyOption(icon: Icons.people, title: 'Falar com Alguém', subtitle: 'Comunidade de apoio', color: Colors.orange, onTap: () => Navigator.pop(context)),
          const SizedBox(height: 12),
          _EmergencyOption(icon: Icons.water_drop, title: 'Beber Água', subtitle: 'Distração simples', color: Colors.cyan, onTap: () => Navigator.pop(context)),
          const SizedBox(height: 24),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Registrar recaída (sem julgamento)', style: TextStyle(color: AppColors.textSecondaryLight))),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _EmergencyOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _EmergencyOption({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)), Text(subtitle, style: Theme.of(context).textTheme.bodySmall)])),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
