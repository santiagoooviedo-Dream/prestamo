import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../nucleo/colores_app.dart';
import '../widgets/comunes/boton_primario.dart';
import '../widgets/comunes/boton_volver.dart';
import 'pantalla_metodo_desembolso.dart';

/// Figma: Solicita tu préstamo + selector de cuotas (2–36)
class PantallaSolicitarPrestamo extends StatefulWidget {
  const PantallaSolicitarPrestamo({super.key});

  @override
  State<PantallaSolicitarPrestamo> createState() =>
      _PantallaSolicitarPrestamoState();
}

class _PantallaSolicitarPrestamoState extends State<PantallaSolicitarPrestamo> {
  final _montoCtrl = TextEditingController();
  final _motivoCtrl = TextEditingController();
  int? _cuotas;
  bool _menuAbierto = false;

  /// Lista visible en el desplegable (2–10) + resto hasta 36
  static const _cuotasVisibles = [2, 3, 4, 5, 6, 7, 8, 9, 10];
  static const _todasLasCuotas = [
    2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 15, 18, 24, 30, 36,
  ];

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
    final etiqueta = _menuAbierto ? 'SOLICITUD / CUOTAS' : 'SOLICITUD / DATOS';

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
                BotonVolver(alPresionar: () => Navigator.pop(context)),
                Text(
                  etiqueta,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.textoContexto,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Solicita tu préstamo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF17243C),
                height: 1.18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Completa la información para continuar.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF66758D),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Monto
                    const Text(
                      'Monto a solicitar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17243C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF17243C),
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Ingresa el monto',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF94A0B3),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Mínimo \$100.000 · Máximo \$3.000.000',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A0B3),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Número de cuotas
                    const Text(
                      'Número de cuotas',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17243C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _menuAbierto = !_menuAbierto),
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
                    ),
                    if (!_menuAbierto)
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          'Mínimo 2 · Máximo 36 cuotas',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A0B3),
                          ),
                        ),
                      ),

                    // Lista desplegable 2–10 + más
                    if (_menuAbierto) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE1E8F3)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D17243C),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ..._cuotasVisibles.map((n) {
                              final sel = _cuotas == n;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _cuotas = n;
                                    _menuAbierto = false;
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: sel
                                        ? const Color(0xFFEDF3FF)
                                        : Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: const Color(0xFFE8EEF6),
                                        width: n == _cuotasVisibles.last
                                            ? 0
                                            : 1,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    '$n cuotas',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: sel
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: sel
                                          ? const Color(0xFF285FE8)
                                          : const Color(0xFF17243C),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            // Más opciones hasta 36
                            InkWell(
                              onTap: () => _mostrarTodasLasCuotas(context),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: const Text(
                                  'Más opciones hasta 36 cuotas',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF285FE8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),

                    // Motivo
                    const Text(
                      'Motivo del préstamo',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17243C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE1E8F3)),
                      ),
                      child: TextField(
                        controller: _motivoCtrl,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF17243C),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Ingresa el motivo',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF94A0B3),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BotonPrimario(
              texto: 'Continuar',
              alPresionar: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PantallaMetodoDesembolso()),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarTodasLasCuotas(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Selecciona el número de cuotas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF17243C),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _todasLasCuotas.length,
                  itemBuilder: (_, i) {
                    final n = _todasLasCuotas[i];
                    final sel = _cuotas == n;
                    return ListTile(
                      title: Text(
                        '$n cuotas',
                        style: TextStyle(
                          fontWeight:
                              sel ? FontWeight.w600 : FontWeight.w400,
                          color: sel
                              ? const Color(0xFF285FE8)
                              : const Color(0xFF17243C),
                        ),
                      ),
                      trailing: sel
                          ? const Icon(Icons.check,
                              color: Color(0xFF285FE8), size: 20)
                          : null,
                      onTap: () {
                        setState(() {
                          _cuotas = n;
                          _menuAbierto = false;
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
