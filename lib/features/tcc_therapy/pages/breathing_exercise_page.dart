import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

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
  final int _totalCycles = 4;
  String _instruction = 'Inspire';
  bool _isRunning = false;
  int _inhale = 4, _hold = 7, _exhale = 8;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(vsync: this, duration: Duration(seconds: _inhale + _hold + _exhale));
    _breathAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _breathController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _breathController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startExercise() {
    setState(() => _isRunning = true);
    _runCycle();
  }

  void _runCycle() {
    if (_currentCycle > _totalCycles) {
      _completeExercise();
      return;
    }
    // Inspire
    setState(() => _instruction = 'Inspire...');
    _breathController.forward(from: 0);
    _timer = Timer(Duration(seconds: _inhale), () {
      // Segure
      setState(() => _instruction = 'Segure...');
      _timer = Timer(Duration(seconds: _hold), () {
        // Expire
        setState(() => _instruction = 'Expire...');
        _breathController.reverse();
        _timer = Timer(Duration(seconds: _exhale), () {
          setState(() => _currentCycle++);
          _runCycle();
        });
      });
    });
  }

  void _completeExercise() {
    setState(() {
      _isRunning = false;
      _instruction = 'Completo! 🎉';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary.withOpacity(0.1),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop())),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Técnica 4-7-8', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Ciclo $_currentCycle de $_totalCycles', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondaryLight)),
          const SizedBox(height: 60),
          Center(
            child: AnimatedBuilder(
              animation: _breathAnimation,
              builder: (context, child) {
                return Container(
                  width: 200 * _breathAnimation.value,
                  height: 200 * _breathAnimation.value,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withOpacity(0.3), border: Border.all(color: AppColors.primary, width: 4)),
                  child: Center(child: Text(_instruction, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primary))),
                );
              },
            ),
          ),
          const SizedBox(height: 60),
          if (!_isRunning && _instruction != 'Completo! 🎉')
            ElevatedButton(onPressed: _startExercise, child: const Text('Iniciar'))
          else if (_instruction == 'Completo! 🎉')
            ElevatedButton(onPressed: () => context.pop(), child: const Text('Concluir')),
        ],
      ),
    );
  }
}
