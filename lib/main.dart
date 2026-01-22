import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/injection/injection_container.dart';
import 'data/repositories/local_progress_repository.dart';
import 'presentation/blocs/progress/progress_bloc.dart';
import 'presentation/cubits/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar dependências
  await configureDependencies();
  
  // Inicializar SharedPreferences (simples injeção manual para este exemplo)
  final prefs = await SharedPreferences.getInstance();
  final progressRepository = LocalProgressRepository(prefs);

  runApp(QuitNowApp(progressRepository: progressRepository));
}

class QuitNowApp extends StatelessWidget {
  final LocalProgressRepository progressRepository;

  const QuitNowApp({super.key, required this.progressRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => ProgressBloc(repository: progressRepository)..add(const LoadProgressEvent(userId: 'local')),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'QuitNow Pro',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
