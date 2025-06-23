-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Estados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Estados` (
  `idEstado` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(450) NULL,
  PRIMARY KEY (`idEstado`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Convocatorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Convocatorias` (
  `idConvocatoria` INT NOT NULL,
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NOT NULL,
  `restricciones` VARCHAR(450) NULL,
  `nivel` ENUM('E', 'N', 'I') NULL DEFAULT 'Estatal, Nacional, Internacional',
  `organizacion` VARCHAR(45) NULL,
  PRIMARY KEY (`idConvocatoria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Proyectos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Proyectos` (
  `idProyecto` INT NOT NULL,
  `fecha_registro` DATE NULL,
  `fecha_inicio` DATE NULL,
  `fecha_fin` DATE NULL,
  `descripcion` VARCHAR(450) NULL,
  `idEstado` INT NOT NULL,
  `financiamiento` ENUM('Sin financiamiento', 'Interno', 'externo') NULL,
  `monto` DECIMAL(12,2) NULL,
  `idConvocatoria` INT NOT NULL,
  PRIMARY KEY (`idProyecto`),
  INDEX `fk_Proyectos_Estados1_idx` (`idEstado` ASC) VISIBLE,
  INDEX `fk_Proyectos_Convocatorias1_idx` (`idConvocatoria` ASC) VISIBLE,
  CONSTRAINT `fk_Proyectos_Estados1`
    FOREIGN KEY (`idEstado`)
    REFERENCES `mydb`.`Estados` (`idEstado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Proyectos_Convocatorias1`
    FOREIGN KEY (`idConvocatoria`)
    REFERENCES `mydb`.`Convocatorias` (`idConvocatoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Instituciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Instituciones` (
  `idInstitucion` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `rfc` VARCHAR(13) NOT NULL,
  PRIMARY KEY (`idInstitucion`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Roles` (
  `idRol` INT NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `descripcion` VARCHAR(450) NULL,
  PRIMARY KEY (`idRol`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Usuarios` (
  `idUsuario` INT NOT NULL,
  `correo_institucional` VARCHAR(45) NULL,
  `contrasenia` VARCHAR(45) NULL,
  `nombres` VARCHAR(45) NULL,
  `apellido_paterno` VARCHAR(45) NULL,
  `apellido_materno` VARCHAR(45) NULL,
  `correo_adicional` VARCHAR(45) NULL,
  `telefono_institucional` VARCHAR(45) NULL,
  `extension` VARCHAR(45) NULL,
  `celular` VARCHAR(45) NULL,
  `idInstitucion` INT NOT NULL,
  `idRol` INT NOT NULL,
  PRIMARY KEY (`idUsuario`),
  INDEX `fk_Usuarios_Instituciones_idx` (`idInstitucion` ASC) VISIBLE,
  INDEX `fk_Usuarios_Roles1_idx` (`idRol` ASC) VISIBLE,
  CONSTRAINT `fk_Usuarios_Instituciones`
    FOREIGN KEY (`idInstitucion`)
    REFERENCES `mydb`.`Instituciones` (`idInstitucion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuarios_Roles1`
    FOREIGN KEY (`idRol`)
    REFERENCES `mydb`.`Roles` (`idRol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Participantes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Participantes` (
  `idUsuario` INT NOT NULL,
  `idProyecto` INT NOT NULL,
  `lider` INT NULL,
  `nivel` INT NULL,
  `tipo_participacion` ENUM('Autor', 'Coautor', 'Colaborador', 'Externo') NULL,
  PRIMARY KEY (`idUsuario`, `idProyecto`),
  INDEX `fk_Usuarios_has_Proyectos_Proyectos1_idx` (`idProyecto` ASC) VISIBLE,
  INDEX `fk_Usuarios_has_Proyectos_Usuarios1_idx` (`idUsuario` ASC) VISIBLE,
  CONSTRAINT `fk_Usuarios_has_Proyectos_Usuarios1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `mydb`.`Usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuarios_has_Proyectos_Proyectos1`
    FOREIGN KEY (`idProyecto`)
    REFERENCES `mydb`.`Proyectos` (`idProyecto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Disciplinas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Disciplinas` (
  `idDisciplina` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(450) NULL,
  PRIMARY KEY (`idDisciplina`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Pertenecen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Pertenecen` (
  `idConvocatoria` INT NOT NULL,
  `idDisciplina` INT NOT NULL,
  PRIMARY KEY (`idConvocatoria`, `idDisciplina`),
  INDEX `fk_Convocatorias_has_Categorias_Categorias1_idx` (`idDisciplina` ASC) VISIBLE,
  INDEX `fk_Convocatorias_has_Categorias_Convocatorias1_idx` (`idConvocatoria` ASC) VISIBLE,
  CONSTRAINT `fk_Convocatorias_has_Categorias_Convocatorias1`
    FOREIGN KEY (`idConvocatoria`)
    REFERENCES `mydb`.`Convocatorias` (`idConvocatoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Convocatorias_has_Categorias_Categorias1`
    FOREIGN KEY (`idDisciplina`)
    REFERENCES `mydb`.`Disciplinas` (`idDisciplina`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Descripcion_Proyectos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Descripcion_Proyectos` (
  `idProyecto` INT NOT NULL,
  `resumen` INT NOT NULL,
  `objetivo` VARCHAR(45) NULL,
  PRIMARY KEY (`idProyecto`),
  CONSTRAINT `fk_Descripcion_Proyectos_Proyectos1`
    FOREIGN KEY (`idProyecto`)
    REFERENCES `mydb`.`Proyectos` (`idProyecto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Tipos_Productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Tipos_Productos` (
  `idTipo_Producto` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(45) NULL,
  `estado` ENUM('Activo', 'Inactivo') NOT NULL,
  PRIMARY KEY (`idTipo_Producto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Productos_Academicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Productos_Academicos` (
  `idProducto_Academico` INT NOT NULL,
  `idProyecto` INT NOT NULL,
  `idTipo_Producto` INT NOT NULL,
  `titulo` VARCHAR(45) NOT NULL,
  `fecha_inicio` VARCHAR(45) NULL,
  `fecha_fin` VARCHAR(45) NULL,
  `referencia` VARCHAR(45) NULL,
  `issn_isbn` VARCHAR(45) NULL,
  `observaciones` VARCHAR(45) NULL,
  PRIMARY KEY (`idProducto_Academico`),
  INDEX `fk_Productos_Academicos_Proyectos1_idx` (`idProyecto` ASC) VISIBLE,
  INDEX `fk_Productos_Academicos_Tipos_Productos1_idx` (`idTipo_Producto` ASC) VISIBLE,
  CONSTRAINT `fk_Productos_Academicos_Proyectos1`
    FOREIGN KEY (`idProyecto`)
    REFERENCES `mydb`.`Proyectos` (`idProyecto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Productos_Academicos_Tipos_Productos1`
    FOREIGN KEY (`idTipo_Producto`)
    REFERENCES `mydb`.`Tipos_Productos` (`idTipo_Producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Colaboradores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Colaboradores` (
  `idColaboradores` INT NOT NULL,
  `nombres` VARCHAR(45) NULL,
  `apellido_paterno` VARCHAR(45) NULL,
  `apellido_materno` VARCHAR(45) NULL,
  `grado` VARCHAR(45) NULL,
  PRIMARY KEY (`idColaboradores`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Colaboradores_Proyectos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Colaboradores_Proyectos` (
  `idProyecto` INT NOT NULL,
  `idColaboradores` INT NOT NULL,
  PRIMARY KEY (`idProyecto`, `idColaboradores`),
  INDEX `fk_Proyectos_has_Colaboradores_Colaboradores1_idx` (`idColaboradores` ASC) VISIBLE,
  INDEX `fk_Proyectos_has_Colaboradores_Proyectos1_idx` (`idProyecto` ASC) VISIBLE,
  CONSTRAINT `fk_Proyectos_has_Colaboradores_Proyectos1`
    FOREIGN KEY (`idProyecto`)
    REFERENCES `mydb`.`Proyectos` (`idProyecto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Proyectos_has_Colaboradores_Colaboradores1`
    FOREIGN KEY (`idColaboradores`)
    REFERENCES `mydb`.`Colaboradores` (`idColaboradores`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
