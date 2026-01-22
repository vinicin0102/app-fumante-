import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';

/// Página do diário
class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Diário'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildStatsCard(context),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Últimos registros'),
          const SizedBox(height: 16),
          _JournalEntryCard(date: DateTime.now(), mood: 4, craving: 3, resisted: true),
          const SizedBox(height: 12),
          _JournalEntryCard(date: DateTime.now().subtract(const Duration(days: 1)), mood: 3, craving: 7, resisted: true),
          const SizedBox(height: 12),
          _JournalEntryCard(date: DateTime.now().subtract(const Duration(days: 2)), mood: 5, craving: 2, resisted: true),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.journalNew),
        icon: const Icon(Icons.add),
        label: const Text('Nova Entrada'),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.secondaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: '85%', label: 'Taxa de sucesso'),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
          _StatItem(value: '3.2', label: 'Humor médio'),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
          _StatItem(value: '7', label: 'Entradas'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold));
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
      ],
    );
  }
}

class _JournalEntryCard extends StatelessWidget {
  final DateTime date;
  final int mood;
  final int craving;
  final bool resisted;

  const _JournalEntryCard({required this.date, required this.mood, required this.craving, required this.resisted});

  String get _moodEmoji {
    switch (mood) {
      case 1: return '😢';
      case 2: return '😕';
      case 3: return '😐';
      case 4: return '🙂';
      case 5: return '😄';
      default: return '❓';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Text(_moodEmoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${date.day}/${date.month}/${date.year}', style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.flash_on, size: 14, color: AppColors.getCravingColor(craving)),
                    const SizedBox(width: 4),
                    Text('Vontade: $craving/10', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: resisted ? AppColors.successBg : AppColors.errorBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(resisted ? 'Resistiu ✓' : 'Recaída', style: TextStyle(color: resisted ? AppColors.success : AppColors.error, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
