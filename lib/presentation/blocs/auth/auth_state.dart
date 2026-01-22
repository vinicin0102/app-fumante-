part of 'auth_bloc.dart';

/// Estados de autenticação
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AuthInitial extends AuthState {}

/// Carregando autenticação
class AuthLoading extends AuthState {}

/// Usuário autenticado
class AuthAuthenticated extends AuthState {
  final UserProfile user;
  final bool isAnonymous;
  final bool needsOnboarding;

  const AuthAuthenticated({
    required this.user,
    this.isAnonymous = false,
    this.needsOnboarding = false,
  });

  /// Verifica se precisa de onboarding
  bool get shouldShowOnboarding => 
      needsOnboarding || !user.hasCompletedOnboarding;

  AuthAuthenticated copyWith({
    UserProfile? user,
    bool? isAnonymous,
    bool? needsOnboarding,
  }) {
    return AuthAuthenticated(
      user: user ?? this.user,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      needsOnboarding: needsOnboarding ?? this.needsOnboarding,
    );
  }

  @override
  List<Object?> get props => [user, isAnonymous, needsOnboarding];
}

/// Usuário não autenticado
class AuthUnauthenticated extends AuthState {}

/// Erro de autenticação
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
