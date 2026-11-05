import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/prestamos/calendario_cuotas.dart';
import '../../widgets/prestamos/resumen_estimado.dart';

class FormularioSolicitudPrestamo extends StatelessWidget {
  final TextEditingController montoCtrl;
  final TextEditingController motivoCtrl;
  final int monto;
  final int? cuotas;
  final bool menuAbierto;
  final bool mostrarResumen;
  final VoidCallback alCambiarMonto;
  final VoidCallback alAlternarMenu;
  final ValueChanged<int> alSeleccionarCuotas;

  const FormularioSolicitudPrestamo({
    super.key,
    required this.montoCtrl,
    required this.motivoCtrl,
    required this.monto,
    required this.cuotas,
    required this.menuAbierto,
    required this.mostrarResumen,
    required this.alCambiarMonto,
    required this.alAlternarMenu,
    required this.alSeleccionarCuotas,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _etiqueta('Monto a solicitar'),
        const SizedBox(height: 8),
        _campoMonto(),
        const SizedBox(height: 6),
        if (monto > 3000000)
          const Text(
            'El monto supera el máximo permitido de \$3.000.000',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFDC2626),
            ),
          )
        else if (monto > 0 && monto < 100000)
          const Text(
            'El monto mínimo es \$100.000',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFDC2626),
            ),
          )
        else
          const Text(
            'Mínimo \$100.000 · Máximo \$3.000.000',
            style: TextStyle(fontSize: 12, color: Color(0xFF94A0B3)),
          ),
        const SizedBox(height: 20),
        _etiqueta('Número de cuotas'),
        const SizedBox(height: 8),
        _selectorCuotas(),
        const SizedBox(height: 6),
        const Text(
          'Mínimo 2 · Máximo 36 cuotas',
          style: TextStyle(fontSize: 12, color: Color(0xFF94A0B3)),
        ),
        if (menuAbierto) ...[const SizedBox(height: 8), _listaCuotas()],
        if (mostrarResumen) ...[
          const SizedBox(height: 20),
          ResumenEstimado(monto: monto, cuotas: cuotas!),
          const SizedBox(height: 14),
          CalendarioCuotas(monto: monto, cuotas: cuotas!),
        ],
        const SizedBox(height: 20),
        _etiqueta('Motivo del préstamo'),
        const SizedBox(height: 8),
        _campoMotivo(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _etiqueta(String texto) => Text(
    texto,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: Color(0xFF17243C),
    ),
  );

  Widget _campoMonto() {
    final invalido = monto > 3000000 || (monto > 0 && monto < 100000);
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: invalido
              ? const Color(0xFFEF4444)
              : const Color(0xFFE1E8F3),
          width: invalido ? 1.5 : 1,
        ),
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
              controller: montoCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => alCambiarMonto(),
              style: const TextStyle(fontSize: 15, color: Color(0xFF17243C)),
              decoration: const InputDecoration(
                hintText: '1.000.000',
                hintStyle: TextStyle(fontSize: 15, color: Color(0xFF94A0B3)),
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
    );
  }

  Widget _selectorCuotas() {
    return GestureDetector(
      onTap: alAlternarMenu,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: menuAbierto
                ? const Color(0xFF285FE8)
                : const Color(0xFFE1E8F3),
            width: menuAbierto ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                cuotas == null
                    ? 'Selecciona el número de cuotas'
                    : '$cuotas cuotas',
                style: TextStyle(
                  fontSize: 15,
                  color: cuotas == null
                      ? const Color(0xFF94A0B3)
                      : const Color(0xFF17243C),
                ),
              ),
            ),
            Icon(
              menuAbierto ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
      constraints: const BoxConstraints(maxHeight: 240),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E8F3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        itemCount: 35,
        itemBuilder: (context, indice) {
          final valor = indice + 2;
          final seleccionado = cuotas == valor;
          return Material(
            color: seleccionado
                ? const Color(0xFFF0F5FF)
                : Colors.transparent,
            child: InkWell(
              onTap: () => alSeleccionarCuotas(valor),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: indice == 34
                          ? Colors.transparent
                          : const Color(0xFFF0F3F8),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$valor cuotas',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: seleccionado
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: seleccionado
                              ? const Color(0xFF285FE8)
                              : const Color(0xFF17243C),
                        ),
                      ),
                    ),
                    if (seleccionado)
                      const Icon(
                        Icons.check,
                        size: 18,
                        color: Color(0xFF285FE8),
                      ),
                  ],
                ),
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
        controller: motivoCtrl,
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
