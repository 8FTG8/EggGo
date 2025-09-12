import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../controllers/sincronizacao_controller.dart';
import '../core/widgets/header.dart';
import '../core/constants/app_colors.dart';

class Sincronizacao extends StatelessWidget {
  static const routeName = 'SincronizacaoPage';
  const Sincronizacao({super.key});

  @override
  Widget build(BuildContext context) {
    // O provider é criado aqui para que o estado seja exclusivo desta tela
    return ChangeNotifierProvider(
      create: (_) => SincronizacaoController(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomHeader(pageTitle: 'Sincronização'),
        body: Consumer<SincronizacaoController>(
          builder: (context, controller, child) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildStatusSection(controller),
                    ),
                  ),
                  _buildLastSyncInfo(controller),
                  const SizedBox(height: 20),
                  _buildSyncButton(context, controller),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusSection(SincronizacaoController controller) {
    bool hasFailed = controller.geralStatusMessage.contains('Falha');
    return Column(
      children: [
        if (controller.isSyncing)
          const SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 5,
            ),
          )
        else
          Icon(
            hasFailed ? Icons.cloud_off_outlined : Icons.cloud_done_outlined,
            size: 60,
            color: hasFailed ? Colors.red.shade700 : AppColors.primary,
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
          return _buildTaskItem(entry.key, entry.value);
        }),
      ],
    );
  }

  Widget _buildTaskItem(String name, SyncTaskStatus status) {
    Icon icon;
    Color color = Colors.grey;

    switch (status) {
      case SyncTaskStatus.pendente:
        icon = Icon(Icons.hourglass_empty, color: color);
        break;
      case SyncTaskStatus.sincronizando:
        icon = const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ) as Icon;
        break;
      case SyncTaskStatus.sucesso:
        color = Colors.green.shade700;
        icon = Icon(Icons.check_circle_outline, color: color);
        break;
      case SyncTaskStatus.falha:
        color = Colors.red.shade700;
        icon = Icon(Icons.error_outline, color: color);
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 16),
          Text(name, style: TextStyle(fontSize: 16, color: color)),
        ],
      ),
    );
  }

  Widget _buildLastSyncInfo(SincronizacaoController controller) {
    String lastSyncText = 'Nunca sincronizado';
    if (controller.lastSyncTime != null) {
      lastSyncText = 'Última sincronização: ${DateFormat('dd/MM/yy \'às\' HH:mm').format(controller.lastSyncTime!)}';
    }
    return Text(lastSyncText, style: const TextStyle(color: Colors.grey));
  }

  Widget _buildSyncButton(BuildContext context, SincronizacaoController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.sync),
        label: Text(
          'Sincronizar Agora',
          style: GoogleFonts.inter(fontSize: 16),
        ),
        onPressed: controller.isSyncing ? null : () => controller.startSync(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}