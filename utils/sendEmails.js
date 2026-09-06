// Importamos nodemailer
import nodemailer from 'nodemailer';

// Importamos Brevo
import { BrevoClient } from '@getbrevo/brevo';

// CORREO PARA RECUPERAR CONTRASEÑA

// Creamos el transporte para Gmail
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});


// Funcion para enviar el codigo de recuperacion
export const enviarCodigoRecuperacion = async (correo, codigo) => {

    const mailOptions = {
        from: process.env.EMAIL_USER,
        to: correo,
        subject: 'Codigo para recuperar tu contraseña',

        html: `
            <h2>Recuperacion de contraseña</h2>

            <p>Hola, recibimos una solicitud para recuperar tu contraseña.</p>

            <p>Tu codigo de recuperacion es:</p>

            <h1>${codigo}</h1>

            <p>Este codigo sera utilizado para cambiar tu contraseña.</p>
        `
    };
    try {

        await transporter.sendMail(mailOptions);

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
export const enviarCodigoVerificacion = async (
    emailDestino,
    nombreDestino,
    codigo
) => {
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
}