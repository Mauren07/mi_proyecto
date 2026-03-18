# Paso A Paso Para Descargar Y Ejecutar El Proyecto

Esta guia explica como bajar el repositorio en una maquina nueva y dejar funcionando:

- backend Node.js
- base de datos MySQL / MariaDB
- aplicacion Flutter

---

## 1. Requisitos previos

Antes de empezar, instala estas herramientas:

### Herramientas obligatorias

- Git
- Node.js 18 o superior
- MySQL o MariaDB
- Flutter SDK
- Android Studio o VS Code con extensiones de Flutter y Dart

### Si vas a correr en Android

- Android Studio
- Android SDK
- un emulador Android configurado

### Si vas a correr en web

- Google Chrome

---

## 2. Clonar el repositorio

Abre una terminal y ejecuta:

```bash
git clone https://github.com/Mauren07/mi_proyecto.git
cd mi_proyecto/proyecto_login
```

Si el repositorio queda clonado en otra carpeta, entra siempre a la carpeta donde estan:

- `api/`
- `db/`
- `flutter/`

---

## 3. Estructura del proyecto

Una vez clonado, vas a tener esta estructura:

```text
proyecto_login/
|-- api/
|-- db/
|-- flutter/
|-- README.md
`-- PASO_A_PASO.md
```

Descripcion rapida:

- `api/`: backend en Node.js + Express
- `db/`: script SQL para crear la base de datos
- `flutter/application_login/`: app Flutter

---

## 4. Configurar la base de datos

### 4.1 Crear la base de datos

Abre MySQL o phpMyAdmin y crea una base llamada:

```sql
app_crud
```

### 4.2 Importar el script SQL

Importa este archivo:

```text
db/app_crud.sql
```

Ese script crea las tablas principales:

- `api_users`
- `users`
- `user_status`
- `roles`
- `modules`
- `role_modules`
- `profiles`

Y tambien inserta datos base.

---

## 5. Configurar el backend

Entra a la carpeta del backend:

```bash
cd api
```

### 5.1 Instalar dependencias

Ejecuta:

```bash
npm install
```

Dependencias principales que se instalan:

- express
- mysql2
- dotenv
- jsonwebtoken
- bcrypt
- morgan

### 5.2 Configurar variables de entorno

El proyecto usa este archivo:

```text
api/.env
```

Si no existe o quieres recrearlo, puedes usar como base:

```text
api/.env.example
```

Contenido esperado:

```env
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=app_crud
DB_PORT=3306
JWT_SECRET=change_this_secret
JWT_EXPIRES_IN=1h
```

Revisa especialmente:

- `DB_HOST`
- `DB_USER`
- `DB_PASSWORD`
- `DB_NAME`
- `DB_PORT`
- `JWT_SECRET`

### 5.3 Arrancar el backend

Desde la carpeta `api/`, ejecuta:

```bash
npm start
```

Si todo esta bien, el backend debe quedar corriendo en:

```text
http://localhost:3000
```

Y la API base queda en:

```text
http://localhost:3000/api_v1
```

---

## 6. Probar el backend

Sin salir de `api/`, puedes correr las pruebas con:

```bash
npm test
```

Estas pruebas cubren principalmente:

- login
- generacion de JWT
- consulta protegida de `userStatus`
- creacion de `userStatus`

---

## 7. Configurar Flutter

Ahora entra a la app Flutter:

```bash
cd ../flutter/application_login
```

### 7.1 Instalar dependencias Flutter

Ejecuta:

```bash
flutter pub get
```

Paquetes usados actualmente:

- http
- provider
- qr_flutter
- flutter_launcher_icons

### 7.2 Verificar entorno Flutter

Recomendado:

```bash
flutter doctor
```

Si Flutter reporta problemas, corrige primero lo que marque:

- Android SDK
- licencias Android
- Chrome
- Visual Studio o Xcode segun plataforma

---

## 8. Revisar la URL del backend en Flutter

Archivo importante:

```text
flutter/application_login/lib/services/api_service.dart
```

La URL base actual del proyecto es:

```dart
http://localhost:3000/api_v1
```

### Si corres en web o desktop local

Generalmente puedes dejar:

```text
http://localhost:3000/api_v1
```

### Si corres en Android emulator

Normalmente debes cambiarla a:

```text
http://10.0.2.2:3000/api_v1
```

### Si corres en celular fisico

Debes usar la IP local de tu computador, por ejemplo:

```text
http://192.168.1.10:3000/api_v1
```

Ademas:

- el backend y el celular deben estar en la misma red

---

## 9. Arrancar Flutter

Desde `flutter/application_login/`, ejecuta:

```bash
flutter run
```

Si tienes varios dispositivos disponibles:

```bash
flutter devices
flutter run -d chrome
```

o por ejemplo:

```bash
flutter run -d emulator-5554
```

---

## 10. Flujo esperado al abrir la app

Si todo quedo bien:

1. aparece el splash
2. despues pasa al login
3. ingresas usuario y contrasena
4. Flutter llama `POST /api_v1/apiUserLogin`
5. el backend responde con un JWT
6. la app navega a `user-statuses`
7. consulta `GET /api_v1/userStatus`

---

## 11. Usuario de prueba

El SQL trae un usuario base en `api_users`.

Si no recuerdas las credenciales exactas:

- revisa el SQL importado
- o revisa la tabla `api_users` en tu base de datos

Recuerda:

- el login usa `api_users`
- no usa directamente la tabla `users`

---

## 12. Comandos rapidos

### Clonar proyecto

```bash
git clone https://github.com/Mauren07/mi_proyecto.git
cd mi_proyecto/proyecto_login
```

### Backend

```bash
cd api
npm install
npm start
```

### Tests backend

```bash
cd api
npm test
```

### Flutter

```bash
cd flutter/application_login
flutter pub get
flutter run
```

### Verificar Flutter

```bash
flutter doctor
```

---

## 13. Problemas comunes

### Error de conexion desde Flutter

Revisa:

- que el backend este corriendo
- que el puerto sea `3000`
- que la URL en `api_service.dart` sea correcta
- que si usas Android emulator no estes usando `localhost`

### Error de base de datos

Revisa:

- que la base `app_crud` exista
- que importaste `db/app_crud.sql`
- que `api/.env` tenga credenciales correctas

### Error de dependencias Node

Ejecuta de nuevo:

```bash
cd api
npm install
```

### Error de dependencias Flutter

Ejecuta:

```bash
cd flutter/application_login
flutter pub get
```

### Flutter no detecta dispositivo

Ejecuta:

```bash
flutter doctor
flutter devices
```

---

## 14. Orden recomendado para levantar todo sin problemas

Usa este orden:

1. clonar el repo
2. crear e importar la base de datos
3. configurar `api/.env`
4. instalar dependencias del backend con `npm install`
5. arrancar backend con `npm start`
6. instalar dependencias Flutter con `flutter pub get`
7. revisar `api_service.dart`
8. ejecutar `flutter run`

---

## 15. Resumen final

Si quieres levantar el proyecto rapido, el camino corto es:

```bash
git clone https://github.com/Mauren07/mi_proyecto.git
cd mi_proyecto/proyecto_login
decargar zip

```

Luego:

```bash
cd api
npm install
npm start
```

En otra terminal:

```bash
cd flutter/application_login
flutter pub get
flutter run
```

Y antes de eso no olvides:

- importar `db/app_crud.sql`
- revisar `api/.env`
- validar la URL del backend en Flutter
