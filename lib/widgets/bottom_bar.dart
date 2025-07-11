import 'package:egg_go/utilis/app_colors.dart';
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

  // ESTILOS REUTILIZÁVEIS \\
  TextStyle _navBarTextStyle(Color color) => GoogleFonts.inter(
    color: color,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );


  // BOTTOM NAVIGATION BAR \\
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.black,
      selectedLabelStyle: _navBarTextStyle(AppColors.primary),
      unselectedLabelStyle: _navBarTextStyle(AppColors.black),
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          label: 'Ajustes',
          icon: Icon(Icons.settings, size: 28),
        ),
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home_sharp, size: 28),
        ),
        BottomNavigationBarItem(
          label: '+Venda',
          icon: Icon(Icons.sell, size: 28),
        ),
      ],
    );
  }
}
