import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

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
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF17243C),
        elevation: 0,
      ),
      body: PdfViewer.asset(
        assetPath,
        params: const PdfViewerParams(
          backgroundColor: Color(0xFFF3F6FB),
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
          style: TextStyle(color: Color(0xFF66758D)),
        ),
      ),
    );
  }
}
