import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildCampo({
  required String label,
  int maxLines = 1,
  TextEditingController? controller,
  TextInputType keyboardType = TextInputType.text,
  void Function(String)? onChanged,
  String? initialValue,
  bool enabled = true,
  }) {
  return TextFormField(
    maxLines: maxLines,
    controller: controller,
    initialValue: controller == null ? initialValue : null,
    keyboardType: keyboardType,
    enabled: enabled,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      border: const OutlineInputBorder(),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
  );
}