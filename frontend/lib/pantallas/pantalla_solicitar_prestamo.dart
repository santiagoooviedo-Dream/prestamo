import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import '../widgets/prestamos/calendario_cuotas.dart';
import '../widgets/prestamos/resumen_estimado.dart';
import 'pantalla_metodo_desembolso.dart';

/// Solicita tu préstamo + selector de cuotas (2–36) + resumen y calendario
class PantallaSolicitarPrestamo extends StatefulWidget {
  const PantallaSolicitarPrestamo({super.key});

  @override
  State<PantallaSolicitarPrestamo> createState() =>
      _PantallaSolicitarPrestamoState();
}

class _PantallaSolicitarPrestamoState extends State<PantallaSolicitarPrestamo> {
  final _montoCtrl = TextEditingController(text: '1000000');
  final _motivoCtrl = TextEditingController();
  int? _cuotas;
  bool _menuAbierto = false;

  static final _opcionesRapidas = List<int>.generate(35, (i) => i + 2); // 2..36

  int get _monto {
    final t = _montoCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(t) ?? 0;
  }

  bool get _mostrarResumen =>
      _cuotas != null && _monto >= 100000 && _monto <= 3000000;

  @override
  void initState() {
    super.initState();
    _montoCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _montoCtrl.dispose();
    _motivoCtrl.dispose();
    super.dispose();
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
                  _cuotas != null ? 'SOLICITUD / CUOTAS' : 'SOLICITUD / DATOS',
                  style: const TextStyle(
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
              'Solicita tu préstamo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17243C),
                height: 1.15,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Completa la información para continuar.',
              style: TextStyle(fontSize: 15, color: Color(0xFF66758D)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Monto a solicitar'),
                    const SizedBox(height: 8),
                    _campoMonto(),
                    const SizedBox(height: 6),
                    const Text(
                      'Mínimo \$100.000 · Máximo \$3.000.000',
                      style: TextStyle(fontSize: 12, color: Color(0xFF94A0B3)),
                    ),
                    const SizedBox(height: 20),
                    _label('Número de cuotas'),
                    const SizedBox(height: 8),
                    _selectorCuotas(),
                    const SizedBox(height: 6),
                    const Text(
                      'Mínimo 2 · Máximo 36 cuotas',
                      style: TextStyle(fontSize: 12, color: Color(0xFF94A0B3)),
                    ),
                    if (_menuAbierto) ...[
                      const SizedBox(height: 8),
                      _listaCuotas(),
                    ],
                    if (_mostrarResumen) ...[
                      const SizedBox(height: 20),
                      ResumenEstimado(monto: _monto, cuotas: _cuotas!),
                      const SizedBox(height: 14),
                      CalendarioCuotas(monto: _monto, cuotas: _cuotas!),
                    ],
                    const SizedBox(height: 20),
                    _label('Motivo del préstamo'),
                    const SizedBox(height: 8),
                    _campoMotivo(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            BotonPrimario(
              texto: 'Continuar',
              alPresionar: () {
                if (!_mostrarResumen ||
                    _motivoCtrl.text.trim().isEmpty ||
                    _cuotas == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Verifica el monto, las cuotas y el motivo del préstamo.'),
                    ),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PantallaMetodoDesembolso(
                      monto: _monto,
                      cuotas: _cuotas!,
                      motivo: _motivoCtrl.text.trim(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Text(
        t,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF17243C),
        ),
      );

  Widget _campoMonto() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              '\$',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF94A0B3),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _montoCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontSize: 15, color: Color(0xFF17243C)),
              decoration: const InputDecoration(
                hintText: '1.000.000',
                hintStyle: TextStyle(fontSize: 15, color: Color(0xFF94A0B3)),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectorCuotas() {
    return GestureDetector(
      onTap: () => setState(() => _menuAbierto = !_menuAbierto),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _menuAbierto
                ? const Color(0xFF285FE8)
                : const Color(0xFFE1E8F3),
            width: _menuAbierto ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _cuotas == null
                    ? 'Selecciona el número de cuotas'
                    : '$_cuotas cuotas',
                style: TextStyle(
                  fontSize: 15,
                  color: _cuotas == null
                      ? const Color(0xFF94A0B3)
                      : const Color(0xFF17243C),
                ),
              ),
            ),
            Icon(
              _menuAbierto
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: const Color(0xFF66758D),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listaCuotas() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 280),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _opcionesRapidas.length,
        itemBuilder: (_, i) {
          final n = _opcionesRapidas[i];
          final sel = _cuotas == n;
          final esUltimo = i == _opcionesRapidas.length - 1;
          return InkWell(
            onTap: () => setState(() {
              _cuotas = n;
              _menuAbierto = false;
            }),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: esUltimo
                        ? Colors.transparent
                        : const Color(0xFFF0F3F8),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$n cuotas',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            sel ? FontWeight.w600 : FontWeight.w400,
                        color: sel
                            ? const Color(0xFF285FE8)
                            : const Color(0xFF17243C),
                      ),
                    ),
                  ),
                  if (sel)
                    const Icon(Icons.check,
                        size: 18, color: Color(0xFF285FE8)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _campoMotivo() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      child: TextField(
        controller: _motivoCtrl,
        style: const TextStyle(fontSize: 15, color: Color(0xFF17243C)),
        decoration: const InputDecoration(
          hintText: 'Ingresa el motivo',
          hintStyle: TextStyle(fontSize: 15, color: Color(0xFF94A0B3)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
