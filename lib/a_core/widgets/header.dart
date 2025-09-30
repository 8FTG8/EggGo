import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final bool showBackButton;
  final List<Widget>? actions;

  const CustomHeader({
    super.key,
    required this.pageTitle,
    this.showBackButton = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: null,
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      actions: actions,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: !showBackButton ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [

                // ÍCONE VOLTAR \\
                if (showBackButton)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  ),

                // TÍTULO \\
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    pageTitle,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                    textAlign: !showBackButton ? TextAlign.center : TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      elevation: 0,
      bottom: null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0); // Mantém a altura total do AppBar
}
