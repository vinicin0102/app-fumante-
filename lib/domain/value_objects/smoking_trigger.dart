import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Gatilhos de vontade de fumar
enum SmokingTrigger {
  afterCoffee,
  stress,
  social,
  boredom,
  afterMeal,
  alcohol,
  driving,
  wakeUp,
  breakTime,
  anxiety,
  sadness,
  anger,
  celebration,
  habit,
  other,
}

extension SmokingTriggerExtension on SmokingTrigger {
  String get displayName {
    switch (this) {
      case SmokingTrigger.afterCoffee:
        return 'Após o café';
      case SmokingTrigger.stress:
        return 'Estresse';
      case SmokingTrigger.social:
        return 'Situação social';
      case SmokingTrigger.boredom:
        return 'Tédio';
      case SmokingTrigger.afterMeal:
        return 'Após refeição';
      case SmokingTrigger.alcohol:
        return 'Bebida alcoólica';
      case SmokingTrigger.driving:
        return 'Dirigindo';
      case SmokingTrigger.wakeUp:
        return 'Ao acordar';
      case SmokingTrigger.breakTime:
        return 'Pausa no trabalho';
      case SmokingTrigger.anxiety:
        return 'Ansiedade';
      case SmokingTrigger.sadness:
        return 'Tristeza';
      case SmokingTrigger.anger:
        return 'Raiva';
      case SmokingTrigger.celebration:
        return 'Celebração';
      case SmokingTrigger.habit:
        return 'Hábito automático';
      case SmokingTrigger.other:
        return 'Outro';
    }
  }

  String get description {
    switch (this) {
      case SmokingTrigger.afterCoffee:
        return 'A combinação café e cigarro é clássica. Experimente mudar de bebida!';
      case SmokingTrigger.stress:
        return 'O estresse é um gatilho forte. Exercícios de respiração podem ajudar.';
      case SmokingTrigger.social:
        return 'Fumar em grupo cria associação. Avise amigos sobre sua meta!';
      case SmokingTrigger.boredom:
        return 'O cigarro preenche o tempo. Encontre uma atividade substituta.';
      case SmokingTrigger.afterMeal:
        return 'A digestão libera dopamina. Levante-se e caminhe após comer.';
      case SmokingTrigger.alcohol:
        return 'Álcool diminui inibição. Evite ou reduza bebidas no início.';
      case SmokingTrigger.driving:
        return 'O carro é um ambiente associado. Mantenha balas ou água no carro.';
      case SmokingTrigger.wakeUp:
        return 'O cigarro matinal é intenso. Mude sua rotina de acordar.';
      case SmokingTrigger.breakTime:
        return 'A pausa é ritual. Caminhe ou tome água ao invés de fumar.';
      case SmokingTrigger.anxiety:
        return 'A nicotina dá falsa calma. Técnicas de relaxamento ajudam de verdade.';
      case SmokingTrigger.sadness:
        return 'Fumar não alivia tristeza. Fale com alguém ou escreva no diário.';
      case SmokingTrigger.anger:
        return 'Raiva e cigarro são comuns. Respire fundo antes de agir.';
      case SmokingTrigger.celebration:
        return 'Celebrar sem cigarro é possível. Encontre outras formas de comemorar!';
      case SmokingTrigger.habit:
        return 'Às vezes é automático. Preste atenção e quebre o padrão.';
      case SmokingTrigger.other:
        return 'Identifique o padrão para entender melhor seus gatilhos.';
    }
  }

  IconData get icon {
    switch (this) {
      case SmokingTrigger.afterCoffee:
        return Icons.coffee;
      case SmokingTrigger.stress:
        return Icons.psychology_alt;
      case SmokingTrigger.social:
        return Icons.people;
      case SmokingTrigger.boredom:
        return Icons.hourglass_empty;
      case SmokingTrigger.afterMeal:
        return Icons.restaurant;
      case SmokingTrigger.alcohol:
        return Icons.local_bar;
      case SmokingTrigger.driving:
        return Icons.directions_car;
      case SmokingTrigger.wakeUp:
        return Icons.wb_sunny;
      case SmokingTrigger.breakTime:
        return Icons.free_breakfast;
      case SmokingTrigger.anxiety:
        return Icons.sentiment_very_dissatisfied;
      case SmokingTrigger.sadness:
        return Icons.mood_bad;
      case SmokingTrigger.anger:
        return Icons.whatshot;
      case SmokingTrigger.celebration:
        return Icons.celebration;
      case SmokingTrigger.habit:
        return Icons.autorenew;
      case SmokingTrigger.other:
        return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case SmokingTrigger.afterCoffee:
        return AppColors.triggerCoffee;
      case SmokingTrigger.stress:
        return AppColors.triggerStress;
      case SmokingTrigger.social:
        return AppColors.triggerSocial;
      case SmokingTrigger.boredom:
        return AppColors.triggerBoredom;
      case SmokingTrigger.afterMeal:
        return AppColors.triggerMeal;
      case SmokingTrigger.alcohol:
        return AppColors.triggerAlcohol;
      case SmokingTrigger.driving:
        return const Color(0xFF0891B2);
      case SmokingTrigger.wakeUp:
        return const Color(0xFFF59E0B);
      case SmokingTrigger.breakTime:
        return const Color(0xFF10B981);
      case SmokingTrigger.anxiety:
        return const Color(0xFFEC4899);
      case SmokingTrigger.sadness:
        return const Color(0xFF6366F1);
      case SmokingTrigger.anger:
        return const Color(0xFFEF4444);
      case SmokingTrigger.celebration:
        return const Color(0xFFF97316);
      case SmokingTrigger.habit:
        return const Color(0xFF6B7280);
      case SmokingTrigger.other:
        return const Color(0xFF9CA3AF);
    }
  }

  /// Sugestão de ação para o gatilho
  String get actionSuggestion {
    switch (this) {
      case SmokingTrigger.afterCoffee:
        return 'Troque o café por chá ou água com limão';
      case SmokingTrigger.stress:
        return 'Faça 5 respirações profundas';
      case SmokingTrigger.social:
        return 'Avise seus amigos que você parou de fumar';
      case SmokingTrigger.boredom:
        return 'Tenha um hobby ou jogo sempre à mão';
      case SmokingTrigger.afterMeal:
        return 'Escove os dentes ou caminhe após comer';
      case SmokingTrigger.alcohol:
        return 'Limite ou evite bebidas alcoólicas';
      case SmokingTrigger.driving:
        return 'Mantenha chicletes ou balas no carro';
      case SmokingTrigger.wakeUp:
        return 'Comece o dia com um copo de água';
      case SmokingTrigger.breakTime:
        return 'Use a pausa para se alongar';
      case SmokingTrigger.anxiety:
        return 'Pratique a técnica 4-7-8 de respiração';
      case SmokingTrigger.sadness:
        return 'Fale com alguém de confiança';
      case SmokingTrigger.anger:
        return 'Conte até 10 antes de reagir';
      case SmokingTrigger.celebration:
        return 'Celebre com uma atividade prazerosa';
      case SmokingTrigger.habit:
        return 'Mude sua rotina para quebrar o padrão';
      case SmokingTrigger.other:
        return 'Observe e anote o que desencadeou a vontade';
    }
  }
}

/// Objeto de valor para representar um gatilho com dados adicionais
class TriggerData extends Equatable {
  final SmokingTrigger trigger;
  final int occurrences;
  final DateTime? lastOccurrence;
  final double averageIntensity;
  final int timesResisted;

  const TriggerData({
    required this.trigger,
    this.occurrences = 0,
    this.lastOccurrence,
    this.averageIntensity = 0.0,
    this.timesResisted = 0,
  });

  /// Taxa de resistência (0.0 a 1.0)
  double get resistanceRate {
    if (occurrences == 0) return 0.0;
    return timesResisted / occurrences;
  }

  /// Indica se é um gatilho crítico (muitas ocorrências, baixa resistência)
  bool get isCritical {
    return occurrences >= 5 && resistanceRate < 0.5;
  }

  TriggerData copyWith({
    SmokingTrigger? trigger,
    int? occurrences,
    DateTime? lastOccurrence,
    double? averageIntensity,
    int? timesResisted,
  }) {
    return TriggerData(
      trigger: trigger ?? this.trigger,
      occurrences: occurrences ?? this.occurrences,
      lastOccurrence: lastOccurrence ?? this.lastOccurrence,
      averageIntensity: averageIntensity ?? this.averageIntensity,
      timesResisted: timesResisted ?? this.timesResisted,
    );
  }

  @override
  List<Object?> get props => [
        trigger,
        occurrences,
        lastOccurrence,
        averageIntensity,
        timesResisted,
      ];
}
