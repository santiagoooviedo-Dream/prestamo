export const sumarMesesAFecha = (fechaBase, meses) => {
    const fecha = new Date(fechaBase);
    if (Number.isNaN(fecha.getTime())) {
        throw new TypeError('La fecha base no es válida');
    }

    if (!Number.isInteger(meses) || meses < 0) {
        throw new RangeError('La cantidad de meses debe ser un entero no negativo');
    }

    const primerDiaMesObjetivo = new Date(Date.UTC(
        fecha.getUTCFullYear(),
        fecha.getUTCMonth() + meses,
        1
    ));
    const anio = primerDiaMesObjetivo.getUTCFullYear();
    const mes = primerDiaMesObjetivo.getUTCMonth();
    const ultimoDiaMes = new Date(Date.UTC(anio, mes + 1, 0)).getUTCDate();
    const dia = Math.min(fecha.getUTCDate(), ultimoDiaMes);

    return new Date(Date.UTC(anio, mes, dia)).toISOString().slice(0, 10);
};
