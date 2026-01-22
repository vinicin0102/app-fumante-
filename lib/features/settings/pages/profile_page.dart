import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';

/// Página de perfil do usuário
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil'), actions: [IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () => context.push(Routes.settings))]),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 24),
          _buildLevelCard(context),
          const SizedBox(height: 24),
          _buildStatsSection(context),
          const SizedBox(height: 24),
          _buildAchievementsSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(width: 100, height: 100, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.person, size: 50, color: AppColors.primary)),
            Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.white, size: 16)),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Usuário', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondaryLight), const SizedBox(width: 4), Text('Membro desde Jan 2026', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondaryLight))]),
      ],
    );
  }

  Widget _buildLevelCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: AppColors.achievementGradient, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.star, color: Colors.white, size: 28)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Nível 5', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), Text('Determinado', style: TextStyle(color: Colors.white.withOpacity(0.9)))])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [const Text('750 XP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text('Próximo: 1000 XP', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12))]),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: 0.75, backgroundColor: Colors.white.withOpacity(0.3), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 8)),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Estatísticas', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _StatCard(icon: Icons.smoke_free, value: '140', label: 'Cigarros evitados', color: AppColors.success)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(icon: Icons.savings, value: 'R\$210', label: 'Economizados', color: AppColors.warning)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _StatCard(icon: Icons.local_fire_department, value: '7', label: 'Maior streak', color: AppColors.accent)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(icon: Icons.favorite, value: '15h', label: 'Vida recuperada', color: AppColors.error)),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievementsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Conquistas', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)), TextButton(onPressed: () {}, child: const Text('Ver todas'))]),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _AchievementBadge(icon: Icons.flag, title: '1º Dia', isUnlocked: true),
              _AchievementBadge(icon: Icons.workspace_premium, title: '1 Semana', isUnlocked: true),
              _AchievementBadge(icon: Icons.military_tech, title: '2 Semanas', isUnlocked: false),
              _AchievementBadge(icon: Icons.emoji_events, title: '1 Mês', isUnlocked: false),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isUnlocked;

  const _AchievementBadge({required this.icon, required this.title, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(width: 56, height: 56, decoration: BoxDecoration(gradient: isUnlocked ? AppColors.achievementGradient : null, color: isUnlocked ? null : Colors.grey.shade200, shape: BoxShape.circle), child: Icon(icon, color: isUnlocked ? Colors.white : Colors.grey)),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 11, color: isUnlocked ? null : Colors.grey)),
        ],
      ),
    );
  }
}
