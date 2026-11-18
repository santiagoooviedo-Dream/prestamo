import test from 'node:test';
import assert from 'node:assert/strict';

process.env.SUPABASE_URL = 'http://127.0.0.1:54321';
process.env.SUPABASE_KEY = 'test-key';

const { supabase } = await import('../config/supabase.js');
const {
    guardarInstalacionDispositivo,
    eliminarInstalacionDispositivo
} = await import('../controllers/notificacionController.js');

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

test('registra y quita el FID push en la cuenta autenticada', async () => {
    let instalaciones = ['fid-existente'];
    const originalFrom = supabase.from;

    supabase.from = (tabla) => {
        assert.equal(tabla, 'usuarios');
        return {
            select() {
                return this;
            },
            eq(campo, idUsuario) {
                assert.equal(campo, 'id_usuario');
                assert.equal(idUsuario, 7);
                return this;
            },
            update(datos) {
                instalaciones = datos.fcm_installation_ids;
                return this;
            },
            maybeSingle() {
                return Promise.resolve({
                    data: { id_usuario: 7, fcm_installation_ids: instalaciones },
                    error: null
                });
            }
        };
    };

    try {
        const respuestaRegistro = crearRespuesta();
        await guardarInstalacionDispositivo(
            { usuario: { id_usuario: 7 }, body: { fid: 'fid-nuevo' } },
            respuestaRegistro
        );
        assert.equal(respuestaRegistro.codigoEstado, 200);
        assert.deepEqual(instalaciones, ['fid-existente', 'fid-nuevo']);

        const respuestaEliminacion = crearRespuesta();
        await eliminarInstalacionDispositivo(
            { usuario: { id_usuario: 7 }, body: { fid: 'fid-nuevo' } },
            respuestaEliminacion
        );
        assert.equal(respuestaEliminacion.codigoEstado, 200);
        assert.deepEqual(instalaciones, ['fid-existente']);
    } finally {
        supabase.from = originalFrom;
    }
});

test('rechaza identificadores de instalación vacíos', async () => {
    const respuesta = crearRespuesta();
    await guardarInstalacionDispositivo(
        { usuario: { id_usuario: 7 }, body: { fid: ' ' } },
        respuesta
    );

    assert.equal(respuesta.codigoEstado, 400);
});
