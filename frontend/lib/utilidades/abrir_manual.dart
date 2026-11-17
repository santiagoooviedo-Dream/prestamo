import 'package:flutter/material.dart';

import '../pantallas/pantalla_manual_pdf.dart';

void abrirManualPdf(
  BuildContext context, {
  required String assetPath,
  required String titulo,
}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => PantallaManualPdf(assetPath: assetPath, titulo: titulo),
    ),
  );
}
