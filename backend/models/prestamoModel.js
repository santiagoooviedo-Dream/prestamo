//importamos la base de datos
import { supabase } from "../config/supabase.js";

export const obtenerPrestamosPorUsuario = async (id_usuario) => {
    const { data, error } = await supabase
        .from('prestamos')
        .select('*')
        .eq('id_usuario', id_usuario)
        .order('fecha_inicio', { ascending: false });

    return { data, error };
};

export const obtenerCuotasPorPrestamos = async (id_prestamos) => {
    const { data, error } = await supabase
        .from('cuotas')
        .select('*')
        .in('id_prestamo', id_prestamos);

    return { data, error };
};

//funcion para buscar una solicitud por su ID
export const buscarSolicitudPorId = async (id_solicitud) => {

    const { data, error } = await supabase
        .from('solicitudes')
        .select('*')
        .eq('id_solicitud', id_solicitud)
        .single();

    return { data, error };
};

//funcion para crear un prestamo
export const crearPrestamoModel = async (prestamo) => {

    const { data, error } = await supabase
        .from('prestamos')
        .insert(prestamo)
        .select()
        .single();

    return { data, error };
};

//funcion para buscar un prestamo por su ID
export const buscarPrestamoPorId = async (id_prestamo) => {

    const { data, error } = await supabase
        .from('prestamos')
        .select('*')
        .eq('id_prestamo', id_prestamo)
        .single();

    return { data, error };
};

//funcion para crear las cuotas
export const crearCuotasModel = async (cuotas) => {

    const { data, error } = await supabase
        .from('cuotas')
        .insert(cuotas)
        .select();

    return { data, error };
};
