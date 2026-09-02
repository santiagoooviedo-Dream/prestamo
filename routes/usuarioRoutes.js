//importamos express para crear las rutas
import express from 'express';
//importamos la funcion registrarUsuario del controller usuarioController
import { registrarUsuario, loginUsuario, cambiarContraseñaUsuario, cambiarCorreoUsuario, solicitarCodigoRecuperacion, verificarCodigoRecuperacion, recuperarContrasena, cambiarFotoUsuario } from '../controllers/usuarioController.js';
//importamos la funcion verificarToken del middleware authMiddleware
import { verificarToken } from '../middleware/authMiddleware.js';
//importamos la funcion upload del config cloudinary
import { upload } from '../config/cloudinary.js';
//creamos un router para las rutas de usuario
const router = express.Router();

//ruta para registrar un nuevo usuario
router.post('/registrar', registrarUsuario

//http://localhost:3000/usuarios/registrar  POST

//"nombre": ""
//"apellido": ""
//"correo": ""
//"telefono": ""
//"cedula": ""
//"contrasena" : ""

//se crea un nuevo usuario 
);

//ruta para iniciar sesion
router.post('/login', loginUsuario

//http://localhost:3000/usuarios/login  POST

//"correo":""
//"contrasena":""

//se inicia sesion y se devuelve un token tambien admin
);

//ruta para cambiar correo
router.put('/correo',
    verificarToken,
    cambiarCorreoUsuario

//http://localhost:3000/usuarios/correo         PUT

//"nuevoCorreo":""
//"contrasena":""

//ruta para cambiar correo electronico del usuario

)
//ruta para cambiar contraseña 
router.put('/contrasena',
    verificarToken,
    cambiarContraseñaUsuario

//http://localhost:3000/usuarios/contrasena     PUT
//"contrasenaActual": ""
//"contrasenaNueva": ""

//ruta para cambiar la contraseña del usuario
)

//ruta para solicitar codigo de recuperacion
router.post('/codigo',
    solicitarCodigoRecuperacion

//http://localhost:3000/usuarios/codigo POST

//"correo": ""
//ruta para solicitar un codigo de recuperacion de contraseña
);


//ruta para verificar codigo
router.post('/verificar',
    verificarCodigoRecuperacion
//http://localhost:3000/usuarios/verificar POST

//"correo" : "",
//"codigo": ""
//ruta para verificar el codigo de recuperacion
);

//ruta para cambiar contraseña mediante recuperacion
router.put('/recuperar',
    recuperarContrasena
//http://localhost:3000/usuarios/recuperar PUT
//"correo": "",
//"codigo": "",
//"contrasenaNueva": ""

//ruta para cambiar la contraseña del usuario mediante el codigo de recuperacion
);

router.put('/foto',
    verificarToken,
    upload.single('foto'),
    cambiarFotoUsuario
//http://localhost:3000/usuarios/foto PUT
//seleccionar en el body -> form-data
//"foto": archivo de imagen

);
//ruta protegida que requiere un token valido para acceder
router.get('/perfil', verificarToken, (req,res) => {
    res.json({
        mensaje: 'Token validado correctamente',
        usuario: req.usuario
    });
});

//exportamos el router para usarlo en index.js
export default router;