import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap
  });

  // BOTTOM NAVIGATION BAR \\
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BottomNavigationBar(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        //BottomNavigationBarItem(label: 'Ajustes', icon: Icon(Icons.settings, size: 28)),
        BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home_sharp, size: 28)),
        BottomNavigationBarItem(label: '+Venda', icon: Icon(Icons.sell, size: 28)),
      ],
    );
  }
}
