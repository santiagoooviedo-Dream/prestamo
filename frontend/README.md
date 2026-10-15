# Front Prestamo

Aplicación Flutter para autenticación y recuperación de cuentas de Prestamo.

## Ejecutar en desarrollo

1. Inicia el backend desde `../backend` con `npm run dev` y confirma que esté disponible en el puerto `3000`. En PowerShell de Windows, usa `npm.cmd run dev` si la política de ejecución bloquea `npm.ps1`.
2. Desde esta carpeta, ejecuta `flutter pub get` y `flutter run`.

En Windows, si `flutter run -d windows` muestra `Building with plugins requires symlink support`, activa **Developer Mode** en la configuración de Windows y vuelve a ejecutar el comando. Si no puedes activarlo, inicia la aplicación web con `flutter run -d chrome`.

La URL predeterminada de la API es `http://10.0.2.2:3000` para el emulador Android y `http://localhost:3000` para web, escritorio e iOS Simulator. Para usar otra dirección (por ejemplo, el IP local del computador desde un teléfono físico), configúrala al ejecutar Flutter:

```sh
flutter run --dart-define=API_BASE_URL=https://tu-api.example.com
```

Las compilaciones de producción deben usar una URL HTTPS. El permiso de tráfico HTTP sin cifrar está habilitado únicamente para compilaciones Android de depuración.

## Flujos conectados

- Inicio de sesión con cédula y contraseña.
- Registro y verificación por código enviado al correo.
- Reenvío del código de verificación.
- Solicitud, verificación y uso de código para recuperar la contraseña.
