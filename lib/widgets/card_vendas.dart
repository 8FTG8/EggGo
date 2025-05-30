import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendasResumoCard extends StatefulWidget {
  const VendasResumoCard({super.key});

  @override
  State<VendasResumoCard> createState() => _VendasResumoCardState();
}

class _VendasResumoCardState extends State<VendasResumoCard> {
  int selectedIndex = 0;
  bool _isVisible = true;
  final List<String> filtros = ['Hoje', '1S', '1M', '6M', '1A'];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF000C39) : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF000C39))),
                    child: Text(
                      filtros[index],
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isSelected ? const Color(0xFFFDB014) : const Color(0xFF000C39),
                      ),
                    ),
                  ),
                );
              }),
            ),

            // VENDAS REALIZADAS
            const SizedBox(height: 8),
            Text('Vendas realizadas: 14',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // VALOR TOTAL
            const SizedBox(height: 8),
            Text(
              'R\$ ${_isVisible ? '763,50' : '••••••'}',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),

            // BOTÃO DE VISIBILLIDADE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    _isVisible ? Icons.visibility : Icons.visibility_off,
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
        ),
      ),
    );
  }
}