import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../c_controllers/sincronizacao_controller.dart';
import '../a_core/widgets/header.dart';

class Sincronizacao extends StatelessWidget {
  static const routeName = 'SincronizacaoPage';
  const Sincronizacao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(pageTitle: 'Sincronização', showBackButton: true),
      body: Consumer<SincronizacaoController>(
        builder: (context, controller, child) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildStatusSection(context, controller),
                  ),
                ),
                _buildLastSyncInfo(context, controller),
                const SizedBox(height: 20),
                _buildSyncButton(context, controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, SincronizacaoController controller) {
    bool hasFailed = controller.geralStatusMessage.contains('Falha');
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        if (controller.isSyncing)
          SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              strokeWidth: 5,
            ),
          )
        else
          Icon(
            hasFailed ? Icons.cloud_off_outlined : Icons.cloud_done_outlined,
            size: 60,
            color: hasFailed ? colorScheme.error : colorScheme.secondary,
          ),
        const SizedBox(height: 16),
        Text(
          controller.geralStatusMessage,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        // Constrói a lista de tarefas de sincronização
        ...controller.taskStatus.entries.map((entry) {
          return _buildTaskItem(context, entry.key, entry.value);
        }),
      ],
    );
  }

  Widget _buildTaskItem(BuildContext context, String name, SyncTaskStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    Widget iconWidget;
    Color color = colorScheme.onSurface.withAlpha(153);

    switch (status) {
      case SyncTaskStatus.pendente:
        iconWidget = Icon(Icons.hourglass_empty, color: color);
        break;
      case SyncTaskStatus.sincronizando:
        iconWidget = const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        );
        break;
      case SyncTaskStatus.sucesso:
        color = colorScheme.secondary;
        iconWidget = Icon(Icons.check_circle_outline, color: color);
        break;
      case SyncTaskStatus.falha:
        color = colorScheme.error;
        iconWidget = Icon(Icons.error_outline, color: color);
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          iconWidget,
          const SizedBox(width: 16),
          Text(name, style: TextStyle(fontSize: 16, color: color)),
        ],
      ),
    );
  }

  Widget _buildLastSyncInfo(BuildContext context, SincronizacaoController controller) {
    String lastSyncText = 'Nunca sincronizado';
    if (controller.lastSyncTime != null) {
      lastSyncText = 'Última sincronização: ${DateFormat('dd/MM/yy \'às\' HH:mm').format(controller.lastSyncTime!)}';
    }
    return Text(lastSyncText, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(153)));
  }

  Widget _buildSyncButton(BuildContext context, SincronizacaoController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.sync),
        label: Text('Sincronizar Agora',
          style: GoogleFonts.inter(fontSize: 16),
        ),
        onPressed: controller.isSyncing ? null : () => controller.startSync(),
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
      ),
    );
  }
}