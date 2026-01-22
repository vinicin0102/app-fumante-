import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';

/// Ações rápidas do dashboard
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações Rápidas',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.self_improvement,
                label: 'Exercício',
                color: AppColors.secondary,
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(Routes.exercises);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.edit_note,
                label: 'Diário',
                color: AppColors.info,
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(Routes.journalNew);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.emoji_events,
                label: 'Conquistas',
                color: AppColors.warning,
                onTap: () {
                  HapticFeedback.lightImpact();
                  // Abrir conquistas
                  _showAchievementsSheet(context);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.share,
                label: 'Compartilhar',
                color: AppColors.success,
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showShareSheet(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showAchievementsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AchievementsBottomSheet(),
    );
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ShareBottomSheet(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '🏆 Suas Conquistas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _AchievementBadge(
                  icon: Icons.flag,
                  title: 'Primeiro Dia',
                  isUnlocked: true,
                ),
                _AchievementBadge(
                  icon: Icons.workspace_premium,
                  title: '1 Semana',
                  isUnlocked: true,
                ),
                _AchievementBadge(
                  icon: Icons.military_tech,
                  title: '2 Semanas',
                  isUnlocked: false,
                  progress: 0.5,
                ),
                _AchievementBadge(
                  icon: Icons.emoji_events,
                  title: '1 Mês',
                  isUnlocked: false,
                ),
                _AchievementBadge(
                  icon: Icons.savings,
                  title: 'R\$100 Economizados',
                  isUnlocked: true,
                ),
                _AchievementBadge(
                  icon: Icons.smoke_free,
                  title: '100 Cigarros',
                  isUnlocked: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isUnlocked;
  final double? progress;

  const _AchievementBadge({
    required this.icon,
    required this.title,
    required this.isUnlocked,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: isUnlocked
                    ? AppColors.achievementGradient
                    : null,
                color: isUnlocked ? null : Colors.grey.shade200,
                shape: BoxShape.circle,
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                color: isUnlocked ? Colors.white : Colors.grey.shade400,
                size: 32,
              ),
            ),
            if (progress != null)
              SizedBox(
                width: 78,
                height: 78,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isUnlocked ? null : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}

class _ShareBottomSheet extends StatelessWidget {
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
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Compartilhe sua conquista!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.smoke_free,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
                  '7 dias sem fumar! 🎉',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '140 cigarros evitados • R\$210 economizados',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ShareOption(
                icon: Icons.image,
                label: 'Salvar Imagem',
                onTap: () {},
              ),
              _ShareOption(
                icon: Icons.share,
                label: 'WhatsApp',
                onTap: () {},
              ),
              _ShareOption(
                icon: Icons.copy,
                label: 'Copiar',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
