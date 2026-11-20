import 'package:flutter/material.dart';

import '../models/calendario_pagos_model.dart';
import '../nucleo/api_service.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_metodo_pago.dart';

class PantallaCalendarioPagos extends StatefulWidget {
  const PantallaCalendarioPagos({super.key});

  @override
  State<PantallaCalendarioPagos> createState() =>
      _PantallaCalendarioPagosState();
}

class _PantallaCalendarioPagosState extends State<PantallaCalendarioPagos> {
  final _modelo = const CalendarioPagosModel();
  late Future<List<CuotaPrestamoModel>> _future;
  List<CuotaPrestamoModel> _cuotas = [];
  DateTime _mesVisible = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _diaSeleccionado;
  CuotaPrestamoModel? _cuotaSeleccionada;

  static const _meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  @override
  void initState() {
    super.initState();
    _future = _cargar();
  }

  Future<List<CuotaPrestamoModel>> _cargar() async {
    final lista = await _modelo.obtenerCuotas();
    _cuotas = lista;
    // Seleccionar próximo pago pendiente
    final pendientes = lista.where((c) => !c.estaPagada && c.fecha != null).toList()
      ..sort((a, b) => a.fecha!.compareTo(b.fecha!));
    if (pendientes.isNotEmpty) {
      final prox = pendientes.first;
      _mesVisible = DateTime(prox.fecha!.year, prox.fecha!.month);
      _diaSeleccionado =
          DateTime(prox.fecha!.year, prox.fecha!.month, prox.fecha!.day);
      _cuotaSeleccionada = prox;
    } else if (lista.isNotEmpty && lista.first.fecha != null) {
      final f = lista.first.fecha!;
      _mesVisible = DateTime(f.year, f.month);
    }
    return lista;
  }

  void _reintentar() => setState(() => _future = _cargar());

  List<CuotaPrestamoModel> _cuotasDelDia(DateTime dia) {
    return _cuotas.where((c) {
      if (c.fecha == null) return false;
      return c.fecha!.year == dia.year &&
          c.fecha!.month == dia.month &&
          c.fecha!.day == dia.day;
    }).toList();
  }

  CuotaPrestamoModel? _proximaPendiente() {
    final pendientes = _cuotas
        .where((c) => !c.estaPagada && c.fecha != null)
        .toList()
      ..sort((a, b) => a.fecha!.compareTo(b.fecha!));
    return pendientes.isEmpty ? null : pendientes.first;
  }

  Color? _colorDia(DateTime dia) {
    final delDia = _cuotasDelDia(dia);
    if (delDia.isEmpty) return null;
    if (delDia.any((c) => c.estaPagada)) return ColoresApp.exitoProfundo;
    if (delDia.any((c) => c.estaVencida)) return ColoresApp.advertenciaOscuro;
    // Próximo pago (primera pendiente global) en azul
    final prox = _proximaPendiente();
    if (prox?.fecha != null &&
        prox!.fecha!.year == dia.year &&
        prox.fecha!.month == dia.month &&
        prox.fecha!.day == dia.day) {
      return ColoresApp.primario;
    }
    return ColoresApp.primario;
  }

  void _seleccionarDia(DateTime dia) {
    final delDia = _cuotasDelDia(dia);
    setState(() {
      _diaSeleccionado = dia;
      if (delDia.isNotEmpty) {
        _cuotaSeleccionada = delDia.first;
      } else {
        _cuotaSeleccionada = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, top + 6, 24, 16 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  'MI CUENTA / CALENDARIO',
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
              'Calendario de pagos',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: ColoresApp.textoPrincipal,
                height: 1.18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Consulta tus fechas de pago y mantente al día con tus cuotas.',
              style: TextStyle(
                fontSize: 15,
                color: ColoresApp.textoSecundario,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<CuotaPrestamoModel>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            snapshot.error is ApiException
                                ? (snapshot.error as ApiException).mensaje
                                : 'No se pudieron cargar tus cuotas.',
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: _reintentar,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No tienes un préstamo en curso.\nCuando tengas uno activo, aquí verás sus cuotas.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: ColoresApp.textoSecundario,
                            height: 1.5,
                          ),
                        ),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _tarjetaCalendario(),
                        const SizedBox(height: 14),
                        _leyenda(),
                        const SizedBox(height: 14),
                        if (_cuotaSeleccionada != null) ...[
                          _tarjetaDetalle(_cuotaSeleccionada!),
                          const SizedBox(height: 16),
                          if (!_cuotaSeleccionada!.estaPagada)
                            BotonPrimario(
                              texto: 'Pagar ahora',
                              alPresionar: () {
                                final c = _cuotaSeleccionada!;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PantallaMetodoPago(
                                      idPrestamo:
                                          int.tryParse(c.idPrestamo),
                                      idCuota: int.tryParse(c.idCuota),
                                      monto: c.monto,
                                      numeroCuota: c.numero,
                                      fechaPago: c.fecha,
                                    ),
                                  ),
                                ).then((_) {
                                  // Al volver del pago, refrescar estados/colores
                                  if (mounted) _reintentar();
                                });
                              },
                            ),
                        ] else
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Selecciona un día con cuota para ver el detalle.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: ColoresApp.textoSecundario,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaCalendario() {
    final primerDiaMes = DateTime(_mesVisible.year, _mesVisible.month, 1);
    // Monday-based offset: weekday 1=Mon ... 7=Sun → 0..6
    final offset = primerDiaMes.weekday - 1;
    final diasEnMes =
        DateTime(_mesVisible.year, _mesVisible.month + 1, 0).day;
    final celdas = offset + diasEnMes;
    final filas = ((celdas + 6) / 7).floor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColoresApp.blanco,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColoresApp.bordeTarjeta),
        boxShadow: const [
          BoxShadow(
            color: ColoresApp.sombraSuave,
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _mesVisible =
                        DateTime(_mesVisible.year, _mesVisible.month - 1);
                  });
                },
                child: const Icon(Icons.chevron_left,
                    color: ColoresApp.textoPrincipal, size: 22),
              ),
              Text(
                '${_meses[_mesVisible.month - 1]} ${_mesVisible.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColoresApp.textoPrincipal,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _mesVisible =
                        DateTime(_mesVisible.year, _mesVisible.month + 1);
                  });
                },
                child: const Icon(Icons.chevron_right,
                    color: ColoresApp.textoPrincipal, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: _DiaSemana('Lun')),
              Expanded(child: _DiaSemana('Mar')),
              Expanded(child: _DiaSemana('Mié')),
              Expanded(child: _DiaSemana('Jue')),
              Expanded(child: _DiaSemana('Vie')),
              Expanded(child: _DiaSemana('Sáb')),
              Expanded(child: _DiaSemana('Dom')),
            ],
          ),
          const SizedBox(height: 8),
          for (var f = 0; f < filas; f++)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  for (var c = 0; c < 7; c++)
                    Expanded(child: _celdaDia(f * 7 + c, offset, diasEnMes)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _celdaDia(int indice, int offset, int diasEnMes) {
    final diaNum = indice - offset + 1;
    if (diaNum < 1 || diaNum > diasEnMes) {
      return const SizedBox(height: 36);
    }
    final fecha = DateTime(_mesVisible.year, _mesVisible.month, diaNum);
    final colorCuota = _colorDia(fecha);
    final seleccionado = _diaSeleccionado != null &&
        _diaSeleccionado!.year == fecha.year &&
        _diaSeleccionado!.month == fecha.month &&
        _diaSeleccionado!.day == fecha.day;

    // Círculo de estado (más visible sobre fondo azul)
    Color? bordeCirculo = colorCuota;
    Color fondoCelda = Colors.transparent;
    if (seleccionado) {
      fondoCelda = ColoresApp.fondoSeleccionado;
      bordeCirculo ??= ColoresApp.primario;
    }

    return GestureDetector(
      onTap: () => _seleccionarDia(fecha),
      child: SizedBox(
        height: 36,
        child: Center(
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: fondoCelda,
              shape: BoxShape.circle,
              border: bordeCirculo != null
                  ? Border.all(color: bordeCirculo, width: 2)
                  : null,
            ),
            child: Text(
              '$diaNum',
              style: TextStyle(
                fontSize: 13,
                fontWeight: (seleccionado || colorCuota != null)
                    ? FontWeight.w700
                    : FontWeight.w400,
                // Número siempre oscuro para legibilidad; el estado lo marca el círculo
                color: ColoresApp.textoPrincipal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _leyenda() {
    Widget item(Color color, String texto) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            texto,
            style: const TextStyle(fontSize: 12, color: ColoresApp.textoSecundario),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        item(ColoresApp.exitoProfundo, 'Pagado'),
        item(ColoresApp.primario, 'Próximo pago'),
        item(ColoresApp.advertenciaOscuro, 'Vencido'),
      ],
    );
  }

  Widget _tarjetaDetalle(CuotaPrestamoModel c) {
    final esProximo = !c.estaPagada && !c.estaVencida;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColoresApp.blanco,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ColoresApp.bordeTarjeta),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  formatoFechaLarga(c.fecha),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoPrincipal,
                  ),
                ),
              ),
              if (esProximo)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: ColoresApp.fondoSeleccionado,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'Próximo pago',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.primario,
                    ),
                  ),
                )
              else if (c.estaPagada)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: ColoresApp.exitoClaro2,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'Pagado',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.exitoProfundo,
                    ),
                  ),
                )
              else if (c.estaVencida)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: ColoresApp.advertenciaFondo,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'Vencido',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.advertenciaOscuro,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _filaDetalle(
            'Cuota',
            c.totalCuotas > 0
                ? '${c.numero} de ${c.totalCuotas}'
                : c.numero,
          ),
          _filaDetalle('Monto a pagar', '\$${formatoMontoCuota(c.monto)}'),
          _filaDetalle('Fecha límite de pago', formatoFechaCorta(c.fecha)),
          _filaDetalle(
            'Estado',
            c.estaPagada
                ? 'Pagado'
                : c.estaVencida
                    ? 'Vencido'
                    : 'Pendiente',
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColoresApp.fondoAzulClaro,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColoresApp.bordeAviso),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, size: 18, color: ColoresApp.primario),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Paga a tiempo y evita cargos extras.',
                    style: TextStyle(fontSize: 13, color: ColoresApp.textoSecundario),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filaDetalle(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: const TextStyle(fontSize: 14, color: ColoresApp.textoSecundario),
            ),
          ),
          Text(
            v,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColoresApp.textoPrincipal,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaSemana extends StatelessWidget {
  final String texto;
  const _DiaSemana(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 11, color: ColoresApp.textoSecundario),
    );
  }
}
