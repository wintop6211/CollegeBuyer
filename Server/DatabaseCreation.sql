-- MySQL Script generated by MySQL Workbench
-- Sun Jan 21 16:50:14 2018
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema CollegeBuyer
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema CollegeBuyer
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CollegeBuyer` DEFAULT CHARACTER SET utf8 ;
USE `CollegeBuyer` ;

-- -----------------------------------------------------
-- Table `CollegeBuyer`.`School`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CollegeBuyer`.`School` (
  `idSchool` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(90) NOT NULL,
  `logo` VARCHAR(200) NULL,
  PRIMARY KEY (`idSchool`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  UNIQUE INDEX `logo_UNIQUE` (`logo` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CollegeBuyer`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CollegeBuyer`.`User` (
  `idUser` INT NOT NULL AUTO_INCREMENT,
  `emailAddress` VARCHAR(90) NOT NULL,
  `password` VARCHAR(90) NOT NULL,
  `gender` INT NOT NULL,
  `profilePicture` VARCHAR(150) NULL,
  `name` VARCHAR(90) NOT NULL,
  `phone` VARCHAR(90) NOT NULL,
  `School_idSchool` INT NOT NULL,
  `verified` INT NOT NULL,
  `loginIdentifier` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`idUser`),
  UNIQUE INDEX `emailAddress_UNIQUE` (`emailAddress` ASC),
  UNIQUE INDEX `profilePicture_UNIQUE` (`profilePicture` ASC),
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC),
  INDEX `fk_User_School_idx` (`School_idSchool` ASC),
  UNIQUE INDEX `loginIdentifier_UNIQUE` (`loginIdentifier` ASC),
  CONSTRAINT `fk_User_School`
    FOREIGN KEY (`School_idSchool`)
    REFERENCES `CollegeBuyer`.`School` (`idSchool`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CollegeBuyer`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CollegeBuyer`.`Product` (
  `idProduct` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(90) NOT NULL,
  `description` VARCHAR(1000) NULL,
  `price` FLOAT NOT NULL,
  `pictures` VARCHAR(150) NOT NULL,
  `sold` INT NOT NULL,
  `condition` INT NOT NULL,
  `School_idSchool` INT NOT NULL,
  `idSeller` INT NOT NULL,
  `idBuyer` INT NULL,
  `view` INT NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idProduct`),
  UNIQUE INDEX `pictures_UNIQUE` (`pictures` ASC),
  INDEX `fk_Product_School1_idx` (`School_idSchool` ASC),
  INDEX `fk_seller_id_idx` (`idSeller` ASC),
  INDEX `fk_buyer_id_idx` (`idBuyer` ASC),
  CONSTRAINT `fk_Product_School1`
    FOREIGN KEY (`School_idSchool`)
    REFERENCES `CollegeBuyer`.`School` (`idSchool`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_seller_id`
    FOREIGN KEY (`idSeller`)
    REFERENCES `CollegeBuyer`.`User` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_buyer_id`
    FOREIGN KEY (`idBuyer`)
    REFERENCES `CollegeBuyer`.`User` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CollegeBuyer`.`Category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CollegeBuyer`.`Category` (
  `idCategory` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(90) NOT NULL,
  PRIMARY KEY (`idCategory`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CollegeBuyer`.`BuyerReview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CollegeBuyer`.`BuyerReview` (
  `idBuyerReview` INT NOT NULL AUTO_INCREMENT,
  `stars` INT NOT NULL,
  `review` VARCHAR(1000) NULL,
  `User_idUser` INT NOT NULL,
  PRIMARY KEY (`idBuyerReview`),
  INDEX `fk_BuyerReview_User1_idx` (`User_idUser` ASC),
  CONSTRAINT `fk_BuyerReview_User1`
    FOREIGN KEY (`User_idUser`)
    REFERENCES `CollegeBuyer`.`User` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CollegeBuyer`.`Report`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CollegeBuyer`.`Report` (
  `idReport` INT NOT NULL AUTO_INCREMENT,
  `report` VARCHAR(1000) NOT NULL,
  `User_idUser` INT NOT NULL,
  PRIMARY KEY (`idReport`),
  INDEX `fk_Report_User1_idx` (`User_idUser` ASC),
  CONSTRAINT `fk_Report_User1`
    FOREIGN KEY (`User_idUser`)
    REFERENCES `CollegeBuyer`.`User` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CollegeBuyer`.`SellerReview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CollegeBuyer`.`SellerReview` (
  `idSellerReview` INT NOT NULL AUTO_INCREMENT,
  `stars` INT NOT NULL,
  `review` VARCHAR(1000) NULL,
  `User_idUser` INT NOT NULL,
  PRIMARY KEY (`idSellerReview`),
  INDEX `fk_SellerReview_User1_idx` (`User_idUser` ASC),
  CONSTRAINT `fk_SellerReview_User1`
    FOREIGN KEY (`User_idUser`)
    REFERENCES `CollegeBuyer`.`User` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CollegeBuyer`.`Product_has_Category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CollegeBuyer`.`Product_has_Category` (
  `Product_idProduct` INT NOT NULL,
  `Category_idCategory` INT NOT NULL,
  PRIMARY KEY (`Product_idProduct`, `Category_idCategory`),
  INDEX `fk_Product_has_Category_Category1_idx` (`Category_idCategory` ASC),
  INDEX `fk_Product_has_Category_Product1_idx` (`Product_idProduct` ASC),
  CONSTRAINT `fk_Product_has_Category_Product1`
    FOREIGN KEY (`Product_idProduct`)
    REFERENCES `CollegeBuyer`.`Product` (`idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_has_Category_Category1`
    FOREIGN KEY (`Category_idCategory`)
    REFERENCES `CollegeBuyer`.`Category` (`idCategory`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CollegeBuyer`.`Device`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CollegeBuyer`.`Device` (
  `idDevice` VARCHAR(200) NOT NULL,
  `User_idUser` INT NULL,
  PRIMARY KEY (`idDevice`),
  INDEX `fk_Device_User1_idx` (`User_idUser` ASC),
  CONSTRAINT `fk_Device_User1`
    FOREIGN KEY (`User_idUser`)
    REFERENCES `CollegeBuyer`.`User` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CollegeBuyer`.`PendingRequest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CollegeBuyer`.`PendingRequest` (
  `idPendingRequest` INT NOT NULL AUTO_INCREMENT,
  `idSeller` INT NOT NULL,
  `idBuyer` INT NOT NULL,
  `idProduct` INT NOT NULL,
  `offer_price` DOUBLE NOT NULL,
  `note` VARCHAR(1000) NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idPendingRequest`),
  INDEX `fk_seller_id_idx` (`idSeller` ASC),
  INDEX `fk_product_id_idx` (`idProduct` ASC),
  INDEX `fk_buyer_id_idx` (`idBuyer` ASC),
  CONSTRAINT `fk_seller_id1`
    FOREIGN KEY (`idSeller`)
    REFERENCES `CollegeBuyer`.`User` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_id`
    FOREIGN KEY (`idProduct`)
    REFERENCES `CollegeBuyer`.`Product` (`idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_buyer_id1`
    FOREIGN KEY (`idBuyer`)
    REFERENCES `CollegeBuyer`.`User` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
