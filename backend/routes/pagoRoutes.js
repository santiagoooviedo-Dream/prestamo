// Importamos Express para crear las rutas
import express from 'express';

// Importamos las funciones del controlador de pagos
import {
    registrarPago,
    obtenerMisMovimientos,
    subirComprobante
} from '../controllers/pagoController.js';

// Importamos el middleware para verificar el token
import { verificarToken } from '../middleware/authMiddleware.js';

// Importamos multer/cloudinary para subir imágenes
import { upload } from '../config/cloudinary.js';

// Creamos el router
const router = express.Router();

router.get('/movimientos',
    verificarToken,
    obtenerMisMovimientos
);

// Subir comprobante Nequi (multipart field: comprobante)
router.post('/comprobante',
    verificarToken,
    upload.single('comprobante'),
    subirComprobante
// http://localhost:3000/pagos/comprobante  POST
// Header: Authorization Bearer <token>
// Body: form-data, key "comprobante" = archivo imagen
);

// Ruta para registrar un nuevo pago
router.post('/',
    verificarToken,
    registrarPago
// http://localhost:3000/pagos  POST
//
//    "id_prestamos": 1,
//    "id_cuota": 2,
//     "monto": 100000,
//     "metodo_pago": "transferencia"
//
// Esta ruta permite registrar un pago de un préstamo.
// El usuario debe iniciar sesión porque la ruta utiliza verificarToken.
);

// Exportamos el router para utilizarlo en index.js
export default router;
