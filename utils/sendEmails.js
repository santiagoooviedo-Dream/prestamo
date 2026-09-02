// Importamos nodemailer
import nodemailer from 'nodemailer';
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