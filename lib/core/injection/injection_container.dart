import 'package:get_it/get_it.dart';

import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/progress/progress_bloc.dart';
import '../../presentation/cubits/theme/theme_cubit.dart';

final getIt = GetIt.instance;

/// Configura injeção de dependências
Future<void> configureDependencies() async {
  // ==================== BLOCS ====================
  getIt.registerFactory<AuthBloc>(() => AuthBloc());
  getIt.registerFactory<ProgressBloc>(() => ProgressBloc());
  
  // ==================== CUBITS ====================
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit());
  
  // ==================== REPOSITORIES ====================
  // Adicionar repositórios aqui
  
  // ==================== USE CASES ====================
  // Adicionar casos de uso aqui
  
  // ==================== DATA SOURCES ====================
  // Adicionar data sources aqui
  
  // ==================== SERVICES ====================
  // Adicionar serviços aqui (Firebase, etc.)
}
