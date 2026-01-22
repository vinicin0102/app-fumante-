import 'package:equatable/equatable.dart';

/// Configurações do usuário
class UserSettings extends Equatable {
  final NotificationSettings notifications;
  final PrivacySettings privacy;
  final SubscriptionSettings subscription;
  final AppPreferences preferences;

  const UserSettings({
    required this.notifications,
    required this.privacy,
    required this.subscription,
    required this.preferences,
  });

  factory UserSettings.defaults() {
    return UserSettings(
      notifications: NotificationSettings.defaults(),
      privacy: PrivacySettings.defaults(),
      subscription: SubscriptionSettings.free(),
      preferences: AppPreferences.defaults(),
    );
  }

  UserSettings copyWith({
    NotificationSettings? notifications,
    PrivacySettings? privacy,
    SubscriptionSettings? subscription,
    AppPreferences? preferences,
  }) {
    return UserSettings(
      notifications: notifications ?? this.notifications,
      privacy: privacy ?? this.privacy,
      subscription: subscription ?? this.subscription,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [notifications, privacy, subscription, preferences];
}

/// Configurações de notificações
class NotificationSettings extends Equatable {
  final bool enabled;
  final TimeOfDay? morningReminder;
  final TimeOfDay? eveningCheckin;
  final bool milestoneAlerts;
  final bool cravingReminders;
  final bool dailyMotivation;
  final bool communityAlerts;
  final bool weeklyReport;

  const NotificationSettings({
    required this.enabled,
    this.morningReminder,
    this.eveningCheckin,
    required this.milestoneAlerts,
    required this.cravingReminders,
    required this.dailyMotivation,
    required this.communityAlerts,
    required this.weeklyReport,
  });

  factory NotificationSettings.defaults() {
    return const NotificationSettings(
      enabled: true,
      morningReminder: TimeOfDay(hour: 8, minute: 0),
      eveningCheckin: TimeOfDay(hour: 20, minute: 0),
      milestoneAlerts: true,
      cravingReminders: true,
      dailyMotivation: true,
      communityAlerts: false,
      weeklyReport: true,
    );
  }

  NotificationSettings copyWith({
    bool? enabled,
    TimeOfDay? morningReminder,
    TimeOfDay? eveningCheckin,
    bool? milestoneAlerts,
    bool? cravingReminders,
    bool? dailyMotivation,
    bool? communityAlerts,
    bool? weeklyReport,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      morningReminder: morningReminder ?? this.morningReminder,
      eveningCheckin: eveningCheckin ?? this.eveningCheckin,
      milestoneAlerts: milestoneAlerts ?? this.milestoneAlerts,
      cravingReminders: cravingReminders ?? this.cravingReminders,
      dailyMotivation: dailyMotivation ?? this.dailyMotivation,
      communityAlerts: communityAlerts ?? this.communityAlerts,
      weeklyReport: weeklyReport ?? this.weeklyReport,
    );
  }

  @override
  List<Object?> get props => [
        enabled,
        morningReminder,
        eveningCheckin,
        milestoneAlerts,
        cravingReminders,
        dailyMotivation,
        communityAlerts,
        weeklyReport,
      ];
}

/// Configurações de privacidade
class PrivacySettings extends Equatable {
  final bool anonymousMode;
  final bool hideFromCommunity;
  final bool shareProgress;
  final bool allowDataAnalysis;

  const PrivacySettings({
    required this.anonymousMode,
    required this.hideFromCommunity,
    required this.shareProgress,
    required this.allowDataAnalysis,
  });

  factory PrivacySettings.defaults() {
    return const PrivacySettings(
      anonymousMode: false,
      hideFromCommunity: false,
      shareProgress: true,
      allowDataAnalysis: true,
    );
  }

  PrivacySettings copyWith({
    bool? anonymousMode,
    bool? hideFromCommunity,
    bool? shareProgress,
    bool? allowDataAnalysis,
  }) {
    return PrivacySettings(
      anonymousMode: anonymousMode ?? this.anonymousMode,
      hideFromCommunity: hideFromCommunity ?? this.hideFromCommunity,
      shareProgress: shareProgress ?? this.shareProgress,
      allowDataAnalysis: allowDataAnalysis ?? this.allowDataAnalysis,
    );
  }

  @override
  List<Object?> get props => [
        anonymousMode,
        hideFromCommunity,
        shareProgress,
        allowDataAnalysis,
      ];
}

/// Configurações de assinatura/plano
class SubscriptionSettings extends Equatable {
  final bool isPremium;
  final SubscriptionPlan plan;
  final DateTime? expiresAt;
  final DateTime? startedAt;
  final bool autoRenew;

  const SubscriptionSettings({
    required this.isPremium,
    required this.plan,
    this.expiresAt,
    this.startedAt,
    this.autoRenew = true,
  });

  factory SubscriptionSettings.free() {
    return const SubscriptionSettings(
      isPremium: false,
      plan: SubscriptionPlan.free,
    );
  }

  factory SubscriptionSettings.premium({
    required SubscriptionPlan plan,
    required DateTime expiresAt,
    required DateTime startedAt,
    bool autoRenew = true,
  }) {
    return SubscriptionSettings(
      isPremium: true,
      plan: plan,
      expiresAt: expiresAt,
      startedAt: startedAt,
      autoRenew: autoRenew,
    );
  }

  /// Verifica se a assinatura está ativa
  bool get isActive {
    if (!isPremium) return false;
    if (expiresAt == null) return false;
    return DateTime.now().isBefore(expiresAt!);
  }

  /// Dias restantes da assinatura
  int get daysRemaining {
    if (expiresAt == null) return 0;
    return expiresAt!.difference(DateTime.now()).inDays;
  }

  SubscriptionSettings copyWith({
    bool? isPremium,
    SubscriptionPlan? plan,
    DateTime? expiresAt,
    DateTime? startedAt,
    bool? autoRenew,
  }) {
    return SubscriptionSettings(
      isPremium: isPremium ?? this.isPremium,
      plan: plan ?? this.plan,
      expiresAt: expiresAt ?? this.expiresAt,
      startedAt: startedAt ?? this.startedAt,
      autoRenew: autoRenew ?? this.autoRenew,
    );
  }

  @override
  List<Object?> get props => [isPremium, plan, expiresAt, startedAt, autoRenew];
}

/// Tipos de plano de assinatura
enum SubscriptionPlan {
  free,
  monthly,
  quarterly,
  yearly,
  lifetime,
}

extension SubscriptionPlanExtension on SubscriptionPlan {
  String get displayName {
    switch (this) {
      case SubscriptionPlan.free:
        return 'Grátis';
      case SubscriptionPlan.monthly:
        return 'Mensal';
      case SubscriptionPlan.quarterly:
        return 'Trimestral';
      case SubscriptionPlan.yearly:
        return 'Anual';
      case SubscriptionPlan.lifetime:
        return 'Vitalício';
    }
  }

  String get description {
    switch (this) {
      case SubscriptionPlan.free:
        return 'Funcionalidades básicas';
      case SubscriptionPlan.monthly:
        return 'Acesso completo por 1 mês';
      case SubscriptionPlan.quarterly:
        return 'Acesso completo por 3 meses';
      case SubscriptionPlan.yearly:
        return 'Acesso completo por 1 ano';
      case SubscriptionPlan.lifetime:
        return 'Acesso completo para sempre';
    }
  }

  double get price {
    switch (this) {
      case SubscriptionPlan.free:
        return 0;
      case SubscriptionPlan.monthly:
        return 14.90;
      case SubscriptionPlan.quarterly:
        return 34.90;
      case SubscriptionPlan.yearly:
        return 99.90;
      case SubscriptionPlan.lifetime:
        return 199.90;
    }
  }

  double? get originalPrice {
    switch (this) {
      case SubscriptionPlan.quarterly:
        return 44.70; // 14.90 * 3
      case SubscriptionPlan.yearly:
        return 178.80; // 14.90 * 12
      default:
        return null;
    }
  }

  int? get discountPercent {
    switch (this) {
      case SubscriptionPlan.quarterly:
        return 22;
      case SubscriptionPlan.yearly:
        return 44;
      default:
        return null;
    }
  }
}

/// Preferências gerais do app
class AppPreferences extends Equatable {
  final String language;
  final String currency;
  final bool soundEnabled;
  final bool hapticFeedback;
  final bool showTips;
  final bool darkMode;
  final bool followSystemTheme;

  const AppPreferences({
    required this.language,
    required this.currency,
    required this.soundEnabled,
    required this.hapticFeedback,
    required this.showTips,
    required this.darkMode,
    required this.followSystemTheme,
  });

  factory AppPreferences.defaults() {
    return const AppPreferences(
      language: 'pt_BR',
      currency: 'BRL',
      soundEnabled: true,
      hapticFeedback: true,
      showTips: true,
      darkMode: false,
      followSystemTheme: true,
    );
  }

  AppPreferences copyWith({
    String? language,
    String? currency,
    bool? soundEnabled,
    bool? hapticFeedback,
    bool? showTips,
    bool? darkMode,
    bool? followSystemTheme,
  }) {
    return AppPreferences(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      showTips: showTips ?? this.showTips,
      darkMode: darkMode ?? this.darkMode,
      followSystemTheme: followSystemTheme ?? this.followSystemTheme,
    );
  }

  @override
  List<Object?> get props => [
        language,
        currency,
        soundEnabled,
        hapticFeedback,
        showTips,
        darkMode,
        followSystemTheme,
      ];
}

/// Helper para TimeOfDay (não tem Equatable por padrão)
class TimeOfDay extends Equatable {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  String get formatted {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  List<Object?> get props => [hour, minute];
}
