-- deleting old tables if there are some


DROP TABLE reservation CASCADE CONSTRAINTS;
DROP TABLE economyClass CASCADE CONSTRAINTS;
DROP TABLE firstClass CASCADE CONSTRAINTS;
DROP TABLE seat CASCADE CONSTRAINTS;
DROP TABLE flight CASCADE CONSTRAINTS;
DROP TABLE aircraft CASCADE CONSTRAINTS;
DROP TABLE customer CASCADE CONSTRAINTS;
DROP TABLE airport CASCADE CONSTRAINTS;
DROP TABLE airline CASCADE CONSTRAINTS;
DROP TABLE conection CASCADE CONSTRAINTS;
DROP TABLE reservationStats CASCADE CONSTRAINTS;
 
 
 CREATE TABLE customer 
   (	
    cId INT PRIMARY KEY, --primary key
	firstName VARCHAR2(60 BYTE) NOT NULL, 
	surname VARCHAR2(60 BYTE) NOT NULL, 
	passportNumber INT NOT NULL, 
    email VARCHAR2(100 BYTE) NOT NULL, 
	phoneNumber INT NOT NULL, 
	cardNumber INT NOT NULL, 
	birthDate DATE NOT NULL,
	expirationDate DATE NOT NULL,
    
     CONSTRAINT cardNumberCheck CHECK (
        REGEXP_LIKE(cardNumber, '^(4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13})$')
    )
    );
    
     --IMPLEMENTACE SPECIALIZACE/GENERALIZACE
  CREATE TABLE reservation 
   (	
    rId INT PRIMARY KEY,--primary key
    price NUMBER(*,0) NOT NULL, 
	rDate DATE NOT NULL, --DATE OF THE FLIGHT
    creationDate DATE NOT NULL,
    customerId INT,
    passengersNum INT NOT NULL,  
    resType VARCHAR2(20 BYTE) NOT NULL,

    FOREIGN KEY (customerId) REFERENCES customer(cId)
);



 CREATE TABLE seat
(	
    seId INT PRIMARY KEY, --primary key
	sNumber INT NOT NULL,
    price NUMBER
);


CREATE TABLE airline
(	
    alId VARCHAR(3) PRIMARY KEY, --primary key
	alName VARCHAR(100),
    email VARCHAR(30),
    phoneNumber INT
);

CREATE TABLE aircraft
(	
    acId VARCHAR(6) PRIMARY KEY, --primary key
	producer VARCHAR(20) NOT NULL,
    acModel  VARCHAR(60) NOT NULL,
    totalCapacity INT NOT NULL,
    capacityEconomy INT NOT NULL,
    capacityFirst INT NOT NULL,
    alId VARCHAR(3),
    FOREIGN KEY (alId) REFERENCES airline(alId)
);

CREATE TABLE airport
(
    airportCode VARCHAR(3) PRIMARY KEY, --primary key
    airport VARCHAR(60)
);

CREATE TABLE flight 
(	
    flId VARCHAR(6) PRIMARY KEY, --primary key
	dateOfDeparture DATE NOT NULL, 
	dateOfArrival DATE NOT NULL, 
	origin VARCHAR(3), 
	destination VARCHAR(3), 
    price NUMBER(*,0) NOT NULL, 
    acId VARCHAR(6),
    FOREIGN KEY (acId) REFERENCES aircraft(acId),
    FOREIGN KEY (origin) REFERENCES airport(airportCode),
    FOREIGN KEY (destination) REFERENCES airport(airportCode)
    
);

 CREATE TABLE firstClass
 (
    fId INT PRIMARY KEY,--primary key
    menu VARCHAR2(20),
    resId INT,
    drinkNum INT NOT NULL, --number of consumed alcohol beverages
    
    FOREIGN KEY (resId) REFERENCES reservation(rId) --binding to the generall class
 );
  
  CREATE TABLE economyClass
 (
    eId INT PRIMARY KEY,--primary key
    fineNum INT NOT NULL,
    resId INT,
    totalPay INT NOT NULL,
    
    FOREIGN KEY (resId) REFERENCES reservation(rId) --binding to the generall class
 );   
     

CREATE TABLE conection --ternary relation 
( -- represented by a conecting table that stores all the primary keys
    seId INT,
    flId VARCHAR(6),
    rId INT,
    PRIMARY KEY (seId, flId, rID),
    FOREIGN KEY (seId) REFERENCES seat(seId),
    FOREIGN KEY (flId) REFERENCES flight(flId),
    FOREIGN KEY (rId) REFERENCES reservation(rId)
);

--help table for making the procedures
CREATE TABLE reservationStats (
  resDate  DATE PRIMARY KEY,
  avgPassengers NUMBER NOT NULL
);
   
---------DATA INSERT--------------  
  
     
INSERT INTO customer (cId, firstName, surname, passportNumber, email, phoneNumber, cardNumber, birthDate, expirationDate)   
VALUES (1, 'Jan', 'Novak', 0232413, 'novak@novak.cz', 924434453, 5105105105105100, date '2022-03-28',date '2022-03-28');

INSERT INTO customer (cId, firstName, surname, passportNumber, email, phoneNumber, cardNumber, birthDate, expirationDate)  
VALUES (2, 'Pavel', 'Kozak', 02324, 'Kozak@kozak.cz', 9244544453, 5555555555554444, date '2022-04-28', date '2022-04-28');



INSERT INTO reservation (rId, price, rDate, creationDate, customerId, passengersNum, resType) VALUES
(1, 200, date '2022-06-02',date '2022-04-03', 1, 1, 'economyClass');
INSERT INTO reservation (rId, price, rDate, creationDate, customerId, passengersNum, resType) VALUES
(2, 240, date '2023-07-02', date '2022-12-03', 2, 1, 'firstClass');

INSERT INTO airline(alId, alName, email, phoneNumber) VALUES
('rqt', 'RockAir', 'info@rock.com', 203238889);
INSERT INTO airline(alId, alName, email, phoneNumber) VALUES
('hbn', 'HonzaAir', 'info@honza.com', 756541889);

INSERT INTO aircraft(acId, producer, acModel,totalCapacity, capacityEconomy, capacityFirst, alId) VALUES
('oktvl', 'Airbus', 'a350-1000', 350, 200, 150, 'rqt');
INSERT INTO aircraft(acId, producer, acModel,totalCapacity, capacityEconomy, capacityFirst, alId) VALUES
('oktvs', 'Airbus', 'a340-600', 400, 330, 70, 'hbn');


INSERT INTO airport(airportCode, airport) VALUES
('brq', 'Brno');
INSERT INTO airport(airportCode, airport) VALUES
('stn', 'London');
INSERT INTO airport(airportCode, airport) VALUES
('apg', 'Malaga');

insert INTO seat (seId, sNumber, price) VALUES
(1, 34, 500);
insert INTO seat (seId, sNumber, price) VALUES
(2, 35, 52);

INSERT INTO firstClass (fId, menu, resId, drinkNum) VALUES
(1, 'Espanol', 1, 10);

INSERT INTO economyClass (eId, fineNum, resId, totalPay) VALUES
(2, 3, 2, 340);

INSERT INTO flight (flId, dateOfDeparture, dateOfArrival, origin, destination, price, acId) VALUES
('qs134', date '2023-06-02', date '2023-06-02', 'brq', 'stn', 10000, 'oktvl');
INSERT INTO flight (flId, dateOfDeparture, dateOfArrival, origin, destination, price, acId) VALUES
('ok321', date '2023-07-02', date '2023-07-02', 'brq', 'apg', 23200, 'oktvs');


INSERT INTO conection(seid, flId, rId) VALUES
(1, 'qs134', 1);
INSERT INTO conection(seid, flId, rId) VALUES
(2, 'ok321',2);



-- not needed for this part of project
----------------SELECT-----------------
----all the flights of oktvl aircraft, join of 2 tables
-- SELECT *
--  from flight NATURAL JOIN aircraft
--  WHERE  alId = 'oktvl';
--  
----all the flights of oktvs aircraft, join of 2 tables
--  SELECT *
--  from flight NATURAL JOIN aircraft
--  WHERE  alId = 'oktvs';
--  
----compleate flight info,  join 3 tables
--SELECT flight.flId, flight.dateOfDeparture, flight.dateOfArrival, flight.price, airline.alName, aircraft.acModel
--FROM flight
--JOIN airline ON flight.acId = airline.alId
--JOIN aircraft ON flight.acId = aircraft.acId;
--
----GROUP BY + agregation function
----number of flights from an airport
--SELECT COUNT(*) AS num_flights, origin
--FROM flight
--GROUP BY origin;
--
----total price of flights of an aircraft
--SELECT aircraft.acId, SUM(flight.price) AS total_revenue
--FROM aircraft
--JOIN flight ON aircraft.acId = flight.acId
--GROUP BY aircraft.acId;
--
--
----exits, selecting all the airlines with at least one flight
--SELECT *
--FROM airline a
--WHERE EXISTS (
--    SELECT 1
--    FROM flight f
--    WHERE f.acId = a.alId
--);
--
---- IN with insert SELECT, selects all the flights with aicrafts with bigger capacity than 100 seats
--SELECT *
--FROM flight
--WHERE acId IN (
--    SELECT acId
--    FROM aircraft
--    WHERE totalCapacity > 100
--);


---------------------------------TRIGGERS-----------------------------------

-- automatic increment of rId before inserting new reservation
CREATE OR REPLACE TRIGGER incrementReservationId
BEFORE INSERT ON reservation
FOR EACH ROW
BEGIN
  SELECT MAX(rId) + 1 INTO :new.rId FROM reservation;
END;
/

-------------- TEST ------------------- rId is not needed anymore
INSERT INTO reservation ( price, rDate, creationDate, customerId, passengersNum, resType) VALUES
(200, date '2022-06-02',date '2022-04-03', 1, 1, 'economyClass');

-- checks that customers passport number is not the same as passport numbers of other customers

CREATE OR REPLACE TRIGGER checkPassportNumber
  BEFORE INSERT ON customer
  FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM customer
  WHERE passportNumber = :new.passportNumber;
  
  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Passport number already exists in the database.');
  END IF;
END;
/

-------------------TEST--------------- inserting same passport Number raises error
--INSERT INTO customer (cId, firstName, surname, passportNumber, email, phoneNumber, cardNumber, birthDate, expirationDate)   
--VALUES (3, 'Jan', 'Horak', 0232413, 'horak@email.cz', 924434453, 5105105105105100, date '2022-03-28',date '2022-03-28');


----------------------------PROCEDURES-------------------------------------

-- procedure that counts avarage number of passengers per reservation
-- additional table reservationStats was created to store the data
CREATE OR REPLACE PROCEDURE avgPassengersPerReservation
IS
  vPassengersCount reservation.passengersNum%TYPE;
  vTotalPassengers NUMBER := 0;
  vReservationsCount NUMBER := 0;
  
  CURSOR cReservations IS
  SELECT passengersNum FROM reservation;
BEGIN
  OPEN cReservations;
  LOOP
    FETCH cReservations INTO vPassengersCount;
    EXIT WHEN cReservations%NOTFOUND;
    
    vTotalPassengers := vTotalPassengers + vPassengersCount;
    vReservationsCount := vReservationsCount + 1;
  END LOOP;
  CLOSE cReservations;
  
  IF vReservationsCount = 0 THEN
    DBMS_OUTPUT.PUT_LINE('No reservations found.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Average passengers per reservation: ' || vTotalPassengers / vReservationsCount);
  END IF;
  
  INSERT INTO reservationStats (resDate, avgPassengers)
  SELECT SYSDATE, vTotalPassengers / vReservationsCount FROM DUAL;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

---------------PROCEDURE 2-------------------------------------
-- procedure made to update totat price of a flight
-- takes two paramenters, the flight id and new price 
CREATE OR REPLACE PROCEDURE updateFlightPrice(pFlightId IN VARCHAR2, pNewPrice IN NUMBER)
IS
  vFlight flight%ROWTYPE;
  
  CURSOR cFlight IS
    SELECT *
    FROM flight
    WHERE flId = pFlightId;
BEGIN
  OPEN cFlight;
  FETCH cFlight INTO vFlight;
  CLOSE cFlight;
  
  IF vFlight.flId IS NULL THEN
    RAISE NO_DATA_FOUND;
  END IF;
  
  UPDATE flight
  SET price = pNewPrice
  WHERE flId = pFlightId;
  
  DBMS_OUTPUT.PUT_LINE('Price for flight ' || pFlightId || ' updated to ' || pNewPrice);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error: Flight ' || pFlightId || ' not found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(''); --handling other exceptions
END;
/

-- test of the Procedure
--BEGIN
  --updateFlightPrice('ok321', 1500);
--END;


-----------------------------INDEX and EXPLAIN PLAN---------------------------------
-- index created to faster the search of flights by departure date
CREATE INDEX depDateIndex ON flight(dateOfDeparture);
CREATE INDEX flightAcidIndex ON flight(acId);
--the SQL code selects the airline name 
--the number of flights per airline and the average price of those flights 
--by joining three tables airline, aircraft, and flight and grouping the result by the airline name.
--
EXPLAIN PLAN FOR
SELECT al.alName, COUNT(*) AS numFlights, AVG(f.price) AS avgPrice
FROM airline al
JOIN aircraft a ON al.alId = a.alId
JOIN flight f ON a.acId = f.acId
GROUP BY al.alName;




SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
-------------Permisions for xosusk00-------------
GRANT ALL ON customer to xosusk00;
GRANT ALL ON reservation to xosusk00;
GRANT ALL ON economyClass to xosusk00;
GRANT ALL ON firstClass to xosusk00;
GRANT ALL ON aircraft to xosusk00;
GRANT ALL ON airline to xosusk00;
GRANT ALL ON airport to xosusk00;
GRANT ALL ON seat to xosusk00;
GRANT ALL ON conection to xosusk00;
GRANT ALL ON flight to xosusk00;



---------------Persmisions for fake me-----------------
--GRANT ALL ON customer to xosusk01;
--GRANT ALL ON reservation to xosusk01;
--GRANT ALL ON economyClass to xosusk01;
--GRANT ALL ON firstClass to xosusk01;
--GRANT ALL ON aircraft to xosusk01;
--GRANT ALL ON airline to xosusk01;
--GRANT ALL ON airport to xosusk01;
--GRANT ALL ON seat to xosusk01;
--GRANT ALL ON conection to xosusk01;
--GRANT ALL ON flight to xosusk01;


---------------------------------------MATERIALIZED VIEW------------------------------------
---hypotetic part because i dont have second user and this code doesnt work because the database doesnt recognize user xosusk01
INSERT INTO xosusk00.customer (cId, firstName, surname, passportNumber, email, phoneNumber, cardNumber, birthDate, expirationDate)   
VALUES (5, 'Petr', 'Novak', 0234518, 'petr@novak.cz', 924434253, 5105105105105100, date '2022-03-28',date '2022-03-28');


--CREATE MATERIALIZED VIEW xosusk01.customersInfoMv
  --BUILD IMMEDIATE
  --REFRESH COMPLETE
  --ON COMMITs
  --AS
  --SELECT c.cId, c.firstName, c.surname, c.email, r.rId, r.price, r.rDate, r.creationDate
  --FROM xosusk00.customer c
  --JOIN xosusk00.reservation r ON c.cId = r.customerId;
--test 
-- SELECT * FROM xosusk01.customersInfMv;




-------------------COMPLEX SELECT-------------------------
----- takes data from customer table and reservation table
----- creates temporary table with customers data and information about their reservation
WITH 
  passengerCounts AS (
    SELECT 
      r.customerId, 
      COUNT(*) AS numOfPassengers
    FROM 
      reservation r
    GROUP BY 
      r.customerId
  )
SELECT 
  c.firstName,
  c.surname,
  c.email,
  c.birthDate,
  c.cardNumber,
  r.rDate,
  r.price,
  r.resType,
  CASE 
    WHEN pc.numOfPassengers IS NULL THEN 0
    ELSE pc.numOfPassengers
  END AS numOfPassengers
FROM 
  customer c
  LEFT JOIN reservation r ON c.cId = r.customerId
  LEFT JOIN passengerCounts pc ON c.cId = pc.customerId;
