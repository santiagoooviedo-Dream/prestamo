import {supabase } from '../config/supabase.js';

//buscamos los mensajes de la conversacion 

export const obtenerHistorialIA = async (id_conversacion) => {
    
    const { data, error } = await supabase
        .from('mensajes')
        .select('*')
        .eq('id_conversacion', id_conversacion)
        .order('fecha', { ascending: true });
    
    return { data, error };
}