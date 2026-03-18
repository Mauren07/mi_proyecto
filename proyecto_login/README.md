# Proyecto Login

Proyecto full stack con:

- backend en Node.js + Express + MySQL
- app cliente en Flutter
- autenticacion con JWT
- modulo funcional de login y gestion de estados de usuario

## Estructura

```text
proyecto_login/
|-- api/
|-- db/
|-- flutter/
`-- README.md
```

## Flujo principal

```text
Flutter Splash
  -> Login
  -> POST /api_v1/apiUserLogin
  -> JWT
  -> GET /api_v1/userStatus
  -> POST /api_v1/userStatus
```

## Backend

Carpeta: `api/`

Tecnologias:

- Express
- mysql2
- jsonwebtoken
- bcrypt

Variables de entorno esperadas:

```env
PORT=
DB_HOST=
DB_USER=
DB_PASSWORD=
DB_NAME=
DB_PORT=
JWT_SECRET=
JWT_EXPIRES_IN=
```

Archivo de ejemplo:

- `api/.env.example`

Ejecucion:

```bash
cd api
npm install
npm start
```

Base path:

```text
http://localhost:3000/api_v1
```

Rutas principales:

- `POST /api_v1/apiUserLogin`
- `POST /api_v1/apiUserVerifyToken`
- `GET /api_v1/userStatus`
- `POST /api_v1/userStatus`
- `GET /api_v1/userStatus/:id`
- `PUT /api_v1/userStatus/:id`
- `DELETE /api_v1/userStatus/:id`

## JWT

El login usa la tabla `api_users`.

Si las credenciales son validas:

- el backend genera un JWT con `id`, `role` y `status`
- el cliente Flutter lo envia como `Bearer token`
- el middleware `verifyToken` protege rutas como `userStatus`

## Base de datos

Carpeta: `db/`

Archivo principal:

- `db/app_crud.sql`

Tablas destacadas:

- `api_users`
- `users`
- `user_status`
- `roles`
- `modules`
- `role_modules`
- `profiles`

## Flutter

Carpeta: `flutter/application_login/`

Rutas Flutter registradas:

- `/` -> splash
- `/login` -> login
- `/home` -> home
- `/form` -> formulario
- `/user-statuses` -> estados de usuario

Archivo clave de integracion:

- `lib/services/api_service.dart`

Servicio actual:

- hace login
- guarda el token en memoria
- consulta estados de usuario
- crea estados de usuario

Ejecucion:

```bash
cd flutter/application_login
flutter pub get
flutter run
```

Nota:

- si pruebas en Android emulator, `localhost` puede necesitar cambio a `10.0.2.2`

## Pruebas

Backend:

```bash
cd api
npm test
```

Cobertura actual:

- login exitoso
- acceso protegido con JWT
- validaciones de `userStatus`
- creacion de `userStatus`

## Estado actual

La integracion mas estable hoy es:

- login Flutter
- JWT backend
- consulta y creacion de `userStatus`

Hay CRUD adicionales para `user`, `role`, `module`, `perfil` y `rolo_module`, pero el flujo mejor integrado actualmente es el de autenticacion y estados de usuario.
