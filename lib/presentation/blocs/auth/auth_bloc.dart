import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_profile.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC de autenticação
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // final AuthRepository _authRepository;

  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignInWithAppleEvent>(_onSignInWithApple);
    on<SignInAnonymouslyEvent>(_onSignInAnonymously);
    on<SignOutEvent>(_onSignOut);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Verificar se há usuário autenticado
      // final user = await _authRepository.getCurrentUser();
      
      // Por enquanto, emite não autenticado
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Erro ao verificar autenticação: $e'));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Implementar login com Google
      // final user = await _authRepository.signInWithGoogle();
      // emit(AuthAuthenticated(user: user));
      
      emit(const AuthError(message: 'Login com Google ainda não implementado'));
    } catch (e) {
      emit(AuthError(message: 'Erro ao fazer login com Google: $e'));
    }
  }

  Future<void> _onSignInWithApple(
    SignInWithAppleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Implementar login com Apple
      emit(const AuthError(message: 'Login com Apple ainda não implementado'));
    } catch (e) {
      emit(AuthError(message: 'Erro ao fazer login com Apple: $e'));
    }
  }

  Future<void> _onSignInAnonymously(
    SignInAnonymouslyEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Criar usuário anônimo
      final user = UserProfile.empty(
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        email: 'anonymous@quitnow.app',
      );
      
      emit(AuthAuthenticated(user: user, isAnonymous: true));
    } catch (e) {
      emit(AuthError(message: 'Erro ao criar conta anônima: $e'));
    }
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      // Fazer logout
      // await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Erro ao fazer logout: $e'));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      emit(currentState.copyWith(user: event.user));
    }
  }
}
