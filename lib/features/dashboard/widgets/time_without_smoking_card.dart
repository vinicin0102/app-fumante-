import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Card principal com timer animado mostrando tempo sem fumar
class TimeWithoutSmokingCard extends StatefulWidget {
  const TimeWithoutSmokingCard({super.key});

  @override
  State<TimeWithoutSmokingCard> createState() => _TimeWithoutSmokingCardState();
}

class _TimeWithoutSmokingCardState extends State<TimeWithoutSmokingCard>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Data de início da abstinência (exemplo: 7 dias atrás)
  final DateTime _quitDate = DateTime.now().subtract(const Duration(
    days: 7,
    hours: 14,
    minutes: 32,
  ));

  Duration get _timeSinceQuit => DateTime.now().difference(_quitDate);

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Atualizar a cada segundo
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          children: [
            // Título
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.smoke_free,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tempo sem fumar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Timer principal
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TimeUnit(
                  value: _timeSinceQuit.inDays,
                  label: 'Dias',
                ),
                _TimeSeparator(),
                _TimeUnit(
                  value: _timeSinceQuit.inHours % 24,
                  label: 'Horas',
                ),
                _TimeSeparator(),
                _TimeUnit(
                  value: _timeSinceQuit.inMinutes % 60,
                  label: 'Min',
                ),
                _TimeSeparator(),
                _TimeUnit(
                  value: _timeSinceQuit.inSeconds % 60,
                  label: 'Seg',
                  isSmall: true,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Barra de progresso para próximo marco
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Próximo marco: 2 semanas',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '50%',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Benefício de saúde atual
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Sua circulação está melhorando significativamente!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final int value;
  final String label;
  final bool isSmall;

  const _TimeUnit({
    required this.value,
    required this.label,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: isSmall ? 50 : 60,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmall ? 24 : 32,
              fontWeight: FontWeight.bold,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TimeSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
