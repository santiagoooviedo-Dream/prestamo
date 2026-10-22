import { BrevoClient } from '@getbrevo/brevo';

const brevo = new BrevoClient({ apiKey: process.env.BREVO_API_KEY });

const escaparHtml = (valor = '') => String(valor)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');

const formatoFechaDesembolso = (fecha) => new Intl.DateTimeFormat('es-CO', {
    dateStyle: 'full',
    timeStyle: 'short',
    timeZone: 'America/Bogota'
}).format(new Date(fecha));

const enviarCorreoPrestamo = async (correo, asunto, contenido) => {
    try {
        await brevo.transactionalEmails.sendTransacEmail({
            subject: asunto,
            sender: {
                name: process.env.EMAIL_FROM_NAME || 'Prestamo Amigo',
                email: process.env.EMAIL_USER
            },
            to: [{ email: correo }],
            htmlContent: contenido
        });
        return { enviado: true };
    } catch (error) {
        console.error(`No se pudo enviar el correo "${asunto}":`, error);
        return { enviado: false, error: error.message };
    }
};

export const enviarConfirmacionSolicitud = async (correo, nombre, solicitud) => {
    const metodo = solicitud.metodo_desembolso === 'nequi' ? 'Transferencia a Nequi' : 'Entrega en efectivo';
    const destino = solicitud.metodo_desembolso === 'nequi'
        ? `Número Nequi: ${escaparHtml(solicitud.telefono_nequi)}`
        : 'El punto y la fecha de recogida se confirmarán cuando se apruebe la solicitud.';
    const fecha = new Intl.DateTimeFormat('es-CO', {
        dateStyle: 'full',
        timeStyle: 'short',
        timeZone: 'America/Bogota'
    }).format(new Date(solicitud.created_at || Date.now()));

    return enviarCorreoPrestamo(
        correo,
        `Recibimos tu solicitud de préstamo #${solicitud.id_solicitud}`,
        `<div style="font-family:Arial,sans-serif;max-width:600px;margin:auto;color:#17243C">
          <h2>Solicitud recibida</h2>
          <p>Hola ${escaparHtml(nombre)}, registramos tu solicitud correctamente.</p>
          <ul>
            <li><strong>Número:</strong> ${escaparHtml(solicitud.id_solicitud)}</li>
            <li><strong>Monto solicitado:</strong> $${Number(solicitud.monto_solicitado).toLocaleString('es-CO')} COP</li>
            <li><strong>Cuotas:</strong> ${escaparHtml(solicitud.coutas)} mensuales</li>
            <li><strong>Motivo:</strong> ${escaparHtml(solicitud.motivo)}</li>
            <li><strong>Desembolso elegido:</strong> ${metodo}</li>
            <li><strong>Destino:</strong> ${destino}</li>
            <li><strong>Fecha de solicitud:</strong> ${escaparHtml(fecha)}</li>
            <li><strong>Estado:</strong> En revisión</li>
          </ul>
          <p>Te enviaremos otro correo y una notificación cuando se tome una decisión. Si se aprueba, allí encontrarás la fecha, la hora y el punto de recogida o el número al que se enviará el dinero.</p>
        </div>`
    );
};

export const enviarResultadoSolicitud = async (correo, nombre, solicitud) => {
    const aprobada = solicitud.estado === 'aceptada';
    const detalleDesembolso = aprobada
        ? solicitud.metodo_desembolso === 'nequi'
            ? `<p><strong>Desembolso:</strong> Transferencia a Nequi</p>
               <p><strong>Número de destino:</strong> ${escaparHtml(solicitud.telefono_nequi)}</p>`
            : `<p><strong>Desembolso:</strong> Recogida en efectivo</p>
               <p><strong>Punto de recogida:</strong> ${escaparHtml(solicitud.lugar_recogida)}</p>`
        : '';
    const fecha = aprobada ? escaparHtml(formatoFechaDesembolso(solicitud.fecha_desembolso)) : '';
    const estado = aprobada ? 'fue aprobada' : 'no fue aprobada';

    return enviarCorreoPrestamo(
        correo,
        `Actualización de tu solicitud de préstamo #${solicitud.id_solicitud}`,
        `<div style="font-family:Arial,sans-serif;max-width:600px;margin:auto;color:#17243C">
          <h2>Actualización de tu solicitud</h2>
          <p>Hola ${escaparHtml(nombre)}, tu solicitud de préstamo #${escaparHtml(solicitud.id_solicitud)} ${estado}.</p>
          <p><strong>Monto:</strong> $${Number(solicitud.monto_solicitado).toLocaleString('es-CO')} COP</p>
          <p><strong>Cuotas:</strong> ${escaparHtml(solicitud.coutas)} mensuales</p>
          ${aprobada ? `<p><strong>Fecha y hora programadas:</strong> ${fecha} (hora de Colombia)</p>${detalleDesembolso}` : '<p>Si necesitas más información, comunícate con nuestro equipo de atención.</p>'}
          <p>Este mensaje confirma el resultado de la solicitud. No compartas claves ni códigos de verificación.</p>
        </div>`
    );
};

export const enviarCodigoRecuperacion = async (correo, codigo) => {

    try {
        await brevo.transactionalEmails.sendTransacEmail({
            subject: 'Codigo para recuperar tu contraseña',

            sender: {
                name: process.env.EMAIL_FROM_NAME || 'Prestamo Amigo',
                email: process.env.EMAIL_USER
            },

            to: [
                {
                    email: correo
                }
            ],

            htmlContent: `
                <h2>Recuperacion de contraseña</h2>

                <p>Hola, recibimos una solicitud para recuperar tu contraseña.</p>

                <p>Tu codigo de recuperacion es:</p>

                <h1>${codigo}</h1>

                <p>Este codigo sera utilizado para cambiar tu contraseña.</p>
            `
        });

        console.log('Correo de recuperacion enviado con exito');

        return {
            success: true
        };

    } catch (error) {

        console.error('Error al enviar correo:', error);

        return {
            success: false,
            error: error.message
        };
    }
};

// CORREO PARA VERIFICAR REGISTRO

// Funcion para enviar codigo de verificacion
export const enviarCodigoVerificacion = async (emailDestino,nombreDestino,codigo ) => {
    try {

        // Creamos el cliente de Brevo
        const brevo = new BrevoClient({
            apiKey: process.env.BREVO_API_KEY
        });

        // Enviamos el correo
        const result =
            await brevo.transactionalEmails.sendTransacEmail({
                // Asunto
                subject: 'Codigo de verificacion - Prestamos',
                // Persona que envia
                sender: {
                    name: process.env.EMAIL_FROM_NAME || 'Prestamos',
                    email: process.env.EMAIL_USER
                },

                // Persona que recibe
                to: [
                    {
                        email: emailDestino,
                        name: nombreDestino
                    }
                ],

                // Diseño del correo
                htmlContent: `
        <div style="font-family: Arial, sans-serif; max-width: 500px; margin: 0 auto; padding: 24px; border: 1px solid #f0e6e6; border-radius: 12px; background-color: #ffffff;">
          <h2 style="color: #d81b60; text-align: center; margin-bottom: 8px;">Prestamo Amigo</h2>
          <h3 style="color: #333333; text-align: center; margin-top: 0;">Verifica tu cuenta</h3>

          <p style="color: #555555; font-size: 15px;">Hola <strong>${nombreDestino}</strong>,</p>
          <p style="color: #555555; font-size: 15px;">Gracias por unirte a Prestamo Amigo. Usa el siguiente codigo de verificacion de 6 digitos para activar tu cuenta. Este codigo vencera en <strong>15 minutos</strong>:</p>

          <div style="text-align: center; margin: 30px 0;">
            <span style="font-size: 32px; font-weight: bold; letter-spacing: 6px; color: #d81b60; background: #fdf2f4; padding: 12px 24px; border-radius: 8px; border: 1px dashed #d81b60; display: inline-block;">
              ${codigo}
            </span>
          </div>

          <p style="color: #888888; font-size: 12px; text-align: center; margin-top: 30px;">
            Si no creaste una cuenta en Prestamo Amigo, puedes ignorar este correo.
          </p>
        </div>
      `
            });

        console.log('Correo de verificación enviado con éxito');

        return {
            exito: true,
            result: result
        };

    } catch (error) {

        return {
            exito: false,
            error: {
                nombre: error.name,
                mensaje: error.message,
                codigo: error.statusCode,
                respuesta: error.body
            }
        };
    }
};
