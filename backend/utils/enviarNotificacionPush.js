import { supabase } from '../config/supabase.js';
import { mensajeriaFirebase } from '../config/firebaseMessaging.js';
import { eliminarInstalacionesNotificaciones } from '../models/usuarioModel.js';

export const enviarNotificacionPush = async (notificacion) => {
    if (!mensajeriaFirebase) return;

    const { data: usuario, error: errorUsuario } = await supabase
        .from('usuarios')
        .select('fcm_installation_ids')
        .eq('id_usuario', notificacion.id_usuario)
        .maybeSingle();

    if (errorUsuario) {
        throw new Error(`No se pudieron consultar los dispositivos: ${errorUsuario.message}`);
    }

    const instalaciones = Array.isArray(usuario?.fcm_installation_ids)
        ? [...new Set(usuario.fcm_installation_ids.filter((fid) => typeof fid === 'string'))]
        : [];
    if (instalaciones.length === 0) return;

    const baseMensaje = {
        notification: {
            title: 'Préstamo Amigo',
            body: notificacion.mensaje
        },
        data: {
            notificationId: String(notificacion.id_notificacion ?? ''),
            type: String(notificacion.tipo ?? 'info')
        },
        android: {
            priority: 'high',
            notification: {
                channelId: 'prestamo_notificaciones',
                sound: 'default'
            }
        },
        apns: {
            payload: {
                aps: { sound: 'default' }
            }
        }
    };
    const resultado = await mensajeriaFirebase.sendEach(
        instalaciones.map((fid) => ({ ...baseMensaje, fid }))
    );

    const instalacionesInvalidas = [];
    const erroresEnvio = [];
    resultado.responses.forEach((respuesta, indice) => {
        if (respuesta.success) return;
        const codigo = respuesta.error?.code ?? 'unknown';
        if (codigo === 'messaging/registration-token-not-registered') {
            instalacionesInvalidas.push(instalaciones[indice]);
        } else {
            erroresEnvio.push(codigo);
        }
    });

    if (instalacionesInvalidas.length > 0) {
        const { error } = await eliminarInstalacionesNotificaciones(
            notificacion.id_usuario,
            instalacionesInvalidas
        );
        if (error) {
            throw new Error(`No se pudieron limpiar instalaciones vencidas: ${error.message}`);
        }
    }

    if (erroresEnvio.length > 0) {
        throw new Error(`Firebase no pudo enviar algunos avisos: ${erroresEnvio.join(', ')}`);
    }
};
