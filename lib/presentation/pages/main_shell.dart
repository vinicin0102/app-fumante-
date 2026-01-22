import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/router/app_router.dart';

/// Shell principal com bottom navigation
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNavBar(
        currentPath: GoRouterState.of(context).uri.path,
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final String currentPath;

  const _BottomNavBar({required this.currentPath});

  int get _currentIndex {
    if (currentPath.startsWith('/home')) return 0;
    if (currentPath.startsWith('/journal')) return 1;
    if (currentPath.startsWith('/exercises')) return 2;
    if (currentPath.startsWith('/community')) return 3;
    if (currentPath.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => _onTap(context, index),
          backgroundColor: Theme.of(context).colorScheme.surface,
          indicatorColor: AppColors.primary.withOpacity(0.2),
          animationDuration: const Duration(milliseconds: 500),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.primary),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Icon(Icons.book_outlined),
              selectedIcon: Icon(Icons.book, color: AppColors.primary),
              label: 'Diário',
            ),
            NavigationDestination(
              icon: Icon(Icons.self_improvement_outlined),
              selectedIcon: Icon(Icons.self_improvement, color: AppColors.primary),
              label: 'Terapia',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people, color: AppColors.primary),
              label: 'Comunidade',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.primary),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(Routes.home);
        break;
      case 1:
        context.go(Routes.journal);
        break;
      case 2:
        context.go(Routes.exercises);
        break;
      case 3:
        context.go(Routes.community);
        break;
      case 4:
        context.go(Routes.profile);
        break;
    }
  }
}
