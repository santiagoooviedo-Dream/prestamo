// Importamos Supabase
import { supabase } from '../config/supabase.js';


// Crear una nueva solicitud
export const crearSolicitudModel = async (solicitud) => {

    const { data, error } = await supabase
        .from('solicitudes')
        .insert(solicitud)
        .select()
        .single();

    return { data, error };
};

// Obtener las solicitudes de un usuario
export const obtenerSolicitudesPorUsuario = async (id_usuario) => {

    const { data, error } = await supabase
        .from('solicitudes')
        .select('*')
        .eq('id_usuario', id_usuario);

    return { data, error };
};

// Obtener todas las solicitudes
export const obtenerTodasLasSolicitudes = async () => {

    const { data, error } = await supabase
        .from('solicitudes')
        .select('*');

    return { data, error };
};

// Buscar una solicitud por su ID
export const buscarSolicitudPorId = async (id_solicitud) => {

    const { data, error } = await supabase
        .from('solicitudes')
        .select('*')
        .eq('id_solicitud', id_solicitud)
        .maybeSingle();

    return { data, error };
};

// Actualizar el estado de una solicitud
export const actualizarEstadoSolicitudModel = async (id_solicitud,estado) => {

    const { data, error } = await supabase
        .from('solicitudes')
        .update({
            estado: estado
        })
        .eq('id_solicitud', id_solicitud)
        .select()
        .single();

    return { data, error };
};