import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/aviso_seguridad.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_secundario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_inicio.dart';

/// Número Nequi donde el usuario debe enviar el dinero.
/// Cámbialo por el de tu negocio antes de publicar.
const String kNumeroNequiNegocio = '3001234567';

/// Pago por Nequi semi-manual: el usuario transfiere, sube comprobante
/// y el administrador confirma el pago.
class PantallaPagoNequi extends StatefulWidget {
  final int? idPrestamo;
  final int? idCuota;
  final num? monto;

  const PantallaPagoNequi({
    super.key,
    this.idPrestamo,
    this.idCuota,
    this.monto,
  });

  @override
  State<PantallaPagoNequi> createState() => _PantallaPagoNequiState();
}

class _PantallaPagoNequiState extends State<PantallaPagoNequi> {
  final _picker = ImagePicker();
  XFile? _comprobante;
  Uint8List? _previewBytes;
  bool _enviando = false;

  String get _montoTexto {
    final m = widget.monto;
    if (m == null) return '—';
    final n = m.round().toString();
    final b = StringBuffer();
    for (var i = 0; i < n.length; i++) {
      if (i > 0 && (n.length - i) % 3 == 0) b.write('.');
      b.write(n[i]);
    }
    return '\$${b.toString()}';
  }

  String get _referencia =>
      'REF_NEQUI id_prestamo=${widget.idPrestamo ?? 0} '
      'id_cuota=${widget.idCuota ?? 0} monto=${widget.monto ?? 0}';

  Future<void> _elegirComprobante(ImageSource fuente) async {
    try {
      final file = await _picker.pickImage(
        source: fuente,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      setState(() {
        _comprobante = file;
        _previewBytes = bytes;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la imagen.')),
      );
    }
  }

  Future<void> _enviar() async {
    if (_comprobante == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sube una captura del comprobante de Nequi.'),
        ),
      );
      return;
    }
    if (widget.idPrestamo == null || widget.idCuota == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontraron los datos de la cuota.'),
        ),
      );
      return;
    }

    setState(() => _enviando = true);
    String? urlComprobante;

    try {
      final subida = await ApiService.subirComprobantePago(_comprobante!);
      urlComprobante = subida['url']?.toString() ??
          subida['secure_url']?.toString() ??
          subida['comprobante']?.toString();
    } catch (_) {
      // Si falla la subida, igual avisamos al admin
    }

    try {
      final creada = await ApiService.crearConversacion();
      final conv = creada['conversacion'] is Map
          ? creada['conversacion'] as Map
          : creada;
      final id = conv['id_conversacion']?.toString() ??
          creada['id_conversacion']?.toString();
      if (id == null || id.isEmpty) {
        throw const ApiException('No se pudo notificar al administrador.');
      }

      try {
        await ApiService.transferirConversacionAAdmin(id);
      } catch (_) {
        try {
          await Future.delayed(const Duration(milliseconds: 400));
          await ApiService.transferirConversacionAAdmin(id);
        } catch (_) {}
      }

      final buffer = StringBuffer();
      buffer.writeln(
        'Hola, realicé el pago por Nequi de $_montoTexto.',
      );
      buffer.writeln('Número al que transferí: $kNumeroNequiNegocio');
      buffer.writeln('($_referencia)');
      if (urlComprobante != null && urlComprobante.isNotEmpty) {
        buffer.writeln('Comprobante: $urlComprobante');
      } else {
        buffer.writeln(
          'Adjunté el comprobante en la app. Por favor validar el pago.',
        );
      }

      await ApiService.enviarMensajeConversacion(
        idConversacion: id,
        mensaje: buffer.toString().trim(),
      );

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Comprobante enviado'),
          content: const Text(
            'Tu pago por Nequi quedó en revisión. '
            'Un administrador validará el comprobante y marcará la cuota como pagada.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const PantallaInicio()),
                  (_) => false,
                );
              },
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.mensaje)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo enviar el comprobante. Intenta de nuevo.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final teclado = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 6, 24, 16 + bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: teclado > 0 ? 12 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BotonVolver(
                            alPresionar: () => Navigator.pop(context),
                          ),
                          Text(
                            'PAGOS / NEQUI',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: ColoresApp.textoContexto,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Pagar con Nequi',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF17243C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Transfiere el valor de la cuota y sube el comprobante. '
                        'Un administrador lo validará.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF66758D),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE1E8F3)),
                        ),
                        child: Column(
                          children: [
                            _fila('Monto a pagar', _montoTexto, resaltar: true),
                            const Divider(height: 20),
                            _fila('Pagar al Nequi', kNumeroNequiNegocio),
                            const Divider(height: 20),
                            _fila(
                              'Referencia',
                              'Cuota ${widget.idCuota ?? '—'} · Préstamo ${widget.idPrestamo ?? '—'}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F5FF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFD9E5FA)),
                        ),
                        child: const Text(
                          '1. Abre Nequi y envía el monto exacto al número indicado.\n'
                          '2. Toma captura del comprobante.\n'
                          '3. Súbela aquí y envía. El admin confirmará tu pago.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF41618E),
                            height: 1.45,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Comprobante de pago',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF17243C),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_previewBytes != null)
                        GestureDetector(
                          onTap: () {
                            final bytes = _previewBytes!;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => Scaffold(
                                  backgroundColor: Colors.black,
                                  appBar: AppBar(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    title: const Text(
                                      'Comprobante',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  body: Center(
                                    child: InteractiveViewer(
                                      minScale: 0.8,
                                      maxScale: 4,
                                      child: Image.memory(
                                        bytes,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 220,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F6FC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFE1E8F3),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.memory(
                                _previewBytes!,
                                fit: BoxFit.contain,
                                gaplessPlayback: true,
                              ),
                            ),
                          ),
                        )
                      else
                        _placeholderImagen(),
                      if (_previewBytes != null)
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            'Toca la imagen para verla completa',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF66758D),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _enviando
                                  ? null
                                  : () => _elegirComprobante(ImageSource.camera),
                              icon: const Icon(Icons.photo_camera_outlined),
                              label: const Text('Cámara'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF285FE8),
                                side: const BorderSide(color: Color(0xFFD0DBF0)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _enviando
                                  ? null
                                  : () =>
                                      _elegirComprobante(ImageSource.gallery),
                              icon: const Icon(Icons.image_outlined),
                              label: const Text('Galería'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF285FE8),
                                side: const BorderSide(color: Color(0xFFD0DBF0)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const AvisoSeguridad(
                        texto:
                            'Solo se usará el comprobante para validar tu pago.',
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              BotonPrimario(
                texto: _enviando ? 'Enviando…' : 'Enviar comprobante',
                alPresionar: _enviando ? null : _enviar,
                cargando: _enviando,
              ),
              const SizedBox(height: 10),
              BotonSecundario(
                texto: 'Cancelar',
                alPresionar: _enviando ? null : () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderImagen() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 36, color: Color(0xFF94A0B3)),
          SizedBox(height: 8),
          Text(
            'Aún no has subido el comprobante',
            style: TextStyle(fontSize: 13, color: Color(0xFF66758D)),
          ),
        ],
      ),
    );
  }

  Widget _fila(String label, String valor, {bool resaltar = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF66758D)),
        ),
        Flexible(
          child: Text(
            valor,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: resaltar ? 18 : 14,
              fontWeight: FontWeight.w700,
              color: resaltar
                  ? const Color(0xFF285FE8)
                  : const Color(0xFF17243C),
            ),
          ),
        ),
      ],
    );
  }
}
