// Importamos Express
import express from 'express';
// Importamos las funciones del controlador
import { crearConversacion, obtenerMisConversaciones, obtenerConversacionesAdmin, enviarMensaje, obtenerMensajes, cerrarConversacion } from '../controllers/conversacionController.js';
// Importamos el middleware
import { verificarToken, verificarAdmin } from '../middleware/authMiddleware.js';


// Creamos el router
const router = express.Router();

// Crear una nueva conversacion

router.post('/',
    verificarToken,
    crearConversacion
);

// http://localhost:3000/conversaciones  POST
// No se envian datos en el body
// El id_usuario se obtiene automaticamente desde el token
// Esta ruta crea una nueva conversacion para el usuario
// Obtener las conversaciones del usuario

router.get('/',
    verificarToken,
    obtenerMisConversaciones

);

// http://localhost:3000/conversaciones  GET
// No se envian datos
// El usuario se obtiene desde el token
// Esta ruta muestra las conversaciones del usuario que inicio sesion
// Obtener todas las conversaciones como administrador

router.get('/admin',
    verificarToken,
    verificarAdmin,
    obtenerConversacionesAdmin
);

// http://localhost:3000/conversaciones/admin  GET
// No se envian datos
// Requiere un token de administrador
// Esta ruta permite al administrador consultar todas las conversaciones
// Enviar un mensaje dentro de una conversacion

router.post('/:id/mensajes',
    verificarToken,
    enviarMensaje
);
// http://localhost:3000/conversaciones/1/mensajes  POST
// :id = id_conversacion
// Body:
// {
//     "respuesta": "Hola, necesito ayuda con mi prestamo"
// }
// El usuario o administrador puede enviar un mensaje
// El id del usuario se obtiene desde el token
// Obtener los mensajes de una conversacion

router.get('/:id/mensajes',
    verificarToken,
    obtenerMensajes
);

// http://localhost:3000/conversaciones/1/mensajes  GET
// :id = id_conversacion
// No se envia body
// Esta ruta muestra todos los mensajes de la conversacion
// Solo puede verla el usuario dueño de la conversacion o un administrador
// Cerrar una conversacion

router.put('/:id/cerrar',
    verificarToken,
    cerrarConversacion

);

// http://localhost:3000/conversaciones/1/cerrar  PUT
// :id = id_conversacion
// No se envia body
// Esta ruta cambia el estado de la conversacion a "cerrada"

// Exportamos el router

export default router;

