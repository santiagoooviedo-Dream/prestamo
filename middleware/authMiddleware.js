//importamos el jsonwebtoken para generar el token
import jwt from 'jsonwebtoken';

//funcion que verifica el token 
export const verificarToken = (req,res,next) => {

    //Buscamos el token que envia el usuario
    const autorizacion = req.headers.authorization;

    //si no ahi token enviamos un error 
    if (!autorizacion) {
        return res.status(401).json({
            error: 'No tienes el autorizacion'
        });
    }
    //separar el "barrer" del token
    const token = autorizacion.split(' ')[1];

    try {
        //verificamos si el token es valido
        const usuario = jwt.verify(
            token, 
            process.env.JWT_SECRET
        );
        //guardamos la informacion del usuario
        req.usuario = usuario;
        //continuamos con la peticion
        next();
    } catch (error) {
        //si el token no es valido enviamos un error
        return res.status(401).json({
            mensaje:'El token es invalido o ha expirado',
            error: error.message
        })
    }
}

//funcion que verifica si el usuario es el administrador 
export const verificarAdmin = (req, res, next ) => {

    //revisamos el rol que viene dentro del token
    if (req.usuario.rol !== 'admin') {
        return res.status(403).json({
            mensaje: 'No tienes permiso de administrador'
        })
    }
    //si es administrador continua 
    next();
}