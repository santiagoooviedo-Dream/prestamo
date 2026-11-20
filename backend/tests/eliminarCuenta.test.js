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

test('eliminación bloqueada no se presenta como si hubiera eliminado la cuenta', async () => {
    const originalRpc = supabase.rpc;
    let llamadas = 0;
    supabase.rpc = async (nombre, parametros) => {
        llamadas++;
        assert.equal(nombre, 'eliminar_cuenta_usuario');
        assert.deepEqual(parametros, { p_id_usuario: 7 });
        return {
            data: null,
            error: { code: '23503', message: 'foreign key constraint' }
        };
    };

    try {
        const respuesta = crearRespuesta();
        await eliminarCuentaUsuario(
            { usuario: { id_usuario: 7 } },
            respuesta
        );

        assert.equal(llamadas, 1);
        assert.equal(respuesta.codigoEstado, 409);
        assert.match(respuesta.cuerpo.mensaje, /información relacionada/);
    } finally {
        supabase.rpc = originalRpc;
    }
});

test('una segunda solicitud después de borrar la cuenta responde como éxito idempotente', async () => {
    const originalRpc = supabase.rpc;
    supabase.rpc = async () => ({ data: false, error: null });

    try {
        const respuesta = crearRespuesta();
        await eliminarCuentaUsuario(
            { usuario: { id_usuario: 7 } },
            respuesta
        );

        assert.equal(respuesta.codigoEstado, 200);
        assert.equal(respuesta.cuerpo.mensaje, 'La cuenta ya no existe');
    } finally {
        supabase.rpc = originalRpc;
    }
});
