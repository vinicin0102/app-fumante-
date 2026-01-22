part of 'auth_bloc.dart';

/// Eventos de autenticação
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Verifica o status de autenticação
class CheckAuthStatusEvent extends AuthEvent {}

/// Login com Google
class SignInWithGoogleEvent extends AuthEvent {}

/// Login com Apple
class SignInWithAppleEvent extends AuthEvent {}

/// Login anônimo
class SignInAnonymouslyEvent extends AuthEvent {}

/// Logout
class SignOutEvent extends AuthEvent {}

/// Atualiza perfil do usuário
class UpdateUserProfileEvent extends AuthEvent {
  final UserProfile user;

  const UpdateUserProfileEvent({required this.user});

  @override
  List<Object?> get props => [user];
}
