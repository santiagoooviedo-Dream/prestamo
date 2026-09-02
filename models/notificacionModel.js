// Importamos Supabase

import { supabase } from "../config/supabase.js";


// Crear una notificacion

export const crearNotificacionModel = async (notificacion) => {

    const { data, error } = await supabase
        .from('notificaciones')
        .insert(notificacion)
        .select()
        .single();

    return { data, error };
};


// Buscar las notificaciones de un usuario

export const obtenerNotificacionesModel = async (id_usuario) => {

    const { data, error } = await supabase
        .from('notificaciones')
        .select('*')
        .eq('id_usuario', id_usuario)
        .order('fecha', { ascending: false });

    return { data, error };
};


// Marcar una notificacion como leida

export const marcarNotificacionLeidaModel = async (id_notificacion) => {

    const { data, error } = await supabase
        .from('notificaciones')
        .update({
            leida: true
        })
        .eq('id_notificacion', id_notificacion)
        .select()
        .single();

    return { data, error };
};