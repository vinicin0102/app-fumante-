import 'package:equatable/equatable.dart';

import 'smoking_profile.dart';
import 'progress.dart';
import 'gamification_profile.dart';
import 'user_settings.dart';

/// Entidade principal do usuário
class UserProfile extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SmokingProfile smokingProfile;
  final Progress progress;
  final GamificationProfile gamification;
  final UserSettings settings;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.createdAt,
    required this.updatedAt,
    required this.smokingProfile,
    required this.progress,
    required this.gamification,
    required this.settings,
  });

  /// Cria um perfil vazio/padrão para novo usuário
  factory UserProfile.empty({
    required String uid,
    required String email,
    String? displayName,
  }) {
    final now = DateTime.now();
    return UserProfile(
      uid: uid,
      email: email,
      displayName: displayName ?? 'Usuário',
      createdAt: now,
      updatedAt: now,
      smokingProfile: SmokingProfile.empty(),
      progress: Progress.initial(),
      gamification: GamificationProfile.initial(),
      settings: UserSettings.defaults(),
    );
  }

  /// Verifica se o usuário completou o onboarding
  bool get hasCompletedOnboarding => 
      smokingProfile.cigarettesPerDay > 0 && 
      smokingProfile.quitDate != null;

  /// Verifica se é usuário premium
  bool get isPremium => settings.subscription.isPremium;

  /// Retorna o nível do usuário formatado
  String get levelTitle => gamification.levelTitle;

  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? createdAt,
    DateTime? updatedAt,
    SmokingProfile? smokingProfile,
    Progress? progress,
    GamificationProfile? gamification,
    UserSettings? settings,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      smokingProfile: smokingProfile ?? this.smokingProfile,
      progress: progress ?? this.progress,
      gamification: gamification ?? this.gamification,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoURL,
        createdAt,
        updatedAt,
        smokingProfile,
        progress,
        gamification,
        settings,
      ];
}
