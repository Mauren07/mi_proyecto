-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-03-2026 a las 01:28:34
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `app_crud`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `api_users`
--

CREATE TABLE `api_users` (
  `Api_user_id` int(11) NOT NULL,
  `Api_user` varchar(60) NOT NULL,
  `Api_password` varchar(255) NOT NULL,
  `Api_role` enum('Admin','Read-only') NOT NULL,
  `Api_status` enum('Active','Inactive') NOT NULL,
  `Created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `Updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `api_users`
--

INSERT INTO `api_users` (`Api_user_id`, `Api_user`, `Api_password`, `Api_role`, `Api_status`, `Created_at`, `Updated_at`) VALUES
(1, 'user@email.com', '$2b$10$A.RezjA04B1GcvfGDnnve.elhd56BPN.44qUtvgyVG5Jy8IkwxoFi', 'Admin', 'Active', '2026-02-16 01:22:51', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modules`
--

CREATE TABLE `modules` (
  `Modules_id` int(11) UNSIGNED NOT NULL,
  `Modules_name` varchar(30) NOT NULL,
  `Modules_description` varchar(300) DEFAULT NULL,
  `Modules_route` varchar(80) DEFAULT NULL,
  `Modules_icon` varchar(30) DEFAULT NULL,
  `Modules_submodule` tinyint(3) NOT NULL DEFAULT 0,
  `Modules_parent_module` varchar(11) DEFAULT NULL,
  `create_at` timestamp NULL DEFAULT current_timestamp(),
  `update_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `modules`
--

INSERT INTO `modules` (`Modules_id`, `Modules_name`, `Modules_description`, `Modules_route`, `Modules_icon`, `Modules_submodule`, `Modules_parent_module`, `create_at`, `update_at`) VALUES
(1, 'Dashboard', 'This is dashboard', 'dashboard', 'bi-speedometer', 0, 'NULL', '2024-05-16 23:13:05', '0000-00-00 00:00:00'),
(2, 'User', 'This is user', 'user', 'bi-person-circle', 0, 'NULL', '2024-05-16 23:13:23', '0000-00-00 00:00:00'),
(3, 'Module', 'This is module', 'module', 'bi-box-fill', 0, 'NULL', '2024-05-16 23:13:53', '2024-05-28 06:07:47'),
(4, 'User Status', 'This is module the User Status', 'userStatus', 'bi-people-fill', 1, '2', '2024-05-25 22:13:17', NULL),
(5, 'Role', 'This is module the Role', 'role', 'bi-person-lock', 1, '2', '2024-05-26 00:03:41', NULL),
(6, 'Role Modules', 'This is Role Modules', 'roleModule', 'bi-boxes', 1, '3', '2024-05-27 20:46:42', NULL),
(7, 'Permissions', 'This is permissions', 'permission', 'bi-shield-lock-fill', 0, NULL, '2024-05-28 01:14:30', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profiles`
--

CREATE TABLE `profiles` (
  `Profile_id` int(11) UNSIGNED NOT NULL,
  `Profile_email` varchar(255) NOT NULL,
  `Profile_name` varchar(30) NOT NULL,
  `Profile_photo` varchar(255) DEFAULT NULL,
  `User_id_fk` int(11) UNSIGNED DEFAULT NULL,
  `create_at` timestamp NULL DEFAULT current_timestamp(),
  `update_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `profiles`
--

INSERT INTO `profiles` (`Profile_id`, `Profile_email`, `Profile_name`, `Profile_photo`, `User_id_fk`, `create_at`, `update_at`) VALUES
(2, 'Diego@gmail.com', 'Diego Casallas', 'https://cdn-icons-png.flaticon.com/512/622/622848.png', 5, '2024-05-23 22:00:55', NULL),
(3, 'laura@gmail.com', 'Laura Camila', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUzNr-zMxcqeJwrncR5YG1EN-ygMrD\r\nAz1_U5gwTqfJsg&s', 4, '2024-05-24 06:24:11', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `Roles_id` int(11) UNSIGNED NOT NULL,
  `Roles_name` varchar(30) NOT NULL,
  `Roles_description` varchar(300) DEFAULT NULL,
  `create_at` timestamp NULL DEFAULT current_timestamp(),
  `update_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`Roles_id`, `Roles_name`, `Roles_description`, `create_at`, `update_at`) VALUES
(1, 'Admin', 'This is admin', '2024-05-16 23:11:57', '0000-00-00 00:00:00'),
(2, 'Test', 'This is test', '2024-05-16 23:12:18', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `role_modules`
--

CREATE TABLE `role_modules` (
  `RoleModules_id` int(11) UNSIGNED NOT NULL,
  `Modules_fk` int(11) UNSIGNED DEFAULT NULL,
  `Roles_fk` int(11) UNSIGNED DEFAULT NULL,
  `create_at` timestamp NULL DEFAULT current_timestamp(),
  `update_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `User_id` int(11) UNSIGNED NOT NULL,
  `User_user` varchar(255) NOT NULL,
  `User_password` varchar(255) NOT NULL,
  `Roles_fk` int(11) UNSIGNED DEFAULT NULL,
  `User_status_fk` int(11) UNSIGNED DEFAULT NULL,
  `create_at` timestamp NULL DEFAULT current_timestamp(),
  `update_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`User_id`, `User_user`, `User_password`, `Roles_fk`, `User_status_fk`, `create_at`, `update_at`) VALUES
(4, 'd.casallas@sinapsist.com.co', '$2y$10$/F0Kxg/eZKVYX/Uq7GD6xO1IOfWYcYHgy10XrO7.GI7qkLB9yNFM2', 1, 1, '2024-05-18 15:07:53', '0000-00-00 00:00:00'),
(5, 'info@sinapsist.com.co', '$2y$10$/F0Kxg/eZKVYX/Uq7GD6xO1IOfWYcYHgy10XrO7.GI7qkLB9yNFM2', 1, 1, '2024-05-23 22:06:37', '2025-04-07 05:02:44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_status`
--

CREATE TABLE `user_status` (
  `User_status_id` int(11) UNSIGNED NOT NULL,
  `User_status_name` varchar(30) NOT NULL,
  `User_status_description` varchar(300) DEFAULT NULL,
  `create_at` timestamp NULL DEFAULT current_timestamp(),
  `update_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `user_status`
--

INSERT INTO `user_status` (`User_status_id`, `User_status_name`, `User_status_description`, `create_at`, `update_at`) VALUES
(1, 'Active', 'Active', '2024-05-18 05:44:01', NULL),
(2, 'Inactive', 'Inactive', '2024-05-18 05:44:01', NULL),
(3, 'Blocked', 'This is Blocked', '2024-05-28 01:05:28', '0000-00-00 00:00:00'),
(4, 'Delete', 'Delete', '2024-06-02 01:44:23', '0000-00-00 00:00:00');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `api_users`
--
ALTER TABLE `api_users`
  ADD PRIMARY KEY (`Api_user_id`),
  ADD UNIQUE KEY `Api_user` (`Api_user`);

--
-- Indices de la tabla `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`Modules_id`),
  ADD UNIQUE KEY `Modules_name` (`Modules_name`);

--
-- Indices de la tabla `profiles`
--
ALTER TABLE `profiles`
  ADD PRIMARY KEY (`Profile_id`),
  ADD UNIQUE KEY `Profile_email` (`Profile_email`),
  ADD KEY `fk_user_profile` (`User_id_fk`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`Roles_id`),
  ADD UNIQUE KEY `Roles_name` (`Roles_name`);

--
-- Indices de la tabla `role_modules`
--
ALTER TABLE `role_modules`
  ADD PRIMARY KEY (`RoleModules_id`),
  ADD KEY `fk_module` (`Modules_fk`),
  ADD KEY `fk_roles` (`Roles_fk`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`User_id`),
  ADD UNIQUE KEY `User_user` (`User_user`),
  ADD KEY `fk_user_status` (`User_status_fk`),
  ADD KEY `fk_user_role` (`Roles_fk`);

--
-- Indices de la tabla `user_status`
--
ALTER TABLE `user_status`
  ADD PRIMARY KEY (`User_status_id`),
  ADD UNIQUE KEY `User_status_name` (`User_status_name`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `api_users`
--
ALTER TABLE `api_users`
  MODIFY `Api_user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `modules`
--
ALTER TABLE `modules`
  MODIFY `Modules_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `profiles`
--
ALTER TABLE `profiles`
  MODIFY `Profile_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `Roles_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `role_modules`
--
ALTER TABLE `role_modules`
  MODIFY `RoleModules_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `User_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `user_status`
--
ALTER TABLE `user_status`
  MODIFY `User_status_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `profiles`
--
ALTER TABLE `profiles`
  ADD CONSTRAINT `fk_user_profile` FOREIGN KEY (`User_id_fk`) REFERENCES `users` (`User_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `role_modules`
--
ALTER TABLE `role_modules`
  ADD CONSTRAINT `fk_module` FOREIGN KEY (`Modules_fk`) REFERENCES `modules` (`Modules_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_roles` FOREIGN KEY (`Roles_fk`) REFERENCES `roles` (`Roles_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_user_role` FOREIGN KEY (`Roles_fk`) REFERENCES `roles` (`Roles_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_status` FOREIGN KEY (`User_status_fk`) REFERENCES `user_status` (`User_status_id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
