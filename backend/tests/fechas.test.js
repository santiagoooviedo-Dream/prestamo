import test from 'node:test';
import assert from 'node:assert/strict';
import { sumarMesesAFecha } from '../utils/fechas.js';

test('suma meses consecutivos conservando el dia cuando existe', () => {
    assert.equal(sumarMesesAFecha('2026-10-15', 0), '2026-10-15');
    assert.equal(sumarMesesAFecha('2026-10-15', 1), '2026-11-15');
    assert.equal(sumarMesesAFecha('2026-10-15', 2), '2026-12-15');
});

test('limita el dia al ultimo dia valido del mes de destino', () => {
    assert.equal(sumarMesesAFecha('2026-01-31', 1), '2026-02-28');
    assert.equal(sumarMesesAFecha('2026-01-31', 2), '2026-03-31');
    assert.equal(sumarMesesAFecha('2024-01-31', 1), '2024-02-29');
});
