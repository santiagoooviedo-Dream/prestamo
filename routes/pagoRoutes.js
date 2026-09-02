// Importamos Express para crear las rutas
import express from 'express';

// Importamos la función registrarPago del controlador de pagos
import { registrarPago } from '../controllers/pagoController.js';

// Importamos el middleware para verificar el token
import { verificarToken } from '../middleware/authMiddleware.js';

// Creamos el router
const router = express.Router();

// Ruta para registrar un nuevo pago
router.post('/',
    verificarToken,
    registrarPago
// http://localhost:3000/pagos  POST

// Datos que debemos enviar en el body:
//
//    "id_prestamos": 1,
//    "id_cuota": 2,
//     "monto": 100000,
//     "metodo_pago": "transferencia

// Esta ruta permite registrar un pago de un préstamo.
// El usuario debe iniciar sesión porque la ruta utiliza verificarToken.

);

// Exportamos el router para utilizarlo en index.js
export default router;

