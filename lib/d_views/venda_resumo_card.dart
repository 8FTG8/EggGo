import 'package:egg_go/c_controllers/controller_venda.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CardVendas extends StatefulWidget {
  const CardVendas({super.key});

  @override
  State<CardVendas> createState() => _CardVendasState();
}

class _CardVendasState extends State<CardVendas> {
  int selectedIndex = 0;
  bool _isVisible = false;
  final List<String> filtros = ['Hoje', '1S', '1M', '6M', '1A'];

  DateTimeRange _getPeriodoSelecionado() {
    final now = DateTime.now();
    // Garante que o 'end' seja sempre o início do dia seguinte para incluir o dia atual inteiro.
    final endOfToday = DateTime(now.year, now.month, now.day + 1);

    switch (selectedIndex) {
      case 0: // Hoje
        return DateTimeRange(
          start: DateTime(now.year, now.month, now.day),
          end: endOfToday,
        );
      case 1: // 1 semana
        return DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: endOfToday,
        );
      case 2: // 1 mês
        return DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: endOfToday,
        );
      case 3: // 6 meses
        return DateTimeRange(
          start: DateTime(now.year, now.month - 6, now.day),
          end: endOfToday,
        );
      case 4: // 1 ano
        return DateTimeRange(
          start: DateTime(now.year - 1, now.month, now.day),
          end: endOfToday,
        );
      default:
        return DateTimeRange(
          start: DateTime(now.year, now.month, now.day),
          end: endOfToday,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(filtros.length, (index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },

                  // FILTRO DE DATA \\
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? colorScheme.primary : colorScheme.onSurface.withAlpha(128),
                      ),
                    ),
                    child: Text(
                      filtros[index],
                      style: GoogleFonts.inter(
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 14,
                        color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }),
            ),

            Consumer<VendaController>(builder: (context, controller, child) {
              final periodo = _getPeriodoSelecionado();
              final resumo = controller.getResumoVendas(periodo);
              return Column(
                children: [
                  
                  // VENDAS REALIZADAS \\
                  const SizedBox(height: 8),
                  Text('Vendas realizadas: ${resumo.totalVendas}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // VALOR TOTAL \\
                  const SizedBox(height: 4),
                  Text(
                    'R\$ ${_isVisible ? resumo.valorTotal.toStringAsFixed(2).replaceAll('.', ',') : '••••••'}',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  // BOTÃO DE VISIBILLIDADE \\
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                          size: 24,
                        ),
                        onPressed: () {
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
