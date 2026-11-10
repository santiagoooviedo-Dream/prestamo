import 'package:flutter/material.dart';

import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';

/// Chat admin. Si es pago personal, permite validar el abono.
class PantallaAdminChat extends StatefulWidget {
  final String nombreUsuario;
  final String? mensajeInicialUsuario;
  final String? idConversacion;
  final bool esPagoPersonal;
  final int? idPrestamo;
  final int? idCuota;
  final num? monto;
  final int? idUsuario;

  const PantallaAdminChat({
    super.key,
    this.nombreUsuario = 'Usuario',
    this.mensajeInicialUsuario,
    this.idConversacion,
    this.esPagoPersonal = false,
    this.idPrestamo,
    this.idCuota,
    this.monto,
    this.idUsuario,
  });

  @override
  State<PantallaAdminChat> createState() => _PantallaAdminChatState();
}

class _PantallaAdminChatState extends State<PantallaAdminChat> {
  final _ctrl = TextEditingController();
  final List<_Msg> _msgs = [];
  bool _cargando = false;
  bool _validando = false;
  bool _pagoValidado = false;
  /// Se activa si en cualquier mensaje del chat se detecta REF_PAGO / datos de cuota
  bool _esPagoPersonalDetectado = false;

  int? _idPrestamo;
  int? _idCuota;
  num? _monto;

  bool get _mostrarBotonValidar =>
      (widget.esPagoPersonal || _esPagoPersonalDetectado) && !_pagoValidado;

  @override
  void initState() {
    super.initState();
    _idPrestamo = widget.idPrestamo;
    _idCuota = widget.idCuota;
    _monto = widget.monto;
    _esPagoPersonalDetectado = widget.esPagoPersonal;

    if (widget.mensajeInicialUsuario != null) {
      _msgs.add(_Msg(widget.mensajeInicialUsuario!, deUsuario: true));
      _extraerRef(widget.mensajeInicialUsuario!);
      if (_idPrestamo != null && _idCuota != null) {
        _esPagoPersonalDetectado = true;
      }
    }
    _cargarMensajes();
  }

  void _extraerRef(String texto) {
    // REF_PAGO id_prestamo=1 id_cuota=2 monto=200000
    final p = RegExp(r'id_prestamo=(\d+)').firstMatch(texto);
    final c = RegExp(r'id_cuota=(\d+)').firstMatch(texto);
    final m = RegExp(r'monto=([0-9.]+)').firstMatch(texto);
    if (p != null) _idPrestamo = int.tryParse(p.group(1)!);
    if (c != null) _idCuota = int.tryParse(c.group(1)!);
    if (m != null) _monto = num.tryParse(m.group(1)!);
  }

  Future<void> _cargarMensajes() async {
    final id = widget.idConversacion;
    if (id == null || id.isEmpty) return;
    setState(() => _cargando = true);
    try {
      final lista = await ApiService.obtenerMensajesConversacion(id);
      if (!mounted) return;
      final nuevos = <_Msg>[];
      for (final raw in lista) {
        final texto = raw['mensaje']?.toString() ??
            raw['respuesta']?.toString() ??
            raw['contenido']?.toString() ??
            '';
        if (texto.isEmpty) continue;
        _extraerRef(texto);
        final remitente =
            (raw['remitente'] ?? raw['rol'] ?? raw['tipo'] ?? '')
                .toString()
                .toLowerCase()
                .trim();
        // Vista admin: mensajes del usuario a la izquierda, del admin a la derecha
        final deUsuario = remitente != 'admin' &&
            remitente != 'administrador' &&
            remitente != 'agente';
        // Si no viene remitente, intentar flags legacy
        final deUsuarioFinal = remitente.isEmpty
            ? true // sin remitente: se asume mensaje del usuario
            : deUsuario;
        nuevos.add(_Msg(texto, deUsuario: deUsuarioFinal));
      }
      // Si ya existe un mensaje de validación, ocultar el botón
      final yaValidado = nuevos.any((m) {
        final t = m.texto.toLowerCase();
        return t.contains('pago personal fue validado') ||
            t.contains('pago verificado') ||
            t.contains('queda registrada como pagada');
      });
      if (yaValidado) {
        _pagoValidado = true;
      }

      // Detectar pago personal aunque el último mensaje no tenga REF_PAGO
      // (el usuario pudo escribir mensajes adicionales después)
      final hayRefPago = nuevos.any((m) {
        final t = m.texto.toLowerCase();
        return t.contains('ref_pago') ||
            t.contains('id_prestamo') ||
            t.contains('pago personal');
      });

      if (nuevos.isNotEmpty) {
        setState(() {
          _msgs
            ..clear()
            ..addAll(nuevos);
          // Si encontramos datos de pago en cualquier mensaje, activar modo pago
          if (hayRefPago ||
              (_idPrestamo != null && _idCuota != null && _monto != null)) {
            _esPagoPersonalDetectado = true;
          }
        });
      }
    } catch (_) {
      // Mantiene mensajes locales
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _enviar() async {
    final t = _ctrl.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _msgs.add(_Msg(t, deUsuario: false));
      _ctrl.clear();
    });
    final id = widget.idConversacion;
    if (id == null || id.isEmpty) return;
    try {
      await ApiService.enviarMensajeConversacion(
        idConversacion: id,
        mensaje: t,
      );
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.mensaje)));
      }
    }
  }

  Future<void> _validarPago() async {
    // Re-escanear mensajes por si no se cargaron los ids al abrir
    for (final m in _msgs) {
      _extraerRef(m.texto);
    }

    if (_idPrestamo == null || _idCuota == null || _monto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Faltan datos del pago en el chat '
            '(préstamo: $_idPrestamo, cuota: $_idCuota, monto: $_monto). '
            'Debe existir un mensaje con REF_PAGO.',
          ),
        ),
      );
      return;
    }
    setState(() => _validando = true);
    try {
      await ApiService.registrarPago(
        idPrestamo: _idPrestamo!,
        idCuota: _idCuota!,
        monto: _monto!,
        metodoPago: 'efectivo',
      );
      if (!mounted) return;
      setState(() => _pagoValidado = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pago personal validado correctamente.')),
      );
      // Aviso claro en el chat
      final id = widget.idConversacion;
      if (id != null && id.isNotEmpty) {
        const aviso =
            '✅ Pago verificado. Tu pago personal fue validado correctamente y la cuota ya quedó registrada como pagada.';
        setState(() => _msgs.add(const _Msg(aviso, deUsuario: false)));
        try {
          await ApiService.enviarMensajeConversacion(
            idConversacion: id,
            mensaje: aviso,
          );
        } catch (_) {}
      }

      // Notificación al usuario
      final idUser = widget.idUsuario;
      if (idUser != null) {
        try {
          final montoTxt = _monto == null
              ? ''
              : '\$${_monto!.round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.')}';
          await ApiService.crearNotificacion(
            idUsuario: idUser,
            mensaje:
                'Pago de cuota confirmado\n\nTu pago personal de $montoTxt fue validado. La cuota ya aparece como pagada en tu estado de cuenta y calendario.',
            tipo: 'pago',
          );
        } catch (_) {}
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.mensaje)));
      }
    } finally {
      if (mounted) setState(() => _validando = false);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 12 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(
                  alPresionar: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                ),
                const Text(
                  'SOPORTE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.nombreUsuario,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            if (widget.esPagoPersonal) ...[
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Solicitud de pago personal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF285FE8),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (_cargando)
              const LinearProgressIndicator(minHeight: 2)
            else
              const SizedBox(height: 2),
            Expanded(
              child: ListView.builder(
                itemCount: _msgs.length,
                itemBuilder: (_, i) {
                  final m = _msgs[i];
                  return Align(
                    alignment: m.deUsuario
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.72,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: m.deUsuario
                            ? Colors.white
                            : const Color(0xFF285FE8),
                        borderRadius: BorderRadius.circular(16),
                        border: m.deUsuario
                            ? Border.all(color: const Color(0xFFE1E8F3))
                            : null,
                      ),
                      child: Text(
                        m.texto,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: m.deUsuario
                              ? const Color(0xFF17243C)
                              : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_mostrarBotonValidar) ...[
              BotonPrimario(
                texto: _validando ? 'Validando…' : 'Validar pago personal',
                alPresionar: _validando ? null : _validarPago,
              ),
              const SizedBox(height: 10),
            ],
            // Confirmación de pago solo en el mensaje del chat (sin texto verde).
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE1E8F3)),
                    ),
                    child: TextField(
                      controller: _ctrl,
                      onSubmitted: (_) => _enviar(),
                      decoration: const InputDecoration(
                        hintText: 'Escribe tu mensaje',
                        hintStyle:
                            TextStyle(fontSize: 14, color: Color(0xFF94A0B3)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _enviar,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF285FE8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Msg {
  final String texto;
  final bool deUsuario;
  const _Msg(this.texto, {required this.deUsuario});
}
