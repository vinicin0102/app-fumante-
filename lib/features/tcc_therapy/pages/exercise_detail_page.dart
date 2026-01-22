import 'package:flutter/material.dart';

/// Página de detalhes do exercício
class ExerciseDetailPage extends StatelessWidget {
  final String exerciseId;

  const ExerciseDetailPage({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Exercício')),
      body: const Center(child: Text('Detalhes do exercício')),
    );
  }
}
