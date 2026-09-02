import { buscarCuotaPorId, buscarPrestamoPorId, crearPago, actualizarEstadoCuota, crearMovimiento } from "../models/pagoModel.js";
// Funcion para registrar el pago de una cuota
export const registrarPago = async (req, res) => {

// Obtenemos los datos enviados
const { id_prestamos, id_cuota, monto, metodo_pago } = req.body;

// Verificamos que los datos sean obligatorios
if (!id_prestamos || !id_cuota || !monto || !metodo_pago) {
    return res.status(400).json({
        mensaje: 'El prestamo, la cuota, el monto y el metodo de pago son obligatorios'
    });
}

// Buscamos la cuota
const { data: cuota, error: errorCuota } =
    await buscarCuotaPorId(id_cuota);

// Si no encontramos la cuota
if (errorCuota) {
    return res.status(404).json({
        mensaje: 'No se encontro la cuota',
        error: errorCuota.message
    });
}

// Verificamos que la cuota pertenezca al prestamo
if (cuota.id_prestamo != id_prestamos) {
    return res.status(400).json({
        mensaje: 'La cuota no pertenece a este prestamo'
    });
}

// Buscamos el prestamo para obtener el usuario
const { data: prestamo, error: errorPrestamo } =
    await buscarPrestamoPorId(id_prestamos);

// Si no encontramos el prestamo
if (errorPrestamo) {
    return res.status(404).json({
        mensaje: 'No se encontro el prestamo',
        error: errorPrestamo.message
    });
}

// Creamos el pago
const { data: pago, error } = await crearPago({

    id_prestamos: id_prestamos,
    id_cuota: id_cuota,
    numero_coutas: cuota.numero_cuota,
    monto: monto,
    fecha_pago: new Date().toISOString().split('T')[0],
    estado: 'pagado',
    metodo_pago: metodo_pago

});

// Comprobamos si ocurrio un error
if (error) {
    return res.status(500).json({
        mensaje: 'Error al registrar el pago',
        error: error.message
    });
}

// Actualizamos el estado de la cuota
const { error: errorActualizacion } =
    await actualizarEstadoCuota(id_cuota);

// Comprobamos si ocurrio un error
if (errorActualizacion) {
    return res.status(500).json({
        mensaje: 'El pago se registro, pero no se pudo actualizar la cuota',
        error: errorActualizacion.message
    });
}

// Creamos un movimiento para registrar el pago
const { error: errorMovimiento } =
    await crearMovimiento({

        id_usuario: prestamo.id_usuario,
        id_prestamo: id_prestamos,
        tipo: 'pago',
        description: 'Pago de cuota realizado',
        monto: monto

    });

// Comprobamos si ocurrio un error al crear el movimiento
if (errorMovimiento) {
    return res.status(500).json({
        mensaje: 'El pago y la cuota se actualizaron, pero no se pudo crear el movimiento',
        error: errorMovimiento.message
    });
}

// Respondemos con el pago creado
res.status(201).json({
    mensaje: 'Pago registrado correctamente',
    pago: pago
});

};
