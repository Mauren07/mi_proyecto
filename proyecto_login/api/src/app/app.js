/**
*Author: 	DIEGO CASALLAS
*Date:		01/01/2026  
*Description:	Application setup for the API - NODEJS
**/
import express from 'express';
import morgan from 'morgan';
import userRoutes from '../routes/user.routes.js';
import userStatusRoutes from '../routes/userStatus.routes.js';
import roleRoutes from '../routes/role.routes.js';
import userApiRoutes from '../routes/apiUser.routes.js';
import moduleRoutes from '../routes/module.routes.js';
import roleModuleRoutes from '../routes/roleModule.routes.js';
import perfilRoutes from '../routes/perfil.routes.js';

// Create an instance of the Express application
const app = express();
// Define the base path for the API
const NAME_API = '/api_v1';

app.use(morgan(':method :url :status :response-time ms'));

// Middleware para CORS - Permitir solicitudes desde Flutter
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With');
  
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

// Middleware to handle JSON
app.use(express.json());

// Routes for the API
app.use(NAME_API, userRoutes);
app.use(NAME_API, userStatusRoutes);
app.use(NAME_API, roleRoutes);
app.use(NAME_API, userApiRoutes);
app.use(NAME_API, moduleRoutes);
app.use(NAME_API, roleModuleRoutes);
app.use(NAME_API, perfilRoutes);

// Handle 404 errors for undefined routes
app.use((req, res, next) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found',
    path: req.originalUrl,
    method: req.method
  });
});

export default app;
