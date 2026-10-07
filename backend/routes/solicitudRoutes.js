//importamos express para crear las rutas
import express from 'express';

//importamos las funciones del controlador solicitudController
import { crearSolicitud, obtenerSolicitudes, obtenerSolicitudesAdmin, actualizarEstadoSolicitud } from '../controllers/solicitudController.js';

//importamos las funciones del middleware authMiddleware
import { verificarToken, verificarAdmin } from '../middleware/authMiddleware.js';

//creamos un router para las rutas de solicitudes
const router = express.Router();

//ruta para crear una nueva solicitud de prestamo
router.post('/',
    verificarToken,
    crearSolicitud

//http://localhost:3000/solicitudes/  POST

//"monto_solicitado": 0
//"coutas": 0
//"motivo": ""

//se crea una nueva solicitud de prestamo
);

//ruta para consultar las solicitudes del usuario
router.get('/',
    verificarToken,
    obtenerSolicitudes

//http://localhost:3000/solicitudes/  GET

//no necesita datos en el body

//se obtienen las solicitudes realizadas por el usuario que inicio sesion
);

//ruta para consultar todas las solicitudes como administrador
router.get('/admin',
    verificarToken,
    verificarAdmin,
    obtenerSolicitudesAdmin

//http://localhost:3000/solicitudes/admin  GET

//no necesita datos en el body

//se obtienen todas las solicitudes registradas para que el administrador pueda revisarlas
);

//ruta para aceptar o rechazar una solicitud
router.patch('/:id',
    verificarToken,
    verificarAdmin,
    actualizarEstadoSolicitud

//http://localhost:3000/solicitudes/:id  PATCH

//"estado": "aceptada"
//o
//"estado": "rechazada"

//se actualiza el estado de una solicitud como administrador
);

//exportamos el router para usarlo en index.js
export default router;

