import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/tcc_exercise.dart';

/// Página de exercícios TCC
class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terapia & Exercícios')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildFeaturedExercise(context),

          const SizedBox(height: 24),
          Text('Respiração', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...ExercisesList.breathingExercises.map((e) => _ExerciseCard(exercise: e)),

          const SizedBox(height: 24),
          Text('Exercícios Cognitivos', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...ExercisesList.cognitiveExercises.map((e) => _ExerciseCard(exercise: e)),

          const SizedBox(height: 24),
          Text('Sons Relaxantes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          _SoundCard(
            title: 'Chuva Suave',
            duration: 'Infinito',
            icon: Icons.thunderstorm,
            color: Colors.blueGrey,
            onTap: () => context.push(Routes.meditationPlayer('rain_ambience')),
          ),
          const SizedBox(height: 12),
          _SoundCard(
            title: 'Floresta Calma',
            duration: 'Infinito',
            icon: Icons.forest,
            color: Colors.green,
            onTap: () => context.push(Routes.meditationPlayer('forest_sounds')),
          ),
          const SizedBox(height: 12),
          _SoundCard(
            title: 'Relaxamento Guiado',
            duration: '15 min',
            icon: Icons.self_improvement,
            color: Colors.purple,
            onTap: () => context.push(Routes.meditationPlayer('guided_relax')),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFeaturedExercise(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.air, color: Colors.white, size: 28)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Exercício Rápido', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)), const Text('Técnica 4-7-8', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))])),
            ],
          ),
          const SizedBox(height: 16),
          const Text('A técnica mais eficaz para acalmar rapidamente. 5 minutos apenas.', style: TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () => context.push(Routes.breathingExercise('breathing_478')), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary), child: const Text('Começar Agora')),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final TCCExercise exercise;

  const _ExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: exercise.type.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(exercise.type.icon, color: exercise.type.color)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('${exercise.durationMinutes} min • ${exercise.difficulty.displayName}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondaryLight)),
              ],
            ),
          ),
          if (exercise.isPremium) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text('PRO', style: TextStyle(color: AppColors.warning, fontSize: 10, fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}

class _SoundCard extends StatelessWidget {
  final String title;
  final String duration;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SoundCard({
    required this.title,
    required this.duration,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    duration,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: color,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
