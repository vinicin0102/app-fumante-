import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/health_benefits.dart';

/// Carrossel horizontal de marcos de saúde
class HealthMilestonesCarousel extends StatelessWidget {
  const HealthMilestonesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    // Pegar os primeiros 6 marcos
    final milestones = HealthBenefits.allMilestones.take(6).toList();
    final currentDays = 7; // Exemplo: 7 dias sem fumar

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Benefícios de Saúde',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  // Ver todos os marcos
                },
                child: const Text('Ver todos'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: milestones.length,
            itemBuilder: (context, index) {
              final milestone = milestones[index];
              final isAchieved = currentDays >= milestone.daysRequired;
              final isNext = !isAchieved &&
                  (index == 0 ||
                      currentDays >= milestones[index - 1].daysRequired);

              return _MilestoneCard(
                milestone: milestone,
                isAchieved: isAchieved,
                isNext: isNext,
                currentDays: currentDays,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final HealthMilestone milestone;
  final bool isAchieved;
  final bool isNext;
  final int currentDays;

  const _MilestoneCard({
    required this.milestone,
    required this.isAchieved,
    required this.isNext,
    required this.currentDays,
  });

  @override
  Widget build(BuildContext context) {
    final progress = isAchieved
        ? 1.0
        : isNext
            ? (currentDays / milestone.daysRequired).clamp(0.0, 1.0)
            : 0.0;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAchieved
            ? AppColors.successBg
            : isNext
                ? Theme.of(context).cardColor
                : Theme.of(context).cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: isNext
            ? Border.all(color: AppColors.primary, width: 2)
            : isAchieved
                ? Border.all(color: AppColors.success.withOpacity(0.3), width: 2)
                : null,
        boxShadow: isNext
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ícone e status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isAchieved
                      ? AppColors.success.withOpacity(0.2)
                      : _getCategoryColor(milestone.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  milestone.icon,
                  color: isAchieved
                      ? AppColors.success
                      : _getCategoryColor(milestone.category),
                  size: 22,
                ),
              ),
              if (isAchieved)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                )
              else if (isNext)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'PRÓXIMO',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Título
          Text(
            milestone.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isAchieved
                  ? AppColors.success
                  : isNext
                      ? AppColors.primary
                      : null,
            ),
          ),

          const SizedBox(height: 4),

          // Descrição
          Expanded(
            child: Text(
              milestone.benefit,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryLight,
                    height: 1.3,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Barra de progresso (apenas para próximo)
          if (isNext) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getCategoryColor(MilestoneCategory category) {
    switch (category) {
      case MilestoneCategory.cardiovascular:
        return AppColors.error;
      case MilestoneCategory.respiratory:
        return AppColors.info;
      case MilestoneCategory.sensorial:
        return AppColors.warning;
      case MilestoneCategory.detox:
        return AppColors.secondary;
      case MilestoneCategory.cancer:
        return AppColors.primary;
      case MilestoneCategory.general:
        return AppColors.success;
    }
  }
}
