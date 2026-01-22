import 'package:equatable/equatable.dart';

import 'health_benefits.dart';

/// Representa o progresso do usuário na jornada de parar de fumar
class Progress extends Equatable {
  final int daysWithoutSmoking;
  final int cigarettesAvoided;
  final double moneySaved;
  final int currentStreak; // Dias consecutivos atuais
  final int bestStreak; // Melhor sequência de dias
  final DateTime? lastCigarette; // Última vez que fumou
  final DateTime quitStartDate; // Data que começou a parar
  final int totalRelapses; // Total de recaídas
  final double lifeRegained; // Horas de vida recuperadas

  const Progress({
    required this.daysWithoutSmoking,
    required this.cigarettesAvoided,
    required this.moneySaved,
    required this.currentStreak,
    required this.bestStreak,
    this.lastCigarette,
    required this.quitStartDate,
    this.totalRelapses = 0,
    this.lifeRegained = 0,
  });

  factory Progress.initial() {
    return Progress(
      daysWithoutSmoking: 0,
      cigarettesAvoided: 0,
      moneySaved: 0.0,
      currentStreak: 0,
      bestStreak: 0,
      quitStartDate: DateTime.now(),
    );
  }

  /// Calcula os benefícios de saúde com base no tempo sem fumar
  HealthBenefits get healthBenefits => HealthBenefits.calculate(daysWithoutSmoking);

  /// Horas sem fumar
  int get hoursWithoutSmoking {
    if (lastCigarette == null) return 0;
    return DateTime.now().difference(lastCigarette!).inHours;
  }

  /// Minutos sem fumar
  int get minutesWithoutSmoking {
    if (lastCigarette == null) return 0;
    final totalMinutes = DateTime.now().difference(lastCigarette!).inMinutes;
    return totalMinutes % 60;
  }

  /// Segundos sem fumar
  int get secondsWithoutSmoking {
    if (lastCigarette == null) return 0;
    final totalSeconds = DateTime.now().difference(lastCigarette!).inSeconds;
    return totalSeconds % 60;
  }

  /// Progresso para o próximo marco de saúde (0.0 a 1.0)
  double get nextMilestoneProgress {
    final nextMilestone = healthBenefits.nextMilestone;
    if (nextMilestone == null) return 1.0;
    
    final previousMilestone = healthBenefits.currentMilestone;
    final previousDays = previousMilestone?.daysRequired ?? 0;
    final nextDays = nextMilestone.daysRequired;
    
    return (daysWithoutSmoking - previousDays) / (nextDays - previousDays);
  }

  /// Título do próximo marco
  String get nextMilestoneTitle {
    return healthBenefits.nextMilestone?.title ?? 'Você conquistou tudo!';
  }

  /// Descrição do benefício atual
  String get currentBenefitDescription {
    return healthBenefits.currentMilestone?.benefit ?? 
        'Continue assim! Cada momento conta.';
  }

  /// Calcula economia em diferentes períodos
  double moneySavedIn(Duration duration) {
    final daysInPeriod = duration.inDays;
    return (moneySaved / daysWithoutSmoking) * daysInPeriod;
  }

  /// Estatísticas resumidas
  Map<String, dynamic> get quickStats => {
        'dias': daysWithoutSmoking,
        'cigarros_evitados': cigarettesAvoided,
        'economia': moneySaved,
        'streak': currentStreak,
        'vida_recuperada': lifeRegained,
      };

  Progress copyWith({
    int? daysWithoutSmoking,
    int? cigarettesAvoided,
    double? moneySaved,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastCigarette,
    DateTime? quitStartDate,
    int? totalRelapses,
    double? lifeRegained,
  }) {
    return Progress(
      daysWithoutSmoking: daysWithoutSmoking ?? this.daysWithoutSmoking,
      cigarettesAvoided: cigarettesAvoided ?? this.cigarettesAvoided,
      moneySaved: moneySaved ?? this.moneySaved,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastCigarette: lastCigarette ?? this.lastCigarette,
      quitStartDate: quitStartDate ?? this.quitStartDate,
      totalRelapses: totalRelapses ?? this.totalRelapses,
      lifeRegained: lifeRegained ?? this.lifeRegained,
    );
  }

  /// Registra uma recaída
  Progress recordRelapse({int cigarettesSmoked = 1}) {
    return copyWith(
      lastCigarette: DateTime.now(),
      currentStreak: 0,
      totalRelapses: totalRelapses + 1,
    );
  }

  /// Atualiza o progresso diário
  Progress updateDaily({
    required int cigarettesPerDay,
    required double pricePerCigarette,
    required double minutesPerCigarette,
  }) {
    final newDays = daysWithoutSmoking + 1;
    final newCigarettesAvoided = cigarettesAvoided + cigarettesPerDay;
    final newMoneySaved = moneySaved + (cigarettesPerDay * pricePerCigarette);
    final newLifeRegained = lifeRegained + (cigarettesPerDay * minutesPerCigarette / 60);
    final newStreak = currentStreak + 1;

    return copyWith(
      daysWithoutSmoking: newDays,
      cigarettesAvoided: newCigarettesAvoided,
      moneySaved: newMoneySaved,
      currentStreak: newStreak,
      bestStreak: newStreak > bestStreak ? newStreak : bestStreak,
      lifeRegained: newLifeRegained,
    );
  }

  @override
  List<Object?> get props => [
        daysWithoutSmoking,
        cigarettesAvoided,
        moneySaved,
        currentStreak,
        bestStreak,
        lastCigarette,
        quitStartDate,
        totalRelapses,
        lifeRegained,
      ];
}
