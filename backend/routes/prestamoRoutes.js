//importamos express para crear las rutas
import express from 'express';

//importamos las funciones del controlador de prestamos
import { crearPrestamo, crearCuotas } from '../controllers/prestamoController.js';

//importamos los middleware de autenticacion
import { verificarToken, verificarAdmin } from '../middleware/authMiddleware.js';

//creamos el router para las rutas de prestamos
const router = express.Router();


//crear un prestamo a partir de una solicitud aceptada
router.post('/:id',
    verificarToken,
    verificarAdmin,
    crearPrestamo
//http://localhost:3000/prestamos/:id POST
//el id corresponde al id_solicitud
//la solicitud debe tener estado "aceptada"
//solo un administrador puede crear el prestamo
);


//crear las cuotas de un prestamo
router.post('/:id/cuotas',
    verificarToken,
    verificarAdmin,
    crearCuotas
//http://localhost:3000/prestamos/:id/cuotas POST
//el id corresponde al id_prestamo
//solo un administrador puede crear las cuotas
);


//exportamos el router para utilizarlo en index.js
export default router;

