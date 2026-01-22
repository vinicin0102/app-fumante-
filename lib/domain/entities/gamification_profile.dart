import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Perfil de gamificação do usuário
class GamificationProfile extends Equatable {
  final int xp;
  final int level;
  final List<String> badges;
  final Map<String, Achievement> achievements;
  final bool dailyMissionCompleted;
  final Map<String, int> weeklyMissionProgress;
  final int consecutiveDaysUsed; // Dias consecutivos usando o app

  const GamificationProfile({
    required this.xp,
    required this.level,
    required this.badges,
    required this.achievements,
    required this.dailyMissionCompleted,
    required this.weeklyMissionProgress,
    this.consecutiveDaysUsed = 0,
  });

  factory GamificationProfile.initial() {
    return const GamificationProfile(
      xp: 0,
      level: 1,
      badges: [],
      achievements: {},
      dailyMissionCompleted: false,
      weeklyMissionProgress: {},
    );
  }

  /// Título do nível atual
  String get levelTitle {
    if (level >= 50) return 'Lenda';
    if (level >= 30) return 'Mestre';
    if (level >= 20) return 'Vencedor';
    if (level >= 10) return 'Resistente';
    if (level >= 5) return 'Determinado';
    return 'Iniciante';
  }

  /// XP necessário para próximo nível
  int get xpForNextLevel {
    return _calculateXpForLevel(level + 1);
  }

  /// XP do nível atual
  int get xpForCurrentLevel {
    return _calculateXpForLevel(level);
  }

  /// Progresso para o próximo nível (0.0 a 1.0)
  double get levelProgress {
    final currentLevelXp = xpForCurrentLevel;
    final nextLevelXp = xpForNextLevel;
    return (xp - currentLevelXp) / (nextLevelXp - currentLevelXp);
  }

  /// Total de conquistas desbloqueadas
  int get achievementsUnlocked {
    return achievements.values.where((a) => a.unlocked).length;
  }

  /// Calcula o XP necessário para um nível
  static int _calculateXpForLevel(int level) {
    if (level <= 1) return 0;
    if (level == 2) return 100;
    if (level == 3) return 300;
    if (level == 4) return 600;
    if (level == 5) return 1000;
    // Após nível 5, aumenta 500 por nível
    return 1000 + ((level - 5) * 500);
  }

  /// Calcula o nível baseado no XP
  static int calculateLevel(int xp) {
    int level = 1;
    while (_calculateXpForLevel(level + 1) <= xp) {
      level++;
    }
    return level;
  }

  /// Adiciona XP e retorna o novo perfil
  GamificationProfile addXp(int amount) {
    final newXp = xp + amount;
    final newLevel = calculateLevel(newXp);
    return copyWith(
      xp: newXp,
      level: newLevel,
    );
  }

  /// Desbloqueia uma conquista
  GamificationProfile unlockAchievement(String achievementId) {
    if (!achievements.containsKey(achievementId)) return this;
    
    final achievement = achievements[achievementId]!;
    if (achievement.unlocked) return this;
    
    final updatedAchievements = Map<String, Achievement>.from(achievements);
    updatedAchievements[achievementId] = achievement.copyWith(
      unlocked: true,
      unlockedAt: DateTime.now(),
    );

    return copyWith(
      achievements: updatedAchievements,
      xp: xp + achievement.xpReward,
    );
  }

  GamificationProfile copyWith({
    int? xp,
    int? level,
    List<String>? badges,
    Map<String, Achievement>? achievements,
    bool? dailyMissionCompleted,
    Map<String, int>? weeklyMissionProgress,
    int? consecutiveDaysUsed,
  }) {
    return GamificationProfile(
      xp: xp ?? this.xp,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      achievements: achievements ?? this.achievements,
      dailyMissionCompleted: dailyMissionCompleted ?? this.dailyMissionCompleted,
      weeklyMissionProgress: weeklyMissionProgress ?? this.weeklyMissionProgress,
      consecutiveDaysUsed: consecutiveDaysUsed ?? this.consecutiveDaysUsed,
    );
  }

  @override
  List<Object?> get props => [
        xp,
        level,
        badges,
        achievements,
        dailyMissionCompleted,
        weeklyMissionProgress,
        consecutiveDaysUsed,
      ];
}

/// Representa uma conquista
class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int xpReward;
  final AchievementCategory category;
  final bool unlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 a 1.0 para conquistas progressivas
  final int? targetValue;
  final int? currentValue;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.category,
    this.unlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
    this.targetValue,
    this.currentValue,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    int? xpReward,
    AchievementCategory? category,
    bool? unlocked,
    DateTime? unlockedAt,
    double? progress,
    int? targetValue,
    int? currentValue,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      xpReward: xpReward ?? this.xpReward,
      category: category ?? this.category,
      unlocked: unlocked ?? this.unlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        icon,
        xpReward,
        category,
        unlocked,
        unlockedAt,
        progress,
        targetValue,
        currentValue,
      ];
}

/// Categorias de conquistas
enum AchievementCategory {
  streak, // Sequências de dias
  milestone, // Marcos de tempo
  engagement, // Uso do app
  community, // Participação na comunidade
  therapy, // Exercícios TCC
  special, // Conquistas especiais
}

extension AchievementCategoryExtension on AchievementCategory {
  String get displayName {
    switch (this) {
      case AchievementCategory.streak:
        return 'Sequências';
      case AchievementCategory.milestone:
        return 'Marcos';
      case AchievementCategory.engagement:
        return 'Engajamento';
      case AchievementCategory.community:
        return 'Comunidade';
      case AchievementCategory.therapy:
        return 'Terapia';
      case AchievementCategory.special:
        return 'Especiais';
    }
  }

  IconData get icon {
    switch (this) {
      case AchievementCategory.streak:
        return Icons.local_fire_department;
      case AchievementCategory.milestone:
        return Icons.flag;
      case AchievementCategory.engagement:
        return Icons.touch_app;
      case AchievementCategory.community:
        return Icons.people;
      case AchievementCategory.therapy:
        return Icons.psychology;
      case AchievementCategory.special:
        return Icons.stars;
    }
  }
}

/// Lista de todas as conquistas disponíveis
class AchievementsList {
  static List<Achievement> get all => [
        // Conquistas de Streak
        const Achievement(
          id: 'first_day',
          title: 'Primeiro Dia',
          description: 'Complete 24 horas sem fumar',
          icon: Icons.flag,
          xpReward: 50,
          category: AchievementCategory.streak,
        ),
        const Achievement(
          id: 'week_warrior',
          title: 'Guerreiro da Semana',
          description: '7 dias consecutivos sem fumar',
          icon: Icons.workspace_premium,
          xpReward: 150,
          category: AchievementCategory.streak,
        ),
        const Achievement(
          id: 'two_weeks_strong',
          title: 'Duas Semanas Fortes',
          description: '14 dias consecutivos sem fumar',
          icon: Icons.military_tech,
          xpReward: 300,
          category: AchievementCategory.streak,
        ),
        const Achievement(
          id: 'monthly_champion',
          title: 'Campeão do Mês',
          description: '30 dias consecutivos sem fumar',
          icon: Icons.emoji_events,
          xpReward: 500,
          category: AchievementCategory.streak,
        ),
        const Achievement(
          id: 'quarterly_hero',
          title: 'Herói Trimestral',
          description: '90 dias consecutivos sem fumar',
          icon: Icons.shield,
          xpReward: 1000,
          category: AchievementCategory.streak,
        ),
        const Achievement(
          id: 'half_year_legend',
          title: 'Lenda de 6 Meses',
          description: '180 dias consecutivos sem fumar',
          icon: Icons.star,
          xpReward: 2000,
          category: AchievementCategory.streak,
        ),
        const Achievement(
          id: 'year_master',
          title: 'Mestre do Ano',
          description: 'Um ano inteiro sem fumar!',
          icon: Icons.celebration,
          xpReward: 5000,
          category: AchievementCategory.streak,
        ),

        // Conquistas de Engajamento
        const Achievement(
          id: 'first_journal',
          title: 'Primeiro Diário',
          description: 'Registre sua primeira entrada no diário',
          icon: Icons.book,
          xpReward: 25,
          category: AchievementCategory.engagement,
        ),
        const Achievement(
          id: 'journal_habit',
          title: 'Hábito do Diário',
          description: 'Registre 7 entradas no diário',
          icon: Icons.edit_note,
          xpReward: 75,
          category: AchievementCategory.engagement,
        ),
        const Achievement(
          id: 'craving_crusher',
          title: 'Destruidor de Vontades',
          description: 'Resista a 10 crises de vontade',
          icon: Icons.flash_on,
          xpReward: 100,
          category: AchievementCategory.engagement,
        ),

        // Conquistas de Terapia
        const Achievement(
          id: 'first_exercise',
          title: 'Primeiro Exercício',
          description: 'Complete seu primeiro exercício TCC',
          icon: Icons.self_improvement,
          xpReward: 30,
          category: AchievementCategory.therapy,
        ),
        const Achievement(
          id: 'breathing_master',
          title: 'Mestre da Respiração',
          description: 'Complete 10 exercícios de respiração',
          icon: Icons.air,
          xpReward: 100,
          category: AchievementCategory.therapy,
        ),
        const Achievement(
          id: 'cognitive_warrior',
          title: 'Guerreiro Cognitivo',
          description: 'Complete 10 exercícios de reestruturação cognitiva',
          icon: Icons.psychology,
          xpReward: 150,
          category: AchievementCategory.therapy,
        ),

        // Conquistas de Comunidade
        const Achievement(
          id: 'first_post',
          title: 'Primeiro Post',
          description: 'Compartilhe sua jornada na comunidade',
          icon: Icons.chat,
          xpReward: 20,
          category: AchievementCategory.community,
        ),
        const Achievement(
          id: 'helpful_member',
          title: 'Membro Prestativo',
          description: 'Receba 10 curtidas em seus posts',
          icon: Icons.favorite,
          xpReward: 100,
          category: AchievementCategory.community,
        ),
        const Achievement(
          id: 'community_pillar',
          title: 'Pilar da Comunidade',
          description: 'Ajude 5 membros da comunidade',
          icon: Icons.people_alt,
          xpReward: 200,
          category: AchievementCategory.community,
        ),

        // Conquistas Especiais
        const Achievement(
          id: 'money_saver_100',
          title: 'Economizador',
          description: 'Economize R\$ 100 deixando de fumar',
          icon: Icons.savings,
          xpReward: 50,
          category: AchievementCategory.special,
        ),
        const Achievement(
          id: 'money_saver_500',
          title: 'Grande Poupador',
          description: 'Economize R\$ 500 deixando de fumar',
          icon: Icons.attach_money,
          xpReward: 200,
          category: AchievementCategory.special,
        ),
        const Achievement(
          id: 'life_saver',
          title: 'Vida Recuperada',
          description: 'Recupere 24 horas de vida',
          icon: Icons.access_time_filled,
          xpReward: 100,
          category: AchievementCategory.special,
        ),
        const Achievement(
          id: 'cigarettes_avoided_100',
          title: 'Centenário',
          description: 'Evite 100 cigarros',
          icon: Icons.smoke_free,
          xpReward: 100,
          category: AchievementCategory.special,
        ),
        const Achievement(
          id: 'cigarettes_avoided_1000',
          title: 'Milésimo',
          description: 'Evite 1000 cigarros',
          icon: Icons.whatshot,
          xpReward: 500,
          category: AchievementCategory.special,
        ),
      ];
}
