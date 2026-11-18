import test from 'node:test';
import assert from 'node:assert/strict';

process.env.SUPABASE_URL = 'http://127.0.0.1:54321';
process.env.SUPABASE_KEY = 'test-key';

const { supabase } = await import('../config/supabase.js');
const { eliminarCuentaUsuario } = await import('../controllers/usuarioController.js');

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

test('elimina solo la cuenta identificada por el token', async () => {
    let idEliminado;
    const originalFrom = supabase.from;
    supabase.from = (tabla) => {
        assert.equal(tabla, 'usuarios');
        return {
            delete() {
                return this;
            },
            eq(campo, id) {
                assert.equal(campo, 'id_usuario');
                idEliminado = id;
                return this;
            },
            select() {
                return this;
            },
            maybeSingle() {
                return Promise.resolve({
                    data: { id_usuario: idEliminado },
                    error: null
                });
            }
        };
    };

    try {
        const respuesta = crearRespuesta();
        await eliminarCuentaUsuario(
            { usuario: { id_usuario: 42 } },
            respuesta
        );

        assert.equal(idEliminado, 42);
        assert.equal(respuesta.codigoEstado, 200);
        assert.equal(respuesta.cuerpo.mensaje, 'La cuenta fue eliminada correctamente');
    } finally {
        supabase.from = originalFrom;
    }
});

test('informa si la cuenta tiene registros relacionados', async () => {
    const originalFrom = supabase.from;
    supabase.from = () => ({
        delete() {
            return this;
        },
        eq() {
            return this;
        },
        select() {
            return this;
        },
        maybeSingle() {
            return Promise.resolve({
                data: null,
                error: { code: '23503', message: 'foreign key constraint' }
            });
        }
    });

    try {
        const respuesta = crearRespuesta();
        await eliminarCuentaUsuario(
            { usuario: { id_usuario: 42 } },
            respuesta
        );

        assert.equal(respuesta.codigoEstado, 409);
        assert.match(respuesta.cuerpo.mensaje, /información relacionada/);
    } finally {
        supabase.from = originalFrom;
    }
});
