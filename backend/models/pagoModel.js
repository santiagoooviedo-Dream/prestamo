import { supabase } from '../config/supabase.js';
// Buscar una cuota por ID
export const buscarCuotaPorId = async (id_cuota) => {

const { data, error } = await supabase
    .from('cuotas')
    .select('*')
    .eq('id_cuota', id_cuota)
    .single();

return { data, error };

};

// Buscar un prestamo por ID
export const buscarPrestamoPorId = async (id_prestamo) => {

const { data, error } = await supabase
    .from('prestamos')
    .select('*')
    .eq('id_prestamo', id_prestamo)
    .single();

return { data, error };

};

// Crear un pago
export const crearPago = async (pago) => {

const { data, error } = await supabase
    .from('pagos')
    .insert(pago)
    .select()
    .single();

return { data, error };

};

// Actualizar el estado de una cuota
export const actualizarEstadoCuota = async (id_cuota) => {

const { data, error } = await supabase
    .from('cuotas')
    .update({
        estado: 'pagada'
    })
    .eq('id_cuota', id_cuota)
    .select()
    .single();

return { data, error };

};

// Crear un movimiento
export const crearMovimiento = async (movimiento) => {

const { data, error } = await supabase
    .from('movimientos')
    .insert(movimiento)
    .select()
    .single();

return { data, error };
};