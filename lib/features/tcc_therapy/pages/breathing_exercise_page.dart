import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/tcc_exercise.dart';

/// Página de exercício de respiração guiado
class BreathingExercisePage extends StatefulWidget {
  final String exerciseId;

  const BreathingExercisePage({super.key, required this.exerciseId});

  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage> with TickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;
  Timer? _timer;
  int _currentCycle = 1;
  late BreathingExercise _exercise;
  String _instruction = 'Prepare-se';
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    // Encontrar o exercício correto
    _exercise = ExercisesList.breathingExercises.firstWhere(
      (e) => e.id == widget.exerciseId,
      orElse: () => ExercisesList.breathingExercises.first,
    );

    // Duração inicial baseada no exercício (soma total do ciclo)
    final totalCycleDuration = _exercise.inhaleSeconds + _exercise.holdSeconds + _exercise.exhaleSeconds;
    
    _breathController = AnimationController(
      vsync: this, 
      duration: Duration(seconds: totalCycleDuration)
    );
    
    _breathAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _breathController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _breathController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startExercise() {
    setState(() {
      _isRunning = true;
      _instruction = 'Inspire'; // Ajuste inicial
    });
    _runCycle();
  }

  void _runCycle() {
    if (_currentCycle > _exercise.cycles) {
      _completeExercise();
      return;
    }
    // Inspire
    setState(() => _instruction = 'Inspire...');
    // Animação de expansão durante inspiração
    _breathController.animateTo(1.0, duration: Duration(seconds: _exercise.inhaleSeconds));
    
    _timer = Timer(Duration(seconds: _exercise.inhaleSeconds), () {
      // Segure
      setState(() => _instruction = 'Segure...');
      
      _timer = Timer(Duration(seconds: _exercise.holdSeconds), () {
        // Expire
        setState(() => _instruction = 'Expire...');
        // Animação de contração durante expiração
        _breathController.animateTo(0.5, duration: Duration(seconds: _exercise.exhaleSeconds));
        
        _timer = Timer(Duration(seconds: _exercise.exhaleSeconds), () {
          if (mounted) {
             setState(() => _currentCycle++);
             _runCycle();
          }
        });
      });
    });
  }

  void _completeExercise() {
    if (mounted) {
      setState(() {
        _isRunning = false;
        _instruction = 'Completo! 🎉';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_exercise.title),
        centerTitle: true,
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary), 
          onPressed: () => context.pop()
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _instruction, 
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary
              )
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Ciclo $_currentCycle de ${_exercise.cycles}', 
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondaryLight
            )
          ),
          const SizedBox(height: 60),
          Center(
            child: AnimatedBuilder(
              animation: _breathController, // Usar o controller para reconstruir se necessário, mas a animação é melhor
              builder: (context, child) {
                // A animação já está sendo controlada manualmente no _runCycle, 
                // mas para suavidade visual podemos usar o valor do controller se estivermos usando .forward().
                // Porem, aqui estamos usando .animateTo().
                // O AnimatedBuilder precisa ouvir algo.
                return Container(
                  width: 300 * (_breathController.value < 0.5 ? 0.5 : _breathController.value), // Garante min 0.5
                  height: 300 * (_breathController.value < 0.5 ? 0.5 : _breathController.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, 
                    color: AppColors.primary.withOpacity(0.3), 
                    border: Border.all(color: AppColors.primary, width: 4)
                  ),
                  child: Center(
                    child: Icon(
                      Icons.air, 
                      size: 100 * (_breathController.value < 0.5 ? 0.5 : _breathController.value), 
                      color: AppColors.primary
                    )
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 60),
          if (!_isRunning && _instruction != 'Completo! 🎉')
            ElevatedButton(
              onPressed: _startExercise, 
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Iniciar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            )
          else if (_instruction == 'Completo! 🎉')
            ElevatedButton(
              onPressed: () => context.pop(), 
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Concluir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ),
        ],
      ),
    );
  }
}
