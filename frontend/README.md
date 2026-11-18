# Front Prestamo

Aplicación Flutter para las cuentas y el flujo de préstamos de Prestamo Amigo.

## Ejecutar en desarrollo

1. Inicia el backend desde `../backend` con `npm run dev` y confirma que esté disponible en el puerto `3000`. En PowerShell de Windows, usa `npm.cmd run dev` si la política de ejecución bloquea `npm.ps1`.
2. Aplica la migración SQL documentada en `../backend/README.md` para guardar
   los datos de desembolso y configura las variables de correo del backend.
3. Desde esta carpeta, ejecuta `flutter pub get` y `flutter run`.

En Windows, si `flutter run -d windows` muestra `Building with plugins requires symlink support`, activa **Developer Mode** en la configuración de Windows y vuelve a ejecutar el comando. Si no puedes activarlo, inicia la aplicación web con `flutter run -d chrome`.

La URL predeterminada de la API es `http://10.0.2.2:3000` para el emulador Android y `http://localhost:3000` para web, escritorio e iOS Simulator. Para usar otra dirección (por ejemplo, el IP local del computador desde un teléfono físico), configúrala al ejecutar Flutter:

```sh
flutter run --dart-define=API_BASE_URL=https://tu-api.example.com
```

Las compilaciones de producción deben usar una URL HTTPS. El permiso de tráfico HTTP sin cifrar está habilitado únicamente para compilaciones Android de depuración.

## Flujos conectados

El inicio de sesión, el registro, la recuperación y los cambios de correo y
contraseña usan modelos de `lib/models` conectados con la API. El perfil, las
solicitudes, los préstamos, las cuotas, los movimientos y las notificaciones se
cargan del backend. El asistente crea una conversación autenticada y envía los
mensajes al chatbot.

Los pagos en línea todavía no se pueden confirmar desde la aplicación: el
backend no integra una pasarela de pago, por lo que el calendario solo consulta
las cuotas y no marca pagos como realizados.

El usuario debe iniciar sesión antes de solicitar préstamos o consultar sus
datos. La aprobación la realiza un administrador mediante `PATCH /solicitudes/:id`;
las instrucciones y el cuerpo requerido están en `../backend/README.md`.

## Notificaciones push

La app usa Firebase Cloud Messaging para mostrar en el teléfono las
notificaciones que también aparecen en la bandeja de la aplicación. Para
habilitarlas:

1. Crea un proyecto en Firebase y registra la app Android con el identificador
   `com.front_prestamo.app`. Copia `google-services.json` en
   `android/app/google-services.json`. El plugin de Google Services se aplica
   automáticamente cuando ese archivo existe.
2. Para iOS, registra el identificador `com.example.frontPrestamo`, copia
   `GoogleService-Info.plist` a `ios/Runner` y habilita Push Notifications y
   Remote notifications en Xcode. También configura una clave APNs en Firebase.
3. En Firebase habilita Firebase Cloud Messaging. Crea una clave privada de
   cuenta de servicio y configura el JSON completo como la variable
   `FIREBASE_SERVICE_ACCOUNT_JSON` del backend. No guardes esa clave en Git.
4. Aplica la migración
   `../backend/migrations/20261118_tokens_notificaciones.sql`
   en Supabase y despliega la versión actualizada del backend.
5. Inicia sesión en la app y acepta el permiso de notificaciones. Android
   requiere un dispositivo o emulador con Google Play Services; iOS requiere un
   dispositivo físico y la configuración APNs.

Sin los archivos de Firebase de la plataforma, la app seguirá funcionando,
pero no podrá registrar el dispositivo para recibir notificaciones push.
