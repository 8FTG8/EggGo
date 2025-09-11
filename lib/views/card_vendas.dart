import 'package:egg_go/controllers/venda_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:egg_go/core/constants/app_colors.dart';

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
    switch (selectedIndex) {
      case 0: // Hoje
        return DateTimeRange(
          start: DateTime(now.year, now.month, now.day),
          end: now.add(const Duration(days: 1)),
        );
      case 1: // 1 semana
        return DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now.add(const Duration(days: 1)),
        );
      case 2: // 1 mês
        return DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: now.add(const Duration(days: 1)),
        );
      case 3: // 6 meses
        return DateTimeRange(
          start: now.subtract(const Duration(days: 181)),
          end: now.add(const Duration(days: 1)),
        );
      case 4: // 1 ano
        return DateTimeRange(
          start: now.subtract(const Duration(days: 365)),
          end: now.add(const Duration(days: 1)),
        );
      default:
        return DateTimeRange(
          start: DateTime(now.year, now.month, now.day),
          end: now.add(const Duration(days: 1)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: Colors.white,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: isSelected
                        ? Border.all(color: AppColors.primary)
                        : Border.all(color: AppColors.black),
                    ),
                    child: Text(
                      filtros[index],
                      style: GoogleFonts.inter(
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 14,
                        color: isSelected ? AppColors.primary : AppColors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),

            Consumer<VendaController>(builder: (context, controller, child) {
              final periodo = _getPeriodoSelecionado();
              final totalVendas = controller.getTotalVendas(periodo);
              final valorTotal = controller.getValorTotal(periodo);
              return Column(
                children: [
                  
                  // VENDAS REALIZADAS \\
                  const SizedBox(height: 8),
                  Text(
                    'Vendas realizadas: $totalVendas',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // VALOR TOTAL \\
                  const SizedBox(height: 4),
                  Text(
                    'R\$ ${_isVisible ? valorTotal.toStringAsFixed(2).replaceAll('.', ',') : '••••••'}',
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
