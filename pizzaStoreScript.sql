
DROP DATABASE IF EXISTS `pizza_time`;

-- this is to initialize the pizza_store Schema and designate it as the database in use
CREATE SCHEMA `pizza_time`;
USE `pizza_time`;
		-- CREATING THE CUSTOMERS DATABASE AND ADDING THE CURRENT EXISTING CUSTOMERS
CREATE TABLE `pizza_time`.`customers` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(45) NULL,
  `phone_number` VARCHAR(15) NULL,
  PRIMARY KEY (`customer_id`)
  );
  
  INSERT INTO `pizza_time`.`customers` (`full_name` , `phone_number`)
	VALUES ('Trevor Page' , '226-555-4982');
  INSERT INTO `pizza_time`.`customers` (`full_name` , `phone_number`)
	VALUES ('John Doe' , '555-555-9498');
  
  
	-- ADDING THE PIZZAS AVAILABLE TO ORDER INTO THE *PIZZAS* TABLE
CREATE TABLE `pizza_time`.`pizzas` (
`pizza_id` INT NOT NULL AUTO_INCREMENT,
PRIMARY KEY (`pizza_id`),
`pizza_description` VARCHAR(50),
`price` DECIMAL(6, 2)
);
		
INSERT INTO `pizzas` (`pizza_description`, `price`)
	VALUES('Pepperoni & Cheese' , 7.99),
		  ('Vegetarian' , 9.99),
		  ('Meat Lovers' , 14.99),
		  ('Hawaiian' , 12.99);
  
		-- ADDING THE KNOWN ORDERS ALREADY PLACED BY EACH CUSTOMER INTO THE *ORDERS* TABLE
  CREATE TABLE `pizza_time`.`orders` (
`order_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
`date` DATETIME 
);

INSERT INTO `pizza_time`.`orders` (`date`)
	VALUES ('2014-09-10 9:47:00'),
		   ('2014-09-10 13:20:00'),
           ('2014-09-10 9:47:00');
           
           /*
				CREATING A JUNCTION TABLE TO ENFORCE A ONE -> TO -> MANY RELATIONSHIP BETWEEN:
                ++ CUSTOMERS -> TO -> CUSTOMER_ORDERS
                ++ ORDERS -> TO -> CUSTOMER_ORDERS			*/
CREATE TABLE `pizza_time`.`customer_orders` (
`customer_id` INT NOT NULL,
	FOREIGN KEY (`customer_id`) REFERENCES customers (`customer_id`),
    
`order_id` INT NOT NULL,
	FOREIGN KEY (`order_id`) REFERENCES `orders`  (`order_id`)
);

-- CORRESPONDING USERS ANS THE ORDERS THEY HAVE PLACED
INSERT INTO `pizza_time`.`customer_orders` ( `customer_id` , `order_id`)
	VALUES  ( 1 , 1),
			( 2 , 2),
            ( 1 , 3 );
            
            
            /*
				CREATING A JUNCTION TABLE TO ENFORCE A ONE -> TO -> MANY RELATIONSHIP BETWEEN:
					++ ORDERS -> TO -> ORDER_PIZZAS
					++ PIZZAS -> TO -> ORDER_PIZZAS
            */
CREATE TABLE `pizza_time`.`order_pizzas` (
`order_id` INT NOT NULL,
	FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
    
`pizza_id` INT NOT NULL,
	FOREIGN KEY (`pizza_id`) REFERENCES `pizzas` (`pizza_id`)
);

-- CORRESPONDING ORDERS AND THE PIZZAS CONTAINED WITHIN SAID ORDERS
INSERT INTO `pizza_time`.`order_pizzas` ( `order_id` , `pizza_id`)
	VALUES  ( 1 , 1),
			( 1 , 3),
            ( 2 , 2),
            ( 2 , 3),
            ( 2 , 3),
            ( 3 , 3),
            ( 3 , 4);
            
            
            /*
					BELOW THIS ARE THE QUERIES FOR GATHERING :
						++ TOTAL MONEY SPENT BY CUSTOMER
                        ++ TOTAL MONEY SPENT BY DATE
                        
                        */
                        
		-- TOTAL SPENT BY CUSTOMER DURING LIFETIME
SELECT c.customer_id, c.full_name, Sum(p.price) AS total
	FROM customers c
JOIN customer_orders co
	ON c.customer_id = co.customer_id
JOIN orders o
	ON co.order_id = o.order_id
JOIN order_pizzas op
	ON o.order_id = op.order_id
JOIN pizzas p
	ON op.pizza_id = p.pizza_id
    GROUP BY c.customer_id;
    
    -- TOTAL SPENT BY CUSTOMER BY EACH DATE ORDERED
    SELECT c.customer_id, c.full_name, o.date, Sum(p.price) AS total
	FROM customers c
JOIN customer_orders co
	ON c.customer_id = co.customer_id
JOIN orders o
	ON co.order_id = o.order_id
JOIN order_pizzas op
	ON o.order_id = op.order_id
JOIN pizzas p
	ON op.pizza_id = p.pizza_id
    
    GROUP BY c.customer_id,
			o.date;
            
            
                    