import { cert, getApps, initializeApp } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';

const cuentaServicioJson = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;

let mensajeriaFirebase = null;

if (cuentaServicioJson) {
    const cuentaServicio = JSON.parse(cuentaServicioJson);
    if (
        typeof cuentaServicio.project_id !== 'string' ||
        typeof cuentaServicio.client_email !== 'string' ||
        typeof cuentaServicio.private_key !== 'string'
    ) {
        throw new Error(
            'FIREBASE_SERVICE_ACCOUNT_JSON no contiene una cuenta de servicio válida'
        );
    }

    const nombreApp = 'prestamo-push';
    const app = getApps().find((actual) => actual.name === nombreApp) ??
        initializeApp({
            credential: cert(cuentaServicio),
            projectId: cuentaServicio.project_id
        }, nombreApp);
    mensajeriaFirebase = getMessaging(app);
} else {
    console.warn(
        'Notificaciones push desactivadas: configura FIREBASE_SERVICE_ACCOUNT_JSON'
    );
}

export { mensajeriaFirebase };
