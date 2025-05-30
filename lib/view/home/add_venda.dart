import 'package:flutter/material.dart';
import 'package:app_frontend/view/widgets/product_field.dart';

class NovaVendaPage extends StatelessWidget {
  const NovaVendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: kToolbarHeight,
        title: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      'HomePage',
                      (route) => false,
                    );
                  },
                ),
                const Spacer(),
                const Text('Nova Venda',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Divider(
                height: 0.5,
                thickness: 0.5,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: ProductField(),
    );
  }
}