class ApiException implements Exception {
  final String mensaje;
  final int? statusCode;

  const ApiException(this.mensaje, {this.statusCode});

  @override
  String toString() => mensaje;
}
