import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import '../nucleo/colores_app.dart';

class PantallaManualPdf extends StatelessWidget {
  final String assetPath;
  final String titulo;

  const PantallaManualPdf({
    super.key,
    required this.assetPath,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoGrisAzul2,
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: ColoresApp.blanco,
        foregroundColor: ColoresApp.textoPrincipal,
        elevation: 0,
      ),
      body: PdfViewer.asset(
        assetPath,
        params: const PdfViewerParams(
          backgroundColor: ColoresApp.fondoGrisAzul2,
          loadingBannerBuilder: _cargando,
          errorBannerBuilder: _error,
        ),
      ),
    );
  }

  static Widget _cargando(
    BuildContext context,
    int bytesDescargados,
    int? totalBytes,
  ) {
    return const Center(child: CircularProgressIndicator());
  }

  static Widget _error(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
    PdfDocumentRef documentRef,
  ) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'No se pudo cargar el documento PDF. Intenta de nuevo.',
          textAlign: TextAlign.center,
          style: TextStyle(color: ColoresApp.textoSecundario),
        ),
      ),
    );
  }
}
