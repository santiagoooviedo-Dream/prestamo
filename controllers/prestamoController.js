
//importamos las funciones del modelo

import { buscarSolicitudPorId,crearPrestamoModel,buscarPrestamoPorId,crearCuotasModel} from "../models/prestamoModel.js";


// Funcion para crear un prestamo a partir de una solicitud aceptada
export const crearPrestamo = async (req, res) => {

    // Obtenemos el ID de la solicitud desde la URL
    const id_solicitud = req.params.id;

    // Buscamos la solicitud
    const { data: solicitud, error: errorSolicitud } =
        await buscarSolicitudPorId(id_solicitud);

    // Si ocurre un error al buscar la solicitud
    if (errorSolicitud) {
        return res.status(404).json({
            mensaje: 'No se encontro la solicitud',
            error: errorSolicitud.message
        });
    }

    // Verificamos que la solicitud sea aceptada
    if (solicitud.estado !== 'aceptada') {
        return res.status(400).json({
            mensaje: 'La solicitud debe estar aceptada para crear el prestamo'
        });
    }

    // Calculamos una cuota mensual sencilla
    const cuotaMensual =
        solicitud.monto_solicitado / solicitud.coutas;

    // Creamos el prestamo
    const { data: prestamo, error } =
        await crearPrestamoModel({

            id_usuario: solicitud.id_usuario,
            id_solicitud: solicitud.id_solicitud,
            monto: solicitud.monto_solicitado,
            coutas: solicitud.coutas,
            coutas_mensual: cuotaMensual,
            interes: 0,
            fecha_inicio: new Date().toISOString().split('T')[0],
            estado: 'activo'

        });

    // Si ocurre un error al crear el prestamo
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al crear el prestamo',
            error: error.message
        });
    }

    // Respondemos con el prestamo creado
    res.status(201).json({
        mensaje: 'Prestamo creado correctamente',
        prestamo: prestamo
    });
};



// Funcion para crear las cuotas de un prestamo
export const crearCuotas = async (req, res) => {

    // Obtenemos el ID del prestamo desde la URL
    const id_prestamo = req.params.id;

    // Buscamos el prestamo
    const { data: prestamo, error: errorPrestamo } =
        await buscarPrestamoPorId(id_prestamo);

    // Si no encontramos el prestamo
    if (errorPrestamo) {
        return res.status(404).json({
            mensaje: 'No se encontro el prestamo',
            error: errorPrestamo.message
        });
    }

    // Creamos un arreglo para guardar las cuotas
    const cuotas = [];

    // Repetimos el proceso segun la cantidad de cuotas
    for (let i = 1; i <= prestamo.coutas; i++) {

        cuotas.push({
            id_prestamo: prestamo.id_prestamo,
            numero_cuota: i,
            monto: prestamo.coutas_mensual,
            fecha_pago: new Date().toISOString().split('T')[0],
            estado: 'pendiente'
        });
    }

    // Guardamos las cuotas en Supabase
    const { data, error } =
        await crearCuotasModel(cuotas);

    // Comprobamos si ocurre un error
    if (error) {
        return res.status(500).json({
            mensaje: 'Error al crear las cuotas',
            error: error.message
        });
    }

    // Respondemos con las cuotas creadas
    res.status(201).json({
        mensaje: 'Cuotas creadas correctamente',
        cuotas: data
    });
};


