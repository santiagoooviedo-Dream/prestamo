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

```bash
  instalacion de node
```
```bash
  Instalación npm install
```
```bash
  Instalación de node
```
```bash
  Instalación de node
```

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
