// Importamos Groq para poder utilizar la inteligencia artificial
import Groq from 'groq-sdk';

// Importamos Supabase para consultar y guardar informacion
import { supabase } from '../config/supabase.js';


// Creamos la conexion con Groq
const groq = new Groq({
    apiKey: process.env.GROQ_API_KEY
});


// Funcion para conversar con el chatbot
export const chatearConBot = async (req, res) => {

    try {

        // Obtenemos el id de la conversacion desde la URL
        const id_conversacion = req.params.id;

        // Obtenemos el usuario que inicio sesion
        const id_usuario = req.usuario.id_usuario;

        // Obtenemos el mensaje enviado
        const { mensaje } = req.body;


        // Verificamos que el usuario haya enviado un mensaje
        if (!mensaje || !mensaje.trim()) {

            return res.status(400).json({
                mensaje: 'Debes escribir un mensaje'
            });

        }


        // Buscamos la conversacion
        const { data: conversacion, error: errorConversacion } =
            await supabase
                .from('conversaciones')
                .select('*')
                .eq('id_conversacion', id_conversacion)
                .maybeSingle();


        // Si ocurrio un error
        if (errorConversacion) {

            return res.status(500).json({
                mensaje: 'Error al buscar la conversacion',
                error: errorConversacion.message
            });

        }


        // Si no existe la conversacion
        if (!conversacion) {

            return res.status(404).json({
                mensaje: 'No se encontro la conversacion'
            });

        }


        // Verificamos que la conversacion pertenezca al usuario
        if (conversacion.id_usuario !== id_usuario) {

            return res.status(403).json({
                mensaje: 'No tienes permiso para utilizar esta conversacion'
            });

        }


        // Verificamos que la conversacion siga utilizando el bot
        if (conversacion.modo !== 'bot') {

            return res.status(400).json({
                mensaje: 'Esta conversacion ya fue transferida a un administrador'
            });

        }


        // Guardamos primero el mensaje del usuario
        const { error: errorMensajeUsuario } = await supabase
            .from('mensajes')
            .insert({
                id_usuario: id_usuario,
                id_conversacion: id_conversacion,
                respuesta: mensaje.trim(),
                remitente: 'usuario'
            });


        // Si ocurrio un error guardando el mensaje
        if (errorMensajeUsuario) {

            return res.status(500).json({
                mensaje: 'Error al guardar el mensaje',
                error: errorMensajeUsuario.message
            });

        }


        // Obtenemos los mensajes anteriores de la conversacion
        const { data: historial, error: errorHistorial } =
            await supabase
                .from('mensajes')
                .select('respuesta, remitente, fecha')
                .eq('id_conversacion', id_conversacion)
                .order('fecha', { ascending: true });


        // Verificamos si ocurrio un error
        if (errorHistorial) {

            return res.status(500).json({
                mensaje: 'Error al consultar el historial',
                error: errorHistorial.message
            });

        }


        // Convertimos nuestro historial al formato que entiende Groq
        const mensajesHistorial = historial.map((mensaje) => {

            if (mensaje.remitente === 'usuario') {

                return {
                    role: 'user',
                    content: mensaje.respuesta
                };

            }

            return {
                role: 'assistant',
                content: mensaje.respuesta
            };

        });


        // Instrucciones que tendrá nuestro chatbot
        const systemPrompt = `
                                Eres el asistente virtual de una aplicación de préstamos.
                                responde de manera amistosa y clara, y proporciona información útil a los usuarios.

Tu función es ayudar a los usuarios con preguntas relacionadas con:

- Solicitudes de préstamos.
- Estado de una solicitud.
- Pagos.
- Cuotas.
- Fechas de pago.
- Información general sobre los préstamos.
- Funcionamiento de la aplicación.

Responde de manera clara, sencilla y amable.

No inventes información sobre préstamos, pagos o solicitudes
que no tengas disponible.

Si el usuario necesita realizar una acción que solamente
puede hacer un administrador, indícale que puede solicitar
la atención de un administrador.

No afirmes que realizaste una acción si realmente no la hiciste.

Si el usuario solicita hablar con una persona,
indícale que puede solicitar la transferencia a un administrador.
`
;


        // Enviamos el historial a Groq
        const completion = await groq.chat.completions.create({

            model: 'openai/gpt-oss-20b',

            messages: [
                {
                    role: 'system',
                    content: systemPrompt
                },

                ...mensajesHistorial
            ],

            temperature: 0.3,

            max_tokens: 500

        });


        // Obtenemos la respuesta de Groq
        const respuestaTexto =
            completion.choices[0]?.message?.content ||
            'No pude generar una respuesta.';


        // Guardamos la respuesta del bot en nuestra tabla mensajes
        const { data: mensajeBot, error: errorMensajeBot } =
            await supabase
                .from('mensajes')
                .insert({
                    id_usuario: id_usuario,
                    id_conversacion: id_conversacion,
                    respuesta: respuestaTexto,
                    remitente: 'bot'
                })
                .select()
                .single();


        // Verificamos si ocurrio un error
        if (errorMensajeBot) {

            return res.status(500).json({
                mensaje: 'El bot respondio pero no se pudo guardar la respuesta',
                error: errorMensajeBot.message
            });

        }


        // Enviamos la respuesta al frontend
        return res.status(200).json({

            mensaje: 'Respuesta generada correctamente',

            respuesta: respuestaTexto,

            mensajeBot: mensajeBot

        });

    } catch (error) {

        // Mostramos el error en la terminal
        console.error('Error en chatbot:', error);

        return res.status(500).json({

            mensaje: 'Error al procesar la respuesta del chatbot',

            error: error.message

        });

    }

};
//funcion para tranferir la conversacion a un administrador
export const transferirAAdmin = async (req, res) => {

    try {
        //obtenemos el id de la conversacion
        const id_conversacion = req.params.id;

        //obtenemos el usuario que incio sesion 
        const id_usuario = req.usuario.id_usuario;

        //buscamos la conversacion 
        const { data: conversacion , error: errorConversacion } = await supabase
            .from('conversaciones')
            .select('*')
            .eq('id_conversacion', id_conversacion)
            .maybeSingle();

        //si ocurre ub errir 
        if (errorConversacion) {
            return res.status(500).json({
                mensaje: 'Error al buscar la conversacion',
                error: errorConversacion.message
            });
        }

        //si no existe
        if (!conversacion) {
            return res.status(404).json({
                mensaje: 'Conversacion no encontrada'
            });
        }

        //verificamos que sea dueño la conversacion
        if (conversacion.id_usuario !== id_usuario) {
            return res.status(403).json({
                mensaje: 'No tienes permiso para transferir esta conversacion'
            });
        }

        //cambiamos el modo de bot a administrador
        const {data, error } = await supabase
            .from('conversaciones')
            .update({
                modo: 'admin'
            })
            .eq('id_conversacion', id_conversacion)
            .select()
            .single();

        //verificamos si ocurre un error
        if (error) {

            return res.status(500).json({
                mensaje: 'Error al transferir la conversacion',
                error: error.message
            });
        }

        //respondemos al usuario
        return res.status(200).json({
            mensaje: 'Conversacion transferida a un administrador correctamente',
            conversacion: data
        });

    } catch (error) {

        console.error('Error al transferir la conversacion a un administrador:', error);

        return res.status(500).json({
            mensaje: 'Error al transferir la conversacion a un administrador',
            error: error.message
        });
    }
};