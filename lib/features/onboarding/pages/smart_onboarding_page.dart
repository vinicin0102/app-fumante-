import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/entities/smoking_profile.dart';
import '../../../presentation/blocs/progress/progress_bloc.dart';

class SmartOnboardingPage extends StatefulWidget {
  const SmartOnboardingPage({super.key});

  @override
  State<SmartOnboardingPage> createState() => _SmartOnboardingPageState();
}

class _SmartOnboardingPageState extends State<SmartOnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Dados do formulário
  String _name = '';
  int _dailyCigarettes = 15;
  int _yearsSmoking = 5;
  double _packPrice = 10.0;
  DateTime _quitDate = DateTime.now();
  bool _alreadyQuit = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finish() {
    // Inicializar o progresso com dados reais
    context.read<ProgressBloc>().add(InitializeProgressEvent(
      quitDate: _quitDate,
      cigarettesPerDay: _dailyCigarettes,
      packPrice: _packPrice,
      yearsSmoking: _yearsSmoking,
    ));
    
    // Navegar para Home
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Barra de progresso linear
            LinearProgressIndicator(
              value: (_currentPage + 1) / 5,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Bloqueia swipe manual
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildIntroStep(),
                  _buildConsumptionStep(),
                  _buildFinancialStep(),
                  _buildQuitDateStep(),
                  _buildMotivationStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // PASSO 1: INTRODUÇÃO
  Widget _buildIntroStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.psychology, size: 80, color: AppColors.primary),
          const SizedBox(height: 32),
          Text(
            'Vamos personalizar seu plano',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Para a TCC funcionar, precisamos entender seus hábitos. Leva menos de 1 minuto.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Começar'),
            ),
          ),
        ],
      ),
    );
  }

  // PASSO 2: CONSUMO
  Widget _buildConsumptionStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Seus Hábitos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          
          Text('Quantos cigarros por dia?', style: Theme.of(context).textTheme.titleMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_dailyCigarettes cigarros', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
              const Text('2 maços', style: TextStyle(color: Colors.grey)),
            ],
          ),
          Slider(
            value: _dailyCigarettes.toDouble(),
            min: 1,
            max: 60,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _dailyCigarettes = val.round()),
          ),
          
          const SizedBox(height: 32),
          
          Text('Fuma há quanto tempo?', style: Theme.of(context).textTheme.titleMedium),
          Text('$_yearsSmoking anos', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
          Slider(
            value: _yearsSmoking.toDouble(),
            min: 0,
            max: 50,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _yearsSmoking = val.round()),
          ),

          const Spacer(),
          _buildNavButtons(onNext: _nextPage),
        ],
      ),
    );
  }

  // PASSO 3: FINANCEIRO
  Widget _buildFinancialStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Financeiro', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Quanto você paga no maço?', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          
          Center(
            child: Text(
              NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(_packPrice),
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.success),
            ),
          ),
          
          Slider(
            value: _packPrice,
            min: 3.0,
            max: 50.0,
            divisions: 94, // Passos de 0.50
            activeColor: AppColors.success,
            onChanged: (val) => setState(() => _packPrice = val),
          ),
          
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.savings, color: AppColors.success),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Economia projetada (1 ano):', style: TextStyle(fontSize: 12)),
                      Text(
                        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format((_dailyCigarettes / 20) * _packPrice * 365),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.success),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
          _buildNavButtons(onNext: _nextPage),
        ],
      ),
    );
  }

  // PASSO 4: DATA
  Widget _buildQuitDateStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Data de Parada', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          
          SwitchListTile(
            title: const Text('Já parei de fumar'),
            subtitle: const Text('Estou mantendo meu progresso'),
            value: _alreadyQuit,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() {
              _alreadyQuit = val;
              if (val) _quitDate = DateTime.now(); // Reset reset para agora se mudar
            }),
          ),
          
          if (_alreadyQuit) ...[
            const SizedBox(height: 24),
            const Text('Quando foi seu último cigarro?'),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: CalendarDatePicker(
                initialDate: _quitDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                onDateChanged: (date) => setState(() => _quitDate = date),
              ),
            ),
            const SizedBox(height: 16),
            TimePickerDialog(
               initialTime: TimeOfDay.now(),
            )
          ] else ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: const Text('Vamos definir uma data futura para você se preparar. Que tal daqui a 7 dias?'),
            ),
          ],
          
          // Nota: O TimePicker não é um widget inline facilmente, simplificaremos
          if (_alreadyQuit)
             Center(child: Text('Hora definida: ${DateFormat('HH:mm').format(_quitDate)}', style: const TextStyle(fontWeight: FontWeight.bold))),

          const Spacer(),
          _buildNavButtons(onNext: _nextPage),
        ],
      ),
    );
  }
  
  // Custom Time Picker simplificado para o exemplo não ficar gigante
  Widget TimePickerDialog({required TimeOfDay initialTime}) {
     return Center(
        child: ElevatedButton.icon(
           icon: const Icon(Icons.access_time),
           label: const Text('Ajustar Hora'),
           onPressed: () async {
              final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_quitDate));
              if (time != null) {
                 setState(() {
                    _quitDate = DateTime(
                       _quitDate.year, _quitDate.month, _quitDate.day, 
                       time.hour, time.minute
                    );
                 });
              }
           },
        ),
     );
  }

  // PASSO 5: MOTIVAÇÃO (Final)
  Widget _buildMotivationStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('O que te motiva?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Vamos usar isso para te lembrar nos momentos difíceis.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MotivationChip(label: 'Minha Saúde', icon: Icons.favorite, color: Colors.red),
              _MotivationChip(label: 'Economizar', icon: Icons.savings, color: Colors.green),
              _MotivationChip(label: 'Família', icon: Icons.family_restroom, color: Colors.blue),
              _MotivationChip(label: 'Liberdade', icon: Icons.flight_takeoff, color: Colors.orange),
              _MotivationChip(label: 'Estética', icon: Icons.face, color: Colors.purple),
              _MotivationChip(label: 'Exemplo', icon: Icons.child_care, color: Colors.teal),
            ],
          ),

          const Spacer(),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _finish,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 8,
              ),
              child: const Text('CRIAR MEU PLANO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButtons({required VoidCallback onNext}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: const Text('Voltar'),
        ),
        ElevatedButton(
          onPressed: onNext,
          child: const Text('Próximo'),
        ),
      ],
    );
  }
}

class _MotivationChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _MotivationChip({required this.label, required this.icon, required this.color});

  @override
  State<_MotivationChip> createState() => _MotivationChipState();
}

class _MotivationChipState extends State<_MotivationChip> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.label),
      avatar: Icon(widget.icon, size: 18, color: _selected ? Colors.white : widget.color),
      selected: _selected,
      onSelected: (val) => setState(() => _selected = val),
      selectedColor: widget.color.withOpacity(0.8),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(color: _selected ? Colors.white : null),
      backgroundColor: Theme.of(context).cardColor,
    );
  }
}
