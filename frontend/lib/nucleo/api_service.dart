import 'package:image_picker/image_picker.dart';

import 'api_admin.dart';
import 'api_auth.dart';
import 'api_chat.dart';
import 'api_data.dart';

export 'api_exception.dart';

class ApiService {
  ApiService._();

  static Future<Map<String, dynamic>> iniciarSesion(
    String cedula,
    String contrasena,
  ) => ApiAuth.iniciarSesion(cedula, contrasena);
  static Future<void> registrarUsuario(Map<String, dynamic> usuario) => ApiAuth.registrarUsuario(usuario);
  static Future<Map<String, dynamic>> obtenerPerfil() => ApiAuth.obtenerPerfil();
  static Future<void> eliminarCuenta() => ApiAuth.eliminarCuenta();
  static Future<void> verificarRegistro(String correo, String codigo) => ApiAuth.verificarRegistro(correo, codigo);
  static Future<void> reenviarCodigoRegistro(String correo) => ApiAuth.reenviarCodigoRegistro(correo);
  static Future<Map<String, dynamic>> solicitarCambioCorreo({
    required String nuevoCorreo,
    required String contrasena,
  }) => ApiAuth.solicitarCambioCorreo(nuevoCorreo: nuevoCorreo, contrasena: contrasena);
  static Future<void> verificarCambioCorreo({
    required String tokenVerificacion,
    required String codigo,
  }) => ApiAuth.verificarCambioCorreo(tokenVerificacion: tokenVerificacion, codigo: codigo);
  static Future<void> cambiarContrasena({
    required String contrasenaActual,
    required String contrasenaNueva,
  }) => ApiAuth.cambiarContrasena(contrasenaActual: contrasenaActual, contrasenaNueva: contrasenaNueva);
  static Future<void> solicitarCodigoRecuperacion(String correo) => ApiAuth.solicitarCodigoRecuperacion(correo);
  static Future<void> verificarCodigoRecuperacion(
    String correo,
    String codigo,
  ) => ApiAuth.verificarCodigoRecuperacion(correo, codigo);
  static Future<void> recuperarContrasena({
    required String correo,
    required String codigo,
    required String contrasenaNueva,
  }) => ApiAuth.recuperarContrasena(correo: correo, codigo: codigo, contrasenaNueva: contrasenaNueva);
  static Future<Map<String, dynamic>> cambiarFoto(XFile archivo) => ApiAuth.cambiarFoto(archivo);
  static Future<void> cerrarSesion() => ApiAuth.cerrarSesion();
  static Future<Map<String, dynamic>> crearSolicitud({
    required int monto,
    required int cuotas,
    required String motivo,
    required String metodoDesembolso,
    String? telefonoNequi,
  }) => ApiData.crearSolicitud(monto: monto, cuotas: cuotas, motivo: motivo, metodoDesembolso: metodoDesembolso, telefonoNequi: telefonoNequi);
  static Future<List<Map<String, dynamic>>> obtenerNotificaciones() => ApiData.obtenerNotificaciones();
  static Future<void> registrarInstalacionNotificaciones(String fid) => ApiData.registrarInstalacionNotificaciones(fid);
  static Future<void> eliminarInstalacionNotificaciones(String fid) => ApiData.eliminarInstalacionNotificaciones(fid);
  static Future<List<Map<String, dynamic>>> obtenerSolicitudes() => ApiData.obtenerSolicitudes();
  static Future<List<Map<String, dynamic>>> obtenerPrestamos() => ApiData.obtenerPrestamos();
  static Future<List<Map<String, dynamic>>> obtenerCuotas() => ApiData.obtenerCuotas();
  static Future<List<Map<String, dynamic>>> obtenerMovimientos() => ApiData.obtenerMovimientos();
  static Future<void> marcarNotificacionLeida(String id) => ApiData.marcarNotificacionLeida(id);
  static Future<Map<String, dynamic>> registrarPago({
    required int idPrestamo,
    required int idCuota,
    required num monto,
    required String metodoPago,
  }) => ApiData.registrarPago(idPrestamo: idPrestamo, idCuota: idCuota, monto: monto, metodoPago: metodoPago);
  static Future<Map<String, dynamic>> subirComprobantePago(
    XFile archivo,
  ) => ApiData.subirComprobantePago(archivo);
  static Future<Map<String, dynamic>> crearConversacion() => ApiChat.crearConversacion();
  static Future<Map<String, dynamic>> enviarMensajeChatbot(
    String idConversacion,
    String mensaje,
  ) => ApiChat.enviarMensajeChatbot(idConversacion, mensaje);
  static Future<List<Map<String, dynamic>>> obtenerConversacionesAdmin() => ApiChat.obtenerConversacionesAdmin();
  static Future<List<Map<String, dynamic>>> obtenerMisConversaciones() => ApiChat.obtenerMisConversaciones();
  static Future<List<Map<String, dynamic>>> obtenerMensajesConversacion(
    String idConversacion,
  ) => ApiChat.obtenerMensajesConversacion(idConversacion);
  static Future<Map<String, dynamic>> enviarMensajeConversacion({
    required String idConversacion,
    required String mensaje,
  }) => ApiChat.enviarMensajeConversacion(idConversacion: idConversacion, mensaje: mensaje);
  static Future<void> cerrarConversacion(String idConversacion) => ApiChat.cerrarConversacion(idConversacion);
  static Future<void> transferirConversacionAAdmin(
    String idConversacion,
  ) => ApiChat.transferirConversacionAAdmin(idConversacion);
  static Future<Map<String, String>> obtenerConversacionesRevisadas() => ApiChat.obtenerConversacionesRevisadas();
  static Future<void> marcarConversacionRevisada(
    String id, {
    String? ultimoMensajeUsuario,
  }) => ApiChat.marcarConversacionRevisada(id, ultimoMensajeUsuario: ultimoMensajeUsuario);
  static Future<List<Map<String, dynamic>>> obtenerSolicitudesAdmin() => ApiAdmin.obtenerSolicitudesAdmin();
  static Future<Map<String, dynamic>> actualizarEstadoSolicitud({
    required int idSolicitud,
    required String estado,
    String? fechaDesembolso,
    String? lugarRecogida,
  }) => ApiAdmin.actualizarEstadoSolicitud(idSolicitud: idSolicitud, estado: estado, fechaDesembolso: fechaDesembolso, lugarRecogida: lugarRecogida);
  static Future<Map<String, dynamic>> crearPrestamoDesdeSolicitud(
    int idSolicitud,
  ) => ApiAdmin.crearPrestamoDesdeSolicitud(idSolicitud);
  static Future<Map<String, dynamic>> crearCuotasPrestamo(int idPrestamo) => ApiAdmin.crearCuotasPrestamo(idPrestamo);
  static Future<Map<String, dynamic>> crearNotificacion({
    required int idUsuario,
    required String mensaje,
    String tipo = 'info',
  }) => ApiAdmin.crearNotificacion(idUsuario: idUsuario, mensaje: mensaje, tipo: tipo);
  static Future<List<Map<String, dynamic>>> obtenerUsuarios() => ApiAdmin.obtenerUsuarios();
}
