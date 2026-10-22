// Importamos las funciones del modelo de solicitudes
import { crearSolicitudModel, obtenerSolicitudesPorUsuario, obtenerTodasLasSolicitudes, buscarSolicitudPorId, actualizarEstadoSolicitudModel } from '../models/solicitudModel.js';

// Importamos el modelo de notificaciones
import { crearNotificacionModel } from '../models/notificacionModel.js';
import { buscarUsuarioPorId } from '../models/usuarioModel.js';
import { enviarConfirmacionSolicitud, enviarResultadoSolicitud } from '../utils/sendEmails.js';

// Funcion para crear una nueva solicitud de prestamo
export const crearSolicitud = async (req, res) => {

    // Recibimos los datos enviados por el usuario
    const { monto_solicitado, coutas, motivo, metodo_desembolso, telefono_nequi } = req.body;

    // Obtenemos el ID del usuario desde el token
    const id_usuario = req.usuario.id_usuario;

    // Verificamos que todos los datos esten completos
    if (
        !Number.isInteger(Number(monto_solicitado)) ||
        Number(monto_solicitado) < 100000 ||
        Number(monto_solicitado) > 3000000 ||
        !Number.isInteger(Number(coutas)) ||
        Number(coutas) < 2 ||
        Number(coutas) > 36 ||
        typeof motivo !== 'string' ||
        !motivo.trim() ||
        !['efectivo', 'nequi'].includes(metodo_desembolso)
    ) {

        return res.status(400).json({
            mensaje: 'Ingresa un monto entre $100.000 y $3.000.000, de 2 a 36 cuotas, un motivo y un método de desembolso válido'
        });

    }

    const numeroNequi = typeof telefono_nequi === 'string'
        ? telefono_nequi.replace(/[\s()-]/g, '')
        : '';
    if (metodo_desembolso === 'nequi' && !/^(?:\+?57)?3\d{9}$/.test(numeroNequi)) {
        return res.status(400).json({
            mensaje: 'Ingresa un número celular colombiano válido para recibir el dinero por Nequi'
        });
    }

    // Creamos la solicitud usando el modelo
    const { data, error } = await crearSolicitudModel({
        id_usuario: id_usuario,
        monto_solicitado: Number(monto_solicitado),
        coutas: Number(coutas),
        motivo: motivo.trim(),
        metodo_desembolso,
        telefono_nequi: metodo_desembolso === 'nequi' ? numeroNequi : null,
        estado: 'pendiente'
    });


    // Comprobamos si ocurrio un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al crear la solicitud',
            error: error.message
        });

    }
    const { error: errorNotificacion } = await crearNotificacionModel({
        id_usuario,
        mensaje: `Recibimos tu solicitud #${data.id_solicitud} por $${Number(data.monto_solicitado).toLocaleString('es-CO')} COP. Método elegido: ${data.metodo_desembolso === 'nequi' ? `Nequi (${data.telefono_nequi})` : 'recogida en efectivo'}. Te avisaremos cuando se revise.`,
        tipo: 'solicitud',
        leida: false
    });
    if (errorNotificacion) {
        console.error('La solicitud se creó, pero no se pudo registrar su notificación:', errorNotificacion);
    }

    const { data: usuario, error: errorUsuario } = await buscarUsuarioPorId(id_usuario);
    if (errorUsuario || !usuario) {
        console.error('La solicitud se creó, pero no se pudo consultar el correo del usuario:', errorUsuario);
        return res.status(201).json({
            mensaje: 'Solicitud creada, pero no se pudo enviar la confirmación por correo',
            solicitud: data,
            correo_enviado: false,
            notificacion_creada: !errorNotificacion
        });
    }

    const resultadoCorreo = await enviarConfirmacionSolicitud(
        usuario.correo,
        `${usuario.nombre} ${usuario.apellido}`,
        data
    );

    res.status(201).json({
        mensaje: 'solicitud creada correctamente',
        solicitud: data,
        correo_enviado: resultadoCorreo.enviado,
        notificacion_creada: !errorNotificacion,
        ...(!resultadoCorreo.enviado && {
            advertencia_correo: 'La solicitud se creó, pero no se pudo enviar el correo de confirmación'
        })
    });
};

// Funcion para consultar las solicitudes del usuario
export const obtenerSolicitudes = async (req, res) => {
    // Obtenemos el ID desde el token
    const id_usuario = req.usuario.id_usuario;
    // Buscamos las solicitudes usando el modelo
    const { data, error } = await obtenerSolicitudesPorUsuario(id_usuario);

    // Si ocurre un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al consultar las solicitudes',
            error: error.message
        });
    }
    // Enviamos las solicitudes encontradas
    res.status(200).json({
        solicitud: data
    });

};
// Funcion para consultar todas las solicitudes como administrador
export const obtenerSolicitudesAdmin = async (req, res) => {
    // Buscamos todas las solicitudes usando el modelo
    const { data, error } =
        await obtenerTodasLasSolicitudes();
    // Si ocurre un error
    if (error) {
        return res.status(500).json({
            mensaje: 'error al consultar las solicitudes',
            error: error.message
        });

    }

    // Enviamos todas las solicitudes
    res.status(200).json({
        solicitud: data
    });

};
// Funcion para aceptar o rechazar una solicitud
export const actualizarEstadoSolicitud = async (req, res) => {

    // Obtenemos el ID de la solicitud desde la URL
    const id_solicitud = req.params.id;

    // Recibimos el nuevo estado
    const { estado, fecha_desembolso, lugar_recogida } = req.body;

    // Verificamos que el estado sea valido
    if (estado !== 'aceptada' && estado !== 'rechazada') {

        return res.status(400).json({
            mensaje: 'El estado debe ser aceptada o rechazada'
        });
    }
    // Buscamos la solicitud
    const {
        data: solicitud,
        error: errorSolicitud
    } = await buscarSolicitudPorId(id_solicitud);


    // Comprobamos si ocurrio un error
    if (errorSolicitud) {

        return res.status(500).json({
            mensaje: 'Error al buscar la solicitud',
            error: errorSolicitud.message
        });
    }

    // Comprobamos si la solicitud no existe
    if (!solicitud) {
        return res.status(404).json({
            mensaje: 'No se encontro la solicitud'
        });

    }

    if (solicitud.estado !== 'pendiente') {
        return res.status(409).json({
            mensaje: 'Solo se pueden resolver solicitudes que estén pendientes'
        });
    }

    let fechaProgramada;
    let lugar = null;
    if (estado === 'aceptada') {
        fechaProgramada = new Date(fecha_desembolso);
        if (!fecha_desembolso || Number.isNaN(fechaProgramada.getTime()) || fechaProgramada <= new Date()) {
            return res.status(400).json({
                mensaje: 'Para aceptar la solicitud debes indicar una fecha y hora futuras en fecha_desembolso'
            });
        }
        if (solicitud.metodo_desembolso === 'efectivo') {
            if (typeof lugar_recogida !== 'string' || !lugar_recogida.trim()) {
                return res.status(400).json({
                    mensaje: 'Indica el punto exacto donde se recogerá el dinero en efectivo'
                });
            }
            lugar = lugar_recogida.trim();
        } else if (solicitud.metodo_desembolso === 'nequi') {
            if (!solicitud.telefono_nequi) {
                return res.status(400).json({
                    mensaje: 'La solicitud no tiene un número Nequi válido asociado'
                });
            }
        } else {
            return res.status(400).json({
                mensaje: 'La solicitud no tiene un método de desembolso válido'
            });
        }
    }

    // Actualizamos el estado usando el modelo
    const {data, error} = await actualizarEstadoSolicitudModel(
        id_solicitud,
        {
            estado,
            ...(estado === 'aceptada' && {
                fecha_desembolso: fechaProgramada.toISOString(),
                lugar_recogida: lugar
            })
        }
    );

    // Comprobamos si ocurre un error
    if (error) {

        return res.status(500).json({
            mensaje: 'Error al actualizar la solicitud',
            error: error.message
        });

    }

    // Creamos el mensaje de la notificacion
    let mensajeNotificacion = `Tu solicitud #${data.id_solicitud} por $${Number(data.monto_solicitado).toLocaleString('es-CO')} COP fue rechazada.`;
    if (estado === 'aceptada') {
        const fechaLegible = new Intl.DateTimeFormat('es-CO', {
            dateStyle: 'full',
            timeStyle: 'short',
            timeZone: 'America/Bogota'
        }).format(fechaProgramada);
        const destino = data.metodo_desembolso === 'nequi'
            ? `Se enviará por Nequi al número ${data.telefono_nequi}.`
            : `Recoge el efectivo en: ${lugar}.`;
        mensajeNotificacion = `¡Tu solicitud #${data.id_solicitud} fue aprobada! Monto: $${Number(data.monto_solicitado).toLocaleString('es-CO')} COP en ${data.coutas} cuotas. ${destino} Fecha y hora: ${fechaLegible} (hora de Colombia).`;
    }


    // Creamos la notificacion usando su modelo
    const {data: notificacion, error: errorNotificacion} = await crearNotificacionModel({
        id_usuario: solicitud.id_usuario,
        mensaje: mensajeNotificacion,
        tipo: 'solicitud',
        leida: false

    });

    // Comprobamos si ocurrio un error
    if (errorNotificacion) {
        console.error('La solicitud cambió de estado, pero no se pudo crear la notificación:', errorNotificacion);
    }

    const { data: usuario, error: errorUsuario } = await buscarUsuarioPorId(data.id_usuario);
    if (errorUsuario || !usuario) {
        console.error('La solicitud cambió de estado, pero no se pudo consultar el correo del usuario:', errorUsuario);
        return res.status(200).json({
            mensaje: 'Solicitud actualizada, pero no se pudo preparar el correo de notificación',
            solicitud: data,
            notificacion_creada: !errorNotificacion,
            correo_enviado: false
        });
    }
    const resultadoCorreo = await enviarResultadoSolicitud(
        usuario.correo,
        `${usuario.nombre} ${usuario.apellido}`,
        data
    );

    // Respondemos con la solicitud y la notificacion
    res.status(200).json({
        mensaje: 'Solicitud actualizada correctamente',
        solicitud: data,
        notificacion: notificacion || null,
        notificacion_creada: !errorNotificacion,
        correo_enviado: resultadoCorreo.enviado,
        ...(!resultadoCorreo.enviado && {
            advertencia_correo: 'El estado cambió, pero no se pudo enviar el correo de notificación'
        })
    });

};