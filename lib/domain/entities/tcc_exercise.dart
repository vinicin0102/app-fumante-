import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Exercício de Terapia Cognitivo-Comportamental
class TCCExercise extends Equatable {
  final String id;
  final String title;
  final String description;
  final ExerciseType type;
  final int durationMinutes;
  final ExerciseDifficulty difficulty;
  final List<String> steps;
  final String? audioUrl;
  final String? videoUrl;
  final String? animationAsset;
  final bool isPremium;
  final int order;
  final List<String> tags;
  final int completionCount;
  final double averageRating;

  const TCCExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.durationMinutes,
    required this.difficulty,
    required this.steps,
    this.audioUrl,
    this.videoUrl,
    this.animationAsset,
    this.isPremium = false,
    this.order = 0,
    this.tags = const [],
    this.completionCount = 0,
    this.averageRating = 0.0,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        durationMinutes,
        difficulty,
        steps,
        audioUrl,
        videoUrl,
        animationAsset,
        isPremium,
        order,
        tags,
        completionCount,
        averageRating,
      ];
}

/// Tipo de exercício TCC
enum ExerciseType {
  breathing,
  cognitive,
  behavioral,
  relaxation,
  mindfulness,
  visualization,
}

extension ExerciseTypeExtension on ExerciseType {
  String get displayName {
    switch (this) {
      case ExerciseType.breathing:
        return 'Respiração';
      case ExerciseType.cognitive:
        return 'Cognitivo';
      case ExerciseType.behavioral:
        return 'Comportamental';
      case ExerciseType.relaxation:
        return 'Relaxamento';
      case ExerciseType.mindfulness:
        return 'Mindfulness';
      case ExerciseType.visualization:
        return 'Visualização';
    }
  }

  String get description {
    switch (this) {
      case ExerciseType.breathing:
        return 'Técnicas de respiração para acalmar o sistema nervoso';
      case ExerciseType.cognitive:
        return 'Reestruturação de pensamentos negativos';
      case ExerciseType.behavioral:
        return 'Mudança de comportamentos e hábitos';
      case ExerciseType.relaxation:
        return 'Técnicas para relaxar corpo e mente';
      case ExerciseType.mindfulness:
        return 'Atenção plena ao momento presente';
      case ExerciseType.visualization:
        return 'Imagine-se livre do cigarro';
    }
  }

  IconData get icon {
    switch (this) {
      case ExerciseType.breathing:
        return Icons.air;
      case ExerciseType.cognitive:
        return Icons.psychology;
      case ExerciseType.behavioral:
        return Icons.directions_run;
      case ExerciseType.relaxation:
        return Icons.spa;
      case ExerciseType.mindfulness:
        return Icons.self_improvement;
      case ExerciseType.visualization:
        return Icons.remove_red_eye;
    }
  }

  Color get color {
    switch (this) {
      case ExerciseType.breathing:
        return const Color(0xFF06B6D4);
      case ExerciseType.cognitive:
        return const Color(0xFF8B5CF6);
      case ExerciseType.behavioral:
        return const Color(0xFFF97316);
      case ExerciseType.relaxation:
        return const Color(0xFF10B981);
      case ExerciseType.mindfulness:
        return const Color(0xFF6366F1);
      case ExerciseType.visualization:
        return const Color(0xFFEC4899);
    }
  }
}

/// Dificuldade do exercício
enum ExerciseDifficulty {
  easy,
  medium,
  hard,
}

extension ExerciseDifficultyExtension on ExerciseDifficulty {
  String get displayName {
    switch (this) {
      case ExerciseDifficulty.easy:
        return 'Fácil';
      case ExerciseDifficulty.medium:
        return 'Médio';
      case ExerciseDifficulty.hard:
        return 'Avançado';
    }
  }

  Color get color {
    switch (this) {
      case ExerciseDifficulty.easy:
        return const Color(0xFF10B981);
      case ExerciseDifficulty.medium:
        return const Color(0xFFF59E0B);
      case ExerciseDifficulty.hard:
        return const Color(0xFFEF4444);
    }
  }
}

/// Exercício de respiração específico
class BreathingExercise extends TCCExercise {
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final int cycles;

  const BreathingExercise({
    required super.id,
    required super.title,
    required super.description,
    required super.durationMinutes,
    required super.difficulty,
    required super.steps,
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
    required this.cycles,
    super.audioUrl,
    super.animationAsset,
    super.isPremium,
    super.order,
    super.tags,
  }) : super(type: ExerciseType.breathing);

  /// Duração total do ciclo em segundos
  int get cycleDuration => inhaleSeconds + holdSeconds + exhaleSeconds;

  /// Duração total do exercício em segundos
  int get totalDuration => cycleDuration * cycles;
}

/// Lista de exercícios pré-definidos
class ExercisesList {
  /// Exercícios de respiração
  static const List<BreathingExercise> breathingExercises = [
    BreathingExercise(
      id: 'breathing_478',
      title: 'Técnica 4-7-8',
      description: 'A técnica mais eficaz para acalmar o sistema nervoso rapidamente.',
      durationMinutes: 5,
      difficulty: ExerciseDifficulty.easy,
      inhaleSeconds: 4,
      holdSeconds: 7,
      exhaleSeconds: 8,
      cycles: 4,
      steps: [
        'Encontre uma posição confortável',
        'Inspire pelo nariz contando até 4',
        'Segure a respiração contando até 7',
        'Expire lentamente pela boca contando até 8',
        'Repita o ciclo 4 vezes',
      ],
      tags: ['emergência', 'rápido', 'ansiedade'],
    ),
    BreathingExercise(
      id: 'breathing_box',
      title: 'Respiração Quadrada',
      description: 'Técnica equilibrada usada por atletas de elite.',
      durationMinutes: 4,
      difficulty: ExerciseDifficulty.easy,
      inhaleSeconds: 4,
      holdSeconds: 4,
      exhaleSeconds: 4,
      cycles: 6,
      steps: [
        'Sente-se confortavelmente',
        'Inspire contando até 4',
        'Segure contando até 4',
        'Expire contando até 4',
        'Segure (pulmões vazios) contando até 4',
        'Repita por 4-6 ciclos',
      ],
      tags: ['foco', 'concentração', 'balanceado'],
    ),
    BreathingExercise(
      id: 'breathing_5555',
      title: 'Respiração Calma',
      description: 'Respiração lenta e profunda para relaxamento gradual.',
      durationMinutes: 6,
      difficulty: ExerciseDifficulty.easy,
      inhaleSeconds: 5,
      holdSeconds: 5,
      exhaleSeconds: 5,
      cycles: 8,
      steps: [
        'Relaxe os ombros',
        'Inspire lentamente pelo nariz por 5 segundos',
        'Segure gentilmente por 5 segundos',
        'Expire suavemente por 5 segundos',
        'Continue por 8 ciclos ou mais',
      ],
      tags: ['relaxamento', 'sono', 'calma'],
    ),
  ];

  /// Exercícios cognitivos
  static const List<TCCExercise> cognitiveExercises = [
    TCCExercise(
      id: 'cognitive_thought_record',
      title: 'Registro de Pensamentos',
      description: 'Identifique e desafie pensamentos negativos sobre fumar.',
      type: ExerciseType.cognitive,
      durationMinutes: 10,
      difficulty: ExerciseDifficulty.medium,
      steps: [
        'Identifique a situação que gerou vontade',
        'Anote o pensamento automático (ex: "Preciso fumar para relaxar")',
        'Identifique a emoção e sua intensidade (0-10)',
        'Busque evidências a favor e contra esse pensamento',
        'Crie um pensamento alternativo mais equilibrado',
        'Reavalie a intensidade da emoção',
      ],
      tags: ['reestruturação', 'pensamentos', 'consciência'],
    ),
    TCCExercise(
      id: 'cognitive_pros_cons',
      title: 'Prós e Contras',
      description: 'Liste razões para continuar e para parar de fumar.',
      type: ExerciseType.cognitive,
      durationMinutes: 15,
      difficulty: ExerciseDifficulty.easy,
      steps: [
        'Pegue papel e caneta (ou use o app)',
        'Divida em 4 quadrantes',
        'Liste os benefícios de fumar',
        'Liste os prejuízos de fumar',
        'Liste os benefícios de parar',
        'Liste os prejuízos de parar (temporários)',
        'Compare e reflita sobre o que é mais importante para você',
      ],
      tags: ['motivação', 'reflexão', 'decisão'],
    ),
    TCCExercise(
      id: 'cognitive_reframing',
      title: 'Reenquadramento',
      description: 'Transforme a vontade de fumar em motivação.',
      type: ExerciseType.cognitive,
      durationMinutes: 5,
      difficulty: ExerciseDifficulty.medium,
      steps: [
        'Quando sentir vontade, pause e nomeie: "Estou sentindo vontade"',
        'Lembre: a vontade é temporária e passará em poucos minutos',
        'Pense: "Cada vontade que resisto me torna mais forte"',
        'Visualize: imagine-se como uma pessoa livre do cigarro',
        'Celebre: você está vencendo!',
      ],
      tags: ['emergência', 'mentalidade', 'força'],
    ),
  ];

  /// Exercícios comportamentais
  static const List<TCCExercise> behavioralExercises = [
    TCCExercise(
      id: 'behavioral_delay',
      title: 'Técnica do Atraso',
      description: 'Atrase a decisão de fumar por alguns minutos.',
      type: ExerciseType.behavioral,
      durationMinutes: 5,
      difficulty: ExerciseDifficulty.easy,
      steps: [
        'Quando sentir vontade, diga: "Vou esperar 5 minutos"',
        'Durante os 5 minutos, faça outra atividade',
        'Após 5 minutos, reavalie: "Ainda preciso?"',
        'Se sim, espere mais 5 minutos',
        'A maioria das vontades passa em 3-5 minutos!',
      ],
      tags: ['emergência', 'prático', 'simples'],
    ),
    TCCExercise(
      id: 'behavioral_distraction',
      title: 'Caixa de Distração',
      description: 'Use atividades substitutas para superar a vontade.',
      type: ExerciseType.behavioral,
      durationMinutes: 10,
      difficulty: ExerciseDifficulty.easy,
      steps: [
        'Beba um copo de água gelada',
        'Masque uma bala ou chiclete sem açúcar',
        'Dê uma caminhada rápida de 5 minutos',
        'Ligue para um amigo ou familiar',
        'Jogue um jogo rápido no celular',
        'Faça 10 flexões ou polichinelos',
        'Escove os dentes ou use enxaguante bucal',
      ],
      tags: ['distração', 'prático', 'substituição'],
    ),
    TCCExercise(
      id: 'behavioral_trigger_planning',
      title: 'Plano de Gatilhos',
      description: 'Crie estratégias personalizadas para seus gatilhos.',
      type: ExerciseType.behavioral,
      durationMinutes: 20,
      difficulty: ExerciseDifficulty.medium,
      isPremium: true,
      steps: [
        'Identifique seus 3 principais gatilhos',
        'Para cada gatilho, escreva quando e onde acontece',
        'Planeje uma ação alternativa específica',
        'Visualize você executando a alternativa',
        'Pratique a situação mentalmente',
        'Quando o gatilho ocorrer, execute o plano',
      ],
      tags: ['planejamento', 'personalizado', 'prevenção'],
    ),
  ];
}
