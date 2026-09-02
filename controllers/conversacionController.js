// Importamos las funciones del modelo
import { crearConversacionModel,buscarConversacionPorId,obtenerConversacionesUsuario,obtenerTodasConversaciones,actualizarEstadoConversacion,crearMensajeModel,obtenerMensajesConversacion } from '../models/conversacionModel.js';

// Funcion para crear una nueva conversacion
export const crearConversacion = async (req, res) => {

    // Obtenemos el ID del usuario desde el token
    const id_usuario = req.usuario.id_usuario;

    // Creamos la conversacion
    const { data, error } =
        await crearConversacionModel(id_usuario);

    // Comprobamos si ocurrio un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al crear la conversacion',
            error: error.message
        });
    }

    // Respondemos con la conversacion creada
    res.status(201).json({
        mensaje: 'Conversacion creada correctamente',
        conversacion: data
    });
};

// Funcion para consultar las conversaciones del usuario
export const obtenerMisConversaciones = async (req, res) => {

    // Obtenemos el ID del usuario desde el token
    const id_usuario = req.usuario.id_usuario;

    // Buscamos las conversaciones
    const { data, error } =
        await obtenerConversacionesUsuario(id_usuario);

    // Comprobamos si ocurre un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al consultar las conversaciones',
            error: error.message
        });
    }

    // Respondemos
    res.status(200).json({
        conversaciones: data
    });
};

// Funcion para que el administrador consulte todas las conversaciones
export const obtenerConversacionesAdmin = async (req, res) => {

    // Buscamos todas las conversaciones
    const { data, error } =
        await obtenerTodasConversaciones();

    // Comprobamos si ocurre un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al consultar las conversaciones',
            error: error.message
        });
    }

    // Respondemos
    res.status(200).json({
        conversaciones: data
    });
};

// Funcion para enviar un mensaje
export const enviarMensaje = async (req, res) => {

    // Obtenemos el ID de la conversacion
    const id_conversacion = req.params.id;

    // Obtenemos el usuario desde el token
    const id_usuario = req.usuario.id_usuario;

    // Recibimos el mensaje
    const { respuesta } = req.body;

    // Verificamos que el mensaje exista
    if (!respuesta) {
        return res.status(400).json({
            mensaje: 'El mensaje es obligatorio'
        });
    }

    // Buscamos la conversacion
    const { data: conversacion, error: errorConversacion } = await buscarConversacionPorId(id_conversacion);

    // Comprobamos si ocurrio un error
    if (errorConversacion) {
        return res.status(500).json({
            mensaje: 'Error al buscar la conversacion',
            error: errorConversacion.message
        });
    }

    // Comprobamos si no existe
    if (!conversacion) {
        return res.status(404).json({
            mensaje: 'No se encontro la conversacion'
        });
    }

    // Verificamos que la conversacion pertenezca al usuario
    if (
        conversacion.id_usuario !== id_usuario &&
        req.usuario.rol !== 'admin'
    ) {
        return res.status(403).json({
            mensaje: 'No tienes permiso para enviar mensajes en esta conversacion'
        });
    }

    // Definimos quien envia el mensaje
    let remitente = 'usuario';

    if (req.usuario.rol === 'admin') {
        remitente = 'admin';
    }

    // Creamos el mensaje
    const { data, error } =
        await crearMensajeModel(
            id_usuario,
            id_conversacion,
            respuesta,
            remitente
        );

    // Comprobamos si ocurrio un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al enviar el mensaje',
            error: error.message
        });
    }

    // Respondemos
    res.status(201).json({
        mensaje: 'Mensaje enviado correctamente',
        mensajeCreado: data
    });
};

// Funcion para consultar los mensajes de una conversacion
export const obtenerMensajes = async (req, res) => {

    // Obtenemos el ID de la conversacion
    const id_conversacion = req.params.id;

    // Obtenemos el usuario desde el token
    const id_usuario = req.usuario.id_usuario;

    // Buscamos la conversacion
    const { data: conversacion,error: errorConversacion } = await buscarConversacionPorId(id_conversacion);

    // Comprobamos si ocurre un error
    if (errorConversacion) {
        return res.status(500).json({
            mensaje: 'Error al buscar la conversacion',
            error: errorConversacion.message
        });
    }

    // Comprobamos si no existe
    if (!conversacion) {
        return res.status(404).json({
            mensaje: 'No se encontro la conversacion'
        });
    }

    // Verificamos los permisos
    if (
        conversacion.id_usuario !== id_usuario &&
        req.usuario.rol !== 'admin'
    ) {
        return res.status(403).json({
            mensaje: 'No tienes permiso para ver esta conversacion'
        });
    }

    // Buscamos los mensajes
    const {
        data,
        error
    } = await obtenerMensajesConversacion(id_conversacion);

    // Comprobamos si ocurre un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al consultar los mensajes',
            error: error.message
        });
    }

    // Respondemos
    res.status(200).json({
        mensajes: data
    });
};

// Funcion para cerrar una conversacion
export const cerrarConversacion = async (req, res) => {

    // Obtenemos el ID de la conversacion
    const id_conversacion = req.params.id;

    // Buscamos la conversacion
    const {
        data: conversacion,
        error: errorConversacion
    } = await buscarConversacionPorId(id_conversacion);

    // Comprobamos si ocurre un error
    if (errorConversacion) {
        return res.status(500).json({
            mensaje: 'Error al buscar la conversacion',
            error: errorConversacion.message
        });
    }

    // Comprobamos si no existe
    if (!conversacion) {
        return res.status(404).json({
            mensaje: 'No se encontro la conversacion'
        });
    }

    // Actualizamos el estado
    const { data, error } =
        await actualizarEstadoConversacion(
            id_conversacion,
            'cerrada'
        );

    // Comprobamos si ocurre un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al cerrar la conversacion',
            error: error.message
        });
    }

    // Respondemos
    res.status(200).json({
        mensaje: 'Conversacion cerrada correctamente',
        conversacion: data
    });
};

