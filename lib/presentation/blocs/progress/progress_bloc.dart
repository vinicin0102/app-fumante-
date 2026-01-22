import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/progress.dart';
import '../../../domain/entities/health_benefits.dart';
import '../../../data/repositories/local_progress_repository.dart';

part 'progress_event.dart';
part 'progress_state.dart';

/// BLoC de progresso do usuário
class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final LocalProgressRepository repository;

  ProgressBloc({required this.repository}) : super(ProgressInitial()) {
    on<LoadProgressEvent>(_onLoadProgress);
    on<InitializeProgressEvent>(_onInitializeProgress);
    on<UpdateProgressEvent>(_onUpdateProgress);
    on<RecordRelapseEvent>(_onRecordRelapse);
    on<ResetProgressEvent>(_onResetProgress);
    on<IncrementDayEvent>(_onIncrementDay);
  }

  Future<void> _onLoadProgress(
    LoadProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(ProgressLoading());
    
    try {
      // Tentar carregar do repositório local
      Progress? progress = repository.getProgress();
      
      // Se não existir (primeira vez), cria novo
      progress ??= Progress.initial();
      
      emit(ProgressLoaded(
        progress: progress,
        healthBenefits: progress.healthBenefits, // Assumindo getter
      ));
    } catch (e) {
      emit(ProgressError(message: 'Erro ao carregar progresso: $e'));
    }
  }

  Future<void> _onUpdateProgress(
    UpdateProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProgressLoaded) {
      emit(currentState.copyWith(
        progress: event.progress,
        healthBenefits: event.progress.healthBenefits,
      ));
    }
  }

  Future<void> _onRecordRelapse(
    RecordRelapseEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProgressLoaded) {
      final updatedProgress = currentState.progress.recordRelapse(
        cigarettesSmoked: event.cigarettesSmoked,
      );
      
      emit(currentState.copyWith(
        progress: updatedProgress,
        healthBenefits: updatedProgress.healthBenefits,
        lastRelapse: DateTime.now(),
      ));
      
      // Salvar localmente
      await repository.saveProgress(updatedProgress);
    }
  }

  Future<void> _onResetProgress(
    ResetProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProgressLoaded) {
      final newProgress = Progress.initial();
      
      emit(currentState.copyWith(
        progress: newProgress,
        healthBenefits: newProgress.healthBenefits,
      ));
    }
  }

  Future<void> _onIncrementDay(
    IncrementDayEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProgressLoaded) {
      final updatedProgress = currentState.progress.updateDaily(
        cigarettesPerDay: event.cigarettesPerDay,
        pricePerCigarette: event.pricePerCigarette,
        minutesPerCigarette: event.minutesPerCigarette,
      );
      
      emit(currentState.copyWith(
        progress: updatedProgress,
        healthBenefits: updatedProgress.healthBenefits,
      ));
      
      await repository.saveProgress(updatedProgress);
    }
  }

  Future<void> _onInitializeProgress(
    InitializeProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(ProgressLoading());
    try {
      // Criar novo progresso inicial
      final newProgress = Progress(
        quitDate: event.quitDate,
        cigarettesSmoked: 0,
        moneySpent: 0,
        lifeLostMinutes: 0,
      );

      // Salvar com as configurações personalizadas
      await repository.saveProgress(
        newProgress,
        cigarettesPerDay: event.cigarettesPerDay,
        packPrice: event.packPrice,
      );

      emit(ProgressLoaded(
        progress: newProgress,
        healthBenefits: newProgress.healthBenefits,
      ));
    } catch (e) {
      emit(ProgressError(message: 'Erro ao criar plano: $e'));
    }
  }
}
