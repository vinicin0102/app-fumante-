import 'package:equatable/equatable.dart';

import '../value_objects/smoking_trigger.dart';

/// Perfil de fumante do usuário
class SmokingProfile extends Equatable {
  final int cigarettesPerDay;
  final int yearsSmoking;
  final DateTime? quitDate;
  final double cigarettePrice; // Preço por cigarro
  final double packPrice; // Preço do maço
  final int cigarettesPerPack;
  final List<SmokingTrigger> triggers;
  final UserGoal goal;
  final ReductionPlan? reductionPlan;
  final String? preferredBrand;

  const SmokingProfile({
    required this.cigarettesPerDay,
    required this.yearsSmoking,
    this.quitDate,
    required this.cigarettePrice,
    required this.packPrice,
    this.cigarettesPerPack = 20,
    required this.triggers,
    required this.goal,
    this.reductionPlan,
    this.preferredBrand,
  });

  factory SmokingProfile.empty() {
    return const SmokingProfile(
      cigarettesPerDay: 0,
      yearsSmoking: 0,
      cigarettePrice: 0.0,
      packPrice: 0.0,
      triggers: [],
      goal: UserGoal.quit,
    );
  }

  /// Calcula o gasto diário estimado
  double get dailySpending => cigarettesPerDay * cigarettePrice;

  /// Calcula o gasto mensal estimado
  double get monthlySpending => dailySpending * 30;

  /// Calcula o gasto anual estimado
  double get yearlySpending => dailySpending * 365;

  /// Calcula total de cigarros fumados na vida (estimativa)
  int get totalCigarettesSmoked => cigarettesPerDay * yearsSmoking * 365;

  /// Verifica se está em modo de redução gradual
  bool get isReducing => goal == UserGoal.reduce && reductionPlan != null;

  SmokingProfile copyWith({
    int? cigarettesPerDay,
    int? yearsSmoking,
    DateTime? quitDate,
    double? cigarettePrice,
    double? packPrice,
    int? cigarettesPerPack,
    List<SmokingTrigger>? triggers,
    UserGoal? goal,
    ReductionPlan? reductionPlan,
    String? preferredBrand,
  }) {
    return SmokingProfile(
      cigarettesPerDay: cigarettesPerDay ?? this.cigarettesPerDay,
      yearsSmoking: yearsSmoking ?? this.yearsSmoking,
      quitDate: quitDate ?? this.quitDate,
      cigarettePrice: cigarettePrice ?? this.cigarettePrice,
      packPrice: packPrice ?? this.packPrice,
      cigarettesPerPack: cigarettesPerPack ?? this.cigarettesPerPack,
      triggers: triggers ?? this.triggers,
      goal: goal ?? this.goal,
      reductionPlan: reductionPlan ?? this.reductionPlan,
      preferredBrand: preferredBrand ?? this.preferredBrand,
    );
  }

  @override
  List<Object?> get props => [
        cigarettesPerDay,
        yearsSmoking,
        quitDate,
        cigarettePrice,
        packPrice,
        cigarettesPerPack,
        triggers,
        goal,
        reductionPlan,
        preferredBrand,
      ];
}

/// Objetivo do usuário
enum UserGoal {
  quit, // Parar completamente
  reduce, // Reduzir gradualmente
}

extension UserGoalExtension on UserGoal {
  String get displayName {
    switch (this) {
      case UserGoal.quit:
        return 'Parar de Fumar';
      case UserGoal.reduce:
        return 'Reduzir Gradualmente';
    }
  }

  String get description {
    switch (this) {
      case UserGoal.quit:
        return 'Você está pronto para parar completamente. Vamos juntos!';
      case UserGoal.reduce:
        return 'Vamos diminuir aos poucos até você conseguir parar.';
    }
  }
}

/// Plano de redução para quem quer diminuir gradualmente
class ReductionPlan extends Equatable {
  final int targetCigarettes; // Meta de cigarros por dia
  final int currentWeek;
  final Map<int, int> weeklyTargets; // Semana -> cigarros permitidos
  final DateTime startDate;

  const ReductionPlan({
    required this.targetCigarettes,
    required this.currentWeek,
    required this.weeklyTargets,
    required this.startDate,
  });

  /// Gera um plano de redução automático
  factory ReductionPlan.generate({
    required int currentCigarettes,
    int targetCigarettes = 0,
    int weeks = 8,
  }) {
    final reduction = (currentCigarettes - targetCigarettes) ~/ weeks;
    final weeklyTargets = <int, int>{};
    
    for (int i = 1; i <= weeks; i++) {
      final target = currentCigarettes - (reduction * i);
      weeklyTargets[i] = target > targetCigarettes ? target : targetCigarettes;
    }

    return ReductionPlan(
      targetCigarettes: targetCigarettes,
      currentWeek: 1,
      weeklyTargets: weeklyTargets,
      startDate: DateTime.now(),
    );
  }

  /// Meta de cigarros para a semana atual
  int get currentWeekTarget => weeklyTargets[currentWeek] ?? targetCigarettes;

  /// Progresso total do plano (0.0 a 1.0)
  double get totalProgress => currentWeek / weeklyTargets.length;

  ReductionPlan copyWith({
    int? targetCigarettes,
    int? currentWeek,
    Map<int, int>? weeklyTargets,
    DateTime? startDate,
  }) {
    return ReductionPlan(
      targetCigarettes: targetCigarettes ?? this.targetCigarettes,
      currentWeek: currentWeek ?? this.currentWeek,
      weeklyTargets: weeklyTargets ?? this.weeklyTargets,
      startDate: startDate ?? this.startDate,
    );
  }

  @override
  List<Object?> get props => [
        targetCigarettes,
        currentWeek,
        weeklyTargets,
        startDate,
      ];
}
