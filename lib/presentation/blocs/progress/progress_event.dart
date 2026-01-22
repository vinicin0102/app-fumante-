part of 'progress_bloc.dart';

/// Eventos de progresso
abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

/// Carregar progresso do usuário
class LoadProgressEvent extends ProgressEvent {
  final String userId;

  const LoadProgressEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Atualizar progresso
class UpdateProgressEvent extends ProgressEvent {
  final Progress progress;

  const UpdateProgressEvent({required this.progress});

  @override
  List<Object?> get props => [progress];
}

/// Registrar recaída
class RecordRelapseEvent extends ProgressEvent {
  final int cigarettesSmoked;
  final String? reason;
  final String? trigger;

  const RecordRelapseEvent({
    this.cigarettesSmoked = 1,
    this.reason,
    this.trigger,
  });

  @override
  List<Object?> get props => [cigarettesSmoked, reason, trigger];
}

/// Inicializar novo plano de parada
class InitializeProgressEvent extends ProgressEvent {
  final DateTime quitDate;
  final int cigarettesPerDay;
  final double packPrice;
  final int yearsSmoking;

  const InitializeProgressEvent({
    required this.quitDate,
    required this.cigarettesPerDay,
    required this.packPrice,
    required this.yearsSmoking,
  });

  @override
  List<Object?> get props => [quitDate, cigarettesPerDay, packPrice, yearsSmoking];
}

/// Resetar progresso (apagar tudo)
class ResetProgressEvent extends ProgressEvent {}

/// Incrementar dia (para atualização diária)
class IncrementDayEvent extends ProgressEvent {
  final int cigarettesPerDay;
  final double pricePerCigarette;
  final double minutesPerCigarette;

  const IncrementDayEvent({
    required this.cigarettesPerDay,
    required this.pricePerCigarette,
    this.minutesPerCigarette = 11.0, // Média científica: cada cigarro tira 11 min de vida
  });

  @override
  List<Object?> get props => [cigarettesPerDay, pricePerCigarette, minutesPerCigarette];
}
