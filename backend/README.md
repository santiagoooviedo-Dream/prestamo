# 💰 PRESTAMO - SISTEMA DE GESTIÓN DE PRÉSTAMOS

API REST desarrollada para gestionar usuarios, solicitudes de préstamos,
préstamos, cuotas y pagos.

El backend permite manejar la autenticación de usuarios, recuperación de
contraseña, actualización de información personal y control de acceso
mediante roles.

---

# 🛠️ Stack Tecnológico

El proyecto utiliza una arquitectura basada en un servidor backend,
una API REST y una base de datos en la nube, integrando las siguientes
tecnologías:

- Node.js + Express (backend)
- Supabase (base de datos)
- JWT (autenticación y manejo de sesiones)
- Bcrypt (protección de contraseñas)
- Brevo (envío de correos)
- Cloudinary (almacenamiento de imágenes)
- Nodemon (desarrollo del servidor)

---

# 🚀 Características del Proyecto

## 🔐 1. Autenticación y Seguridad

- **Registro e Inicio de Sesión:** Permite registrar usuarios e iniciar
  sesión utilizando correo y contraseña.

- **Protección de Contraseñas:** Las contraseñas son protegidas mediante
  Bcrypt antes de ser almacenadas.

- **Tokens JWT:** El sistema utiliza tokens JWT para identificar al
  usuario y proteger las rutas.

- **Control de Acceso Basado en Roles (RBAC):** Permite diferenciar
  los permisos entre usuarios y administradores.

- **Protección de Rutas:** Los middleware verifican que el usuario tenga
  un token válido y los permisos necesarios.

---

# ⚙️ Instalación y Configuración

## 1. Clonar el repositorio

```bash
git clone https://github.com/santiagoooviedo-Dream/prestamo.git
```

Instala las dependencias desde esta carpeta:

```bash
npm install
```

En PowerShell de Windows, usa `npm.cmd install` y `npm.cmd run dev` si la política de ejecución bloquea `npm.ps1`.

---

# ▶️ Ejecutar el Servidor

Para iniciar el servidor en modo desarrollo utilizar:

```bash
npm run dev
```

El servidor se ejecutará en:

```text
http://localhost:3000
```

## Solicitudes y desembolso

Antes de iniciar el servidor, aplica una sola vez el SQL de
`migrations/20261022_detalles_desembolso.sql` en el editor SQL de Supabase. La
migración agrega a `solicitudes` el método de desembolso, el número Nequi y los
datos de programación de una aprobación.

Las solicitudes autenticadas se crean en `POST /solicitudes` con un token
Bearer. El cuerpo incluye `monto_solicitado`, `coutas`, `motivo` y
`metodo_desembolso` (`efectivo` o `nequi`). Para Nequi se requiere
`telefono_nequi` en formato celular colombiano de 10 dígitos.

Para resolver una solicitud, un administrador usa `PATCH /solicitudes/:id`.
La aprobación requiere indicar una fecha futura ISO 8601 en `fecha_desembolso`;
si el método elegido fue efectivo, también requiere `lugar_recogida`. Ejemplo:

```json
{
  "estado": "aceptada",
  "fecha_desembolso": "2026-11-05T15:30:00-05:00",
  "lugar_recogida": "Oficina principal, Calle 10 # 20-30"
}
```

En solicitudes Nequi, el número de destino es el que el cliente indicó al
solicitar; la aprobación solo requiere fecha y hora. Rechazar requiere
`{"estado":"rechazada"}`. Cada decisión genera una notificación en la aplicación
y un correo detallado al usuario. Configura `BREVO_API_KEY` y `EMAIL_USER` en el
entorno; las respuestas indican explícitamente si el correo pudo enviarse.

`GET /prestamos` y `GET /solicitudes` requieren el token del usuario y solo
devuelven sus propios datos. `GET /notificaciones` permite consultar sus
notificaciones y `PUT /notificaciones/:id` marcar una como leída.

---

# 📁 Estructura del Proyecto

```text
prestamo/
│
├── controllers/
│   ├── usuarioController.js
│   ├── solicitudController.js
│   ├── prestamoController.js
│   └── ...
│
├── models/
│   ├── usuarioModel.js
│   ├── solicitudModel.js
│   ├── prestamoModel.js
│   └── ...
│
├── routes/
│   ├── usuarioRoutes.js
│   ├── solicitudRoutes.js
│   ├── prestamoRoutes.js
│   └── ...
│
├── middleware/
│   ├── authMiddleware.js
│   └── ...
│
├── config/
│   └── supabase.js
│
├── utils/
│   └── sendEmails.js
│
├── index.js
├── package.json
├── package-lock.json
└── .env
```

---

# 👨‍💻 Autor

- **Jhoan Santiago Oviedo FLorez**
  - Estudiante de ADSO
  - Desarrollo de aplicaciones y servicios backend
