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

  const PantallaAdminMontoPagado({
    super.key,
    this.idPrestamo,
    this.idCuota,
    this.monto = 0,
    this.metodo = 'Pago personal',
    this.tipoPrestamo = 'Préstamo personal',
    this.fechaPago = '',
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

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;
    final f = DateTime.now();
    final fecha = widget.fechaPago.isEmpty
        ? '${f.day}/${f.month}/${f.year}'
        : widget.fechaPago;
    final montoTxt =
        '\$${SolicitudAdmin.formatoMonto(widget.monto.round())}';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 20 + bottom),
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
            const SizedBox(height: 20),
            const Text(
              'Monto pagado',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Revisa y confirma el pago del usuario.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
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
                  const Text(
                    'Monto recibido',
                    style: TextStyle(fontSize: 13, color: Color(0xFFD6E4FF)),
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
                  FilaDatoAdmin(etiqueta: 'Fecha de pago', valor: fecha),
                  FilaDatoAdmin(
                    etiqueta: 'Préstamo',
                    valor: widget.tipoPrestamo,
                  ),
                  FilaDatoAdmin(
                    etiqueta: 'Método',
                    valor: widget.metodo,
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
            const Spacer(),
            BotonPrimario(
              texto: _validando
                  ? 'Validando…'
                  : _listo
                      ? 'Listo'
                      : 'Confirmar pago',
              alPresionar: _validando ? null : _confirmar,
              cargando: _validando,
            ),
          ],
        ),
      ),
    );
  }
}
