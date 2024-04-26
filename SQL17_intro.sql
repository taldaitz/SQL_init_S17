CREATE DATABASE formation;

USE formation;

DROP TABLE booking;

CREATE TABLE booking (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customer_firstname VARCHAR(100) NOT NULL,
  customer_lastname VARCHAR(100) NOT NULL,
  customer_phone_number VARCHAR(20) NULL,
  customer_email VARCHAR(255) NOT NULL,
  check_in DATETIME NOT NULL,
  check_out DATETIME NOT NULL,
  room_number INT NOT NULL,
  room_floor INT NOT NULL,
  room_type VARCHAR(50) NULL
);

DESCRIBE booking;

USE formation_thomas;

DESCRIBE contact;

ALTER TABLE contact
	MODIFY lastname VARCHAR(200) NOT NULL,
    ADD COLUMN is_friend BOOL NOT NULL
;

SELECT * FROM contact;

INSERT INTO contact (lastname, firstname,  phone_number, email, is_friend)
VALUES ('Aldaitz', 'Thomas',  '061465416541', 'taldaitz@dawan.fr', true)
;

INSERT INTO contact (lastname, firstname,  email, is_friend)
VALUES ('Test', 'Robert',  'rtest@dawan.fr', false)
;


INSERT INTO contact (lastname, firstname,  email, is_friend)
VALUES ('ReTest', 'Jean',  'jrtest@dawan.fr', true),
	('DuTest', 'Grégoire', 'gdutest@dawan.fr', true)
;

SELECT * FROM contact;


UPDATE contact
SET is_friend = false
WHERE id = 3
;

UPDATE contact
SET phone_number = '0616514561', email = 'gdutest@gmail.com'
WHERE id = 4
;

UPDATE contact
SET is_friend = true
;

ALTER TABLE booking
	ADD COLUMN notes TEXT NULL,
    DROP COLUMN room_floor
;

ALTER TABLE booking
	MODIFY notes TEXT NULL;

DESCRIBE booking;

ALTER TABLE booking
	MODIFY id INT PRIMARY KEY AUTO_INCREMENT;
    
USE formation;

INSERT INTO booking (
		customer_firstname, 
        customer_lastname, 
        customer_phone_number, 
        customer_email,
        check_in,
        check_out,
        room_number,
        room_type
	)
VALUES (
		'Thomas',
        'Aldaitz',
        '061631561165',
        'taldaitz@dawan.fr',
        '2024-04-22 09:30:00',
        '2024-04-28 11:45:00',
        202,
        'Double'
        ); 
        
SELECT * FROM booking;        
        
USE formation;


SELECT * FROM booking;

/* UPDATE
-> 
Pour la réservation avec l'id 8, le type de chambre doit etre Single */

UPDATE booking
SET room_type = 'Single'
WHERE id = 8
;

/* ->
Pour la réservation avec l'id 12, le prénom et le nom doivent etre Jean Test */

UPDATE booking
SET customer_firstname = 'Jean', customer_lastname = 'Test'
WHERE id = 12
;

/* ->
Pour toutes les réservation Premium, ajouter une note "Ajouter un surplus 
de 5 euros" */

UPDATE booking
SET notes = 'Ajouter un surplus de 5 euros'
WHERE room_type = 'Premium'
;


DELETE FROM booking
WHERE room_number >= 300
	AND room_number < 400
;

SELECT * FROM booking;

SELECT *
FROM booking
;

SELECT customer_lastname AS Nom_de_famille, customer_firstname AS Prénom
FROM booking
;

SELECT * FROM booking
WHERE customer_firstname LIKE '%t%'
;

SELECT * FROM booking
WHERE room_number BETWEEN 400 AND 499;

SELECT * FROM booking
WHERE room_number >= 400 
AND room_number <= 499;


SELECT * 
FROM booking
WHERE check_in BETWEEN '2024-01-01' AND '2024-12-31';



/* -> Le nom, prénom et email des clients dont le prénom est "Julien" */

SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_firstname = 'Julien';

/* -> Le nom, prénom et email des clients dont l'email termine par "@gmail.com" */

SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_email LIKE '%@gmail.com';

/* -> toutes les commandes  non payées */

SELECT * 
FROM full_order
WHERE is_paid = false;

/* -> toutes les commandes  payées mais non livré */

SELECT * 
FROM full_order
WHERE is_paid = true
AND shipment_date IS NULL
;

/* -> toutes les commandes  livré hors de France */

SELECT *
FROM full_order
WHERE shipment_date IS NOT NULL
AND shipment_country <> 'France'
;


/* -> toutes les commandes au montant de plus 8000€ ordonnées du plus grand au plus petit */

SELECT *
FROM full_order
WHERE amount > 8000
ORDER BY amount DESC
;

/* -> La commande au montant le plus élevé (une seule) */

SELECT *
FROM full_order
ORDER BY amount DESC
LIMIT 1
;


/* -> toutes les commandes réglées en Cash en 2022 livré en France dont le montant est inférieur à 5000 € */

SELECT *
FROM full_order
WHERE payment_type = 'Cash'
AND YEAR(payment_date) = 2022
AND shipment_country = 'France'
AND amount < 5000
;

/* -> toutes les commandes payés par carte ou payé aprés le 15/10/2021 */

SELECT *
FROM full_order
WHERE payment_type = 'Credit Card'
OR payment_date > '2021-10-15'
;

/* -> les 3 dernières commandes envoyées en France */

SELECT *
FROM full_order
WHERE shipment_country = 'France'
ORDER BY shipment_date DESC
LIMIT 3
;

/* -> les 10 commandes les plus élevés passé sur l'année 2021 */

SELECT *
FROM full_order
WHERE YEAR(date) = 2021
ORDER BY amount DESC
LIMIT 10;

/* -> la somme des commandes non payés */
SELECT ROUND(SUM(amount), 2) AS UnpaidOrderAmount
FROM full_order
WHERE is_paid = false;

/* -> la moyenne des montants des commandes payés en cash */
SELECT ROUND(AVG(amount), 2) AS AverageCashAmount
FROM full_order
WHERE payment_type = 'Cash'
;

/* -> le nombre de client dont le nom est "Laporte" */

SELECT COUNT(*)
FROM full_order
WHERE customer_lastname = 'Laporte'
;

/* -> Le nombre de jour Maximum entre la date de payment et la date de livraison -> DATEDIFF() */

SELECT MAX(ABS(DATEDIFF(payment_date, shipment_date))) AS MaxDelay
FROM full_order
;

/* proposition de Aurélien*/
select datediff(payment_date,shipment_date) as difference
from full_order
order by difference desc
limit 1;

/* -> Le délai moyen (en jour) de réglement d'une commande */
SELECT ROUND(AVG(ABS(DATEDIFF(date, payment_date)))) AS AveragePaymentDelay
FROM full_order
;

/* -> le nombre de commande payés en chèque sur 2021 */
SELECT COUNT(*)
FROM full_order
WHERE payment_type = 'Check'
AND YEAR(payment_date) = 2021
;


SELECT payment_type, YEAR(date) AS orderYear,  COUNT(*) AS nbOrder
FROM full_order
WHERE payment_type IS NOT NULL
GROUP BY payment_type, orderYear
	HAVING nbOrder < 100
ORDER BY payment_type, orderYear
;

SELECT * FROM full_order;

/* -> Le montant total des commandes par type de paiement */

SELECT payment_type, ROUND(SUM(amount), 2) AS totalAmount
FROM full_order
WHERE payment_type IS NOT NULL
GROUP BY payment_type
ORDER BY payment_type
;


/* -> La moyenne des montants des commandes par Pays */
SELECT shipment_country, ROUND(AVG(amount), 2) AS AverageAmount
FROM full_order
WHERE shipment_country IS NOT NULL
GROUP BY shipment_country
ORDER BY shipment_country
;


/* -> Par année la somme des commandes */
SELECT YEAR(date) AS orderYear, ROUND(SUM(amount), 2) AS totalAmount
FROM full_order
GROUP BY orderYear
ORDER BY orderYear
;


/* -> Liste des clients (nom, prénom) qui ont au moins deux commandes */
SELECT customer_lastname, customer_firstname, COUNT(*) AS nbOrder
FROM full_order
GROUP BY customer_lastname, customer_firstname
	HAVING nbOrder >= 2
ORDER BY customer_lastname, customer_firstname
;


/* -> Liste des clients (nom, prénom) avec le montant de leur commande
la plus élevé en 2021 (TOP 3) */

SELECT customer_lastname, customer_firstname, MAX(amount) AS MaxOrder
FROM full_order
WHERE YEAR(date) = 2021
GROUP BY customer_lastname, customer_firstname
ORDER BY MaxOrder DESC
LIMIT 3
;


/* -> tous les produits avec leur nom et le label de leur catégorie */

SELECT pr.name, ca.label
FROM product pr 
	JOIN category ca ON pr.category_id = ca.id
;

/*-> Pour chaque client (nom, prénom) remonter le nombre de facture 
associé*/

SELECT cu.id, cu.lastname, cu.firstname, COUNT(bi.id)
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
GROUP BY cu.id
;


/*-> Pour chaque catégorie la moyenne des prix de produits associés*/
SELECT ca.id, ca.label, ROUND(AVG(pr.unit_price), 2) AS AveragePrice
FROM category ca 
	JOIN product pr ON ca.id = pr.category_id
GROUP BY ca.id
;


USE billings;

SELECT *
FROM product pr
	JOIN category ca ON ca.id = pr.category_id
;

SELECT * FROM product;
SELECT * FROM category;

SELECT *
FROM product pr, category ca
WHERE pr.category_id = ca.id
	AND unit_price > 100
ORDER BY pr.id
;




/*-> Pour Chaque produit la quantité commandée depuis le 01/01/2021 */

SELECT pr.id, pr.name, SUM(li.quantity) AS totalQuantity
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
WHERE bi.date > '2021-01-01'
GROUP BY pr.id
ORDER BY pr.id
;

/*-> La liste des Facture (ref) qui ont plus de 2 produits 
différends commandé*/

SELECT bi.id, bi.ref, COUNT(li.product_id) AS nbOfProduct
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
GROUP BY bi.id
	HAVING nbOfProduct > 2
;


/*-> Pour chaque Facture afficher le montant total*/
SELECT bi.id, bi.ref, SUM(li.quantity * pr.unit_price) AS totalAmount
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
GROUP BY bi.id
ORDER BY bi.id
;


/*-> Pour chaque client compter le nombre de produit différents 
qu'il a commandé*/

SELECT cu.id, cu.lastname, cu.firstname, COUNT(li.product_id) AS nbProductOrdered
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
    JOIN line_item li ON li.bill_id = bi.id
GROUP BY cu.id
ORDER BY cu.id
;


/*-> Pour chaque produit compter le nombre de client différents 
qu'ils l'ont commandé*/

SELECT pr.id, pr.name, COUNT(bi.customer_id) AS nbOfCustomer
FROM product pr
	JOIN line_item li ON li.product_id = pr.id
    JOIN bill bi ON bi.id = li.bill_id
GROUP BY pr.id
ORDER BY pr.id
;


USE formation;

SELECT * FROM booking;
SELECT * FROM payment;


SELECT bo.*, SUM(pa.amount) 
FROM booking bo
	JOIN payment pa ON pa.booking_id = bo.id
GROUP BY bo.id
;

DELETE FROM payment WHERE id = 2;

CREATE TABLE payment (
	id INT PRIMARY KEY AUTO_INCREMENT,
    amount FLOAT NOT NULL,
    date DATE NOT NULL,
    payment_mean VARCHAR(100) NOT NULL,
    booking_id INT NOT NULL
);

INSERT INTO payment (amount, date, payment_mean, booking_id)
VALUES (100, '2024-04-24', 'Card', 1);

INSERT INTO payment (amount, date, payment_mean, booking_id)
VALUES (50, '2024-04-24', 'Cash', 2);

INSERT INTO payment (amount, date, payment_mean, booking_id)
VALUES (50, '2024-04-24', 'Card', 2);

INSERT INTO payment (amount, date, payment_mean, booking_id)
VALUES (150, '2024-04-24', 'Check', 3);




SELECT * FROM booking;
SELECT * FROM payment;

DELETE FROM payment WHERE id = 5;
DELETE FROM payment WHERE id = 6;

DELETE FROM booking WHERE id = 6;


SELECT bo.*, SUM(pa.amount) 
FROM booking bo
	JOIN payment pa ON pa.booking_id = bo.id
GROUP BY bo.id
;

INSERT INTO payment (amount, date, payment_mean, booking_id)
VALUES (75, '2024-04-24', 'Cash', 1);


ALTER TABLE payment
ADD CONSTRAINT FK_booking_payment
FOREIGN KEY payment (booking_id)
REFERENCES booking (id);


USE billings;


SELECT * 
FROM customer
WHERE id IN (4142, 4143, 4144)
;

SELECT * 
FROM customer
WHERE id = 4142 OR id = 4143 OR id= 4144
;




SELECT * 
FROM customer
WHERE id IN (
	SELECT customer_id
	FROM bill
	WHERE is_paid = false
);


SELECT customer_id
FROM bill
WHERE is_paid = false;


CREATE VIEW view_products_with_category_label AS 
SELECT pr.id, pr.name, pr.description, pr.unit_price, pr.quantity_available, ca.label  
FROM product pr
	JOIN category ca ON ca.id = pr.category_id
; 


SELECT * 
FROM view_products_with_category_label
WHERE unit_price < 100
;


SELECT bi.*, SUM(li.quantity * pr.unit_price) AS totalAmount
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
GROUP BY bi.id
ORDER BY bi.id
;



/*1 - Créer une vue basée sur la requête des 
factures avec leur montant.*/

CREATE VIEW view_bills_with_amount AS
SELECT bi.*, SUM(li.quantity * pr.unit_price) AS totalAmount
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
    JOIN category ca ON pr.category_id = ca.id
GROUP BY bi.id
ORDER BY bi.id
;


/*2 - Tester la vue */

SELECT * FROM view_bills_with_amount;


/*3 - Grace à la vue réaliser les requêtes suivantes

/*-> le nom, prénom et somme des factures des 3 clients qui ont passé le plus grand nombre 
de facture*/

SELECT cu.id, cu.lastname, cu.firstname, SUM(vbi.totalAmount) AS totalBilled, COUNT(vbi.id) AS nbBill
FROM customer cu
	JOIN view_bills_with_amount vbi ON vbi.customer_id = cu.id
GROUP BY cu.id
ORDER BY nbBill DESC
LIMIT 3
;

/*-> le nom, prénom et (somme des factures) des 3 clients qui ont passé les factures 
les plus chers*/

SELECT cu.id, cu.lastname, cu.firstname, SUM(vbi.totalAmount) AS totalBilled, MAX(vbi.totalAmount) AS MaxBill
FROM customer cu
	JOIN view_bills_with_amount vbi ON vbi.customer_id = cu.id
GROUP BY cu.id
ORDER BY MaxBill DESC
LIMIT 3
;

/*-> le nom, prénom et somme des factures des 3 clients qui ont  le total des factures 
les plus élevés*/


SELECT cu.id, cu.lastname, cu.firstname, SUM(vbi.totalAmount) AS totalBilled
FROM customer cu
	JOIN view_bills_with_amount vbi ON vbi.customer_id = cu.id
GROUP BY cu.id
ORDER BY totalBilled DESC
LIMIT 3
;


USE formation;

SELECT * FROM booking;
SELECT * FROM payment;

INSERT INTO payment (amount, date, payment_mean, booking_id)
VALUES (70, '2024-04-24', 'Cash', 5);

DROP PROCEDURE pay_bookings;

DELIMITER //
CREATE PROCEDURE pay_bookings(room_price FLOAT)
BEGIN

	UPDATE booking
	SET notes = 'Payé'
	WHERE id IN (
		SELECT booking_id
		FROM payment
		GROUP BY booking_id
			HAVING SUM(amount) >= room_price
	);
    
END//


CALL pay_bookings(120);




ALTER TABLE customer 
	ADD COLUMN is_vip BOOL NOT NULL; 
    
SELECT * FROM customer;

DROP PROCEDURE update_vips;
DELIMITER //
CREATE PROCEDURE update_vips(vipLimit FLOAT)
BEGIN

	UPDATE customer
    SET is_vip = false;

	UPDATE customer
	SET is_vip = true
	WHERE id IN (
		SELECT customer_id
		FROM view_bills_with_amount
		GROUP BY customer_id
			HAVING SUM(totalAmount) > vipLimit
	);
    
END//


CALL update_vips(25000);

USE billings;

SELECT * FROM customer;

SELECT * FROM customer WHERE id = 4001;
SELECT * FROM customer WHERE id = 5000;


SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, date_of_birth, NOW())))
FROM customer;

SELECT *
FROM customer
WHERE TIMESTAMPDIFF(YEAR, date_of_birth, NOW()) >= (
	SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, date_of_birth, NOW())))
	FROM customer
);

USE formation;


SELECT * FROM booking;

DELETE FROM booking
WHERE id = 1;

SET GLOBAL local_infile=1;

USE netflix;


LOAD DATA LOCAL INFILE 'C:\\formations\\SQL\\netflix.csv'
INTO TABLE import_netflix
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

SELECT * FROM import_netflix WHERE type = 'Movie';
SELECT * FROM movie;
SELECT * FROM director;

ALTER TABLE movie MODIFY release_year INT;

ALTER TABLE movie MODIFY country VARCHAR(255);


INSERT INTO movie (title, release_year, description, country, director_id)
SELECT title, release_year, description, country, 1 
FROM import_netflix
WHERE type = 'Movie'
AND release_year REGEXP '^[0-9]+$' = 1
; 


DELETE FROM movie;
SELECT * FROM movie;



DELIMITER //
CREATE PROCEDURE import_movies()
BEGIN

	DELETE FROM movie;
    
    INSERT INTO movie (title, release_year, description, country, director_id)
	SELECT title, release_year, description, country, 1 
	FROM import_netflix
	WHERE type = 'Movie'
	AND release_year REGEXP '^[0-9]+$' = 1
	; 

END//


CALL import_movies();

SELECT 
	SUBSTRING_INDEX(director, ' ', 1) AS firstname,
	SUBSTRING_INDEX(director, ' ', -1) AS lastname
FROM import_netflix
WHERE type = 'Movie'
;

SELECT director
FROM import_netflix
WHERE type = 'Movie'
;


USE billings;



/*-> pour chaque catégorie de produit la somme des facture 
payées*/

SELECT ca.id, ca.label, SUM(li.quantity * pr.unit_price) AS totalAmount
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
    JOIN category ca ON pr.category_id = ca.id
WHERE bi.is_paid = true
GROUP BY ca.id
;

/*-> par Année de facture la moyenne d'age des clients
	TIMESTAMPDIFF() -> */

SELECT YEAR(bi.date) AS billYear, AVG(TIMESTAMPDIFF(YEAR, cu.date_of_birth, bi.date)) AS averageAge
FROM bill bi
	JOIN customer cu ON cu.id = bi.customer_id
GROUP BY billYear
ORDER BY billYear
;


/*-> les nom, prénom et num de tel des clients qui ont
 commandes des produit de camping ces deux 
dernières années*/

SELECT cu.lastname, cu.firstname, cu.phone_number
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
    JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON pr.id = li.product_id
    JOIN category ca ON pr.category_id = ca.id
WHERE ca.label = 'Camping'
AND YEAR(bi.date) >= 2022
GROUP BY cu.id
ORDER BY cu.id
;



SELECT 	ca.label, 
        CASE WHEN is_paid = 1 THEN 'Factures payées' ELSE 
			CASE WHEN GROUPING(is_paid) = 1 THEN 'Sous-total : ' ELSE 'Factures impayées' END
        END AS status,
        SUM(li.quantity * pr.unit_price) AS totalAmount
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
    JOIN category ca ON pr.category_id = ca.id
GROUP BY ca.label, bi.is_paid WITH ROLLUP
;


USE netflix;


SELECT * FROM import_netflix
WHERE type = 'Movie';

SELECT * FROM movie
ORDER BY title;

SELECT * FROM director
WHERE lastname = 'Scorsese';



SELECT lastname, firstname, COUNT(*)
FROM director
GROUP BY lastname, firstname
	HAVING COUNT(*) >= 2
ORDER BY lastname, firstname
;

WITH director_double AS 
(
	SELECT lastname, firstname, COUNT(*)
	FROM director
	GROUP BY lastname, firstname
		HAVING COUNT(*) >= 2
	ORDER BY lastname, firstname
)

SELECT COUNT(*) FROM director_double;




SELECT 
		SUBSTRING_INDEX(director, ' ', 1) AS firstname,
		SUBSTRING_INDEX(director, ' ', -1) AS lastname
	FROM import_netflix
	WHERE type = 'Movie'
	AND director <> ''
    GROUP BY lastname, firstname
    ;


DROP PROCEDURE import_movies;
DELIMITER //
CREATE PROCEDURE import_movies()
BEGIN

	/* Gestion des Exceptions dans une procédure stockée */
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		ROLLBACK;
        SELECT ('Une erreur est survenue durant l\'execution de la procédure.') AS ErrorMessage;
    END;

    START TRANSACTION;
    
	DELETE FROM movie;
	DELETE FROM director;
    
    INSERT INTO director (firstname, lastname)
    SELECT 
		SUBSTRING_INDEX(director, ' ', 1) AS firstname,
		SUBSTRING_INDEX(director, ' ', -1) AS lastname
	FROM import_netflix
	WHERE type = 'Movie'
	AND director <> ''
    GROUP BY lastname, firstname
	;
    
	IF 	(     
			WITH director_double AS 
			(
				SELECT lastname, firstname, COUNT(*)
				FROM director
				GROUP BY lastname, firstname
					HAVING COUNT(*) >= 2
				ORDER BY lastname, firstname
			)

			SELECT COUNT(*) FROM director_double
		) > 0
	   THEN ROLLBACK;
	END IF;

    
    INSERT INTO movie (title, release_year, description, country, director_id)
	SELECT title, release_year, description, country, di.id
	FROM import_netflix imp
		JOIN director di ON imp.director = CONCAT(di.firstname, ' ', di.lastname)
	WHERE type = 'Movie'
    AND release_year REGEXP '^[0-9]+$' = 1
	; 

	COMMIT;
END//


SELECT * FROM movie;
SELECT * FROM director;

DELETE FROM movie;
DELETE FROM director;

CALL import_movies();

SET @nbOfMovies = (SELECT COUNT(*) FROM movie);
SET @nbOfDirectors = (SELECT COUNT(*) FROM director);

SELECT @nbOfMovies, @nbOfDirectors, @nbOfMovies + @nbOfDirectors AS result;


DROP PROCEDURE generate_viewings;

DELIMITER //
CREATE PROCEDURE generate_viewings(nbViewing INT)
BEGIN

	SET @nbLoop = 0;
    
	REPEAT
		SET @nbLoop = @nbLoop + 1;
        
		SET @userId = (SELECT id FROM user ORDER BY RAND() LIMIT 1);
		SET @movieId = (SELECT id FROM movie ORDER BY RAND() LIMIT 1);


		INSERT INTO viewing (date, user_id, movie_id)
		VALUES (NOW(), @userId, @movieId);
        
	UNTIL @nbLoop >= nbViewing END REPEAT;

END//


SELECT * FROM viewing;

CALL generate_viewings(500); 


SELECT * FROM import_netflix;

CALL insert_actor ('James Marsden');

CALL insert_cast ('Sofia Carson, Liza Koshy, Ken Jeong, Elizabeth Perkins, Jane Krakowski, Michael McKean, Phil LaMarr');

CALL import_actors();


SELECT *
FROM actor 
;


DELIMITER //
CREATE PROCEDURE insert_actor(full_name VARCHAR(200))
BEGIN

	SET @lastname = SUBSTRING_INDEX(full_name, ' ', -1);
	SET @firstname = SUBSTRING_INDEX(full_name, ' ', 1);
    
    IF (SELECT COUNT(*) FROM actor WHERE lastname = @lastname AND firstname = @firstname) = 0
		THEN

			INSERT INTO actor (lastname, firstname)
			VALUES (@lastname, @firstname);	
            
	END IF;

END//

DROP PROCEDURE insert_cast;
DELIMITER //
CREATE PROCEDURE insert_cast(cast TEXT)
BEGIN
	
    REPEAT
    
		SET @actor = SUBSTRING_INDEX(cast, ', ', 1);
		CALL insert_actor(@actor);
        
        SET cast = REPLACE(cast, CONCAT(@actor, ', '), '');
    
    UNTIL cast = @actor END REPEAT;

END//


DROP PROCEDURE import_actors;
DELIMITER //
CREATE PROCEDURE import_actors()
BEGIN

	DECLARE done BOOL DEFAULT false;
	DECLARE actors TEXT;
    DECLARE cur CURSOR FOR SELECT cast FROM import_netflix WHERE type = 'Movie' AND cast <> '' LIMIT 20;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
    OPEN cur;
    
    REPEAT 
		
        FETCH cur INTO actors;
        CALL insert_cast(actors);
    
    UNTIL done = true END REPEAT;
    
    CLOSE cur;

END//


/* Création tache plannifié */
CREATE EVENT daily_import_actors
	ON SCHEDULE
		EVERY 1 DAY
	DO CALL import_actors();
    
/* Modification tache plannifié */
ALTER EVENT daily_import_actors
	ON SCHEDULE
		EVERY 1 DAY
		STARTS '2024-04-27 01:00:00'
	DO CALL import_actors();



