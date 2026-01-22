part of 'progress_bloc.dart';

/// Estados de progresso
abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class ProgressInitial extends ProgressState {}

/// Carregando progresso
class ProgressLoading extends ProgressState {}

/// Progresso carregado
class ProgressLoaded extends ProgressState {
  final Progress progress;
  final HealthBenefits healthBenefits;
  final DateTime? lastRelapse;
  final bool hasNewAchievement;
  final String? newAchievementId;

  const ProgressLoaded({
    required this.progress,
    required this.healthBenefits,
    this.lastRelapse,
    this.hasNewAchievement = false,
    this.newAchievementId,
  });

  /// Dias sem fumar formatados
  String get formattedDaysWithoutSmoking {
    final days = progress.daysWithoutSmoking;
    if (days == 0) return 'Hoje é o dia!';
    if (days == 1) return '1 dia';
    return '$days dias';
  }

  /// Economia formatada (BRL)
  String get formattedMoneySaved {
    final value = progress.moneySaved;
    if (value >= 1000) {
      return 'R\$ ${(value / 1000).toStringAsFixed(1)}k';
    }
    return 'R\$ ${value.toStringAsFixed(2)}';
  }

  /// Score de saúde formatado
  String get formattedHealthScore {
    return '${healthBenefits.overallHealthScore.round()}%';
  }

  ProgressLoaded copyWith({
    Progress? progress,
    HealthBenefits? healthBenefits,
    DateTime? lastRelapse,
    bool? hasNewAchievement,
    String? newAchievementId,
  }) {
    return ProgressLoaded(
      progress: progress ?? this.progress,
      healthBenefits: healthBenefits ?? this.healthBenefits,
      lastRelapse: lastRelapse ?? this.lastRelapse,
      hasNewAchievement: hasNewAchievement ?? this.hasNewAchievement,
      newAchievementId: newAchievementId ?? this.newAchievementId,
    );
  }

  @override
  List<Object?> get props => [
        progress,
        healthBenefits,
        lastRelapse,
        hasNewAchievement,
        newAchievementId,
      ];
}

/// Erro de progresso
class ProgressError extends ProgressState {
  final String message;

  const ProgressError({required this.message});

  @override
  List<Object?> get props => [message];
}
