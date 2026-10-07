import { supabase } from "../config/supabase.js";

//funcion para crear una notificacion
export const crearNotificacionController = async (req, res) => {

    //recibimos los datos enviados
    const { id_usuario, mensaje, tipo } = req.body;

    //verificamos que ningun dato falte
    if (!id_usuario || !mensaje) {
        return res.status(400).json({
            mensaje: 'El usuario y el mensaje son obligatorios'
        });
    }

    //creamos la notificacion
    const { data, error } = await supabase
        .from('notificaciones')
        .insert({
            id_usuario: id_usuario,
            mensaje: mensaje,
            tipo: tipo || 'info',
            leida: false
        })
        .select()
        .single();

    //comprobamos si hay un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al crear la notificacion',
            error: error.message
        });
    }

    //respondemos con la notificacion creada
    res.status(201).json({
        mensaje: 'Notificacion creada correctamente',
        notification: data
    });
};


//funcion para consultar las notificaciones del usuario
export const obtenerNotificaciones = async (req, res) => {

    //obtenemos el ID del usuario desde el token
    const id_usuario = req.usuario.id_usuario;

    //buscamos las notificaciones del usuario
    const { data, error } = await supabase
        .from('notificaciones')
        .select('*')
        .eq('id_usuario', id_usuario)
        .order('fecha', { ascending: false });

    //comprobamos si hay un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al consultar las notificaciones',
            error: error.message
        });
    }

    //respondemos con las notificaciones
    res.status(200).json({
        notificaciones: data
    });
};


//funcion para marcar una notificacion como leida
export const marcarNotificacionLeida = async (req, res) => {

    //obtenemos el ID de la notificacion desde la URL
    const id_notificacion = req.params.id;

    //actualizamos la notificacion
    const { data, error } = await supabase
        .from('notificaciones')
        .update({
            leida: true
        })
        .eq('id_notificacion', id_notificacion)
        .select()
        .single();

    //comprobamos si ocurre un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al marcar la notificacion',
            error: error.message
        });
    }

    //respondemos con la notificacion actualizada
    res.status(200).json({
        mensaje: 'Notificacion marcada como leida',
        notification: data
    });
};