
// Importamos Supabase
import { supabase } from "../config/supabase.js";


// Crear una nueva conversacion
export const crearConversacionModel = async (id_usuario) => {

    const { data, error } = await supabase
        .from('conversaciones')
        .insert({
            id_usuario: id_usuario,
            estado: 'abierta'
        })
        .select()
        .single();

    return { data, error };
};


// Buscar una conversacion por ID
export const buscarConversacionPorId = async (id_conversacion) => {

    const { data, error } = await supabase
        .from('conversaciones')
        .select('*')
        .eq('id_conversacion', id_conversacion)
        .maybeSingle();

    return { data, error };
};


// Obtener las conversaciones de un usuario
export const obtenerConversacionesUsuario = async (id_usuario) => {

    const { data, error } = await supabase
        .from('conversaciones')
        .select('*')
        .eq('id_usuario', id_usuario)
        .order('fecha_creacion', { ascending: false });

    return { data, error };
};


// Obtener todas las conversaciones
export const obtenerTodasConversaciones = async () => {

    const { data, error } = await supabase
        .from('conversaciones')
        .select('*')
        .order('fecha_creacion', { ascending: false });

    return { data, error };
};


// Actualizar el estado de una conversacion
export const actualizarEstadoConversacion = async (
    id_conversacion,
    estado
) => {

    const { data, error } = await supabase
        .from('conversaciones')
        .update({
            estado: estado
        })
        .eq('id_conversacion', id_conversacion)
        .select()
        .single();

    return { data, error };
};


// Crear un mensaje
export const crearMensajeModel = async (
    id_usuario,
    id_conversacion,
    respuesta,
    remitente
) => {

    const { data, error } = await supabase
        .from('mensajes')
        .insert({
            id_usuario: id_usuario,
            id_conversacion: id_conversacion,
            respuesta: respuesta,
            remitente: remitente
        })
        .select()
        .single();

    return { data, error };
};


// Obtener los mensajes de una conversacion
export const obtenerMensajesConversacion = async (id_conversacion) => {

    const { data, error } = await supabase
        .from('mensajes')
        .select('*')
        .eq('id_conversacion', id_conversacion)
        .order('fecha', { ascending: true });

    return { data, error };
};
