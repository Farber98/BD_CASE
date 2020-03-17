-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 25-02-2020 a las 18:51:11
-- Versión del servidor: 5.7.29-0ubuntu0.18.04.1
-- Versión de PHP: 7.2.24-0ubuntu0.18.04.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `proyectoCASE`
--
CREATE DATABASE IF NOT EXISTS `proyectoCASE` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `proyectoCASE`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `AUD_RUBROS`
--

CREATE TABLE `AUD_RUBROS` (
  `Id` bigint(20) NOT NULL,
  `FechaAud` datetime NOT NULL,
  `UsuarioAud` varchar(30) NOT NULL,
  `Ip` varchar(40) NOT NULL,
  `UserAgent` varchar(255) DEFAULT NULL,
  `Aplicacion` varchar(50) NOT NULL,
  `Motivo` varchar(100) DEFAULT NULL,
  `TipoAud` char(1) NOT NULL,
  `IdRubros` smallint(6) NOT NULL,
  `Rubro` varchar(40) NOT NULL,
  `EstadoRub` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena la informacion de la Auditoria en la tabla Rubros';

--
-- Volcado de datos para la tabla `AUD_RUBROS`
--

INSERT INTO `AUD_RUBROS` (`Id`, `FechaAud`, `UsuarioAud`, `Ip`, `UserAgent`, `Aplicacion`, `Motivo`, `TipoAud`, `IdRubros`, `Rubro`, `EstadoRub`) VALUES
(1, '2020-02-24 10:23:31', 'root', 'localhost', NULL, 'localhost', NULL, 'I', 5, 'Auditando', 'A'),
(2, '2020-02-24 10:23:55', 'root', 'localhost', NULL, 'localhost', NULL, 'A', 5, 'Auditando', 'A'),
(3, '2020-02-24 10:23:55', 'root', 'localhost', NULL, 'localhost', NULL, 'D', 5, 'Cambio', 'B'),
(4, '2020-02-24 10:24:25', 'root', 'localhost', NULL, 'localhost', NULL, 'B', 5, 'Cambio', 'B');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `CARGOS`
--

CREATE TABLE `CARGOS` (
  `IdCargos` tinyint(4) NOT NULL,
  `Cargo` varchar(40) NOT NULL,
  `EstadoCar` char(1) NOT NULL DEFAULT 'A'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que tipifica los Cargos de un Empleado.';

--
-- Volcado de datos para la tabla `CARGOS`
--

INSERT INTO `CARGOS` (`IdCargos`, `Cargo`, `EstadoCar`) VALUES
(1, 'Socio', 'A'),
(2, 'Gerente', 'A'),
(3, 'Vendedor', 'A'),
(4, 'Secretario', 'A'),
(5, 'Bajado', 'B');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `CLIENTES`
--

CREATE TABLE `CLIENTES` (
  `IdPersonas` bigint(20) NOT NULL,
  `Correo` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena la informacion de los Clientes del Local.';

--
-- Volcado de datos para la tabla `CLIENTES`
--

INSERT INTO `CLIENTES` (`IdPersonas`, `Correo`) VALUES
(1, 'ignacioac@hotmail.com'),
(7, 'juanpavon@gmail.com'),
(5, 'martap@yahoo.com.ar');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `COMPRAS`
--

CREATE TABLE `COMPRAS` (
  `IdCompras` bigint(20) NOT NULL,
  `IdPersonas` bigint(20) NOT NULL,
  `IdEmpleados` bigint(20) NOT NULL,
  `EstadoCom` char(1) NOT NULL,
  `FechaCompra` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena la informacion perteneciente a las Compras del Local.';

--
-- Volcado de datos para la tabla `COMPRAS`
--

INSERT INTO `COMPRAS` (`IdCompras`, `IdPersonas`, `IdEmpleados`, `EstadoCom`, `FechaCompra`) VALUES
(1, 2, 13, 'C', '2018-09-30 15:20:32'),
(2, 4, 13, 'C', '2019-03-23 16:25:20'),
(3, 6, 13, 'I', '2020-02-21 17:12:39'),
(4, 4, 13, 'C', '2020-02-22 21:13:32'),
(5, 2, 11, 'I', '2020-02-22 21:13:32');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `COMPRASPRODUCTOS`
--

CREATE TABLE `COMPRASPRODUCTOS` (
  `IdCompras` bigint(20) NOT NULL,
  `IdPersonas` bigint(20) NOT NULL,
  `IdProductos` bigint(20) NOT NULL,
  `Cantidad` bigint(20) NOT NULL,
  `PrecioCompra` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena la informacion perteneciente a la Compra de Productos.';

--
-- Volcado de datos para la tabla `COMPRASPRODUCTOS`
--

INSERT INTO `COMPRASPRODUCTOS` (`IdCompras`, `IdPersonas`, `IdProductos`, `Cantidad`, `PrecioCompra`) VALUES
(1, 2, 1, 10, '30000.00'),
(2, 4, 3, 50, '10000.00'),
(3, 6, 2, 30, '200000.00'),
(4, 4, 7, 100, '20000.50');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `EMPLEADOS`
--

CREATE TABLE `EMPLEADOS` (
  `IdPersonas` bigint(20) NOT NULL,
  `IdCargos` tinyint(4) NOT NULL,
  `Usuario` varchar(30) NOT NULL,
  `Clave` char(32) NOT NULL,
  `FechaIngreso` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena la informacion de los Empleados pertenecientes al Local.';

--
-- Volcado de datos para la tabla `EMPLEADOS`
--

INSERT INTO `EMPLEADOS` (`IdPersonas`, `IdCargos`, `Usuario`, `Clave`, `FechaIngreso`) VALUES
(8, 1, 'mduran', 'c57bc4191c68e4186937802d36657495', '2015-02-20 15:22:55'),
(9, 1, 'njaime', '8a49bf88a90b5560b01d978fdd9d1e8c', '2015-05-19 15:22:55'),
(10, 2, 'rhernun', 'e1ee789ea913c70a63f738e9dfd90b47', '2016-10-30 17:40:55'),
(11, 3, 'esunchi', '24de952a6c70f88591e0e2f210b19dc0', '2017-03-13 19:20:30'),
(12, 3, 'fkito', '9f7e9b9537868fb3b4de72b5f81f6c00', '2018-09-20 18:25:32'),
(13, 4, 'nemdun', '84d75bedcf33ea108b63b873c0c530a2', '2020-02-21 16:46:16'),
(19, 3, 'pandoo', 'c193b8a1ae1d6efcbfb58ca6614484c2', '2020-02-22 20:15:21');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `FISICAS`
--

CREATE TABLE `FISICAS` (
  `IdPersonas` bigint(20) NOT NULL,
  `Apellidos` varchar(40) NOT NULL,
  `Nombres` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena las personas fisicas relacionadas al Local.';

--
-- Volcado de datos para la tabla `FISICAS`
--

INSERT INTO `FISICAS` (`IdPersonas`, `Apellidos`, `Nombres`) VALUES
(1, 'Alvarez Cordoba', 'Ignacio Sebastian'),
(3, 'Corronca', 'Luis'),
(8, 'Duran', 'Matias'),
(13, 'Emdun', 'Nino'),
(10, 'Hernun', 'Roman'),
(9, 'Jaime', 'Norma'),
(12, 'Kito', 'Franco'),
(7, 'Pavon', 'Juan'),
(5, 'Peruzzi', 'Marta'),
(19, 'probando', 'ando'),
(11, 'Sunchi', 'Elsa');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PERSONAS`
--

CREATE TABLE `PERSONAS` (
  `IdPersonas` bigint(20) NOT NULL,
  `Telefono` int(11) NOT NULL,
  `EstadoPer` char(1) NOT NULL DEFAULT 'A'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena la informacion de las Personas relacionadas al Local.';

--
-- Volcado de datos para la tabla `PERSONAS`
--

INSERT INTO `PERSONAS` (`IdPersonas`, `Telefono`, `EstadoPer`) VALUES
(1, 40329343, 'A'),
(2, 30219232, 'A'),
(3, 5392343, 'A'),
(4, 30234303, 'A'),
(5, 9543432, 'A'),
(6, 3420343, 'A'),
(7, 39432349, 'A'),
(8, 3943023, 'A'),
(9, 3423423, 'A'),
(10, 3402934, 'A'),
(11, 3493234, 'A'),
(12, 39493233, 'A'),
(13, 9343923, 'A'),
(14, 3049392, 'A'),
(17, 3439493, 'A'),
(18, 324234, 'B'),
(19, 23432, 'B');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PRODUCTOS`
--

CREATE TABLE `PRODUCTOS` (
  `IdProductos` bigint(20) NOT NULL,
  `IdRubros` smallint(6) NOT NULL,
  `Producto` varchar(60) NOT NULL,
  `EstadoPro` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena la informacion perteneciente a Productos.';

--
-- Volcado de datos para la tabla `PRODUCTOS`
--

INSERT INTO `PRODUCTOS` (`IdProductos`, `IdRubros`, `Producto`, `EstadoPro`) VALUES
(1, 3, 'MP4', 'A'),
(2, 3, 'MC5', 'A'),
(3, 2, 'Mouse', 'A'),
(4, 2, 'Teclado', 'A'),
(5, 2, 'Graphix 5000', 'A'),
(6, 1, 'Graphix 6000', 'A'),
(7, 1, 'Pantalla LED', 'A');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PROVEEDORES`
--

CREATE TABLE `PROVEEDORES` (
  `IdPersonas` bigint(20) NOT NULL,
  `Proveedor` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena la informacion de los Proveedores del Local.';

--
-- Volcado de datos para la tabla `PROVEEDORES`
--

INSERT INTO `PROVEEDORES` (`IdPersonas`, `Proveedor`) VALUES
(18, 'Bajado'),
(2, 'Cortex S.A'),
(4, 'Maynard S.R.L'),
(6, 'Nobsung');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `RUBROS`
--

CREATE TABLE `RUBROS` (
  `IdRubros` smallint(6) NOT NULL,
  `Rubro` varchar(40) NOT NULL,
  `EstadoRub` char(1) NOT NULL DEFAULT 'A'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que tipifica los Rubros de Productos.';

--
-- Volcado de datos para la tabla `RUBROS`
--

INSERT INTO `RUBROS` (`IdRubros`, `Rubro`, `EstadoRub`) VALUES
(1, 'Tarjetas Graficas', 'A'),
(2, 'Perifericos', 'A'),
(3, 'Microprocesadores y Microcontroladores', 'A'),
(4, 'Bajado', 'B');

--
-- Disparadores `RUBROS`
--
DELIMITER $$
CREATE TRIGGER `RUBROS_AFTER_DELETE` AFTER DELETE ON `RUBROS` FOR EACH ROW INSERT INTO AUD_RUBROS VALUES(0, NOW(), SUBSTRING_INDEX(USER(),'@',1), SUBSTRING_INDEX(USER(),'@',-1), NULL,
    SUBSTRING_INDEX(USER(),'@',-1), NULL, 'B', OLD.IdRubros, OLD.Rubro, OLD.EstadoRub)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `RUBROS_AFTER_INSERT` AFTER INSERT ON `RUBROS` FOR EACH ROW INSERT INTO AUD_RUBROS VALUES(0, NOW(), SUBSTRING_INDEX(USER(),'@',1), SUBSTRING_INDEX(USER(),'@',-1), NULL,
    SUBSTRING_INDEX(USER(),'@',-1), NULL, 'I',NEW.IdRubros, NEW.Rubro, NEW.EstadoRub)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `RUBROS_AFTER_UPDATE` AFTER UPDATE ON `RUBROS` FOR EACH ROW BEGIN
    INSERT INTO AUD_RUBROS VALUES(0, NOW(), SUBSTRING_INDEX(USER(),'@',1), SUBSTRING_INDEX(USER(),'@',-1), NULL,
    SUBSTRING_INDEX(USER(),'@',-1), NULL, 'A', OLD.IdRubros, OLD.Rubro, OLD.EstadoRub);
    INSERT INTO AUD_RUBROS VALUES (0, NOW(), SUBSTRING_INDEX(USER(),'@',1), SUBSTRING_INDEX(USER(),'@',-1), NULL,
    SUBSTRING_INDEX(USER(),'@',-1), NULL, 'D', NEW.IdRubros, NEW.Rubro, NEW.EstadoRub);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `VENTAS`
--

CREATE TABLE `VENTAS` (
  `IdVentas` bigint(20) NOT NULL,
  `IdPersonas` bigint(20) NOT NULL,
  `IdEmpleados` bigint(20) NOT NULL,
  `EstadoVen` char(1) NOT NULL,
  `FechaVenta` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena la informacion perteneciente a las Ventas del Local.';

--
-- Volcado de datos para la tabla `VENTAS`
--

INSERT INTO `VENTAS` (`IdVentas`, `IdPersonas`, `IdEmpleados`, `EstadoVen`, `FechaVenta`) VALUES
(1, 1, 11, 'C', '2018-05-30 09:30:32'),
(2, 5, 12, 'C', '2019-07-29 15:15:40'),
(3, 7, 11, 'I', '2020-02-21 17:29:05');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `VENTASPRODUCTOS`
--

CREATE TABLE `VENTASPRODUCTOS` (
  `IdVentas` bigint(20) NOT NULL,
  `IdPersonas` bigint(20) NOT NULL,
  `IdProductos` bigint(20) NOT NULL,
  `Cantidad` bigint(20) NOT NULL,
  `PrecioVenta` decimal(10,2) NOT NULL,
  `Descuento` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena la informacion perteneciente a la Venta de Productos.';

--
-- Volcado de datos para la tabla `VENTASPRODUCTOS`
--

INSERT INTO `VENTASPRODUCTOS` (`IdVentas`, `IdPersonas`, `IdProductos`, `Cantidad`, `PrecioVenta`, `Descuento`) VALUES
(1, 1, 6, 2, '35000.00', '3500.00'),
(2, 5, 4, 10, '3000.00', '0.00'),
(3, 7, 5, 5, '50000.00', '10000.00');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `AUD_RUBROS`
--
ALTER TABLE `AUD_RUBROS`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `IX_FechaAud` (`FechaAud`),
  ADD KEY `IX_Usuario` (`UsuarioAud`),
  ADD KEY `IX_IP` (`Ip`),
  ADD KEY `IX_Aplicacion` (`Aplicacion`);

--
-- Indices de la tabla `CARGOS`
--
ALTER TABLE `CARGOS`
  ADD PRIMARY KEY (`IdCargos`),
  ADD UNIQUE KEY `UI_Cargo` (`Cargo`),
  ADD KEY `IX_EstadoCar` (`EstadoCar`);

--
-- Indices de la tabla `CLIENTES`
--
ALTER TABLE `CLIENTES`
  ADD PRIMARY KEY (`IdPersonas`),
  ADD UNIQUE KEY `UI_Correo` (`Correo`),
  ADD KEY `Ref2138` (`IdPersonas`);

--
-- Indices de la tabla `COMPRAS`
--
ALTER TABLE `COMPRAS`
  ADD PRIMARY KEY (`IdCompras`,`IdPersonas`),
  ADD UNIQUE KEY `UI_IdCompras` (`IdCompras`),
  ADD KEY `IX_EstadoCom` (`EstadoCom`),
  ADD KEY `Ref412` (`IdPersonas`),
  ADD KEY `Ref239` (`IdEmpleados`);

--
-- Indices de la tabla `COMPRASPRODUCTOS`
--
ALTER TABLE `COMPRASPRODUCTOS`
  ADD PRIMARY KEY (`IdCompras`,`IdPersonas`,`IdProductos`),
  ADD KEY `IX_Cantidad` (`Cantidad`),
  ADD KEY `IX_PrecioCompra` (`PrecioCompra`),
  ADD KEY `Ref1116` (`IdProductos`),
  ADD KEY `Ref932` (`IdCompras`,`IdPersonas`);

--
-- Indices de la tabla `EMPLEADOS`
--
ALTER TABLE `EMPLEADOS`
  ADD PRIMARY KEY (`IdPersonas`),
  ADD UNIQUE KEY `UI_Usuario` (`Usuario`),
  ADD KEY `IX_FechaIngreso` (`FechaIngreso`),
  ADD KEY `Ref1622` (`IdCargos`),
  ADD KEY `Ref2137` (`IdPersonas`);

--
-- Indices de la tabla `FISICAS`
--
ALTER TABLE `FISICAS`
  ADD PRIMARY KEY (`IdPersonas`),
  ADD KEY `IX_ApellidosNombres` (`Apellidos`,`Nombres`),
  ADD KEY `Ref135` (`IdPersonas`);

--
-- Indices de la tabla `PERSONAS`
--
ALTER TABLE `PERSONAS`
  ADD PRIMARY KEY (`IdPersonas`),
  ADD KEY `IX_EstadoPer` (`EstadoPer`);

--
-- Indices de la tabla `PRODUCTOS`
--
ALTER TABLE `PRODUCTOS`
  ADD PRIMARY KEY (`IdProductos`),
  ADD UNIQUE KEY `UI_Producto` (`Producto`),
  ADD KEY `Ref1523` (`IdRubros`),
  ADD KEY `IX_EstadoPro` (`EstadoPro`);

--
-- Indices de la tabla `PROVEEDORES`
--
ALTER TABLE `PROVEEDORES`
  ADD PRIMARY KEY (`IdPersonas`),
  ADD UNIQUE KEY `UI_Proveedor` (`Proveedor`),
  ADD KEY `Ref136` (`IdPersonas`);

--
-- Indices de la tabla `RUBROS`
--
ALTER TABLE `RUBROS`
  ADD PRIMARY KEY (`IdRubros`),
  ADD UNIQUE KEY `UX_Rubro` (`Rubro`),
  ADD KEY `IX_EstadoRub` (`EstadoRub`);

--
-- Indices de la tabla `VENTAS`
--
ALTER TABLE `VENTAS`
  ADD PRIMARY KEY (`IdVentas`,`IdPersonas`),
  ADD UNIQUE KEY `UI_IdVentas` (`IdVentas`),
  ADD KEY `IX_EstadoVen` (`EstadoVen`),
  ADD KEY `Ref813` (`IdPersonas`),
  ADD KEY `Ref240` (`IdEmpleados`);

--
-- Indices de la tabla `VENTASPRODUCTOS`
--
ALTER TABLE `VENTASPRODUCTOS`
  ADD PRIMARY KEY (`IdVentas`,`IdPersonas`,`IdProductos`),
  ADD KEY `IX_Cantidad` (`Cantidad`),
  ADD KEY `IX_PrecioVenta` (`PrecioVenta`),
  ADD KEY `Ref1117` (`IdProductos`),
  ADD KEY `Ref1034` (`IdVentas`,`IdPersonas`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `AUD_RUBROS`
--
ALTER TABLE `AUD_RUBROS`
  MODIFY `Id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT de la tabla `COMPRAS`
--
ALTER TABLE `COMPRAS`
  MODIFY `IdCompras` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `PERSONAS`
--
ALTER TABLE `PERSONAS`
  MODIFY `IdPersonas` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
--
-- AUTO_INCREMENT de la tabla `PRODUCTOS`
--
ALTER TABLE `PRODUCTOS`
  MODIFY `IdProductos` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT de la tabla `VENTAS`
--
ALTER TABLE `VENTAS`
  MODIFY `IdVentas` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `CLIENTES`
--
ALTER TABLE `CLIENTES`
  ADD CONSTRAINT `RefFISICAS38` FOREIGN KEY (`IdPersonas`) REFERENCES `FISICAS` (`IdPersonas`);

--
-- Filtros para la tabla `COMPRAS`
--
ALTER TABLE `COMPRAS`
  ADD CONSTRAINT `RefEMPLEADOS39` FOREIGN KEY (`IdEmpleados`) REFERENCES `EMPLEADOS` (`IdPersonas`),
  ADD CONSTRAINT `RefPROVEEDORES12` FOREIGN KEY (`IdPersonas`) REFERENCES `PROVEEDORES` (`IdPersonas`);

--
-- Filtros para la tabla `COMPRASPRODUCTOS`
--
ALTER TABLE `COMPRASPRODUCTOS`
  ADD CONSTRAINT `RefCOMPRAS32` FOREIGN KEY (`IdCompras`,`IdPersonas`) REFERENCES `COMPRAS` (`IdCompras`, `IdPersonas`),
  ADD CONSTRAINT `RefPRODUCTOS16` FOREIGN KEY (`IdProductos`) REFERENCES `PRODUCTOS` (`IdProductos`);

--
-- Filtros para la tabla `EMPLEADOS`
--
ALTER TABLE `EMPLEADOS`
  ADD CONSTRAINT `RefCARGOS22` FOREIGN KEY (`IdCargos`) REFERENCES `CARGOS` (`IdCargos`),
  ADD CONSTRAINT `RefFISICAS37` FOREIGN KEY (`IdPersonas`) REFERENCES `FISICAS` (`IdPersonas`);

--
-- Filtros para la tabla `FISICAS`
--
ALTER TABLE `FISICAS`
  ADD CONSTRAINT `RefPERSONAS35` FOREIGN KEY (`IdPersonas`) REFERENCES `PERSONAS` (`IdPersonas`);

--
-- Filtros para la tabla `PRODUCTOS`
--
ALTER TABLE `PRODUCTOS`
  ADD CONSTRAINT `RefRUBROS23` FOREIGN KEY (`IdRubros`) REFERENCES `RUBROS` (`IdRubros`);

--
-- Filtros para la tabla `PROVEEDORES`
--
ALTER TABLE `PROVEEDORES`
  ADD CONSTRAINT `RefPERSONAS36` FOREIGN KEY (`IdPersonas`) REFERENCES `PERSONAS` (`IdPersonas`);

--
-- Filtros para la tabla `VENTAS`
--
ALTER TABLE `VENTAS`
  ADD CONSTRAINT `RefCLIENTES13` FOREIGN KEY (`IdPersonas`) REFERENCES `CLIENTES` (`IdPersonas`),
  ADD CONSTRAINT `RefEMPLEADOS40` FOREIGN KEY (`IdEmpleados`) REFERENCES `EMPLEADOS` (`IdPersonas`);

--
-- Filtros para la tabla `VENTASPRODUCTOS`
--
ALTER TABLE `VENTASPRODUCTOS`
  ADD CONSTRAINT `RefPRODUCTOS17` FOREIGN KEY (`IdProductos`) REFERENCES `PRODUCTOS` (`IdProductos`),
  ADD CONSTRAINT `RefVENTAS34` FOREIGN KEY (`IdVentas`,`IdPersonas`) REFERENCES `VENTAS` (`IdVentas`, `IdPersonas`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
