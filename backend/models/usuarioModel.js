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
export const buscarUsuarioPorCedula = async (cedula) => {
        const { data, error } = await supabase
            .from('usuarios')
            .select('*')
            .eq('cedula', cedula)
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
export const agregarInstalacionNotificaciones = async (id_usuario, fid) => {
    const { data: usuario, error: errorLectura } = await supabase
        .from('usuarios')
        .select('fcm_installation_ids')
        .eq('id_usuario', id_usuario)
        .maybeSingle();

    if (errorLectura || !usuario) {
        return { data: usuario, error: errorLectura };
    }

    const instalaciones = Array.isArray(usuario.fcm_installation_ids)
        ? usuario.fcm_installation_ids.filter((actual) => typeof actual === 'string')
        : [];
    if (instalaciones.includes(fid)) {
        return { data: usuario, error: null };
    }

    const { data, error } = await supabase
        .from('usuarios')
        .update({ fcm_installation_ids: [...instalaciones, fid] })
        .eq('id_usuario', id_usuario)
        .select('id_usuario')
        .maybeSingle();

    return { data, error };
};
export const eliminarInstalacionesNotificaciones = async (id_usuario, instalacionesEliminar) => {
    const { data: usuario, error: errorLectura } = await supabase
        .from('usuarios')
        .select('fcm_installation_ids')
        .eq('id_usuario', id_usuario)
        .maybeSingle();

    if (errorLectura || !usuario) {
        return { data: usuario, error: errorLectura };
    }

    const instalacionesActuales = Array.isArray(usuario.fcm_installation_ids)
        ? usuario.fcm_installation_ids.filter((fid) =>
            typeof fid === 'string' && !instalacionesEliminar.includes(fid)
        )
        : [];
    const { data, error } = await supabase
        .from('usuarios')
        .update({ fcm_installation_ids: instalacionesActuales })
        .eq('id_usuario', id_usuario)
        .select('id_usuario')
        .maybeSingle();

    return { data, error };
};
export const eliminarUsuarioPorId = async (id_usuario) => {
    const { data, error } = await supabase
        .from('usuarios')
        .delete()
        .eq('id_usuario', id_usuario)
        .select('id_usuario')
        .maybeSingle();

    return { data, error };
};
export const crearUsuario = async (usuario) => {
    const { data, error } = await supabase
        .from('usuarios')
        .insert({
            nombre: usuario.nombre,
            apellido: usuario.apellido,
            correo: usuario.correo,
            telefono: usuario.telefono,
            cedula: usuario.cedula,
            contrasena: usuario.contrasena,
            rol: usuario.rol,
            isVerified: true,
            codigoVerificacion: null,
            codigoVerificacionExpiracion: null
        })
        .select()
        .single();

    return { data, error };
};

export const buscarRegistroPendientePorCorreo = async (correo) => {
    const { data, error } = await supabase
        .from('registros_pendientes')
        .select('*')
        .eq('correo', correo)
        .maybeSingle();

    return { data, error };
};

export const buscarRegistroPendientePorCedula = async (cedula) => {
    const { data, error } = await supabase
        .from('registros_pendientes')
        .select('correo')
        .eq('cedula', cedula)
        .limit(1)
        .maybeSingle();

    return { data, error };
};

export const guardarRegistroPendiente = async (registro) => {
    const { data, error } = await supabase
        .from('registros_pendientes')
        .upsert({
            correo: registro.correo,
            nombre: registro.nombre,
            apellido: registro.apellido,
            telefono: registro.telefono,
            cedula: registro.cedula,
            contrasena: registro.contrasena,
            codigo_verificacion: registro.codigoVerificacion,
            codigo_verificacion_expiracion: registro.codigoVerificacionExpiracion
        }, { onConflict: 'correo' })
        .select()
        .single();

    return { data, error };
};

export const eliminarRegistrosPendientesExpirados = async (ahora) => {
    const { error } = await supabase
        .from('registros_pendientes')
        .delete()
        .lt('codigo_verificacion_expiracion', ahora);

    return { error };
};

export const actualizarCodigoRegistroPendiente = async (correo, codigo, expiracion) => {
    const { data, error } = await supabase
        .from('registros_pendientes')
        .update({
            codigo_verificacion: codigo,
            codigo_verificacion_expiracion: expiracion
        })
        .eq('correo', correo)
        .select()
        .maybeSingle();

    return { data, error };
};

export const eliminarRegistroPendiente = async (correo) => {
    const { error } = await supabase
        .from('registros_pendientes')
        .delete()
        .eq('correo', correo);

    return { error };
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
    // Verificar la cuenta del usuario
 export const verificarUsuario = async (id_usuario) => {

    const { data, error } = await supabase
        .from('usuarios')
        .update({
            isVerified: true,
            codigoVerificacion: null,
            codigoVerificacionExpiracion: null
        })
        .eq('id_usuario', id_usuario)
        .select()
        .single();

    return { data, error };
};

export const actualizarCodigoVerificacion = async (id_usuario, codigo, expiracion) => {
    const { data, error } = await supabase
        .from('usuarios')
        .update({
            codigoVerificacion: codigo,
            codigoVerificacionExpiracion: expiracion
        })
        .eq('id_usuario', id_usuario)
        .select()
        .single();

    return { data, error };
};