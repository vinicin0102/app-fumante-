import 'package:equatable/equatable.dart';

import '../value_objects/smoking_trigger.dart';

/// Entrada do diário emocional do usuário
class JournalEntry extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final int mood; // 1-5 (muito ruim a muito bom)
  final int cravingIntensity; // 0-10
  final String? situation; // Situação que causou a vontade
  final List<SmokingTrigger> triggers;
  final bool resisted; // Se resistiu à vontade
  final String? notes; // Notas adicionais
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? exerciseCompleted; // ID do exercício feito
  final Duration? cravingDuration; // Quanto tempo durou a vontade

  const JournalEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.mood,
    required this.cravingIntensity,
    this.situation,
    required this.triggers,
    required this.resisted,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.exerciseCompleted,
    this.cravingDuration,
  });

  factory JournalEntry.create({
    required String userId,
    required int mood,
    required int cravingIntensity,
    String? situation,
    List<SmokingTrigger>? triggers,
    bool resisted = true,
    String? notes,
    String? exerciseCompleted,
    Duration? cravingDuration,
  }) {
    final now = DateTime.now();
    return JournalEntry(
      id: now.millisecondsSinceEpoch.toString(),
      userId: userId,
      date: now,
      mood: mood,
      cravingIntensity: cravingIntensity,
      situation: situation,
      triggers: triggers ?? [],
      resisted: resisted,
      notes: notes,
      createdAt: now,
      exerciseCompleted: exerciseCompleted,
      cravingDuration: cravingDuration,
    );
  }

  /// Indica se foi uma crise forte (nível 7+)
  bool get wasIntenseCraving => cravingIntensity >= 7;

  /// Indica se foi uma crise média (nível 4-6)
  bool get wasModerateCraving => cravingIntensity >= 4 && cravingIntensity < 7;

  /// Indica se o humor era negativo
  bool get hadNegativeMood => mood <= 2;

  /// Descrição do humor
  String get moodDescription {
    switch (mood) {
      case 1:
        return 'Muito mal';
      case 2:
        return 'Ruim';
      case 3:
        return 'Neutro';
      case 4:
        return 'Bem';
      case 5:
        return 'Muito bem';
      default:
        return 'Desconhecido';
    }
  }

  /// Descrição da intensidade da vontade
  String get cravingDescription {
    if (cravingIntensity == 0) return 'Sem vontade';
    if (cravingIntensity <= 2) return 'Vontade leve';
    if (cravingIntensity <= 4) return 'Vontade moderada';
    if (cravingIntensity <= 6) return 'Vontade forte';
    if (cravingIntensity <= 8) return 'Vontade muito forte';
    return 'Crise intensa';
  }

  /// Emoji do humor
  String get moodEmoji {
    switch (mood) {
      case 1:
        return '😢';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '😄';
      default:
        return '❓';
    }
  }

  JournalEntry copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? mood,
    int? cravingIntensity,
    String? situation,
    List<SmokingTrigger>? triggers,
    bool? resisted,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? exerciseCompleted,
    Duration? cravingDuration,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      cravingIntensity: cravingIntensity ?? this.cravingIntensity,
      situation: situation ?? this.situation,
      triggers: triggers ?? this.triggers,
      resisted: resisted ?? this.resisted,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      exerciseCompleted: exerciseCompleted ?? this.exerciseCompleted,
      cravingDuration: cravingDuration ?? this.cravingDuration,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        mood,
        cravingIntensity,
        situation,
        triggers,
        resisted,
        notes,
        createdAt,
        updatedAt,
        exerciseCompleted,
        cravingDuration,
      ];
}

/// Análise de padrões do diário
class JournalAnalytics extends Equatable {
  final double averageMood;
  final double averageCravingIntensity;
  final int totalEntries;
  final int resistedCount;
  final int relapsedCount;
  final Map<SmokingTrigger, int> triggerFrequency;
  final Map<int, int> cravingsByHour; // Hora do dia -> quantidade
  final Map<int, int> cravingsByDayOfWeek; // Dia da semana -> quantidade
  final List<String> mostEffectiveExercises;
  final double successRate;

  const JournalAnalytics({
    required this.averageMood,
    required this.averageCravingIntensity,
    required this.totalEntries,
    required this.resistedCount,
    required this.relapsedCount,
    required this.triggerFrequency,
    required this.cravingsByHour,
    required this.cravingsByDayOfWeek,
    required this.mostEffectiveExercises,
    required this.successRate,
  });

  factory JournalAnalytics.fromEntries(List<JournalEntry> entries) {
    if (entries.isEmpty) {
      return const JournalAnalytics(
        averageMood: 0,
        averageCravingIntensity: 0,
        totalEntries: 0,
        resistedCount: 0,
        relapsedCount: 0,
        triggerFrequency: {},
        cravingsByHour: {},
        cravingsByDayOfWeek: {},
        mostEffectiveExercises: [],
        successRate: 0,
      );
    }

    final avgMood = entries.map((e) => e.mood).reduce((a, b) => a + b) / entries.length;
    final avgCraving = entries.map((e) => e.cravingIntensity).reduce((a, b) => a + b) / entries.length;
    
    final resisted = entries.where((e) => e.resisted).length;
    final relapsed = entries.where((e) => !e.resisted).length;

    // Frequência de gatilhos
    final triggerFreq = <SmokingTrigger, int>{};
    for (final entry in entries) {
      for (final trigger in entry.triggers) {
        triggerFreq[trigger] = (triggerFreq[trigger] ?? 0) + 1;
      }
    }

    // Vontades por hora
    final byHour = <int, int>{};
    for (final entry in entries) {
      final hour = entry.date.hour;
      byHour[hour] = (byHour[hour] ?? 0) + 1;
    }

    // Vontades por dia da semana
    final byDayOfWeek = <int, int>{};
    for (final entry in entries) {
      final day = entry.date.weekday;
      byDayOfWeek[day] = (byDayOfWeek[day] ?? 0) + 1;
    }

    // Exercícios mais efetivos
    final exerciseSuccess = <String, int>{};
    final exerciseTotal = <String, int>{};
    for (final entry in entries) {
      if (entry.exerciseCompleted != null) {
        exerciseTotal[entry.exerciseCompleted!] = 
            (exerciseTotal[entry.exerciseCompleted!] ?? 0) + 1;
        if (entry.resisted) {
          exerciseSuccess[entry.exerciseCompleted!] = 
              (exerciseSuccess[entry.exerciseCompleted!] ?? 0) + 1;
        }
      }
    }

    final effectiveExercises = exerciseTotal.entries
        .map((e) {
          final successRate = (exerciseSuccess[e.key] ?? 0) / e.value;
          return MapEntry(e.key, successRate);
        })
        .where((e) => e.value > 0.7) // 70%+ sucesso
        .toList();
    effectiveExercises.sort((a, b) => b.value.compareTo(a.value));

    return JournalAnalytics(
      averageMood: avgMood,
      averageCravingIntensity: avgCraving,
      totalEntries: entries.length,
      resistedCount: resisted,
      relapsedCount: relapsed,
      triggerFrequency: triggerFreq,
      cravingsByHour: byHour,
      cravingsByDayOfWeek: byDayOfWeek,
      mostEffectiveExercises: effectiveExercises.map((e) => e.key).toList(),
      successRate: entries.isNotEmpty ? resisted / entries.length : 0,
    );
  }

  /// Retorna o gatilho mais comum
  SmokingTrigger? get mostCommonTrigger {
    if (triggerFrequency.isEmpty) return null;
    return triggerFrequency.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Retorna a hora mais crítica
  int? get peakCravingHour {
    if (cravingsByHour.isEmpty) return null;
    return cravingsByHour.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Retorna o dia mais crítico
  int? get peakCravingDay {
    if (cravingsByDayOfWeek.isEmpty) return null;
    return cravingsByDayOfWeek.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  @override
  List<Object?> get props => [
        averageMood,
        averageCravingIntensity,
        totalEntries,
        resistedCount,
        relapsedCount,
        triggerFrequency,
        cravingsByHour,
        cravingsByDayOfWeek,
        mostEffectiveExercises,
        successRate,
      ];
}
