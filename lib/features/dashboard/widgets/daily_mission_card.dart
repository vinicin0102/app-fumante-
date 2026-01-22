import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Card de missão diária
class DailyMissionCard extends StatelessWidget {
  const DailyMissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.flag, color: AppColors.accent, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Missão do Dia', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text('+50 XP ao completar', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.accent)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _MissionItem(title: 'Registrar no diário', isCompleted: false),
          const SizedBox(height: 12),
          _MissionItem(title: 'Fazer exercício de respiração', isCompleted: true),
          const SizedBox(height: 12),
          _MissionItem(title: 'Verificar progresso', isCompleted: true),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 2 / 3,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 10,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text('2/3', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MissionItem extends StatelessWidget {
  final String title;
  final bool isCompleted;

  const _MissionItem({required this.title, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.successBg : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.success : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: isCompleted ? AppColors.success : AppColors.textSecondaryLight, width: 2),
            ),
            child: isCompleted ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted ? AppColors.success : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
