import test from 'node:test';
import assert from 'node:assert/strict';

process.env.SUPABASE_URL = 'http://127.0.0.1:54321';
process.env.SUPABASE_KEY = 'test-key';

const { supabase } = await import('../config/supabase.js');
const { verificarRegistro } = await import('../controllers/usuarioController.js');

test('solo crea el usuario después de validar el código de correo', async () => {
    const registroPendiente = {
        correo: 'persona@example.com',
        nombre: 'Persona',
        apellido: 'Prueba',
        telefono: '3001234567',
        cedula: '12345678',
        contrasena: 'hash',
        codigo_verificacion: '123456',
        codigo_verificacion_expiracion: new Date(Date.now() + 60_000).toISOString()
    };
    const usuarioCreado = {
        id_usuario: 1,
        nombre: 'Persona',
        apellido: 'Prueba',
        correo: 'persona@example.com',
        cedula: '12345678',
        isVerified: true
    };
    let inserciones = 0;
    const originalFrom = supabase.from;

    supabase.from = (tabla) => {
        const consulta = {
            select() {
                return this;
            },
            eq() {
                return this;
            },
            maybeSingle() {
                return Promise.resolve({
                    data: tabla === 'registros_pendientes' ? registroPendiente : null,
                    error: null
                });
            },
            insert() {
                inserciones++;
                return this;
            },
            single() {
                return Promise.resolve({ data: usuarioCreado, error: null });
            },
            delete() {
                return this;
            },
            then(resolve, reject) {
                return Promise.resolve({ error: null }).then(resolve, reject);
            }
        };
        return consulta;
    };

    const crearRespuesta = () => ({
        codigoEstado: null,
        cuerpo: null,
        status(codigo) {
            this.codigoEstado = codigo;
            return this;
        },
        json(cuerpo) {
            this.cuerpo = cuerpo;
            return this;
        }
    });

    try {
        const respuestaCodigoIncorrecto = crearRespuesta();
        await verificarRegistro(
            { body: { correo: registroPendiente.correo, codigo: '000000' } },
            respuestaCodigoIncorrecto
        );
        assert.equal(respuestaCodigoIncorrecto.codigoEstado, 400);
        assert.equal(inserciones, 0);

        const respuestaCodigoCorrecto = crearRespuesta();
        await verificarRegistro(
            { body: { correo: registroPendiente.correo, codigo: '123456' } },
            respuestaCodigoCorrecto
        );
        assert.equal(respuestaCodigoCorrecto.codigoEstado, 200);
        assert.equal(inserciones, 1);
    } finally {
        supabase.from = originalFrom;
    }
});
