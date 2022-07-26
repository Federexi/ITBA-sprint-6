/* PRIMER PROBLEMATICA */

ALTER TABLE cliente 
ADD customer_type TEXT DEFAULT CLASSIC;

UPDATE cliente 
SET customer_type = 'GOLD'
WHERE EXISTS (SELECT customer_id FROM cuenta WHERE customer_id = cliente.customer_id)
AND customer_id IN (SELECT customer_id FROM cuenta GROUP BY customer_id HAVING COUNT(customer_id) > 1 );

UPDATE cliente 
SET customer_type = 'GOLD'
WHERE EXISTS (SELECT customer_id FROM cuenta WHERE customer_id = cliente.customer_id)
AND customer_id IN (SELECT customer_id FROM cuenta GROUP BY customer_id HAVING COUNT(customer_id) = 1 )
AND EXISTS (SELECT customer_id FROM cuenta WHERE balance < 0 AND customer_id = cliente.customer_id);

UPDATE cliente 
SET customer_type = 'BLACK'
WHERE EXISTS (SELECT customer_id FROM cuenta WHERE customer_id = cliente.customer_id) 
AND customer_id IN (SELECT customer_id FROM cuenta GROUP BY customer_id HAVING COUNT(customer_id) > 2 );

ALTER TABLE cuenta 
ADD account_type TEXT DEFAULT 'Caja de ahorro en pesos';

UPDATE cuenta 
SET account_type = 'Cuenta Corriente'
WHERE balance < 0;

UPDATE cuenta 
SET account_type = 'Caja de ahorro en dólares'
WHERE account_id IN (SELECT account_id FROM cuenta WHERE account_type = 'Caja de ahorro en pesos' GROUP BY customer_id HAVING COUNT(customer_id) > 1 ORDER BY customer_id);

ALTER TABLE cuenta 
ADD card_provider TEXT DEFAULT VISA;

UPDATE cuenta
SET card_provider = 'MASTERCARD'
WHERE account_type = 'Cuenta Corriente';

UPDATE cuenta
SET card_provider = 'AMERICAN EXPRESS'
WHERE account_type = 'Caja de ahorro en dólares';

CREATE TABLE tarjeta (
	account_id INTEGER PRIMARY KEY AUTOINCREMENT,
	customer_id INTEGER NOT NULL DEFAULT 1,
	card_number varchar(255) UNIQUE CHECK(length(card_number)<=20),
	CVV TEXT NOT NULL,
	valid_from DATE NOT NULL,
	expiration_date DATE NOT NULL,
	type TEXT NOT NULL,
	FOREIGN KEY (account_id) REFERENCES cuenta (account_id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (customer_id) REFERENCES cliente (customer_id) ON UPDATE CASCADE ON DELETE CASCADE
);

UPDATE tarjeta
SET customer_id = (SELECT customer_id FROM cuenta WHERE account_id = tarjeta.account_id ORDER BY account_id);

/* AGREGAR TARJETAS */ 

CREATE TABLE direccion (
	branch_id INTEGER PRIMARY KEY AUTOINCREMENT,
	street TEXT NOT NULL,
	number TEXT NOT NULL,
	city TEXT NOT NULL,
	state TEXT NOT NULL,
	country TEXT NOT NULL
);

/* AGREGAR DIRECCIONES */

/* Corregir el campo employee_hire_date: */


/* SEGUNDA PROBLEMATICA */


/* TERCER PROBLEMATICA */

/* CUARTA PROBLEMATICA */

