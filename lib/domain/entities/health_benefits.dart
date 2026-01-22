import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Representa os benefícios de saúde baseados no tempo sem fumar
class HealthBenefits extends Equatable {
  final List<HealthMilestone> achievedMilestones;
  final HealthMilestone? currentMilestone;
  final HealthMilestone? nextMilestone;
  final double overallHealthScore; // 0-100

  const HealthBenefits({
    required this.achievedMilestones,
    this.currentMilestone,
    this.nextMilestone,
    required this.overallHealthScore,
  });

  /// Calcula os benefícios com base nos dias sem fumar
  factory HealthBenefits.calculate(int daysWithoutSmoking) {
    final hoursWithoutSmoking = daysWithoutSmoking * 24;
    
    final achieved = <HealthMilestone>[];
    HealthMilestone? current;
    HealthMilestone? next;

    for (int i = 0; i < allMilestones.length; i++) {
      final milestone = allMilestones[i];
      
      if (hoursWithoutSmoking >= milestone.hoursRequired) {
        achieved.add(milestone.copyWith(achieved: true));
        current = milestone;
      } else {
        if (next == null) {
          next = milestone;
        }
      }
    }

    // Calcula score de saúde (0-100)
    double healthScore;
    if (daysWithoutSmoking >= 365) {
      healthScore = 100;
    } else if (daysWithoutSmoking >= 180) {
      healthScore = 85 + ((daysWithoutSmoking - 180) / 185 * 15);
    } else if (daysWithoutSmoking >= 90) {
      healthScore = 70 + ((daysWithoutSmoking - 90) / 90 * 15);
    } else if (daysWithoutSmoking >= 30) {
      healthScore = 50 + ((daysWithoutSmoking - 30) / 60 * 20);
    } else if (daysWithoutSmoking >= 7) {
      healthScore = 30 + ((daysWithoutSmoking - 7) / 23 * 20);
    } else if (daysWithoutSmoking >= 1) {
      healthScore = 10 + ((daysWithoutSmoking - 1) / 6 * 20);
    } else {
      healthScore = daysWithoutSmoking * 10.0;
    }

    return HealthBenefits(
      achievedMilestones: achieved,
      currentMilestone: current,
      nextMilestone: next,
      overallHealthScore: healthScore.clamp(0, 100),
    );
  }

  /// Lista de todos os marcos de saúde
  static const List<HealthMilestone> allMilestones = [
    // Primeiras horas
    HealthMilestone(
      id: '20_min',
      title: '20 Minutos',
      hoursRequired: 0.33, // 20 minutos
      benefit: 'Sua pressão arterial e frequência cardíaca começam a voltar ao normal.',
      detailedBenefit: 'O corpo já começa a se recuperar! A nicotina elevou sua pressão e batimentos, mas eles estão normalizando.',
      icon: Icons.favorite_outline,
      category: MilestoneCategory.cardiovascular,
    ),
    HealthMilestone(
      id: '2_hours',
      title: '2 Horas',
      hoursRequired: 2,
      benefit: 'Nicotina começa a ser eliminada do corpo.',
      detailedBenefit: 'Seu corpo está trabalhando para eliminar a nicotina. Você pode sentir vontade de fumar - é normal!',
      icon: Icons.water_drop_outlined,
      category: MilestoneCategory.detox,
    ),
    HealthMilestone(
      id: '8_hours',
      title: '8 Horas',
      hoursRequired: 8,
      benefit: 'Nível de monóxido de carbono no sangue diminui.',
      detailedBenefit: 'O monóxido de carbono do cigarro está sendo substituído por oxigênio. Suas células começam a receber mais O2.',
      icon: Icons.air,
      category: MilestoneCategory.respiratory,
    ),
    HealthMilestone(
      id: '24_hours',
      title: '24 Horas',
      hoursRequired: 24,
      benefit: 'Risco de ataque cardíaco começa a diminuir.',
      detailedBenefit: 'Um dia inteiro! O monóxido de carbono foi eliminado. Seu coração já agradece.',
      icon: Icons.favorite,
      category: MilestoneCategory.cardiovascular,
    ),
    HealthMilestone(
      id: '48_hours',
      title: '48 Horas',
      hoursRequired: 48,
      benefit: 'Terminações nervosas começam a se regenerar. Paladar e olfato melhoram.',
      detailedBenefit: 'Você pode notar que as comidas têm mais sabor e os aromas estão mais intensos!',
      icon: Icons.restaurant,
      category: MilestoneCategory.sensorial,
    ),
    HealthMilestone(
      id: '72_hours',
      title: '72 Horas',
      hoursRequired: 72,
      benefit: 'Bronquíolos relaxam, facilitando a respiração. Capacidade pulmonar aumenta.',
      detailedBenefit: 'Respirar está mais fácil! Os tubos bronquiais estão relaxando e seus pulmões trabalham melhor.',
      icon: Icons.spa,
      category: MilestoneCategory.respiratory,
    ),
    // Primeira semana
    HealthMilestone(
      id: '1_week',
      title: '1 Semana',
      hoursRequired: 168,
      benefit: 'Circulação sanguínea melhora significativamente.',
      detailedBenefit: 'Uma semana de vitória! Sua circulação está melhorando e você pode notar mais disposição.',
      icon: Icons.directions_run,
      category: MilestoneCategory.cardiovascular,
    ),
    // Duas semanas
    HealthMilestone(
      id: '2_weeks',
      title: '2 Semanas',
      hoursRequired: 336,
      benefit: 'Função pulmonar aumenta até 30%. Andar fica mais fácil.',
      detailedBenefit: 'Seus pulmões estão se recuperando! Atividades físicas ficam mais fáceis.',
      icon: Icons.trending_up,
      category: MilestoneCategory.respiratory,
    ),
    // Um mês
    HealthMilestone(
      id: '1_month',
      title: '1 Mês',
      hoursRequired: 720,
      benefit: 'Tosse diminui. Cílios pulmonares se recuperam. Menor risco de infecções.',
      detailedBenefit: 'Um mês incrível! Os cílios dos pulmões, que limpam o muco, estão funcionando novamente.',
      icon: Icons.verified,
      category: MilestoneCategory.respiratory,
    ),
    // Três meses
    HealthMilestone(
      id: '3_months',
      title: '3 Meses',
      hoursRequired: 2160,
      benefit: 'Circulação e função pulmonar melhoram muito. Produção de muco normaliza.',
      detailedBenefit: 'Trimestre de conquistas! Seus pulmões e coração estão muito mais saudáveis.',
      icon: Icons.emoji_events,
      category: MilestoneCategory.general,
    ),
    // Seis meses
    HealthMilestone(
      id: '6_months',
      title: '6 Meses',
      hoursRequired: 4320,
      benefit: 'Ataques de tosse e falta de ar diminuem drasticamente.',
      detailedBenefit: 'Meio ano livre do cigarro! Sua energia está em alta e o fôlego muito melhor.',
      icon: Icons.military_tech,
      category: MilestoneCategory.respiratory,
    ),
    // Um ano
    HealthMilestone(
      id: '1_year',
      title: '1 Ano',
      hoursRequired: 8760,
      benefit: 'Risco de doença cardíaca cai pela metade em relação a um fumante.',
      detailedBenefit: 'Um ano de liberdade! Seu risco de infarto é 50% menor que quando fumava.',
      icon: Icons.celebration,
      category: MilestoneCategory.cardiovascular,
    ),
    // Cinco anos
    HealthMilestone(
      id: '5_years',
      title: '5 Anos',
      hoursRequired: 43800,
      benefit: 'Risco de AVC igual ao de quem nunca fumou.',
      detailedBenefit: 'Cinco anos de conquista! Seu risco de derrame é como o de um não-fumante.',
      icon: Icons.stars,
      category: MilestoneCategory.cardiovascular,
    ),
    // Dez anos
    HealthMilestone(
      id: '10_years',
      title: '10 Anos',
      hoursRequired: 87600,
      benefit: 'Risco de câncer de pulmão cai pela metade. Risco de outros cânceres também diminui.',
      detailedBenefit: 'Uma década de liberdade! Seu risco de câncer de pulmão é 50% menor.',
      icon: Icons.workspace_premium,
      category: MilestoneCategory.cancer,
    ),
    // Quinze anos
    HealthMilestone(
      id: '15_years',
      title: '15 Anos',
      hoursRequired: 131400,
      benefit: 'Risco de doença cardíaca igual ao de quem nunca fumou.',
      detailedBenefit: 'Quinze anos! Seu coração é tão saudável quanto o de quem nunca fumou.',
      icon: Icons.shield,
      category: MilestoneCategory.cardiovascular,
    ),
  ];

  @override
  List<Object?> get props => [
        achievedMilestones,
        currentMilestone,
        nextMilestone,
        overallHealthScore,
      ];
}

/// Representa um marco de saúde específico
class HealthMilestone extends Equatable {
  final String id;
  final String title;
  final double hoursRequired;
  final String benefit;
  final String detailedBenefit;
  final IconData icon;
  final MilestoneCategory category;
  final bool achieved;
  final DateTime? achievedAt;

  const HealthMilestone({
    required this.id,
    required this.title,
    required this.hoursRequired,
    required this.benefit,
    required this.detailedBenefit,
    required this.icon,
    required this.category,
    this.achieved = false,
    this.achievedAt,
  });

  /// Dias necessários para atingir o marco
  int get daysRequired => (hoursRequired / 24).ceil();

  /// Descrição do tempo necessário
  String get timeDescription {
    if (hoursRequired < 1) {
      return '${(hoursRequired * 60).round()} minutos';
    } else if (hoursRequired < 24) {
      return '${hoursRequired.round()} horas';
    } else if (hoursRequired < 168) {
      return '$daysRequired dias';
    } else if (hoursRequired < 720) {
      return '${(hoursRequired / 168).round()} semanas';
    } else if (hoursRequired < 8760) {
      return '${(hoursRequired / 720).round()} meses';
    } else {
      return '${(hoursRequired / 8760).round()} anos';
    }
  }

  HealthMilestone copyWith({
    String? id,
    String? title,
    double? hoursRequired,
    String? benefit,
    String? detailedBenefit,
    IconData? icon,
    MilestoneCategory? category,
    bool? achieved,
    DateTime? achievedAt,
  }) {
    return HealthMilestone(
      id: id ?? this.id,
      title: title ?? this.title,
      hoursRequired: hoursRequired ?? this.hoursRequired,
      benefit: benefit ?? this.benefit,
      detailedBenefit: detailedBenefit ?? this.detailedBenefit,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      achieved: achieved ?? this.achieved,
      achievedAt: achievedAt ?? this.achievedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        hoursRequired,
        benefit,
        detailedBenefit,
        icon,
        category,
        achieved,
        achievedAt,
      ];
}

/// Categorias de marcos de saúde
enum MilestoneCategory {
  cardiovascular,
  respiratory,
  sensorial,
  detox,
  cancer,
  general,
}

extension MilestoneCategoryExtension on MilestoneCategory {
  String get displayName {
    switch (this) {
      case MilestoneCategory.cardiovascular:
        return 'Cardiovascular';
      case MilestoneCategory.respiratory:
        return 'Respiratório';
      case MilestoneCategory.sensorial:
        return 'Sentidos';
      case MilestoneCategory.detox:
        return 'Desintoxicação';
      case MilestoneCategory.cancer:
        return 'Prevenção de Câncer';
      case MilestoneCategory.general:
        return 'Saúde Geral';
    }
  }

  IconData get icon {
    switch (this) {
      case MilestoneCategory.cardiovascular:
        return Icons.favorite;
      case MilestoneCategory.respiratory:
        return Icons.air;
      case MilestoneCategory.sensorial:
        return Icons.visibility;
      case MilestoneCategory.detox:
        return Icons.cleaning_services;
      case MilestoneCategory.cancer:
        return Icons.shield;
      case MilestoneCategory.general:
        return Icons.health_and_safety;
    }
  }
}
