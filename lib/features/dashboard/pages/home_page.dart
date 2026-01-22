import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../widgets/time_without_smoking_card.dart';
import '../widgets/stats_grid.dart';
import '../widgets/health_milestones_carousel.dart';
import '../widgets/daily_mission_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/emergency_craving_button.dart';

/// Dashboard principal do app
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeOut),
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // AppBar personalizada
            _buildAppBar(context),

            // Conteúdo
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),

                  // Card principal do timer
                  const TimeWithoutSmokingCard(),

                  const SizedBox(height: 24),

                  // Grid de estatísticas
                  const StatsGrid(),

                  const SizedBox(height: 24),

                  // Ações rápidas
                  const QuickActions(),

                  const SizedBox(height: 24),

                  // Carrossel de marcos de saúde
                  const HealthMilestonesCarousel(),

                  const SizedBox(height: 24),

                  // Missão do dia
                  const DailyMissionCard(),

                  // Espaço para o FAB
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: const EmergencyCravingButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondaryLight,
                        fontSize: 12,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Você está indo muito bem! 💪',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        // Botão de streak
        Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department,
                color: AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '7', // Dias de streak
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
        // Botão de notificações
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
          },
        ),
        // Botão de configurações
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.push(Routes.settings),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia! ☀️';
    if (hour < 18) return 'Boa tarde! 🌤️';
    return 'Boa noite! 🌙';
  }

  Future<void> _onRefresh() async {
    // Atualizar dados
    await Future.delayed(const Duration(seconds: 1));
  }
}
