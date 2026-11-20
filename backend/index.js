//importamos express
import express from 'express';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

//importamos la configuracion de supabase
import { supabase } from './config/supabase.js';

//importamos las rutas de usuario
import usuarioRoutes from './routes/usuarioRoutes.js';

//importamos las rutas de solicitud
import solicitudRoutes from './routes/solicitudRoutes.js';

//importamos las rutas de prestamo
import prestamoRoutes from './routes/prestamoRoutes.js';

//importamos las rutas de pago
import pagoRoutes from './routes/pagoRoutes.js';

//importamos las rutas de notificacion
import notificacionRoutes from './routes/notificacionRoutes.js';

//importamos las ruta de conversaciones
import conversacionRoutes from './routes/conversacionRoutes.js'

//creamos una instancia de express
const app = express();

app.use(cors());

//permite recibir datos en formato JSON
app.use(express.json());

//agregamos las rutas de usuario al servidor
app.use('/usuarios', usuarioRoutes);

//agregamos las rutas de solicitudes
app.use('/solicitudes', solicitudRoutes);

//agregamos las rutas de prestamos
app.use('/prestamos', prestamoRoutes);

//agregamos las rutas de pagos
app.use('/pagos', pagoRoutes);

//agregamos las rutas de notificaciones
app.use('/notificaciones', notificacionRoutes);

//agregamos las ruta de conversaciones
app.use('/conversaciones',conversacionRoutes)

// Montando las rutas de la API

// Politica de privacidad publica (Play Store)
app.get('/privacidad', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'privacidad.html'));
});

//politicas de eliminacion de cuenta (Play Store)
app.get('/eliminar-cuenta', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'eliminar-cuenta.html'));
});

app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

//ruta principal para comprobar que el backend funciona
app.get('/', (req, res) => {
    res.json({
        mensaje: 'Backend funcionando correctamente'
    });
});

//ruta temporal para consultar los usuarios
app.get('/usuarios', async (req, res) => {

    const { data, error } = await supabase
        .from('usuarios')
        .select('*');

    //si ocurre un error
    if (error) {
        return res.status(500).json({
            error: error.message
        });
    }

    //enviamos los usuarios
res.json(data);
});

//obtenemos el puerto desde .env
const PORT = process.env.PORT || 3000;

//iniciamos el servidor
app.listen(PORT, () => {
    console.log(`Servidor funcionando en http://localhost:${PORT}`);
});
// https://jlombanar.github.io/adso_3169657/

