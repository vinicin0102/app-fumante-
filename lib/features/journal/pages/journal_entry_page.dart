import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/value_objects/smoking_trigger.dart';

/// Página para nova entrada no diário
class JournalEntryPage extends StatefulWidget {
  const JournalEntryPage({super.key});

  @override
  State<JournalEntryPage> createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {
  int _mood = 3;
  int _cravingLevel = 0;
  final List<SmokingTrigger> _selectedTriggers = [];
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Como você está?'),
        actions: [TextButton(onPressed: _saveEntry, child: const Text('Salvar'))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMoodSelector(),
            const SizedBox(height: 32),
            _buildCravingSlider(),
            const SizedBox(height: 32),
            _buildTriggersSelector(),
            const SizedBox(height: 32),
            _buildNotesField(),
            if (_cravingLevel >= 7) ...[
              const SizedBox(height: 24),
              _buildEmergencyAction(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Qual seu humor agora?', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final moodValue = index + 1;
            final emojis = ['😢', '😕', '😐', '🙂', '😄'];
            return GestureDetector(
              onTap: () => setState(() => _mood = moodValue),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _mood == moodValue ? AppColors.getMoodColor(moodValue).withOpacity(0.2) : null,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _mood == moodValue ? AppColors.getMoodColor(moodValue) : Colors.transparent, width: 2),
                ),
                child: Text(emojis[index], style: const TextStyle(fontSize: 32)),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCravingSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nível de vontade de fumar', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(_getCravingLabel(_cravingLevel), style: TextStyle(color: AppColors.getCravingColor(_cravingLevel), fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        Slider(
          value: _cravingLevel.toDouble(),
          min: 0,
          max: 10,
          divisions: 10,
          activeColor: AppColors.getCravingColor(_cravingLevel),
          onChanged: (value) => setState(() => _cravingLevel = value.round()),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Sem vontade', style: Theme.of(context).textTheme.bodySmall), Text('Crise intensa', style: Theme.of(context).textTheme.bodySmall)]),
      ],
    );
  }

  String _getCravingLabel(int level) {
    if (level == 0) return 'Sem vontade 😌';
    if (level <= 2) return 'Vontade leve 🟢';
    if (level <= 4) return 'Vontade moderada 🟡';
    if (level <= 6) return 'Vontade forte 🟠';
    if (level <= 8) return 'Vontade muito forte 🔴';
    return 'Crise intensa! 🆘';
  }

  Widget _buildTriggersSelector() {
    final triggers = [SmokingTrigger.stress, SmokingTrigger.afterCoffee, SmokingTrigger.boredom, SmokingTrigger.social, SmokingTrigger.afterMeal, SmokingTrigger.anxiety];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('O que causou a vontade?', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: triggers.map((trigger) {
            final isSelected = _selectedTriggers.contains(trigger);
            return GestureDetector(
              onTap: () => setState(() => isSelected ? _selectedTriggers.remove(trigger) : _selectedTriggers.add(trigger)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(color: isSelected ? trigger.color.withOpacity(0.2) : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? trigger.color : Colors.transparent, width: 2)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(trigger.icon, size: 18, color: isSelected ? trigger.color : null), const SizedBox(width: 6), Text(trigger.displayName, style: TextStyle(color: isSelected ? trigger.color : null, fontWeight: isSelected ? FontWeight.w600 : null))]),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notas (opcional)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextField(controller: _notesController, maxLines: 4, decoration: const InputDecoration(hintText: 'Como você está se sentindo? O que está acontecendo?')),
      ],
    );
  }

  Widget _buildEmergencyAction() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Vontade muito forte!', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.error)), Text('Use um exercício de respiração agora', style: Theme.of(context).textTheme.bodySmall)])),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.error), child: const Text('Ajuda')),
        ],
      ),
    );
  }

  void _saveEntry() {
    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entrada salva com sucesso!')));
  }
}
