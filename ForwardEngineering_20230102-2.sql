-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema decowraps1
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema decowraps1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `decowraps1` ;
-- -----------------------------------------------------
-- Schema test
-- -----------------------------------------------------
USE `decowraps1` ;

-- -----------------------------------------------------
-- Table `decowraps1`.`cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decowraps1`.`cliente` ;

CREATE TABLE IF NOT EXISTS `decowraps1`.`cliente` (
  `cliente_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`cliente_id`),
  INDEX `idx_last_name` (`last_name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Tabla para almacenar registros de clientes.';


-- -----------------------------------------------------
-- Table `decowraps1`.`linea_producto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decowraps1`.`linea_producto` ;

CREATE TABLE IF NOT EXISTS `decowraps1`.`linea_producto` (
  `lineaproducto_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_title` (`title` ASC) VISIBLE,
  PRIMARY KEY (`lineaproducto_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `decowraps1`.`producto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decowraps1`.`producto` ;

CREATE TABLE IF NOT EXISTS `decowraps1`.`producto` (
  `producto_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `lineaproducto_id` SMALLINT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`producto_id`),
  INDEX `idx_fk_film_id` (`lineaproducto_id` ASC) VISIBLE,
  INDEX `idx_store_id_film_id` (`lineaproducto_id` ASC) VISIBLE,
  CONSTRAINT `fk_inventory_film`
    FOREIGN KEY (`lineaproducto_id`)
    REFERENCES `decowraps1`.`linea_producto` (`lineaproducto_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `decowraps1`.`empleado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decowraps1`.`empleado` ;

CREATE TABLE IF NOT EXISTS `decowraps1`.`empleado` (
  `empleado_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(50) NULL DEFAULT NULL,
  `username` VARCHAR(16) NOT NULL,
  `password` VARCHAR(40) BINARY NULL DEFAULT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`empleado_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `decowraps1`.`orden_venta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decowraps1`.`orden_venta` ;

CREATE TABLE IF NOT EXISTS `decowraps1`.`orden_venta` (
  `ordenventa_id` INT NOT NULL AUTO_INCREMENT,
  `producto_id` MEDIUMINT UNSIGNED NOT NULL,
  `cliente_id` SMALLINT UNSIGNED NOT NULL,
  `return_date` DATETIME NULL,
  `empleado_id` TINYINT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ordenventa_id`),
  UNIQUE INDEX `idx_rental` (`producto_id` ASC, `cliente_id` ASC) VISIBLE,
  INDEX `idx_fk_inventory_id` (`producto_id` ASC) VISIBLE,
  INDEX `idx_fk_customer_id` (`cliente_id` ASC) VISIBLE,
  INDEX `idx_fk_staff_id` (`empleado_id` ASC) VISIBLE,
  CONSTRAINT `fk_rental_staff`
    FOREIGN KEY (`empleado_id`)
    REFERENCES `decowraps1`.`empleado` (`empleado_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rental_inventory`
    FOREIGN KEY (`producto_id`)
    REFERENCES `decowraps1`.`producto` (`producto_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rental_customer`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `decowraps1`.`cliente` (`cliente_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `decowraps1`.`transportadora`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decowraps1`.`transportadora` ;

CREATE TABLE IF NOT EXISTS `decowraps1`.`transportadora` (
  `transportadora_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`transportadora_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `decowraps1`.`proveedor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decowraps1`.`proveedor` ;

CREATE TABLE IF NOT EXISTS `decowraps1`.`proveedor` (
  `proveedor_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`proveedor_id`))
ENGINE = InnoDB;

USE `decowraps1` ;

-- -----------------------------------------------------
-- Placeholder table for view `decowraps1`.`orden_venta_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `decowraps1`.`orden_venta_list` (`VentaId` INT, `ProductoNombre` INT, `ClienteNombre` INT, `EmpleadoNombre` INT);

-- -----------------------------------------------------
-- Placeholder table for view `decowraps1`.`linea_producto_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `decowraps1`.`linea_producto_list` (`LineaProductoId` INT, `LineaProductoIdTitle` INT);

-- -----------------------------------------------------
-- Placeholder table for view `decowraps1`.`producto_by_linea`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `decowraps1`.`producto_by_linea` (`ProductoId` INT, `ProductoName` INT, `LineaProductoTitle` INT);

-- -----------------------------------------------------
-- Placeholder table for view `decowraps1`.`producto_list`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `decowraps1`.`producto_list` (`producto_id` INT, `lineaproducto_id` INT, `name` INT);

-- -----------------------------------------------------
-- procedure producto_in_stock
-- -----------------------------------------------------

USE `decowraps1`;
DROP procedure IF EXISTS `decowraps1`.`producto_in_stock`;

DELIMITER $$
USE `decowraps1`$$
CREATE PROCEDURE `sakila`.`producto_in_stock`(IN p_producto_id INT, IN p_lineaproducto_id INT, OUT p_producto_count INT)
READS SQL DATA
BEGIN
     SELECT producto_id
     FROM producto
     WHERE producto_id = p_producto_id
     AND lineaproducto_id = p_lineaproducto_id
     AND inventory_in_stock(lineaproducto_id);

     SELECT FOUND_ROWS() INTO p_producto_count;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function lineaproducto_in_stock
-- -----------------------------------------------------

USE `decowraps1`;
DROP function IF EXISTS `decowraps1`.`lineaproducto_in_stock`;

DELIMITER $$
USE `decowraps1`$$
CREATE FUNCTION `sakila`.`lineaproducto_in_stock`(p_lineaproducto_id INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE v_lineas INT;

    #UNA LÍNEA DE PRODUCTO ESTÁ EN STOCK SI HAY > 0 FILAS EN EL RESULTADO DE LA CONSULTA

    SELECT COUNT(*) INTO v_rentals
    FROM linea_producto
    WHERE lineaproducto_id = p_lineaproducto_id;

    IF v_lineas > 0 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `decowraps1`.`orden_venta_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decowraps1`.`orden_venta_list`;
DROP VIEW IF EXISTS `decowraps1`.`orden_venta_list` ;
USE `decowraps1`;
--
-- View structure for view `orden_venta_list`
--

CREATE  OR REPLACE VIEW orden_venta_list 
AS 
SELECT orden_venta.ordenventa_id AS VentaId, producto.name AS ProductoNombre, CONCAT(cliente.first_name, _utf8' ', cliente.last_name) AS ClienteNombre, CONCAT(empleado.first_name, _utf8' ', empleado.last_name) AS EmpleadoNombre 
FROM orden_venta LEFT JOIN producto ON producto.producto_id = orden_venta.producto_id LEFT JOIN cliente ON cliente.cliente_id = orden_venta.cliente_id
        JOIN empleado ON empleado.empleado_id = orden_venta.empleado_id 
GROUP BY producto.producto_id, cliente.cliente_id;

-- -----------------------------------------------------
-- View `decowraps1`.`linea_producto_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decowraps1`.`linea_producto_list`;
DROP VIEW IF EXISTS `decowraps1`.`linea_producto_list` ;
USE `decowraps1`;
--
-- View structure for view `linea_producto_list`
--

CREATE  OR REPLACE VIEW linea_producto_list 
AS 
SELECT linea_producto.lineaproducto_id AS LineaProductoId, linea_producto.title AS LineaProductoIdTitle 
FROM linea_producto;

-- -----------------------------------------------------
-- View `decowraps1`.`producto_by_linea`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decowraps1`.`producto_by_linea`;
DROP VIEW IF EXISTS `decowraps1`.`producto_by_linea` ;
USE `decowraps1`;
--
-- View structure for view `producto_by_linea`
--

CREATE  OR REPLACE VIEW producto_by_linea
AS 
SELECT 
producto.producto_id AS ProductoId
, producto.name AS ProductoName
, linea_producto.title AS LineaProductoTitle
FROM linea_producto AS lp
INNER JOIN producto AS p ON p.lineaproducto_id = lp.lineaproducto_id
GROUP BY lp.title
ORDER BY p.name, lp.title;

-- -----------------------------------------------------
-- View `decowraps1`.`producto_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `decowraps1`.`producto_list`;
DROP VIEW IF EXISTS `decowraps1`.`producto_list` ;
USE `decowraps1`;
--
-- View structure for view `producto_list`
--

CREATE  OR REPLACE VIEW producto_list
AS 
SELECT 
*
FROM producto AS p
ORDER BY name DESC;
USE `decowraps1`;

DELIMITER $$

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
