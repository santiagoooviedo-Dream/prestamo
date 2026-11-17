import 'package:flutter/material.dart';

import '../models/solicitud_admin.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/admin/tarjeta_blanca_admin.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';

class PantallaAdminMontoPagado extends StatefulWidget {
  final int? idPrestamo;
  final int? idCuota;
  final num monto;
  final String metodo;
  final String tipoPrestamo;
  final String fechaPago;
  final int numeroCuotas;
  final String estado;
  final String fechaInicio;
  final String fechaFin;
  final bool puedeConfirmar;

  const PantallaAdminMontoPagado({
    super.key,
    this.idPrestamo,
    this.idCuota,
    this.monto = 0,
    this.metodo = 'Efectivo',
    this.tipoPrestamo = 'Préstamo personal',
    this.fechaPago = '',
    this.numeroCuotas = 0,
    this.estado = '',
    this.fechaInicio = '',
    this.fechaFin = '',
    this.puedeConfirmar = true,
  });

  @override
  State<PantallaAdminMontoPagado> createState() =>
      _PantallaAdminMontoPagadoState();
}

class _PantallaAdminMontoPagadoState extends State<PantallaAdminMontoPagado> {
  bool _validando = false;
  bool _listo = false;

  Future<void> _confirmar() async {
    if (_listo) {
      Navigator.pop(context, true);
      return;
    }
    final idP = widget.idPrestamo;
    final idC = widget.idCuota;
    if (idP == null || idC == null) {
      setState(() => _listo = true);
      return;
    }
    setState(() => _validando = true);
    try {
      await ApiService.registrarPago(
        idPrestamo: idP,
        idCuota: idC,
        monto: widget.monto,
        metodoPago: widget.metodo.toLowerCase().contains('nequi')
            ? 'nequi'
            : 'efectivo',
      );
      if (!mounted) return;
      setState(() {
        _validando = false;
        _listo = true;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _validando = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.mensaje)));
    } catch (_) {
      if (!mounted) return;
      setState(() => _validando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo validar el pago.')),
      );
    }
  }

  String _limpio(String v) {
    if (v.isEmpty || v == '—' || v == '-') return '—';
    return v;
  }

  String get _plazoTexto {
    if (widget.numeroCuotas > 0) {
      return '${widget.numeroCuotas} ${widget.numeroCuotas == 1 ? 'mes' : 'meses'}';
    }
    final m = RegExp(r'(\d+)').firstMatch(widget.tipoPrestamo);
    if (m != null) {
      final n = int.tryParse(m.group(1)!) ?? 0;
      if (n > 0) return '$n ${n == 1 ? 'mes' : 'meses'}';
    }
    return '—';
  }

  String get _cuotaEstimada {
    final n = widget.numeroCuotas > 0
        ? widget.numeroCuotas
        : (int.tryParse(
                RegExp(r'(\d+)')
                        .firstMatch(widget.tipoPrestamo)
                        ?.group(1) ??
                    '') ??
            0);
    if (widget.monto <= 0 || n <= 0) return '—';
    final cuota = (widget.monto * 1.10) / n;
    return '\$${SolicitudAdmin.formatoMonto(cuota.round())}';
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final montoTxt = '\$${SolicitudAdmin.formatoMonto(widget.monto.round())}';
    final mostrarConfirmar = widget.puedeConfirmar &&
        (widget.idPrestamo != null && widget.idCuota != null);

    final fechaInicio = _limpio(
      widget.fechaInicio.isNotEmpty ? widget.fechaInicio : widget.fechaPago,
    );
    final fechaFin = _limpio(widget.fechaFin);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 6, 24, 16 + bottom),
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
                    'ADMINISTRADOR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.textoContexto,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mostrarConfirmar
                            ? 'Monto pagado'
                            : 'Detalle del préstamo',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF17243C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mostrarConfirmar
                            ? 'Revisa y confirma el pago del usuario.'
                            : 'Información general del préstamo.',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF66758D),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color(0xFF285FE8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mostrarConfirmar
                                  ? 'Monto recibido'
                                  : 'Monto del préstamo',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFD6E4FF),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              montoTxt,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TarjetaBlancaAdmin(
                        child: Column(
                          children: [
                            FilaDatoAdmin(
                              etiqueta: 'Fecha de inicio',
                              valor: fechaInicio,
                            ),
                            FilaDatoAdmin(
                              etiqueta: 'Fecha de finalización',
                              valor: fechaFin,
                            ),
                            FilaDatoAdmin(
                              etiqueta: 'Tipo',
                              valor: widget.tipoPrestamo.contains('cuota')
                                  ? 'Préstamo personal'
                                  : (widget.tipoPrestamo.isEmpty
                                      ? 'Préstamo personal'
                                      : widget.tipoPrestamo),
                            ),
                            FilaDatoAdmin(
                              etiqueta: 'Plazo',
                              valor: _plazoTexto,
                            ),
                            FilaDatoAdmin(
                              etiqueta: 'Tasa de interés',
                              valor: '10%',
                            ),
                            FilaDatoAdmin(
                              etiqueta: 'Cuota estimada',
                              valor: _cuotaEstimada,
                            ),
                            FilaDatoAdmin(
                              etiqueta: 'Método de desembolso',
                              valor:
                                  widget.metodo.isEmpty ? '—' : widget.metodo,
                            ),
                            FilaDatoAdmin(
                              etiqueta: 'Estado',
                              valor:
                                  widget.estado.isEmpty ? '—' : widget.estado,
                              ultimo: true,
                            ),
                          ],
                        ),
                      ),
                      if (_listo)
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(
                            'Pago validado. La cuota quedó como pagada.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF168261),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              if (mostrarConfirmar || _listo)
                BotonPrimario(
                  texto: _validando
                      ? 'Validando…'
                      : _listo
                          ? 'Listo'
                          : 'Confirmar pago',
                  alPresionar: _validando ? null : _confirmar,
                  cargando: _validando,
                )
              else
                BotonPrimario(
                  texto: 'Volver',
                  alPresionar: () {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
