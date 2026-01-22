import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/progress.dart';

class LocalProgressRepository {
  static const String _progressKey = 'user_progress';
  final SharedPreferences _prefs;

  LocalProgressRepository(this._prefs);

  Future<void> saveProgress(Progress progress, {
    int? cigarettesPerDay,
    double? packPrice,
  }) async {
    // Recuperar configs antigas se não fornecidas
    final oldDataString = _prefs.getString(_progressKey);
    final oldData = oldDataString != null ? jsonDecode(oldDataString) : {};

    final finalCigarettesPerDay = cigarettesPerDay ?? oldData['cigarettesPerDay'] ?? 20;
    final finalPrice = packPrice ?? oldData['pricePerPack'] ?? 10.0;

    final data = {
      'quitDate': progress.quitDate.toIso8601String(),
      'cigarettesSmoked': progress.cigarettesSmoked,
      'moneySpent': progress.moneySpent,
      'lifeLostMinutes': progress.lifeLostMinutes,
      // Dados para recalcular
      'cigarettesPerDay': finalCigarettesPerDay,
      'pricePerPack': finalPrice,
    };
    
    await _prefs.setString(_progressKey, jsonEncode(data));
  }

  /// Recupera o progresso salvo ou retorna null se não existir
  Progress? getProgress() {
    final String? dataString = _prefs.getString(_progressKey);
    if (dataString == null) return null;

    try {
      final data = jsonDecode(dataString);
      
      // Reconstrói o objeto Progress
      // Nota: Na versão real, precisaríamos adaptar o construtor do Progress
      // para aceitar dados históricos
      
      return Progress(
        quitDate: DateTime.parse(data['quitDate']),
        cigarettesSmoked: data['cigarettesSmoked'] ?? 0,
        moneySpent: data['moneySpent'] ?? 0.0,
        lifeLostMinutes: data['lifeLostMinutes'] ?? 0.0,
      );
    } catch (e) {
      return null;
    }
  }

  /// Limpa todos os dados
  Future<void> clearProgress() async {
    await _prefs.remove(_progressKey);
  }
}
