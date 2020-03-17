DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_altaPersona`(pIdPersonas bigint)
SALIR:BEGIN
	/*
    Permite cambiar el estado de una Persona a A: Activo siempre y cuando no esté 
    activo ya. Controla parametros. Devuelve OK o el mensaje de error en Mensaje.
	*/
    
  -- Controla parametros
    IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'Persona es necesaria.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    -- Controlar si existe
    IF NOT EXISTS(SELECT IdPersonas FROM PERSONAS WHERE IdPersonas = pIdPersonas) THEN 
		SELECT 'Persona que quiere modificar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    
    -- Controlar Persona no activo ya
    IF EXISTS(SELECT IdPersonas FROM PERSONAS WHERE IdPersonas = pIdPersonas
						AND EstadoPer = 'A') THEN
		SELECT 'La persona ya está activa.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
	-- Activa
    UPDATE PERSONAS SET EstadoPer = 'A' WHERE IdPersonas = pIdPersonas;
	SELECT 'OK' AS Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_altaProducto`(pIdProductos bigint)
SALIR:BEGIN
	/*
    Permite cambiar el estado de un Producto a A: Activo siempre y cuando no esté 
    activo ya. Controla parametros. Controla que exista. 
    Devuelve OK o el mensaje de error en Mensaje.
	*/
    
    -- Controla parametros
    IF pIdProductos IS NULL OR pIdProductos = 0 THEN
		SELECT 'Producto es obligatorio.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
	-- Controlar si existe
    IF NOT EXISTS(SELECT IdProductos FROM PRODUCTOS 
    WHERE IdProductos = pIdProductos) THEN 
		SELECT 'Producto que quiere modificar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    
    -- Controlar Producto no activo ya
    IF EXISTS(SELECT IdProductos FROM PRODUCTOS 
    WHERE IdProductos = pIdProductos AND EstadoPro = 'A') THEN
		SELECT 'Producto ya está activo.' AS Mensaje;
        LEAVE SALIR;
	END IF;
	
    UPDATE PRODUCTOS SET EstadoPro = 'A' WHERE IdProductos = pIdProductos;
    SELECT 'OK' AS Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_autocompletarEmpleado`(pCadena varchar(100), pIncluyeBajas char(1))
BEGIN
/*
    Permite listar todos los empleados que cumplan con la condición de 
    autocompletar de la cadena de búsqueda que coincida con el nombre de 
    usuario del empleado, apellido o correo. Puede incluir o no los dados de baja 
    (pIncluyeBajas: S: SI - N: No). Busca a partir del 
    cuarto caracter y ordena por apellidos, luego por nombres. Limita a 20.
*/
    SELECT		e.IdPersonas,
				CONCAT(f.Apellidos,', ',f.Nombres,' (',
                e.Usuario,')') Empleado
    FROM		FISICAS f INNER JOIN EMPLEADOS e ON f.IdPersonas = e.IdPersonas
				INNER JOIN PERSONAS p ON f.IdPersonas = p.IdPersonas
    WHERE		(f.Apellidos LIKE CONCAT(pCadena,'%') OR
				e.Usuario LIKE CONCAT(pCadena,'%') OR
                f.Nombres LIKE CONCAT(pCadena,'%'))
                AND CHAR_LENGTH(pCadena) > 3 AND
                (pIncluyeBajas = 'S' OR p.EstadoPer = 'A')
	ORDER BY	f.Apellidos, f.Nombres
    LIMIT		20;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_autocompletarProveedor`(pCadena varchar(100), pIncluyeBajas char(1))
BEGIN
/*
    Permite listar todos los Proveedores que cumplan con la condición de 
    autocompletar de la cadena de búsqueda que coincida con el nombre del 
    Proveedor. Puede incluir o no los dados de baja 
    (pIncluyeBajas: S: SI - N: No). Busca a partir del 
    cuarto caracter y ordena por Rubro. Limita a 20.
*/
    SELECT		pr.Proveedor, pe.EstadoPer
    FROM		PROVEEDORES pr INNER JOIN PERSONAS pe 
    ON			pr.IdPersonas = pe.IdPersonas
    WHERE		(pr.Proveedor LIKE CONCAT(pCadena,'%'))
                AND (CHAR_LENGTH(pCadena) > 3) AND
                (pIncluyeBajas = 'S' OR pe.EstadoPer = 'A')
	ORDER BY	pr.Proveedor
    LIMIT		20;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_bajaPersona`(pIdPersonas bigint)
SALIR:BEGIN
	/*
    Permite cambiar el estado de una Persona a B: Baja siempre y cuando no esté dado de 
    baja ya. No se puede dar de baja el administrador (pIdEmpleado = 8). Controla parametros.
    Devuelve OK o el mensaje de error en Mensaje.
	*/
	-- Controla parametros
	IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'La persona es obligatoria.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
   -- Controlar si existe
    IF NOT EXISTS(SELECT IdPersonas FROM PERSONAS WHERE IdPersonas = pIdPersonas) THEN 
		SELECT 'La persona no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;

    -- Controlar no dado de baja
    IF EXISTS( SELECT IdPersonas FROM PERSONAS WHERE IdPersonas = pIdPersonas 
			AND EstadoPer = 'B') THEN SELECT 'La persona ya está dada de baja.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    -- Controlar cuenta del sistema.
    IF pIdPersonas = 8 THEN
		SELECT 'No puede dar de baja la persona. Es una cuenta del sistema.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
	-- Da de baja
    UPDATE PERSONAS SET EstadoPer = 'B' WHERE IdPersonas = pIdPersonas;
    SELECT 'OK' AS Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_bajaProducto`(pIdProductos bigint)
SALIR:BEGIN
	/*
    Permite cambiar el estado de un Producto a B: Baja siempre y cuando exista y 
    no esté dado de baja. Controla parametros. 
    Devuelve OK o el mensaje de error en Mensaje.
	*/
    
    -- Controla parametros
    IF pIdProductos IS NULL OR pIdProductos = 0 THEN
		SELECT 'Producto es obligatorio.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
   -- Controlar si existe
    IF NOT EXISTS(SELECT IdProductos FROM PRODUCTOS WHERE 
    IdProductos = pIdProductos) THEN 
    SELECT 'Producto que quiere modificar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;

    
    -- Controlar Producto no dado de baja
    IF EXISTS( SELECT IdProductos FROM PRODUCTOS 
	WHERE (IdProductos = pIdProductos AND EstadoPro = 'B')) THEN 
		SELECT 'Producto ya está dado de baja.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
	-- Da de baja
    UPDATE PRODUCTOS SET EstadoPro = 'B' WHERE IdProductos = pIdProductos;
    SELECT 'OK' AS Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_borrarCompra`(pIdCompras bigint)
SALIR:BEGIN
/*
    Permite borrar la compra, si no esta asociada a ComprasProductos. Controla parametros. 
    Controla que no este completa. Controla que exista. 
    Devuelve OK o el mensaje de error en Mensaje.
*/
    
    -- Controla parametros
	IF pIdCompras IS NULL OR pIdCompras = 0 THEN
		SELECT 'La compra es obligatoria.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
    END IF;

   -- Controlar si existe
    IF NOT EXISTS(SELECT IdCompras FROM COMPRAS WHERE IdCompras = pIdCompras) 
    THEN SELECT 'La compra que quiere borrar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
        
    -- Controlo asociaciones.
    IF EXISTS(SELECT IdCompras FROM COMPRASPRODUCTOS WHERE IdCompras = pIdCompras) THEN
		SELECT 'No puede borrar la compra. Existen compras de productos asociadas.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    -- Controlo que la compra no este completa.
    IF EXISTS(SELECT IdCompras FROM COMPRAS 
    WHERE (IdCompras = pIdCompras AND EstadoCom = 'C')) THEN 
		SELECT 'No se puede borrar una compra ya concretada.' AS Mensaje;
        LEAVE SALIR;
	END IF;

    DELETE FROM COMPRAS WHERE IdCompras = pIdCompras;
    SELECT 'OK' AS Mensaje;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_borrarCompraProducto`(pIdCompras bigint, pIdProductos bigint)
SALIR:BEGIN
/*
	Permite borrar la CompraProducto si no esta completa. Controla que exista. 
    Controla parametros. Devuelve OK o el mensaje de error en Mensaje.
*/

   DECLARE IdProv bigint;
    -- Manejo de error de la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SHOW ERRORS;
		-- SELECT 'Error en la transacción. Contáctese con el administrador' Mensaje ;
        ROLLBACK;
    END;
    
    -- Control de parámetros
    IF pIdCompras IS NULL OR pIdCompras = 0 THEN
		SELECT 'La compra es obligatoria.' AS Mensaje ;
        LEAVE SALIR;
    END IF;
    
    IF pIdProductos IS NULL OR pIdProductos = 0 THEN
		SELECT 'El producto es obligatorio.' AS Mensaje ;
        LEAVE SALIR;
    END IF;
        
	-- Controlo que exista y chequeo que no este completa.
	IF NOT EXISTS(SELECT cp.IdCompras,cp.IdProductos FROM COMPRASPRODUCTOS cp INNER JOIN COMPRAS c
    ON cp.IdCompras = c.IdCompras 
    WHERE (pIdCompras = cp.IdCompras AND pIdProductos = cp.IdProductos AND c.EstadoCom = 'I'))
    	THEN SELECT 'La compra de productos que quiere borrar no existe o ya se concreto.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
	    
	START TRANSACTION;
		-- Obtengo proveedor.
		SET IdProv = (SELECT IdPersonas FROM COMPRAS WHERE IdCompras = pIdCompras);
		-- Borramos
		DELETE FROM COMPRASPRODUCTOS 
        WHERE (IdCompras = pIdCompras AND IdProductos = pIdProductos AND IdPersonas = IdProv);
		SELECT 'OK' AS Mensaje;
	COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_borrarEmpleado`(pIdPersonas bigint)
SALIR:BEGIN
	/*
    Permite borrar un Empleado controlando que no tenga ventas ni compras 
    asociadas. No puede borrar el IdPersonas = 8, reservado para administrador. 
    Controla parametros ingresados. Controla que exista.
    Devuelve OK o el mensaje de error en Mensaje. 
	*/
    
    -- Controla parametros
	IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'El empleado es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
       
   -- Controlar si existe
    IF NOT EXISTS(SELECT IdPersonas FROM EMPLEADOS WHERE IdPersonas = pIdPersonas) 
    THEN SELECT 'El empleado que quiere borrar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;

    -- Controla cuenta del sistema
    IF pIdPersonas = 8 THEN
		SELECT 'No puede borrar el empleado. Es una cuenta del sistema.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
	-- Controla que no hayan ventas asociadas.
    IF EXISTS(SELECT IdEmpleados FROM VENTAS WHERE IdEmpleados = pIdPersonas) THEN
		SELECT 'No puede borrar el empleado. Existen ventas asociadas.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    -- Controla que no hayan compras asociadas.
    IF EXISTS(SELECT IdEmpleados FROM COMPRAS WHERE IdEmpleados = pIdPersonas) THEN
		SELECT 'No puede borrar el empleado. Existen compras asociadas.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    DELETE FROM EMPLEADOS WHERE IdPersonas = pIdPersonas;
    SELECT 'OK' AS Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_borrarFisica`(pIdPersonas bigint)
SALIR:BEGIN
/*
    Permite borrar una persona Fisica controlando que no tenga ocurrencias en las tablas 
    Clientes o Empleados. No puede borrar el IdPersona = 8, reservado para administrador.  
    Controla parametros. Controla que exista.
    Devuelve OK o el mensaje de error en Mensaje.
*/
    
    -- Controla parametros
	IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'La persona es obligatoria.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
    END IF;

   -- Controlar si existe
    IF NOT EXISTS(SELECT IdPersonas FROM FISICAS WHERE IdPersonas = pIdPersonas) 
    THEN SELECT 'La persona fisica que quiere borrar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    
   -- Controlo cuenta del sistema. 
    IF pIdPersonas = 8 THEN
		SELECT 'No puede borrar la persona fisica. Es una cuenta del sistema.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    -- Controlo asociaciones.
    IF EXISTS(SELECT IdPersonas FROM CLIENTES WHERE IdPersonas = pIdPersonas) THEN
		SELECT 'No puede borrar la persona. Existen clientes asociados.' AS Mensaje;
        LEAVE SALIR;
	END IF;
        
    IF EXISTS(SELECT IdPersonas FROM EMPLEADOS WHERE IdPersonas = pIdPersonas) THEN
		SELECT 'No puede borrar la persona. Existen empleados asociados.' AS Mensaje;
        LEAVE SALIR;
	END IF;
	
    DELETE FROM FISICAS WHERE IdPersonas = pIdPersonas;
    SELECT 'OK' AS Mensaje;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_borrarPersona`(pIdPersonas bigint)
SALIR:BEGIN
	/*
    Permite borrar una Persona controlando que no tenga ocurrencias en las tablas Clientes, 
    Proveedores o Empleados. No puede borrar el IdPersona = 8, reservado para administrador.
    Controla parametros. Controla que exista. Devuelve OK o el mensaje de error en Mensaje.
	*/
    
    -- Controla parametros
	IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'La persona es obligatoria.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
    END IF;

   -- Controlar si existe
    IF NOT EXISTS(SELECT IdPersonas FROM PERSONAS WHERE IdPersonas = pIdPersonas) 
    THEN SELECT 'La persona que quiere borrar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    
   -- Controlo cuenta del sistema. 
    IF pIdPersonas = 8 THEN
		SELECT 'No puede borrar la persona. Es una cuenta del sistema.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    -- Controlo asociaciones.
    IF EXISTS(SELECT IdPersonas FROM CLIENTES WHERE IdPersonas = pIdPersonas) THEN
		SELECT 'No puede borrar la persona. Existen clientes asociados.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
	IF EXISTS(SELECT IdPersonas FROM PROVEEDORES WHERE IdPersonas = pIdPersonas) THEN
		SELECT 'No puede borrar la persona. Existen proveedores asociados.' AS Mensaje;
        LEAVE SALIR;
	END IF;    
    
    IF EXISTS(SELECT IdPersonas FROM EMPLEADOS WHERE IdPersonas = pIdPersonas) THEN
		SELECT 'No puede borrar la persona. Existen empleados asociados.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    DELETE FROM PERSONAS WHERE IdPersonas = pIdPersonas;
    
    SELECT 'OK' AS Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_borrarProducto`(pIdProductos bigint)
SALIR:BEGIN
/*
    Permite borrar el producto, si no esta asociado a compras o ventas.  
    Controla parametros. Controla si existe. 
    Devuelve OK o el mensaje de error en Mensaje.
*/
    -- Manejo de error de la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- SHOW ERRORS;
		SELECT 'Error en la transacción. Contáctese con el administrador' Mensaje;
        ROLLBACK;
    END;
    
	-- Controla parametros
	IF pIdProductos IS NULL OR pIdProductos = 0 THEN
		SELECT 'El producto es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
	-- Controlar si existe
    IF NOT EXISTS(SELECT IdProductos FROM PRODUCTOS WHERE IdProductos = pIdProductos) 
    THEN SELECT 'El producto que quiere borrar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;

	-- Controla que no este en uso por compras.
	IF EXISTS(SELECT IdProductos FROM COMPRASPRODUCTOS WHERE IdProductos = pIdProductos) 
    THEN SELECT 'No puede borrar producto. Existen compras asociadas.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    -- Controla que no este en uso por ventas.
    IF EXISTS(SELECT IdProductos FROM VENTASPRODUCTOS WHERE IdProductos = pIdProductos) 
    THEN SELECT 'No puede borrar producto. Existen ventas asociadas.' AS Mensaje;
        LEAVE SALIR;
	END IF;

		-- Borramos
		DELETE FROM PRODUCTOS WHERE IdProductos = pIdProductos;
        SELECT 'OK' Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_borrarProveedor`(pIdPersonas bigint)
SALIR:BEGIN
	/*
    Permite borrar un Proveedor, mientras no existan compras  asociadas. 
    Controla parametros. Controla que exista. 
    Devuelve OK o el mensaje de error en Mensaje.
	*/
   
   -- Controla parametros
	IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'El Proveedor es obligatorio.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
    END IF;
    
     -- Controlar si existe
    IF NOT EXISTS(SELECT IdPersonas FROM PROVEEDORES WHERE IdPersonas = pIdPersonas) 
    THEN SELECT 'El proveedor que quiere borrar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
  
   -- Controlamos que no existan ventas asociadas
    IF EXISTS(SELECT IdPersonas FROM COMPRAS WHERE IdPersonas = pIdPersonas) THEN
		SELECT 'No puede borrar el Proveedor. Existen compras asociadas.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
   -- Borramos
	DELETE FROM PROVEEDORES WHERE IdPersonas = pIdPersonas;    
    SELECT 'OK' AS Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_buscarAvanzadoCompra`(pFechaIni date, pFechaFin date,
					pIdPersona BIGINT, pIdEmpleado BIGINT, pEstadoCom char(1))
BEGIN
	/* Procedimiento que permite buscar las compras entre fechas, filtrando por 
    proveedor (pIdPersona = 0 no filtra), por empleado (pIdEmpleado = 0 no filtra) y
    por estado (pEstado = 'T' no filtra). Ordena por fecha
    */
    DECLARE pAux date;
	-- Controla fechas
    IF pFechaIni > pFechaFin THEN
		SET pAux = pFechaIni;
        SET pFechaIni = pFechaFin;
        SET pFechaFin = pAux;
	END IF;
    
    SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	/*No bloquea*/
    
    SELECT		c.IdCompras, c.IdPersonas IdProveedores, c.IdEmpleados, c.FechaCompra,
				CASE c.EstadoCom WHEN 'I' THEN 'Incompleta' WHEN 'C' THEN 'Completa' END Estado,
                e.Usuario, p.Proveedor
	FROM		COMPRAS c INNER JOIN PROVEEDORES p ON c.IdPersonas = p.IdPersonas
				INNER JOIN EMPLEADOS e ON c.IdEmpleados = e.IdPersonas
	WHERE		c.FechaCompra BETWEEN pFechaIni AND CONCAT(pFechaFin, ' 23:59:59') AND
				(pIdPersona = 0 OR c.IdPersonas = pIdPersona) AND
                (pIdEmpleado = 0 OR c.IdEmpleados = pIdEmpleado) AND
                (pEstadoCom = 'T' OR c.EstadoCom = pEstadoCom)
	ORDER BY	c.FechaCompra;
    
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;	/*Bloquea entre lecturas. Es el isolation level por defecto del motor.*/
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_buscarEmpleado`(pCadena varchar(100), pIncluyeBajas char(1))
BEGIN
	/*
	Permite buscar los empleados que contengan una parte del apellido, usuario o correo. 
    Ordena por apellidos, luego por nombres. 
    Puede incluir o no los dados de baja (pIncluyeBajas: S: SI - N: No). 
    */
    
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    SELECT		f.Apellidos, f.Nombres, c.Cargo, e.Usuario, e.FechaIngreso
    
    FROM		(PERSONAS p INNER JOIN FISICAS f ON  p.IdPersonas = f.IdPersonas)
				INNER JOIN EMPLEADOS e ON f.IdPersonas = e.IdPersonas INNER JOIN
				CARGOS c ON e.IdCargos = c.IdCargos
                
    WHERE		(f.Apellidos LIKE CONCAT(pCadena,'%') OR
				f.Nombres LIKE CONCAT(pCadena,'%') OR
                e.Usuario LIKE CONCAT(pCadena,'%')) AND
                (pIncluyeBajas = 'S' OR p.EstadoPer = 'A')
	
    ORDER BY	f.Apellidos, f.Nombres;    
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_buscarProveedor`(pCadena varchar(100), pIncluyeBajas char(1))
BEGIN
	/*
	Permite buscar las Proveedores que contengan una parte del nombre. 
    Ordena por nombre. Puede incluir o no los dados de baja (pIncluyeBajas: S: SI - N: No). 
    Para todos, cadena vacía.  
    */
    
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    SELECT		pr.Proveedor, pe.EstadoPer
    FROM		PROVEEDORES pr INNER JOIN PERSONAS pe 
    ON			pr.IdPersonas = pe.IdPersonas
    WHERE		(pr.Proveedor LIKE CONCAT(pCadena,'%')) AND
                (pIncluyeBajas = 'S' OR pe.EstadoPer = 'A')
	ORDER BY	pr.Proveedor;
    
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_calcularStock`(pIdProductos bigint)
SALIR:BEGIN
/*
	Indica el stock actual de un producto. 
    Controla que la compra este completa, que el producto exista y este activo.
    Devuelve el Stock del producto o el mensaje de error en Mensaje.
*/
DECLARE Stock bigint;

	-- Control de parámetros
    IF pIdProductos IS NULL OR pIdProductos = 0 THEN
		SELECT 'El producto es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
   -- Controlo que el producto exista y no este dado de baja.
    IF NOT EXISTS(SELECT IdProductos FROM PRODUCTOS 
    WHERE (IdProductos = pIdProductos AND EstadoPro = 'A')) THEN 
		SELECT 'El producto no existe o esta dado de baja.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
START TRANSACTION;
	-- Calculo el stock
	SET Stock = (SELECT SUM(Cantidad) FROM COMPRASPRODUCTOS cp INNER JOIN COMPRAS c
				ON cp.IdCompras = c.IdCompras
                WHERE (cp.IdProductos = pIdProductos AND c.EstadoCom = 'C'));
                
	SELECT (SELECT Producto FROM PRODUCTOS WHERE IdProductos = pIdProductos)AS Producto, Stock AS Stock;
COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_dameCompra`(pIdCompras bigint)
SALIR:BEGIN
/*
    Procedimiento que sirve para instanciar una Compra de la base de datos. 
    Controlamos parametros. Controla que exista.
*/
    -- Controla parametros
	IF pIdCompras IS NULL OR pIdCompras = 0 THEN
		SELECT 'La compra es obligatoria.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
	-- Controlar si existe
    IF NOT EXISTS(SELECT IdCompras FROM COMPRAS WHERE IdCompras = pIdCompras) 
    THEN SELECT 'La compra que quiere instanciar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;

    
    SELECT	*
    FROM	COMPRAS
    WHERE	IdCompras = pIdCompras;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_dameCompraProducto`(pIdCompras bigint, pIdProductos bigint)
SALIR:BEGIN
/*
    Procedimiento que sirve para instanciar una Compra de la base de datos. 
    Controlamos parametros. Controlamos que exista.
*/
DECLARE IdProv bigint;
    -- Controla parametros
	IF pIdCompras IS NULL OR pIdCompras = 0 THEN
		SELECT 'La compra es obligatoria.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    IF pIdProductos IS NULL OR pIdProductos = 0 THEN
		SELECT 'El producto es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
	-- Controlar si existe
    IF NOT EXISTS(SELECT IdCompras, IdProductos FROM COMPRASPRODUCTOS 
    WHERE (IdCompras = pIdCompras AND IdProductos = pIdProductos)) 
    THEN SELECT 'La compra producto que quiere instanciar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;

START TRANSACTION;
	SET IdProv = (SELECT IdPersonas FROM COMPRAS WHERE IdCompras = pIdCompras);
    SELECT	*
    FROM	COMPRASPRODUCTOS
	WHERE (IdCompras = pIdCompras AND IdProductos = pIdProductos AND IdPersonas = IdProv);
COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_dameEmpleado`(pIdPersonas bigint)
SALIR:BEGIN
/*
    Procedimiento que sirve para instanciar un Empleado desde la base de datos. 
    Controla parametros. Controlamos que exista.
*/
    
	-- Controla parametros
	IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'El empleado es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
       -- Controlar si existe
    IF NOT EXISTS(SELECT IdPersonas FROM EMPLEADOS WHERE IdPersonas = pIdPersonas) 
    THEN SELECT 'El empleado que quiere instanciar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;

    SELECT	*
    FROM	EMPLEADOS
    WHERE	IdPersonas = pIdPersonas;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_dameFisica`(pIdPersonas bigint)
SALIR:BEGIN
/*
	Procedimiento que sirve para instanciar una Persona fisica desde la base de datos. 
    Controla parametros. Controla que exista.
*/

	-- Controla parametros
	IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'La persona es obligatoria.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
   -- Controlar si existe
    IF NOT EXISTS(SELECT IdPersonas FROM FISICAS WHERE IdPersonas = pIdPersonas) 
    THEN SELECT 'La persona que quiere instanciar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;

    SELECT	*
    FROM	FISICAS
    WHERE	IdPersonas = pIdPersonas;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_damePersona`(pIdPersonas bigint)
SALIR:BEGIN
/*
	Procedimiento que sirve para instanciar una Persona desde la base de datos. 
    Controla parametros. Controla que exista.
*/

	-- Controla parametros
	IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'La persona es obligatoria.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
   -- Controlar si existe
    IF NOT EXISTS(SELECT IdPersonas FROM PERSONAS WHERE IdPersonas = pIdPersonas) 
    THEN SELECT 'La persona que quiere instanciar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;

    SELECT	*
    FROM	PERSONAS
    WHERE	IdPersonas = pIdPersonas;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_dameProducto`(pIdProductos bigint)
SALIR:BEGIN
/*
    Procedimiento que sirve para instanciar un Producto de la base de datos. 
    Controla parametros. Controla que exista.
*/
    
    -- Controla parametros
	IF pIdProductos IS NULL OR pIdProductos = 0 THEN
		SELECT 'El producto es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
   -- Controlar si existe
    IF NOT EXISTS(SELECT IdProductos FROM PRODUCTOS WHERE IdProductos = pIdProductos) 
    THEN SELECT 'El producto que quiere instanciar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;

    SELECT	*
    FROM	PRODUCTOS
    WHERE	IdProductos = pIdProductos;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_dameProveedor`(pIdPersonas bigint)
SALIR:BEGIN
	/*
    Procedimiento que sirve para instanciar un Proveedores desde la base de datos.
    Controla parametros. Controla que exista.
    */
    
    -- Controla parametros
	IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'El proveedor es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
   -- Controlar si existe
    IF NOT EXISTS(SELECT IdPersonas FROM PROVEEDORES WHERE IdPersonas = pIdPersonas) 
    THEN SELECT 'El proveedor que quiere instanciar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    
    SELECT	*
    FROM	PROVEEDORES
    WHERE	IdPersonas = pIdPersonas;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_insertarCompra`(pIdPersonas bigint, pIdEmpleados bigint)
SALIR:BEGIN
/*
	Permite insertar una Compra  controlando que los parametros ingresados sean correctos,
    que las personas involucradas existan y esten dadas de alta. 
    Crea en estado 'I':Incompleto y con fecha NOW(). Controla parametros. 
    Devuelve OK + Id o el mensaje de error en Mensaje.
*/

DECLARE pIdCompras bigint;

    -- Manejo de error de la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- SHOW ERRORS;
		SELECT 'Error en la transacción. Contáctese con el administrador' Mensaje, NULL AS Id;
        ROLLBACK;
    END;
    
    -- Control de parámetros
    IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'El proveedor es obligatorio.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
    END IF;
    
    IF pIdEmpleados IS NULL OR pIdEmpleados = 0 THEN
		SELECT 'El empleado es obligatorio.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
    END IF;
    
    -- Controlo que proveedor exista  y no este dado de baja.
    IF NOT EXISTS(SELECT pr.IdPersonas FROM PROVEEDORES pr INNER JOIN PERSONAS pe 
	ON pr.IdPersonas = pe.IdPersonas 
    WHERE (pr.IdPersonas = pIdPersonas AND pe.EstadoPer = 'A'))
		THEN SELECT 'Proveedor no existe o esta dado de baja.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
	END IF;
    
	-- Controlo que empleado exista  y no este dado de baja.
    IF NOT EXISTS(SELECT e.IdPersonas FROM EMPLEADOS e INNER JOIN PERSONAS p
    ON e.IdPersonas = p.IdPersonas
    WHERE (e.IdPersonas = pIdEmpleados AND p.EstadoPer = 'A'))
		THEN SELECT 'Empleado no existe o esta dado de baja.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
	END IF;
    
    START TRANSACTION;
        -- Inserta
        INSERT INTO COMPRAS VALUES(0, pIdPersonas, pIdEmpleados,'I',now());
        -- Devuelve último insertado
        SET pIdCompras = LAST_INSERT_ID();
		SELECT 'OK' Mensaje, pIdCompras AS Id;
    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_insertarCompraProducto`(pIdCompras bigint, 
											pIdProductos bigint,pCantidad bigint, 
											pPrecio decimal(10,2))
SALIR:BEGIN
/*
	Permite insertar una CompraProducto  controlando que los parametros ingresados sean 
    correctos, que tanto la compra como el producto existan. El producto debe estar activo.
    Accedemos al proveedor que se introducio en la compra.
    Controla parametros. Devuelve OK o el mensaje de error en Mensaje.
*/

   DECLARE IdProv bigint;
    -- Manejo de error de la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- SHOW ERRORS;
		SELECT 'Error en la transacción. Contáctese con el administrador' Mensaje ;
        ROLLBACK;
    END;
    
    -- Control de parámetros
    IF pIdCompras IS NULL OR pIdCompras = 0 THEN
		SELECT 'La compra es obligatorio.' AS Mensaje ;
        LEAVE SALIR;
    END IF;
    
    IF pIdProductos IS NULL OR pIdProductos = 0 THEN
		SELECT 'El producto es obligatorio.' AS Mensaje ;
        LEAVE SALIR;
    END IF;
        
	IF pPrecio IS NULL OR pPrecio < 0 THEN
		SELECT 'El precio es obligatorio.' AS Mensaje ;
        LEAVE SALIR;
    END IF;
    
    IF pCantidad IS NULL OR pCantidad = 0 THEN
		SELECT 'La cantidad es obligatoria.' AS Mensaje ;
        LEAVE SALIR;
    END IF;
        
	-- Controlo que la compra exista.
    IF NOT EXISTS(SELECT IdCompras FROM COMPRAS WHERE IdCompras = pIdCompras) 
		THEN SELECT 'La compra no existe.' AS Mensaje;
        LEAVE SALIR;
    END IF;
        
    -- Controlo que el producto exista y no este dado de baja.
    IF NOT EXISTS(SELECT IdProductos FROM PRODUCTOS 
    WHERE (IdProductos = pIdProductos AND EstadoPro = 'A')) THEN 
		SELECT 'El producto no existe o esta dado de baja.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    START TRANSACTION;
		-- Accedemos al proveedor que se inserto en la compra.
		SET IdProv = (SELECT IdPersonas FROM COMPRAS WHERE IdCompras = pIdCompras);
        -- Inserta
        INSERT INTO COMPRASPRODUCTOS VALUES(pIdCompras,IdProv, pIdProductos, pCantidad, pPrecio);
		SELECT 'OK' Mensaje;
    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_insertarEmpleado`(pIdPersonas bigint, pIdCargos tinyint, 
				pUsuario VARCHAR(15), pClave char(32), pConfirmacion char(32))
SALIR:BEGIN
/* 
	Inserta empleado controlando que los parametros ingresados sean correctos. 
	La clave tiene que tener como mínimo 6 caracteres, debe coincidir con su confirmación,  
    Usuario no debe existir. Persona debe estar en Alta y tener solo un cargo.
    Devuelve OK + Id o el mensaje de error en Mensaje.
*/
    -- Manejo de error de la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- SHOW ERRORS;
		SELECT 'Error en la transacción. Contáctese con el administrador' Mensaje;
        ROLLBACK;
    END;
    
    -- Control de parámetros
        IF pIdPersonas IS NULL OR pIdPersonas =0 THEN
		SELECT 'La persona es obligatoria.' AS Mensaje;
        LEAVE SALIR;
    END IF;

    IF pIdCargos IS NULL OR pIdCargos =0 THEN
		SELECT 'El cargo es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;

    IF pUsuario IS NULL OR pUsuario = '' THEN
		SELECT 'El usuario es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    IF CHAR_LENGTH(pClave) < 6 THEN
		SELECT 'La longitud de la clave debe ser mayor que 5 caracteres.' AS Mensaje;
        LEAVE SALIR;
	END IF;  

	-- Controlo que exista la persona.
    IF NOT EXISTS(SELECT IdPersonas FROM FISICAS WHERE IdPersonas = pIdPersonas) THEN
		SELECT 'La persona no existe.' AS Mensaje;
        LEAVE SALIR;
	END IF;
  
  -- Controlo que exista el Cargo.
    IF NOT EXISTS(SELECT IdCargos FROM CARGOS WHERE IdCargos = pIdCargos) THEN
		SELECT 'El cargo no existe.' AS Mensaje;
        LEAVE SALIR;
	END IF;
	
    -- Controlo que una persona tenga solo un cargo
    IF EXISTS(SELECT IdPersonas FROM EMPLEADOS WHERE IdPersonas = pIdPersonas) THEN
		SELECT 'Persona ya tiene un cargo.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
	-- Controlo que usuario no exista
    IF EXISTS( SELECT Usuario FROM EMPLEADOS WHERE Usuario = pUsuario) THEN
		SELECT 'Usuario ya existe.' AS Mensaje;
        LEAVE SALIR;
	END IF;

	-- Controlo que las contraseñas coincidan.
	IF pClave != pConfirmacion THEN
		SELECT 'La contraseña no coincide con la confirmación.' AS Mensaje;
        LEAVE SALIR;
	END IF;

	-- Controlo que la persona este dada de Alta.
    IF(SELECT IdPersonas FROM PERSONAS WHERE IdPersonas = pIdPersonas AND EstadoPer = 'B')
		THEN SELECT 'No se puede insertar el empleado. Persona dada de baja' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
	-- Controlo que el cargo este dado de Alta.
    IF(SELECT IdCargos FROM CARGOS WHERE IdCargos = pIdCargos AND EstadoCar = 'B')
		THEN SELECT 'No se puede insertar el empleado. Cargo dado de baja' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
        -- Inserta
        INSERT INTO EMPLEADOS VALUES(pIdPersonas, pIdCargos, pUsuario, md5(pClave),NOW());
		SELECT 'OK' Mensaje;
    
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_insertarFisica`(pIdPersonas bigint,pApellidos VARCHAR(40), pNombres VARCHAR(40))
SALIR:BEGIN
	/*
    Permite insertar una persona Fisica. Controla que los parametros sean correctos.
    Controla que la persona no este registrada. Controla que proveedor no sea fisica.
    Devuelve OK el mensaje de error en Mensaje.
	*/

    -- Manejo de error de la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- SHOW ERRORS;
		SELECT 'Error en la transacción. Contáctese con el administrador' Mensaje;
        ROLLBACK;
    END;
    
    -- Control de parámetros
    IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'La persona es obligatoria.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
    END IF;
    
    IF pApellidos IS NULL OR pApellidos = '' THEN
		SELECT 'El apellido es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    IF pNombres IS NULL OR pNombres = '' THEN
		SELECT 'El nombre es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
   -- Controlar si existe
    IF NOT EXISTS(SELECT IdPersonas FROM PERSONAS WHERE IdPersonas = pIdPersonas) 
    THEN SELECT 'La persona que quiere asociar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;

	-- Controlo que no se inserten proveedores como fisicas
    IF EXISTS(SELECT IdPersonas FROM PROVEEDORES WHERE IdPersonas = pIdpersonas) THEN
		SELECT 'No corresponde a una persona fisica.' AS Mensaje;
        LEAVE SALIR;
    END IF;

    -- Controlo que la persona no tenga asociada una Fisica ya
    IF EXISTS(SELECT IdPersonas FROM FISICAS WHERE IdPersonas = pIdpersonas) THEN
		SELECT 'Ya existe esa persona fisica.' AS Mensaje;
        LEAVE SALIR;
    END IF;

        -- Inserta
        INSERT INTO FISICAS VALUES(pIdPersonas, pApellidos,pNombres);
		SELECT 'OK' Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_insertarPersona`(pTelefono int)
SALIR:BEGIN
	/*
    Permite insertar una Persona. Controla que los parametros sean correctos. 
    Lo crea en estado 'A'. Devuelve OK + Id o el mensaje de error en Mensaje.
	*/

DECLARE pIdPersonas bigint;

    -- Manejo de error de la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- SHOW ERRORS;
		SELECT 'Error en la transacción. Contáctese con el administrador' Mensaje, NULL AS Id;
        ROLLBACK;
    END;
    
    IF pTelefono IS NULL OR pTelefono <0 THEN
		SELECT 'El telefono es obligatorio.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
    END IF;
    
    START TRANSACTION;
        -- Inserta
        INSERT INTO PERSONAS VALUES(0, pTelefono, 'A');
        -- Devuelve último insertado
        SET pIdPersonas = LAST_INSERT_ID();
        
		SELECT 'OK' Mensaje, pIdPersonas AS Id;
    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_insertarProducto`(pIdRubros smallint, pProducto VARCHAR(60))
SALIR:BEGIN
/*
	Permite insertar un Producto controlando que el Rubro exista 
    y este activo. Controla que producto no se repita. 
    Lo crea en estado 'A'. Controla parametros ingresados.
    Devuelve OK + Id o el mensaje de error en Mensaje.
*/
DECLARE pIdProductos bigint;

    -- Manejo de error de la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- SHOW ERRORS;
		SELECT 'Error en la transacción. Contáctese con el administrador' Mensaje, NULL AS Id;
        ROLLBACK;
    END;
    
    -- Control de parámetros
    IF pIdRubros IS NULL OR pIdRubros = 0 THEN
		SELECT 'El rubro es obligatorio.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
    END IF;
  
	IF pProducto IS NULL OR pProducto = '' THEN
		SELECT 'El nombre del producto es obligatorio.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
	END IF;
    
    -- Controlo que rubro exista Y no este dado de baja
    IF (NOT EXISTS(SELECT IdRubros FROM RUBROS WHERE IdRubros = pIdRubros) OR 
		(SELECT EstadoRub FROM RUBROS WHERE IdRubros = pIdRubros) = 'B') THEN
		SELECT 'Rubro no existe o esta dado de baja.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
	END IF;
    
    -- Controlo que no exista ya ese producto.
    IF EXISTS( SELECT Producto FROM PRODUCTOS WHERE Producto = pProducto) THEN
		SELECT 'Producto existente.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
    END IF;
    
    START TRANSACTION;
        -- Inserta
        INSERT INTO PRODUCTOS VALUES(0, pIdRubros, pProducto,'A');
        -- Devuelve último insertado
        SET pIdProductos = LAST_INSERT_ID();
		SELECT 'OK' Mensaje, pIdProductos AS Id;
    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_insertarProveedor`(pIdPersonas bigint, pProveedor varchar(40))
SALIR:BEGIN
/*
	Permite insertar un Proveedor. Controla parametros, que el Proveedor no exista
	y que la persona este activa. Controlo que la persona no sea fisica.
    Devuelve OK o el mensaje de error en Mensaje.
*/
    -- Manejo de error de la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- SHOW ERRORS;
		SELECT 'Error en la transacción. Contáctese con el administrador' Mensaje;
        ROLLBACK;
    END;
    
    -- Control de parámetros
    IF pProveedor IS NULL OR pProveedor = '' THEN
		SELECT 'El proveedor es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'La persona es obligatoria.' AS Mensaje;
		LEAVE SALIR;
	END IF;
    
    -- Controlo que exista la persona.
    IF NOT EXISTS(SELECT IdPersonas FROM PERSONAS WHERE IdPersonas = pIdPersonas) THEN
		SELECT 'La persona no existe.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    -- Controlo que la persona este dada de Alta.
    IF(SELECT IdPersonas FROM PERSONAS WHERE IdPersonas = pIdPersonas AND EstadoPer = 'B')
		THEN SELECT 'No se puede insertar el proveedor. Persona dada de baja.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
	-- Controlo que no se ingrese dos veces una persona.
    IF EXISTS(SELECT IdPersonas FROM PROVEEDORES WHERE IdPersonas = pIdPersonas) THEN
		SELECT 'Persona ya esta registrada como proveedor.' AS Mensaje;
        LEAVE SALIR;
	END IF;
	
    -- Controlo que no se ingrese dos veces una persona.
	IF EXISTS(SELECT IdPersonas FROM FISICAS WHERE IdPersonas = pIdPersonas) THEN
		SELECT 'Persona ya esta registrada como fisica.' AS Mensaje;
        LEAVE SALIR;
	END IF;
	
    -- Controlo que no repita nombre
    IF EXISTS(SELECT Proveedor FROM PROVEEDORES WHERE Proveedor = pProveedor) THEN
		SELECT 'Proveedor existente.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
        -- Inserta
        INSERT INTO PROVEEDORES VALUES(pIdPersonas, pProveedor);
        -- Devuelve último insertado
		SELECT 'OK' Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_listarCargo`(pIncluyeBajas char(1))
SALIR:BEGIN
/*
	Permite listar los Cargos. Ordena por Cargo. 
    Puede incluir o no los dados de baja (pIncluyeBajas: S: SI - N: No). 
    Para todos, cadena vacía. 
*/
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    SELECT		*
    FROM		CARGOS
    WHERE		(pIncluyeBajas = 'S' OR EstadoCar = 'A')
	ORDER BY	Cargo;    
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_listarRubro`(pIncluyeBajas char(1))
BEGIN
	/*
	Permite listar los rubros.
    Ordena por Rubro. Para todos, cadena vacia.
    Puede incluir o no los dados de baja (pIncluyeBajas: S: SI - N: No). 
    */
    
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
    SELECT		*
    FROM		RUBROS
    WHERE		(pIncluyeBajas = 'S' OR EstadoRub = 'A')
	ORDER BY	Rubro;    
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_loginEmpleado`(pUsuario varchar(30), pClave VARCHAR(32))
SALIR:BEGIN
/*
	Permite iniciar la sesión controlando que  el nombre de usuario exista y el 
    empleado este activo. La clave debe coincidir con la almacenada. 
    Devuelve OK + los datos del empleado o mensaje de error en Login.
*/
    -- Controla parametros
     IF pUsuario IS NULL OR pUsuario = '' THEN
		SELECT 'El usuario es obligatorio.' AS Login;
        LEAVE SALIR;
    END IF;
    
	 IF pClave IS NULL OR pClave = '' THEN
		SELECT 'Clave es obligatoria.' AS Login;
        LEAVE SALIR;
    END IF;

	-- Controlar que el usuario exista y esté activo
    IF NOT EXISTS(
		SELECT e.Usuario 
        FROM EMPLEADOS e INNER JOIN PERSONAS p ON e.IdPersonas = p.IdPersonas
		WHERE e.Usuario = pUsuario AND p.EstadoPer = 'A') 
        THEN SELECT 'Empleado no existe o dado de baja.' AS Login;
        LEAVE SALIR;
	END IF;
    
    -- Controlar que la clave coincida
    IF NOT EXISTS(
		SELECT Usuario FROM EMPLEADOS 
		WHERE Usuario = pUsuario AND Clave = md5(pClave)) THEN
		SELECT 'Credenciales erróneas.' AS Login;
        LEAVE SALIR;
	END IF;
    
    -- Devolver campos
	SELECT	f.Apellidos, f.Nombres, e.Usuario, 'OK' AS Login
    FROM (EMPLEADOS e INNER JOIN FISICAS f ON e.IdPersonas = f.IdPersonas)
    WHERE (e.Usuario = pUsuario AND e.Clave = md5(pClave));
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_modificarClaveEmpleado`(pIdPersonas bigint, pClaveAnterior char(32), 
								pClaveActual varchar(30), pConfirmacion varchar(30))
SALIR:BEGIN
	/*
    Permite modificar la contraseña de un Empleado activo y existente controlando que 
    la misma tenga como mínimo 6 caracteres. Esta debe coincidir 
    con su confirmación, y las credenciales ser correctas.  
    Controla parametros. Devuelve OK o el mensaje de error en Mensaje.
	*/
    -- Controlo parámetros
    IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'El empleado es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
	IF pClaveAnterior IS NULL OR pClaveAnterior = '' THEN
		SELECT 'Clave nueva es obligatoria.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
	IF pConfirmacion IS NULL OR pConfirmacion = '' THEN
		SELECT 'Confirmacion es obligatoria.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
	IF pClaveActual IS NULL OR pClaveActual = '' THEN
		SELECT 'Clave anterior es obligatoria.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    IF CHAR_LENGTH(pClaveActual) < 6 THEN
		SELECT 'La longitud de la clave nueva debe ser mayor que 5 caracteres.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    -- Controlamos que la clave coincida con la confirmacion
	IF pClaveActual != pConfirmacion THEN
		SELECT 'La contraseña no coincide con la confirmación.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    -- Controlar empleado existente y activo
    IF NOT EXISTS(
		SELECT e.IdPersonas 
		FROM EMPLEADOS e INNER JOIN PERSONAS p ON e.IdPersonas = p.IdPersonas
		WHERE e.IdPersonas = pIdPersonas AND p.EstadoPer = 'A') 
		THEN SELECT 'El empleado no existe o esta dado de baja.' AS Mensaje;
		LEAVE SALIR;
	END IF;
    
    -- Controlar contraseña existente
    IF NOT EXISTS(SELECT IdPersonas FROM EMPLEADOS WHERE IdPersonas = pIdPersonas
						AND Clave = md5(pClaveAnterior)) THEN
		SELECT 'Credenciales incorrectas.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
	-- Modifico clave
    UPDATE EMPLEADOS SET Clave = md5(pClaveActual) WHERE IdPersonas = pIdPersonas;
    SELECT 'OK' AS Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_modificarCompra`(pIdCompras bigint, pIdPersonas bigint
										, pIdEmpleados bigint)
SALIR:BEGIN
/*
	Permite modificar una Compra controlando que los parametros ingresados sean correctos,
    que las personas involucradas existan y esten dadas de alta. Toma la fecha de modificacion.
    Una compra no se puede modificar una vez que fue completada.
    Devuelve OK o el mensaje de error en Mensaje.
*/

    -- Manejo de error de la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- SHOW ERRORS;
		SELECT 'Error en la transacción. Contáctese con el administrador' Mensaje;
        ROLLBACK;
    END;
    
    -- Control de parámetros
    IF pIdCompras IS NULL OR pIdCompras = 0 THEN
		SELECT 'La compra es obligatoria.' AS Mensaje;
        LEAVE SALIR;
    END IF;
       
    IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'El proveedor es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    IF pIdEmpleados IS NULL OR pIdEmpleados = 0 THEN
		SELECT 'El empleado es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    -- Controlo que la compra exista.
    IF NOT EXISTS(SELECT IdCompras FROM COMPRAS WHERE IdCompras = pIdCompras) 
		THEN SELECT 'La compra no existe.' AS Mensaje;
        LEAVE SALIR;
    END IF;

   -- Controlo que proveedor exista  y no este dado de baja.
    IF NOT EXISTS(SELECT pr.IdPersonas FROM PROVEEDORES pr INNER JOIN PERSONAS pe 
	ON pr.IdPersonas = pe.IdPersonas 
    WHERE (pr.IdPersonas = pIdPersonas AND pe.EstadoPer = 'A'))
		THEN SELECT 'Proveedor no existe o esta dado de baja.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
	-- Controlo que empleado exista  y no este dado de baja.
    IF NOT EXISTS(SELECT e.IdPersonas FROM EMPLEADOS e INNER JOIN PERSONAS p
    ON e.IdPersonas = p.IdPersonas
    WHERE (e.IdPersonas = pIdEmpleados AND p.EstadoPer = 'A'))
		THEN SELECT 'Empleado no existe o esta dado de baja.' AS Mensaje;
        LEAVE SALIR;
	END IF;

	-- Controlo que la compra no se haya completado ya
    IF EXISTS(SELECT IdCompras FROM COMPRAS 
    WHERE (IdCompras = pIdCompras AND EstadoCom = 'C')) THEN 
		SELECT 'No se puede modificar una compra ya concretada.' AS Mensaje;
        LEAVE SALIR;
	END IF;


   -- Actualizar
    UPDATE	COMPRAS
    SET		IdPersonas = pIdPersonas, IdEmpleados = pIdEmpleados, FechaCompra = now()
	WHERE	IdCompras = pIdCompras;
    SELECT 'OK' AS Mensaje;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_modificarCompraProducto`(pIdComprasAnterior bigint, 
											pIdProductosAnterior bigint, pIdComprasActual bigint,
                                            pIdProductosActual bigint,pCantidad bigint, 
											pPrecio decimal(10,2))
SALIR:BEGIN
/*
	Permite modificar una CompraProducto controlando que los parametros ingresados sean 
    correctos. Primero ubicamos la compra, si es que esta existe,  
    con pIdComprasAnterior y pIdProductosAnterior y seteamos 
    pIdComprasActual y pIdProductosActual como nuevos valores.
    Chequeamos que no se pueda modificar una CompraProducto relacionada a una 
    compra ya concretada. El valor del proveedor se actualiza al actualizar la compra.
    Controla parametros. Devuelve OK o el mensaje de error en Mensaje.
*/

   DECLARE IdProv bigint;
   DECLARE IdProvAnterior bigint;
    -- Manejo de error de la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- SHOW ERRORS;
		SELECT 'Error en la transacción. Contáctese con el administrador' Mensaje ;
        ROLLBACK;
    END;
    
    -- Control de parámetros
    IF pIdComprasActual IS NULL OR pIdComprasActual = 0 THEN
		SELECT 'La nueva compra es obligatoria.' AS Mensaje ;
        LEAVE SALIR;
    END IF;
    
    IF pIdProductosActual IS NULL OR pIdProductosActual = 0 THEN
		SELECT 'El nuevo producto es obligatorio.' AS Mensaje ;
        LEAVE SALIR;
    END IF;
        
	IF pPrecio IS NULL OR pPrecio < 0 THEN
		SELECT 'El nuevo precio es obligatorio.' AS Mensaje ;
        LEAVE SALIR;
    END IF;
    
    IF pCantidad IS NULL OR pCantidad = 0 THEN
		SELECT 'La nueva cantidad es obligatoria.' AS Mensaje ;
        LEAVE SALIR;
    END IF;
        
	-- Encuentro la compra deseada y chequeo que no este completa.
	IF NOT EXISTS(SELECT cp.IdCompras, cp.IdProductos FROM COMPRASPRODUCTOS cp INNER JOIN COMPRAS c
    ON cp.IdCompras = c.IdCompras WHERE (pIdComprasAnterior = cp.IdCompras AND c.EstadoCom = 'I'
    AND pIdProductosAnterior = cp.IdProductos ))THEN 
		SELECT 'La compra y/o el producto anterior no coinciden o ya se concreto.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    -- Controlo que la nueva compra exista.
    IF NOT EXISTS(SELECT IdCompras FROM COMPRAS WHERE (IdCompras = pIdComprasActual AND EstadoCom = 'I')) 
		THEN SELECT 'La nueva compra no existe o ya se concreto.' AS Mensaje;
        LEAVE SALIR;
    END IF;
        
    -- Controlo que el producto exista y no este dado de baja.
    IF NOT EXISTS(SELECT IdProductos FROM PRODUCTOS 
    WHERE (IdProductos = pIdProductosActual AND EstadoPro = 'A')) THEN 
		SELECT 'El nuevo producto no existe o esta dado de baja.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    START TRANSACTION;
		-- Accedemos al proveedor anterior.
        SET IdProvAnterior = (SELECT IdPersonas FROM COMPRAS WHERE IdCompras = pIdComprasAnterior);
        -- Actualizamos el proveedor.
		SET IdProv = (SELECT IdPersonas FROM COMPRAS WHERE IdCompras = pIdComprasActual);
        -- Inserta
        UPDATE COMPRASPRODUCTOS 
        SET IdCompras = pIdComprasActual, IdPersonas = IdProv, 
			IdProductos = pIdProductosActual, Cantidad = pCantidad, PrecioCompra = pPrecio
		WHERE (IdCompras = pIdComprasAnterior AND IdProductos = pIdProductosAnterior
				AND IdPersonas = IdProvAnterior);
		SELECT 'OK' Mensaje;
    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_modificarFisica`(pIdPersonas bigint, pApellidos VARCHAR(40)
										, pNombres VARCHAR(40))
SALIR:BEGIN
/*
	Permite modificar una persona Fisica. Controla que exista. Controla parametros. 
	Devuelve OK o el mensaje de error en Mensaje.
*/
    
	    -- Control de parámetros
    IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'La persona es obligatoria.' AS Mensaje, NULL AS Id;
        LEAVE SALIR;
    END IF;
    
    IF pApellidos IS NULL OR pApellidos = '' THEN
		SELECT 'El apellido es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    IF pNombres IS NULL OR pNombres = '' THEN
		SELECT 'El nombre es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
   -- Controlar si existe
    IF NOT EXISTS(SELECT IdPersonas FROM FISICAS WHERE IdPersonas = pIdPersonas) 
    THEN SELECT 'La persona que quiere modificar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    
    -- Actualizo
    UPDATE	FISICAS
	SET		Apellidos = pApellidos, Nombres = pNombres
	WHERE	IdPersonas = pIdPersonas;
	SELECT 'OK' AS Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_modificarPersona`(pIdPersonas bigint, pTelefono int)
SALIR:BEGIN
	/*
		Permite modificar una Persona. Controla parametros. Controla que exista.
        Devuelve OK o el mensaje de error en Mensaje.
	*/
    
	-- Controlo parámetros
    IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'La persona es obligatoria.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    IF pTelefono IS NULL OR pTelefono < 0 THEN
		SELECT 'El telefono es obligatorio.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
   -- Controlar si existe
    IF NOT EXISTS(SELECT IdPersonas FROM PERSONAS WHERE IdPersonas = pIdPersonas) 
    THEN SELECT 'La persona que quiere modificar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    
    -- Actualizo
    UPDATE	PERSONAS
	SET		Telefono = pTelefono
	WHERE	IdPersonas = pIdPersonas;
	SELECT 'OK' AS Mensaje;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_modificarProducto`(pIdProductos bigint, pIdRubros smallint, pProducto VARCHAR(60))
SALIR:BEGIN
	/*
    Permite modificar un Producto. Controla que, tanto el producto como el rubro, 
    existan y esten activos Controla parametros ingresados. 
    Devuelve OK o el mensaje de error en Mensaje.
    */
    
    -- Manejo de error de la transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		-- SHOW ERRORS;
		SELECT 'Error en la transacción. Contáctese con el administrador' Mensaje;
        ROLLBACK;
    END;
    
    -- Control de parámetros
    IF pIdProductos IS NULL OR pIdProductos = 0 THEN
		SELECT 'El producto es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    IF pIdRubros IS NULL OR pIdRubros = 0 THEN
		SELECT 'El rubro es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    IF pProducto IS NULL OR pProducto = '' THEN
		SELECT 'El nombre del producto es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    -- Controlo que el producto exista y no este dado de baja.
    IF NOT EXISTS(SELECT IdProductos FROM PRODUCTOS 
    WHERE (IdProductos = pIdProductos AND EstadoPro = 'A')) THEN 
		SELECT 'El producto no existe o esta dado de baja.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
   -- Controlo que rubro exista y no este dado de baja
    IF NOT EXISTS(SELECT IdRubros FROM RUBROS 
    WHERE (IdRubros = pIdRubros AND EstadoRub = 'A')) THEN
		SELECT 'Rubro no existe o esta dado de baja.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    -- Controlo que no exista ya ese producto.
    IF EXISTS( SELECT Producto FROM PRODUCTOS WHERE Producto = pProducto) THEN
		SELECT 'Producto existente.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    

    -- Actualizar
    UPDATE	PRODUCTOS
    SET		IdRubros = pIdRubros, Producto= pProducto
	WHERE	IdProductos = pIdProductos;
    SELECT 'OK' AS Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_modificarProveedor`(pIdPersonas bigint, pProveedor varchar(40))
SALIR:BEGIN
	/*
		Permite cambiar nombre de un Proveedor. Controla que este exista. 
        Controla que no exista el nuevo nombre. Controla parametros ingresados.
        Devuelve OK o el mensaje de error en Mensaje.
	*/
    
	-- Controlo parámetros
    IF pIdPersonas IS NULL OR pIdPersonas = 0 THEN
		SELECT 'El proveedor es obligatorio.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    IF pProveedor IS NULL OR pProveedor = '' THEN
		SELECT 'El nuevo nombre es obligatorio.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    
    -- Controlar si el Proveedor existe
    IF NOT EXISTS(SELECT IdPersonas FROM PROVEEDORES WHERE IdPersonas = pIdPersonas) 
    THEN SELECT 'El proveedor que quiere modificar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    
    -- Controlar que no se repita nombre
    IF EXISTS(SELECT Proveedor FROM PROVEEDORES WHERE Proveedor = pProveedor) 
    THEN SELECT 'Ya existe ese proveedor.' AS Mensaje;
        LEAVE SALIR; 
	END IF;


    -- Actualizo
    UPDATE	PROVEEDORES
	SET		Proveedor = pProveedor
	WHERE	IdPersonas = pIdPersonas;
	SELECT 'OK' AS Mensaje;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_modificarUsuarioEmpleado`(pIdPersonas bigint,  pUsuario varchar(15))
BEGIN
SALIR:BEGIN
	/*
    Permite modificar usuario de un empleado. Controla que el empleado exista y este activo. 
    Controla que el nombre de Usuario no exista. Controla parametros. 
    Devuelve OK o el mensaje de error en Mensaje.
	*/
    -- Controla parametros
    IF pIdPersonas IS NULL OR pIdPersonas =0 THEN
		SELECT 'El empleado es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;

    IF pUsuario IS NULL OR pUsuario = '' THEN
		SELECT 'El usuario es obligatorio.' AS Mensaje;
        LEAVE SALIR;
    END IF;
    
    -- Controlar si el empleado existe
    IF NOT EXISTS(SELECT IdPersonas FROM EMPLEADOS WHERE IdPersonas = pIdPersonas) THEN
		SELECT 'El empleado que quiere modificar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    -- Controlar nombre usuario existente
    IF EXISTS(SELECT Usuario FROM EMPLEADOS WHERE Usuario = pUsuario 
						AND IdPersonas != pIdPersonas) THEN
		SELECT 'Nombre de cuenta existente.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
    -- Controlo que la persona este dada de Alta.
    IF(SELECT e.IdPersonas FROM EMPLEADOS e INNER JOIN PERSONAS p 
		ON e.IdPersonas = p.IdPersonas WHERE e.IdPersonas= pIdPersonas AND EstadoPer = 'B')
		THEN SELECT 'No se puede modificar el usuario. Empleado dado de baja' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
	UPDATE	EMPLEADOS
	SET		Usuario = pUsuario
	WHERE	IdPersonas = pIdPersonas;
	SELECT 'OK' AS Mensaje;
END;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bsp_pagaCompra`(pIdCompras bigint)
SALIR:BEGIN
/*
    Permite cambiar el estado de una Compra a C: 'Completa' siempre y cuando no esté 
    completa ya. Controla parametros. Controla que la compra exista. 
    Devuelve OK o el mensaje de error en Mensaje.
*/
    
    -- Controla parametros
    IF pIdCompras IS NULL OR pIdCompras = 0 THEN
		SELECT 'La compra es necesaria.' AS Mensaje;
        LEAVE SALIR;
	END IF;
    
	-- Controlar si existe
    IF NOT EXISTS(SELECT IdCompras FROM COMPRAS WHERE IdCompras = pIdCompras) THEN 
		SELECT 'Compra que quiere modificar no existe.' AS Mensaje;
        LEAVE SALIR; 
	END IF;
    
    -- Controlar compra no completa ya
    IF EXISTS(SELECT IdCompras FROM COMPRAS WHERE IdCompras = pIdCompras AND EstadoCom = 'C') 
    THEN SELECT 'Compra ya está completa.' AS Mensaje;
        LEAVE SALIR;
	END IF;
	
    -- Activa
    UPDATE COMPRAS SET EstadoCom = 'C' WHERE IdCompras = pIdCompras;
    SELECT 'OK' AS Mensaje;
END$$
DELIMITER ;

