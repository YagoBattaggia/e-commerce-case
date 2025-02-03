create database ecommerce;
use ecommerce;

CREATE TABLE IF NOT EXISTS `ecommerce`.`category` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(45) NULL,
  `category_description` VARCHAR(45) NULL,
  `size_id` INT NULL,
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ecommerce`.`product` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `product_name` VARCHAR(45) NOT NULL,
  `product_description` LONGTEXT NULL,
  `product_category_id` INT NOT NULL,
  PRIMARY KEY (`product_id`),
  UNIQUE INDEX `product_id_UNIQUE` (`product_id` ASC) VISIBLE,
  INDEX `category_idx` (`product_category_id` ASC) VISIBLE,
  CONSTRAINT `category`
    FOREIGN KEY (`product_category_id`)
    REFERENCES `ecommerce`.`category` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ecommerce`.`product_color` (
  `color_id` INT NOT NULL AUTO_INCREMENT,
  `color_name` VARCHAR(45) NOT NULL,
  `color_hex` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`color_id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ecommerce`.`product_size` (
  `size_id` INT NOT NULL AUTO_INCREMENT,
  `stock_qty` INT NULL,
  `size_name` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`size_id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ecommerce`.`product_item` (
  `product_item_id` INT NOT NULL AUTO_INCREMENT,
  `product_id` INT NOT NULL,
  `product_color_id` INT NOT NULL,
  `price` VARCHAR(45) NULL,
  `sale_price` VARCHAR(45) NULL,
  `size_id` INT NOT NULL,
  PRIMARY KEY (`product_item_id`),
  UNIQUE INDEX `product_item_id_UNIQUE` (`product_item_id` ASC) VISIBLE,
  INDEX `product_id_idx` (`product_id` ASC) VISIBLE,
  INDEX `product_color_id_idx` (`product_color_id` ASC) VISIBLE,
  INDEX `product_size_idx` (`size_id` ASC) VISIBLE,
  CONSTRAINT `product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `ecommerce`.`product` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `product_color_id`
    FOREIGN KEY (`product_color_id`)
    REFERENCES `ecommerce`.`product_color` (`color_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `product_size`
    FOREIGN KEY (`size_id`)
    REFERENCES `ecommerce`.`product_size` (`size_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



CREATE TABLE IF NOT EXISTS `ecommerce`.`product_image` (
  `image_id` INT NOT NULL AUTO_INCREMENT,
  `product_item_id` INT NOT NULL,
  `image_file` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`image_id`),
  INDEX `product_item_id_idx` (`product_item_id` ASC) VISIBLE,
  CONSTRAINT `product_item_id`
    FOREIGN KEY (`product_item_id`)
    REFERENCES `ecommerce`.`product_item` (`product_item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO product_color (color_name, color_hex) VALUES ('Azul Royal', '#004680');

INSERT INTO category (category_name, category_description) VALUES ('Coleiras', 'Coleiras e Itens de Segurança');

INSERT INTO product (product_name, product_description, product_category_id) VALUES ('Peitoral Pet para cães American pets', 'Resumo
- Com suporte para ajuste, e guia com gancho para maior segurança;
- Fabricado em tecido que permite a ventilação da pele e dos pelos;
- Promove passeios mais confortáveis para o seu pet;
- Elegância e charme com diversas opções de cores;
- Resistente e prático de usar.', 1);

INSERT INTO product_size (stock_qty, size_name) VALUES (20, 'M');

INSERT INTO product_size (stock_qty, size_name) VALUES (20, 'P');

INSERT INTO product_item (product_id, product_color_id, price, sale_price, size_id) VALUES (1, 1, 'R$ 14,00', 'R$ 10,00', 2);

INSERT INTO product_item (product_id, product_color_id, price, sale_price, size_id) VALUES (1, 1, 'R$ 50,00', 'R$ 25,00', 1);

CREATE OR REPLACE VIEW `view_product_item2` AS (SELECT product_item.product_id, product_item.product_item_id, product_color.color_id, product_color.color_name, product_color.color_hex, price, sale_price, '' image_file, product_item.size_id, product_size.stock_qty, product_size.size_name FROM product_item 
INNER JOIN product_size ON product_item.size_id = product_size.size_id
INNER JOIN product_color ON  product_item.product_color_id = product_color.color_id);

CREATE OR REPLACE VIEW `view_product` AS (
SELECT product.product_id, product_name, product_description, category.category_name, category.category_description  FROM product
INNER JOIN category ON  product.product_category_id = category.category_id);

SELECT * FROM view_product_item2;


SHOW TABLES