// Importamos Supabase
import { supabase } from '../config/supabase.js';

// Buscar un usuario por correo
export const buscarUsuarioPorCorreo = async (correo) => {
    const { data, error } = await supabase
        .from('usuarios')
        .select('*')
        .eq('correo', correo)
        .maybeSingle();

    return { data, error };
};
// Buscar un usuario por ID
export const buscarUsuarioPorId = async (id_usuario) => {

    const { data, error } = await supabase
        .from('usuarios')
        .select('*')
        .eq('id_usuario', id_usuario)
        .maybeSingle();

    return { data, error };
};
// Crear un nuevo usuario
export const crearUsuario = async (usuario) => {

    const { data, error } = await supabase
        .from('usuarios')
        .insert(usuario)
        .select()
        .single();

    return { data, error };
};
// cambiar el correo electronico
export const actualizarCorreoUsuario = async (id_usuario, correo) => {

    const { data, error } = await supabase
        .from('usuarios')
        .update({
            correo: correo
        })
        .eq('id_usuario', id_usuario)
        .select()
        .single();

    return { data, error };
};
// cambiar la contraseña del usuario
export const cambiarContrasena = async (id_usuario, contrasena) => {

    const { data, error } = await supabase
        .from('usuarios')
        .update({
            contrasena: contrasena
        })
        .eq('id_usuario', id_usuario)
        .select()
        .single();

    return { data, error };
};
// Guardar codigo de recuperacion
export const crearCodigoRecuperacion = async (id_usuario, codigo) => {

    const { data, error } = await supabase
        .from('codigos')
        .insert([
            {
                id_usuario: id_usuario,
                codigo: codigo
            }
        ])
        .select()
        .single();

    return { data, error };
};
// Buscar codigo de recuperacion
export const buscarCodigoRecuperacion = async (id_usuario, codigo) => {

    const { data, error } = await supabase
        .from('codigos')
        .select('*')
        .eq('id_usuario', id_usuario)
        .eq('codigo', codigo)
        .order('fecha', { ascending: false })
        .limit(1)
        .maybeSingle();

    return { data, error };
};
// Actualizar la foto del usuario
export const actualizarFotoUsuario = async (id_usuario, foto) => {

    const { data, error } = await supabase
        .from('usuarios')
        .update({
            foto: foto
        })
        .eq('id_usuario', id_usuario)
        .select()
        .single();

    return { data, error };
};