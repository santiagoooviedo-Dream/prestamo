class ContrasenaModel {
  const ContrasenaModel();

  static bool tieneLongitudMinima(String valor) => valor.length >= 8;
  static bool tieneNumero(String valor) => RegExp(r'[0-9]').hasMatch(valor);
  static bool tieneMayuscula(String valor) => RegExp(r'[A-Z]').hasMatch(valor);
  static bool tieneSimbolo(String valor) =>
      RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\;/]').hasMatch(valor);

  static bool esValida(String valor) =>
      tieneLongitudMinima(valor) &&
      tieneNumero(valor) &&
      tieneMayuscula(valor) &&
      tieneSimbolo(valor);

  static int puntaje(String valor) => [
    tieneLongitudMinima(valor),
    tieneNumero(valor),
    tieneMayuscula(valor),
    tieneSimbolo(valor),
  ].where((cumple) => cumple).length;
}
