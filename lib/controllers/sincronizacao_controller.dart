import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enum para representar o status de cada tarefa de sincronização
enum SyncTaskStatus { pendente, sincronizando, sucesso, falha }

class SincronizacaoController with ChangeNotifier {
  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  String _geralStatusMessage = "Pronto para sincronizar.";

  // Mapa para guardar o status de cada tarefa individual
  final Map<String, SyncTaskStatus> _taskStatus = {
    'Envio de Produtos': SyncTaskStatus.pendente,
    'Recebimento de Pedidos': SyncTaskStatus.pendente,
    'Atualização de Clientes': SyncTaskStatus.pendente,
  };

  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;
  String get geralStatusMessage => _geralStatusMessage;
  Map<String, SyncTaskStatus> get taskStatus => _taskStatus;

  SincronizacaoController() {
    _loadLastSyncTime();
  }

  // Carrega a data da última sincronização salva localmente
  Future<void> _loadLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('lastSyncTime');
    if (timestamp != null) {
      _lastSyncTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      notifyListeners();
    }
  }

  // Salva a data da sincronização atual
  Future<void> _saveLastSyncTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSyncTime', time.millisecondsSinceEpoch);
    _lastSyncTime = time;
  }

  // Inicia o processo de sincronização
  Future<void> startSync() async {
    if (_isSyncing) return;

    _isSyncing = true;
    _geralStatusMessage = "Iniciando sincronização...";
    // Reseta todas as tarefas para 'pendente'
    _taskStatus.updateAll((key, value) => SyncTaskStatus.pendente);
    notifyListeners();

    try {
      // --- SIMULAÇÃO DO PROCESSO DE SINCRONIZAÇÃO ---
      // Substitua os `_runTask` pelas chamadas reais aos seus serviços

      await _runTask('Envio de Produtos', 2);
      await _runTask('Recebimento de Pedidos', 3);
      await _runTask('Atualização de Clientes', 1);

      // --- FIM DA SIMULAÇÃO ---

      await _saveLastSyncTime(DateTime.now());
      _geralStatusMessage = "Sincronização concluída com sucesso!";
    } catch (e) {
      _geralStatusMessage = "Falha na sincronização. Tente novamente.";
      debugPrint("Erro de sincronização: $e");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // Método auxiliar para simular a execução de uma tarefa
  Future<void> _runTask(String taskName, int delayInSeconds) async {
    try {
      _taskStatus[taskName] = SyncTaskStatus.sincronizando;
      _geralStatusMessage = "Sincronizando: $taskName...";
      notifyListeners();

      // AQUI você colocaria a chamada real ao seu serviço (ex: _produtoService.enviarPendentes())
      await Future.delayed(Duration(seconds: delayInSeconds));

      // Simulação de uma possível falha para demonstração
      if (taskName == 'Recebimento de Pedidos' && DateTime.now().second.isOdd) {
        throw Exception("Erro de conexão ao buscar pedidos.");
      }

      _taskStatus[taskName] = SyncTaskStatus.sucesso;
      notifyListeners();
    } catch (e) {
      _taskStatus[taskName] = SyncTaskStatus.falha;
      notifyListeners();
      // Re-lança a exceção para parar o processo geral e informar a falha
      rethrow;
    }
  }
}