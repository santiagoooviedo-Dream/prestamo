// Importamos Express
import express from 'express';

// Importamos las funciones del controlador de notificaciones
import { crearNotificacionController, obtenerNotificaciones, marcarNotificacionLeida } from '../controllers/notificacionController.js';

// Importamos el middleware de autenticación
import { verificarToken } from '../middleware/authMiddleware.js';

// Creamos el router
const router = express.Router();


// Crear una notificación
router.post('/',
    verificarToken,
    crearNotificacionController
//http://localhost:3000/notificaciones  POST
//Esta ruta necesita un token de autenticación
//En el body se deben enviar los datos de la notificación
//Body -> raw -> JSON
//
//{
//    "id_usuario": 7,
//    "mensaje": "Tu solicitud fue aceptada",
//    "tipo": "info"
//}
//
//id_usuario -> ID del usuario que recibirá la notificación
//mensaje -> Mensaje que tendrá la notificación
//tipo -> Tipo de notificación, por ejemplo: info
//
//La notificación se crea con:
//leida: false
//El campo fecha se genera automáticamente en la base de datos
);


// Obtener las notificaciones del usuario
router.get('/',
    verificarToken,
    obtenerNotificaciones
//http://localhost:3000/notificaciones  GET
//Esta ruta necesita un token de autenticación
//Obtiene las notificaciones del usuario que está autenticado
);


// Marcar una notificación como leída
router.put('/:id',
    verificarToken,
    marcarNotificacionLeida
//http://localhost:3000/notificaciones/:id  PUT
//Esta ruta necesita un token de autenticación
//El :id corresponde al id_notificacion que queremos marcar como leída
);


// Exportamos el router
export default router;