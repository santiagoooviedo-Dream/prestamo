//importamos bcrypt para encriptar la contraseña
import bcrypt from 'bcrypt';

//importamos jwt para generar el token
import jwt from 'jsonwebtoken';

import { buscarUsuarioPorCorreo, crearUsuario, actualizarCorreoUsuario, cambiarContrasena, buscarUsuarioPorId, crearCodigoRecuperacion, buscarCodigoRecuperacion, actualizarFotoUsuario, verificarUsuario } from '../models/usuarioModel.js';

//importamos el brave para enviar codigos de recuperacion de contraseña
import { enviarCodigoRecuperacion, enviarCodigoVerificacion } from '../utils/sendEmails.js';

// Funcion para registrar un nuevo usuario
export const registrarUsuario = async (req, res) => {

    // Obtenemos los datos enviados
    const { nombre, apellido, correo, telefono, cedula, contrasena} = req.body;

    // Verificamos que todos los datos lleguen
    if ( !nombre || !apellido || !correo || !telefono || !cedula || !contrasena) {
        return res.status(400).json({
            mensaje: 'Todos los campos son obligatorios'
        });
    }

    // Buscamos si el correo ya existe
    const { data: usuarioExistente, error: errorCorreo } =
        await buscarUsuarioPorCorreo(correo);

    // Comprobamos si Supabase tuvo un error
    if (errorCorreo) {
        return res.status(500).json({
            mensaje: 'Error al buscar el correo',
            error: errorCorreo.message
        });
    }

    // Si el correo ya esta registrado
    if (usuarioExistente) {
        return res.status(400).json({
            mensaje: 'El correo ya esta en uso'
        });
    }

    // Protegemos la contraseña
    const contrasenaSegura =
        await bcrypt.hash(contrasena, 10);

    // Creamos un codigo de 6 numeros
    const codigo = Math.floor(100000 + Math.random() * 900000).toString();

    // El codigo sera valido durante 15 minutos
    const codigoVerificacionExpiracion =
        new Date(Date.now() + 15 * 60 * 1000);

        
const { data, error } = await crearUsuario({
    nombre,
    apellido,
    correo,
    telefono,
    cedula,
    contrasena: contrasenaSegura,
    rol: 'usuario',
    codigoVerificacion: codigo,
    codigoVerificacionExpiracion: codigoVerificacionExpiracion
});

    // Comprobamos si ocurrio un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al registrar el usuario',
            error: error.message
        });
    }

    // Enviamos el codigo por Brevo
    const resultado =await enviarCodigoVerificacion(
            correo,
            nombre,
            codigo
        );

    // Si no se pudo enviar el correo
    if (!resultado.exito) {

        return res.status(500).json({
            mensaje: 'El usuario fue creado pero no se pudo enviar el codigo',
            error: resultado.error
        });
    }

    // Respondemos
    return res.status(201).json({
        mensaje: 'Usuario creado. Revisa tu correo para verificar la cuenta',
        correo: correo
    });
};
// Funcion para solicitar codigo de verificacion para registrarse
export const solicitarRegistro = async (req, res) => {

    // Obtenemos los datos enviados
    const { nombre, apellido, correo, telefono, cedula, contrasena } = req.body;

    // Verificamos que todos los datos lleguen
    if (
        !nombre || !apellido || !correo || !telefono || !cedula || !contrasena
    ) {
        return res.status(400).json({
            mensaje: 'Todos los campos son obligatorios'
        });
    }

    // Buscamos si el correo ya existe
    const { data: usuarioExistente, error } =
        await buscarUsuarioPorCorreo(correo);

    // Comprobamos si Supabase tuvo un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al buscar el correo',
            error: error.message
        });
    }

    // Si el correo ya existe
    if (usuarioExistente) {
        return res.status(400).json({
            mensaje: 'El correo ya esta registrado'
        });
    }

    // Creamos un codigo de 6 numeros
    const codigo =Math.floor(100000 + Math.random() * 900000).toString();

    // El codigo vence en 15 minutos
    const expiracion =
        new Date(Date.now() + 15 * 60 * 1000);

    // Enviamos el codigo utilizando Brevo
    const resultado =await enviarCodigoVerificacion(
            correo,
            nombre,
            codigo
        );

    // Comprobamos si Brevo pudo enviar el correo
    if (!resultado.exito) {
        return res.status(500).json({
            mensaje: 'No se pudo enviar el codigo',
            error: resultado.error
        });
    }

    // Respondemos
    res.status(200).json({
        mensaje: 'Codigo enviado correctamente',
        correo: correo
    });
};
// Funcion para verificar el registro mediante el codigo
export const verificarRegistro = async (req, res) => {

    // Obtenemos los datos
    const { correo, codigo } = req.body;

    // Verificamos que lleguen
    if (!correo || !codigo) {
        return res.status(400).json({
            mensaje: 'El correo y el codigo son obligatorios'
        });
    }

    // Buscamos el usuario
    const { data: usuario, error } =
        await buscarUsuarioPorCorreo(correo);

    // Comprobamos si ocurrio un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al buscar el usuario',
            error: error.message
        });
    }

    // Comprobamos si existe
    if (!usuario) {
        return res.status(404).json({
            mensaje: 'No se encontro el usuario'
        });
    }

    // Comprobamos si ya esta verificado
    if (usuario.isVerified) {
        return res.status(400).json({
            mensaje: 'El usuario ya esta verificado'
        });
    }

    // Comprobamos si el codigo ya vencio
    if (
        !usuario.codigoVerificacionExpiracion ||
        new Date() > new Date(usuario.codigoVerificacionExpiracion)
    ) {
        return res.status(400).json({
            mensaje: 'El codigo de verificacion ha expirado'
        });
    }

    // Comprobamos si el codigo es correcto
    if (usuario.codigoVerificacion !== codigo) {
        return res.status(400).json({
            mensaje: 'El codigo de verificacion es incorrecto'
        });
    }

    // Verificamos el usuario
    const { data: usuarioVerificado, error: errorVerificacion} = await verificarUsuario(usuario.id_usuario);

    // Comprobamos si ocurrio un error
    if (errorVerificacion) {
        return res.status(500).json({
            mensaje: 'No se pudo verificar la cuenta',
            error: errorVerificacion.message
        });
    }

    // Respondemos
    return res.status(200).json({
        mensaje: 'Cuenta verificada correctamente',
        usuario: {
            id_usuario: usuarioVerificado.id_usuario,
            nombre: usuarioVerificado.nombre,
            apellido: usuarioVerificado.apellido,
            correo: usuarioVerificado.correo,
            isVerified: usuarioVerificado.isVerified
        }
    });
};
//funcion para iniciar sesion
export const loginUsuario = async (req, res) => {

    //recibimos los datos
    const { correo, contrasena } = req.body;

    //comprobamos que llegaron
    if (!correo || !contrasena) {
        return res.status(400).json({
            error: 'correo y contraseña faltan'
        });
    }

    //buscamos el usuario utilizando el modelo
    const {
        data: usuario,
        error
    } = await buscarUsuarioPorCorreo(correo);

    //comprobamos error de Supabase
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al buscar el usuario',
            error: error.message
        });
    }

    //comprobamos si existe
    if (!usuario) {
        return res.status(401).json({
            mensaje: 'Correo o contraseña incorrectos'
        });
    }

    //comparamos la contraseña
    const contrasenaCorrecta =await bcrypt.compare(
            contrasena,
            usuario.contrasena
        );

    //si la contraseña es incorrecta
    if (!contrasenaCorrecta) {
        return res.status(401).json({
            mensaje: 'Correo o contraseña incorrectos'
        });
    }

    //creamos el token
    const token = jwt.sign(
        {
            id_usuario: usuario.id_usuario,
            rol: usuario.rol
        },
        process.env.JWT_SECRET,
        {
            expiresIn: '1h'
        }
    );

    //respondemos
    res.status(200).json({

        mensaje: 'Inicio de sesion exitoso',

        token: token,

        usuario: {
            id_usuario: usuario.id_usuario,
            nombre: usuario.nombre,
            apellido: usuario.apellido,
            correo: usuario.correo,
            telefono: usuario.telefono,
            rol: usuario.rol
        }

    });
};

// Funcion para cambiar el correo del usuario
export const cambiarCorreoUsuario = async (req, res) => {

    // Obtenemos el nuevo correo y la contraseña
    const { nuevoCorreo, contrasena } = req.body;

    // Obtenemos el ID del usuario desde el token
    const id_usuario = req.usuario.id_usuario;

    // Verificamos que los datos sean obligatorios
    if (!nuevoCorreo || !contrasena) {
        return res.status(400).json({
            mensaje: 'El nuevo correo y la contraseña son obligatorios'
        });
    }

    // Buscamos al usuario
    const { data: usuario, error: errorUsuario } =
        await buscarUsuarioPorId(id_usuario);

    // Comprobamos si ocurrió un error
    if (errorUsuario) {
        return res.status(500).json({
            mensaje: 'Error al buscar el usuario',
            error: errorUsuario.message
        });
    }

    // Comprobamos si existe el usuario
    if (!usuario) {
        return res.status(404).json({
            mensaje: 'No se encontro el usuario'
        });
    }

    // Comparamos la contraseña actual
    const contrasenaCorrecta = await bcrypt.compare(
        contrasena,
        usuario.contrasena
    );

    // Si la contraseña no es correcta
    if (!contrasenaCorrecta) {
        return res.status(401).json({
            mensaje: 'La contraseña es incorrecta'
        });
    }

    // Comprobamos que el nuevo correo no este utilizado
    const { data: correoExistente } =
        await buscarUsuarioPorCorreo(nuevoCorreo);

    if (correoExistente) {
        return res.status(400).json({
            mensaje: 'El correo ya esta en uso'
        });
    }

    // Actualizamos el correo
    const { data, error } = await actualizarCorreoUsuario(
        id_usuario,
        nuevoCorreo
    );

    // Comprobamos si ocurrió un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al actualizar el correo',
            error: error.message
        });
    }

    // Respondemos
    res.status(200).json({
        mensaje: 'Correo actualizado correctamente',
        usuario: data
    });
};

//funcion para cambiar la contraseña del usuario
export const cambiarContraseñaUsuario = async (req,res) => {

    //obtenemos el usuario atraves del token
    const id_usuario = req.usuario.id_usuario;

    //recibimos la contraseña
    const {contrasenaActual, contrasenaNueva} = req.body;

    //verificamos que las constraseñas hayan sido enviadas 
    if (!contrasenaActual || !contrasenaNueva) {
        return res.status(400).json({
            mensaje: 'La contraseña actual y nueva son obligatorias'
        })
    }

    //buscamos a el usuario 
    const {data: usuario, error: errorUsuario} = await buscarUsuarioPorId(id_usuario)
    //comprobamos si ocurre un error
    if (errorUsuario) {
        return res.status(500).json({
            mensaje: 'Error al buscar usuario',
            error: errorUsuario.message
        })
    }

    //comprobamos si encontramos a el usuario

    if (!usuario) {
        return res.status(404).json({
            mensaje: 'No se encontro el usuario'
        })
    }

    //compramos la contraseña actual
    const contrasenaCorrecta = await bcrypt.compare(contrasenaActual,usuario.contrasena)

    //si la contraseña actual no es correcta

    if (!contrasenaCorrecta) {
        return res.status(401).json({
            mensaje: 'La contraseña actual es incorrecta'
        })
    }

    //protegemos la nueva contraseña
    const contraseñasegura = await bcrypt.hash(contrasenaNueva,10)

    //actualizamos la contraseña usando el modelo

    const {data,error} = await cambiarContrasena(
        id_usuario,
        contraseñasegura
    )
    //comprobobamos si ocurre un errror

    if(error) {
        return res.status(500).json({
            mensaje: 'Error al cambiar la contraseña',
            error: error.message
        })
    }

    //respondemos 
    res.status(200).json({
        mensaje: 'contraseña actualizada correctamente'
    })
}
// Funcion para solicitar codigo de recuperacion
export const solicitarCodigoRecuperacion = async (req, res) => {
    // Obtenemos el correo
    const { correo } = req.body;
    // Verificamos que llegue el correo
    if (!correo) {
        return res.status(400).json({
            mensaje: 'El correo es obligatorio'
        });
    }
    // Buscamos el usuario
    const { data: usuario, error } =
        await buscarUsuarioPorCorreo(correo);

    // Comprobamos si ocurrio un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al buscar el usuario',
            error: error.message
        });
    }
    // Comprobamos si existe
    if (!usuario) {
        return res.status(404).json({
            mensaje: 'No se encontro un usuario con ese correo'
        });
    }
    // Creamos un codigo de 6 numeros
    const codigo = Math.floor(100000 + Math.random() * 900000).toString();
    // Guardamos el codigo
    const { error: errorCodigo } =
        await crearCodigoRecuperacion(
            usuario.id_usuario,
            codigo
        );
    // Comprobamos si ocurrio un error
    if (errorCodigo) {
        return res.status(500).json({
            mensaje: 'Error al guardar el codigo',
            error: errorCodigo.message
        });
    }
    // Enviamos el codigo por correo
    const resultado =await enviarCodigoRecuperacion(
            correo,
            codigo
        );
    // Comprobamos si ocurrio un error enviando el correo
    if (!resultado.success) {
        return res.status(500).json({
            mensaje: 'No se pudo enviar el codigo',
            error: resultado.error
        });
    }
    // Respondemos
    res.status(200).json({
        mensaje: 'Codigo enviado correctamente'
    });
};
// Funcion para verificar el codigo de recuperacion
export const verificarCodigoRecuperacion = async (req, res) => {

    // Obtenemos los datos
    const { correo, codigo } = req.body;

    // Verificamos que lleguen
    if (!correo || !codigo) {
        return res.status(400).json({
            mensaje: 'El correo y el codigo son obligatorios'
        });
    }

    // Buscamos el usuario
    const { data: usuario, error: errorUsuario } =
        await buscarUsuarioPorCorreo(correo);

    // Comprobamos error
    if (errorUsuario) {
        return res.status(500).json({
            mensaje: 'Error al buscar el usuario',
            error: errorUsuario.message
        });
    }

    // Comprobamos si existe
    if (!usuario) {
        return res.status(404).json({
            mensaje: 'No se encontro el usuario'
        });
    }

    // Buscamos el codigo
    const { data: codigoEncontrado, error } =await buscarCodigoRecuperacion(
            usuario.id_usuario,
            codigo
        );

    // Comprobamos error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al verificar el codigo',
            error: error.message
        });
    }

    // Si no encontramos el codigo
    if (!codigoEncontrado) {
        return res.status(400).json({
            mensaje: 'El codigo es incorrecto'
        });
    }

    // Codigo correcto
    res.status(200).json({
        mensaje: 'Codigo correcto'
    });
};
// Funcion para recuperar la contraseña
export const recuperarContrasena = async (req, res) => {

    // Obtenemos los datos
    const { correo, codigo, contrasenaNueva } = req.body;

    // Verificamos que lleguen
    if (!correo || !codigo || !contrasenaNueva) {
        return res.status(400).json({
            mensaje: 'El correo, codigo y nueva contraseña son obligatorios'
        });
    }

    // Buscamos el usuario
    const { data: usuario, error: errorUsuario } =
        await buscarUsuarioPorCorreo(correo);

    // Comprobamos error
    if (errorUsuario) {
        return res.status(500).json({
            mensaje: 'Error al buscar el usuario',
            error: errorUsuario.message
        });
    }

    // Comprobamos si existe
    if (!usuario) {
        return res.status(404).json({
            mensaje: 'No se encontro el usuario'
        });
    }

    // Buscamos el codigo
    const { data: codigoEncontrado, error: errorCodigo } =
        await buscarCodigoRecuperacion(
            usuario.id_usuario,
            codigo
        );

    // Comprobamos error
    if (errorCodigo) {
        return res.status(500).json({
            mensaje: 'Error al verificar el codigo',
            error: errorCodigo.message
        });
    }

    // Comprobamos si el codigo es correcto
    if (!codigoEncontrado) {
        return res.status(400).json({
            mensaje: 'El codigo es incorrecto'
        });
    }

    // Protegemos la nueva contraseña
    const contrasenaSegura = await bcrypt.hash(contrasenaNueva, 10);

    // Actualizamos la contraseña
    const { error } = await cambiarContrasena(
            usuario.id_usuario,
            contrasenaSegura
        );

    // Comprobamos error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al cambiar la contraseña',
            error: error.message
        });
    }

    // Respondemos
    res.status(200).json({
        mensaje: 'Contraseña recuperada correctamente'
    });
};
// Actualizar foto de perfil
export const cambiarFotoUsuario = async (req, res) => {

    // Obtenemos el usuario desde el token
    const id_usuario = req.usuario.id_usuario;

    // Verificamos que se haya enviado una foto
    if (!req.file) {
        return res.status(400).json({
            error: 'Debes seleccionar una foto'
        });
    }

    // Cloudinary nos entrega la URL de la imagen
    const foto = req.file.path;

    // Actualizamos la foto en la base de datos
    const { data, error } = await actualizarFotoUsuario(
        id_usuario,
        foto
    );

    if (error) {
        return res.status(500).json({
            error: 'No se pudo actualizar la foto',
            detalle: error.message
        });
    }

    res.status(200).json({
        mensaje: 'Foto actualizada correctamente',
        usuario: data
    });
};