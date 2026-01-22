import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/pages/welcome_page.dart';
import '../../features/onboarding/pages/questionnaire_page.dart';
import '../../features/onboarding/pages/goal_page.dart';
import '../../features/onboarding/pages/smart_onboarding_page.dart';
import '../../features/dashboard/pages/home_page.dart';
import '../../features/journal/pages/journal_page.dart';
import '../../features/journal/pages/journal_entry_page.dart';
import '../../features/tcc_therapy/pages/exercises_page.dart';
import '../../features/tcc_therapy/pages/exercise_detail_page.dart';
import '../../features/tcc_therapy/pages/breathing_exercise_page.dart';
import '../../features/tcc_therapy/pages/meditation_player_page.dart';
import '../../features/community/pages/community_page.dart';
import '../../features/settings/pages/profile_page.dart';
import '../../features/settings/pages/settings_page.dart';
import '../../presentation/pages/main_shell.dart';

/// Configuração de rotas do app
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: '/welcome',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      // ==================== ONBOARDING ====================
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/onboarding/questionnaire',
        name: 'questionnaire',
        builder: (context, state) => const QuestionnairePage(),
      ),
      GoRoute(
        path: '/onboarding/goal',
        name: 'goal',
        builder: (context, state) => const GoalPage(),
      ),
      GoRoute(
        path: '/onboarding/smart',
        name: 'smart-onboarding',
        builder: (context, state) => const SmartOnboardingPage(),
      ),

      // ==================== MAIN APP (with bottom nav) ====================
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Home/Dashboard
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          // Diário
          GoRoute(
            path: '/journal',
            name: 'journal',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: JournalPage(),
            ),
          ),
          // Exercícios/Terapia
          GoRoute(
            path: '/exercises',
            name: 'exercises',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ExercisesPage(),
            ),
          ),
          // Comunidade
          GoRoute(
            path: '/community',
            name: 'community',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CommunityPage(),
            ),
          ),
          // Perfil
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),

      // ==================== TELAS FULLSCREEN ====================
      GoRoute(
        path: '/journal/new',
        name: 'journal-new',
        builder: (context, state) => const JournalEntryPage(),
      ),
      GoRoute(
        path: '/exercise/:id',
        name: 'exercise-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ExerciseDetailPage(exerciseId: id);
        },
      ),
      GoRoute(
        path: '/exercise/:id/breathing',
        name: 'breathing-exercise',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BreathingExercisePage(exerciseId: id);
        },
      ),
      GoRoute(
        path: '/exercise/:id/player',
        name: 'meditation-player',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MeditationPlayerPage(exerciseId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}

/// Rotas nomeadas para fácil navegação
class Routes {
  static const welcome = '/welcome';
  static const questionnaire = '/onboarding/questionnaire';
  static const smartOnboarding = '/onboarding/smart';
  static const goal = '/onboarding/goal';
  static const home = '/home';
  static const journal = '/journal';
  static const journalNew = '/journal/new';
  static const exercises = '/exercises';
  static String exerciseDetail(String id) => '/exercise/$id';
  static String breathingExercise(String id) => '/exercise/$id/breathing';
  static String meditationPlayer(String id) => '/exercise/$id/player';
  static const community = '/community';
  static const profile = '/profile';
  static const settings = '/settings';
}
