import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/value_objects/smoking_trigger.dart';

/// Tela de questionário do onboarding
class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Respostas do usuário
  int _cigarettesPerDay = 10;
  int _yearsSmoking = 5;
  double _packPrice = 10.0;
  List<SmokingTrigger> _selectedTriggers = [];
  DateTime _quitDate = DateTime.now();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Ir para seleção de meta
      context.go(Routes.goal);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousPage,
        ),
        title: _buildProgressIndicator(),
        actions: [
          if (_currentPage < 4)
            TextButton(
              onPressed: () => context.go(Routes.goal),
              child: const Text('Pular'),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                _buildCigarettesQuestion(),
                _buildYearsQuestion(),
                _buildPriceQuestion(),
                _buildTriggersQuestion(),
                _buildQuitDateQuestion(),
              ],
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Container(
          width: index == _currentPage ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: index <= _currentPage
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _nextPage,
            child: Text(
              _currentPage < 4 ? 'Continuar' : 'Definir Meta',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== PERGUNTA 1: CIGARROS POR DIA ====================
  Widget _buildCigarettesQuestion() {
    return _QuestionCard(
      title: 'Quantos cigarros você fuma por dia?',
      subtitle: 'Isso nos ajuda a calcular sua economia e progresso',
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _NumberButton(
                    icon: Icons.remove,
                    onPressed: () {
                      if (_cigarettesPerDay > 1) {
                        setState(() => _cigarettesPerDay--);
                      }
                    },
                  ),
                  Container(
                    width: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_cigarettesPerDay',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  _NumberButton(
                    icon: Icons.add,
                    onPressed: () {
                      setState(() => _cigarettesPerDay++);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                _getCigarettesLabel(_cigarettesPerDay),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCigarettesLabel(int count) {
    if (count <= 5) return 'Fumante leve';
    if (count <= 10) return 'Fumante moderado';
    if (count <= 20) return 'Fumante regular';
    return 'Fumante pesado';
  }

  // ==================== PERGUNTA 2: ANOS FUMANDO ====================
  Widget _buildYearsQuestion() {
    return _QuestionCard(
      title: 'Há quanto tempo você fuma?',
      subtitle: 'Não se preocupe, nunca é tarde para parar!',
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Slider(
                value: _yearsSmoking.toDouble(),
                min: 1,
                max: 50,
                divisions: 49,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primary.withOpacity(0.2),
                onChanged: (value) {
                  setState(() => _yearsSmoking = value.round());
                },
              ),
              const SizedBox(height: 16),
              Text(
                _yearsSmoking == 1 ? '1 ano' : '$_yearsSmoking anos',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.infoBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Você fumou aproximadamente ${_cigarettesPerDay * _yearsSmoking * 365} cigarros na vida.',
                        style: const TextStyle(color: AppColors.info),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== PERGUNTA 3: PREÇO DO MAÇO ====================
  Widget _buildPriceQuestion() {
    return _QuestionCard(
      title: 'Quanto custa o maço de cigarros?',
      subtitle: 'Vamos calcular quanto você vai economizar!',
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'R\$',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 150,
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '10.00',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _packPrice = double.tryParse(value) ?? 10.0;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildSavingsPreview(),
        ],
      ),
        ),
      ),
    );
  }

  Widget _buildSavingsPreview() {
    final pricePerCigarette = _packPrice / 20;
    final dailySavings = pricePerCigarette * _cigarettesPerDay;
    final monthlySavings = dailySavings * 30;
    final yearlySavings = dailySavings * 365;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Você vai economizar:',
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SavingsItem(
                label: 'Por mês',
                value: 'R\$ ${monthlySavings.toStringAsFixed(0)}',
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.success.withOpacity(0.3),
              ),
              _SavingsItem(
                label: 'Por ano',
                value: 'R\$ ${yearlySavings.toStringAsFixed(0)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== PERGUNTA 4: GATILHOS ====================
  Widget _buildTriggersQuestion() {
    final triggers = SmokingTrigger.values.where((t) => t != SmokingTrigger.other).toList();

    return _QuestionCard(
      title: 'Quais são seus principais gatilhos?',
      subtitle: 'Selecione as situações que mais te fazem querer fumar',
      child: Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.only(top: 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: triggers.length,
          itemBuilder: (context, index) {
            final trigger = triggers[index];
            final isSelected = _selectedTriggers.contains(trigger);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedTriggers.remove(trigger);
                  } else {
                    _selectedTriggers.add(trigger);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? trigger.color.withOpacity(0.2)
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? trigger.color : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: trigger.color.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      trigger.icon,
                      size: 28,
                      color: isSelected
                          ? trigger.color
                          : AppColors.textSecondaryLight,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      trigger.displayName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? trigger.color
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==================== PERGUNTA 5: DATA PARA PARAR ====================
  Widget _buildQuitDateQuestion() {
    return _QuestionCard(
      title: 'Quando você quer parar?',
      subtitle: 'Escolha uma data que seja realista para você',
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(height: 24),
          _buildDateOption(
            'Hoje',
            DateTime.now(),
            Icons.flash_on,
            'Comece agora mesmo!',
          ),
          const SizedBox(height: 12),
          _buildDateOption(
            'Amanhã',
            DateTime.now().add(const Duration(days: 1)),
            Icons.wb_sunny,
            'Um novo dia, um novo começo',
          ),
          const SizedBox(height: 12),
          _buildDateOption(
            'Próxima semana',
            DateTime.now().add(const Duration(days: 7)),
            Icons.calendar_today,
            'Tempo para se preparar',
          ),
          const SizedBox(height: 12),
          _buildDateOption(
            'Escolher data',
            null,
            Icons.edit_calendar,
            'Selecione uma data específica',
          ),
        ],
      ),
        ),
      ),
    );
  }

  Widget _buildDateOption(
    String label,
    DateTime? date,
    IconData icon,
    String description,
  ) {
    final isSelected = date != null &&
        _quitDate.year == date.year &&
        _quitDate.month == date.month &&
        _quitDate.day == date.day;

    return GestureDetector(
      onTap: () async {
        if (date != null) {
          setState(() => _quitDate = date);
        } else {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (picked != null) {
            setState(() => _quitDate = picked);
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : null,
                    ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}

// ==================== WIDGETS AUXILIARES ====================

class _QuestionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _QuestionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _NumberButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _NumberButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primary),
        onPressed: onPressed,
        iconSize: 32,
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}

class _SavingsItem extends StatelessWidget {
  final String label;
  final String value;

  const _SavingsItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.success.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}
