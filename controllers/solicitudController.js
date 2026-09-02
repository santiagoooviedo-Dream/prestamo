// Importamos las funciones del modelo de solicitudes
import {
    crearSolicitudModel,
    obtenerSolicitudesPorUsuario,
    obtenerTodasLasSolicitudes,
    buscarSolicitudPorId,
    actualizarEstadoSolicitudModel} from '../models/solicitudModel.js';


// Importamos el modelo de notificaciones
import { crearNotificacionModel } from '../models/notificacionModel.js';

// Funcion para crear una nueva solicitud de prestamo
export const crearSolicitud = async (req, res) => {
    // Recibimos los datos enviados por el usuario
    const { monto_solicitado, coutas, motivo } = req.body;
    // Obtenemos el ID del usuario desde el token
    const id_usuario = req.usuario.id_usuario;
    // Verificamos que todos los datos esten completos
    if (!monto_solicitado || !coutas || !motivo) {

        return res.status(400).json({
            mensaje: 'monto coutas y motivo son obligatorios para continuar'
        });

    }

    // Creamos la solicitud usando el modelo
    const { data, error } = await crearSolicitudModel({

        id_usuario: id_usuario,
        monto_solicitado: monto_solicitado,
        coutas: coutas,
        motivo: motivo,
        estado: 'pendiente'

    });


    // Comprobamos si ocurrio un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al crear la solicitud',
            error: error.message
        });

    }
    // Respondemos que la solicitud fue creada
    res.status(201).json({
        mensaje: 'solicitud creada correctamente',
        solicitud: data
    });
};

// Funcion para consultar las solicitudes del usuario
export const obtenerSolicitudes = async (req, res) => {
    // Obtenemos el ID desde el token
    const id_usuario = req.usuario.id_usuario;
    // Buscamos las solicitudes usando el modelo
    const { data, error } =
        await obtenerSolicitudesPorUsuario(id_usuario);
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
    const { estado } = req.body;

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

    // Actualizamos el estado usando el modelo
    const {
        data,
        error
    } = await actualizarEstadoSolicitudModel(
        id_solicitud,
        estado
    );

    // Comprobamos si ocurre un error
    if (error) {

        return res.status(500).json({
            mensaje: 'Error al actualizar la solicitud',
            error: error.message
        });

    }

    // Creamos el mensaje de la notificacion
    let mensajeNotificacion;

    if (estado === 'aceptada') {
        mensajeNotificacion =
            'Tu solicitud de prestamo ha sido aceptada';
    } else {
        mensajeNotificacion =
            'Tu solicitud de prestamo ha sido rechazada';
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
        return res.status(500).json({
            mensaje:
                'La solicitud se actualizo, pero no se pudo crear la notificacion',
            error: errorNotificacion.message
        });
    }


    // Respondemos con la solicitud y la notificacion
    res.status(200).json({
        mensaje: 'Solicitud actualizada correctamente',
        solicitud: data,
        notificacion: notificacion
    });

};