import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/smoking_profile.dart';

/// Tela de seleção de meta (parar ou reduzir)
class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  UserGoal? _selectedGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Qual é sua meta?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Escolha a opção que mais combina com você agora. Você pode mudar depois!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
              const SizedBox(height: 40),

              // Opção: Parar de fumar
              _buildGoalCard(
                goal: UserGoal.quit,
                title: 'Parar de Fumar',
                description: 'Estou pronto para parar completamente',
                icon: Icons.smoke_free,
                color: AppColors.primary,
                benefits: [
                  'Recuperação de saúde mais rápida',
                  'Economia imediata',
                  'Timer de abstinência desde o dia 1',
                ],
              ),

              const SizedBox(height: 16),

              // Opção: Reduzir gradualmente
              _buildGoalCard(
                goal: UserGoal.reduce,
                title: 'Reduzir Gradualmente',
                description: 'Quero diminuir aos poucos até parar',
                icon: Icons.trending_down,
                color: AppColors.secondary,
                benefits: [
                  'Transição mais suave',
                  'Metas semanais personalizadas',
                  'Menos pressão no início',
                ],
              ),

              const Spacer(),

              // Botão de continuar
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedGoal != null
                      ? () => _continue(context)
                      : null,
                  child: const Text(
                    'Continuar',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required UserGoal goal,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required List<String> benefits,
  }) {
    final isSelected = _selectedGoal == goal;

    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = goal),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(isSelected ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? color : null,
                        ),
                      ),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              ...benefits.map((benefit) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: color, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          benefit,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  void _continue(BuildContext context) {
    // Salvar a meta selecionada e ir para o dashboard
    context.go(Routes.home);
  }
}
