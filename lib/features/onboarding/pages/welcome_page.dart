import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';

/// Tela de boas-vindas (onboarding inicial)
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
              Theme.of(context).scaffoldBackgroundColor,
            ],
            stops: const [0, 0.3, 1],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.08),

                  // Logo e ícone
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildLogo(),
                  ),

                  SizedBox(height: size.height * 0.05),

                  // Título e descrição
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildHeader(),
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

                  // Benefícios
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildBenefits(),
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),

                  // Botões
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildButtons(context),
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Termos
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildTerms(),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.smoke_free,
            size: 60,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Livre.io',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Sua jornada para uma\nvida livre do cigarro',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Acompanhe seu progresso, receba apoio e conquiste cada dia sem fumar.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color
                    ?.withOpacity(0.7),
              ),
        ),
      ],
    );
  }

  Widget _buildBenefits() {
    final benefits = [
      {'icon': Icons.timer_outlined, 'text': 'Timer de abstinência'},
      {'icon': Icons.savings_outlined, 'text': 'Economia visualizada'},
      {'icon': Icons.favorite_outline, 'text': 'Benefícios de saúde'},
      {'icon': Icons.psychology_outlined, 'text': 'Exercícios TCC'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: benefits.map((benefit) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    benefit['icon'] as IconData,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  benefit['text'] as String,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Spacer(),
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 20,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        // Botão principal
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => context.go(Routes.smartOnboarding),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.4),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Começar Agora',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Botão secundário
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              // Login com conta existente
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 2,
              ),
            ),
            child: Text(
              'Já tenho uma conta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTerms() {
    return Text(
      'Ao continuar, você concorda com nossos Termos de Uso e Política de Privacidade',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withOpacity(0.6),
          ),
    );
  }
}
