DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS animals;
DROP TABLE IF EXISTS enclosures;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    employee_number INT
);

CREATE TABLE enclosures (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    capacity INT,
    closed_for_maintenance BOOLEAN
);

CREATE TABLE animals (
    id SERIAL,
    name VARCHAR(255),
    type VARCHAR(255),
    age INT,
    enclosure_id INT REFERENCES enclosures(id)
);

CREATE TABLE assignments (
    id SERIAL,
    employee_id INT REFERENCES employees(id),
    enclosure_id INT REFERENCES enclosures(id),
    day VARCHAR(255)
);

INSERT INTO employees (name, employee_number) VALUES ('Colin', 12873);
INSERT INTO employees (name, employee_number) VALUES ('Valeria', 78663);
INSERT INTO employees (name, employee_number) VALUES ('Ben', 98723);
INSERT INTO employees (name, employee_number) VALUES ('Kenny', 67752);
INSERT INTO employees (name, employee_number) VALUES ('Raheela', 77762);
INSERT INTO employees (name, employee_number) VALUES ('Iain', 37845);

INSERT INTO enclosures (name, capacity, closed_for_maintenance) VALUES ('Big Cat Field', 20, FALSE);
INSERT INTO enclosures (name, capacity, closed_for_maintenance) VALUES ('Reptile House', 30, FALSE);
INSERT INTO enclosures (name, capacity, closed_for_maintenance) VALUES ('Petting Zoo', 10, TRUE);
INSERT INTO enclosures (name, capacity, closed_for_maintenance) VALUES ('Bird Cage', 50, FALSE);

INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Leo', 'Lion', 12, 1);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Polly', 'Parrot', 21, 4);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Sid', 'Snake', 3, 2);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Rachel', 'Rabbit', 5, 3);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Charlotte', 'Cheetah', 8, 1);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Tanya', 'Turtle', 5, 2);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Michael', 'Maccaw', 19, 4);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Leah', 'Lion', 10, 1);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Luke', 'Lion', 6, 1);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Phil', 'Penguin', 2, 4);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Graham', 'Guinea Pig', 1, 3);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Nigel', 'Newt', 3, 2);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Naomi', 'Newt', 3, 2);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Harry', 'Hamster', 1, 3);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Terry', 'Tiger', 17, 1);

INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (1, 2, 'Monday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (5, 3, 'Wednesday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (1, 3, 'Thursday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (3, 2, 'Tuesday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (2, 1, 'Monday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (3, 3, 'Friday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (6, 4, 'Tuesday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (5, 2, 'Wednesday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (1, 1, 'Monday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (2, 4, 'Friday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (5, 3, 'Saturday');


--MVP QUERIES -------------------------------------------------------------------------------------------------------------------------------

--1. Find the names of the animals in a given enclosure: 

SELECT (animals.name)
FROM animals 
INNER JOIN  enclosures
ON enclosure_id = enclosures.id 
WHERE enclosures.name = 'Bird Cage';

--or --- we could do:

SELECT animals.name, enclosures.name
FROM animals
INNER JOIN enclosures
ON enclosures.id = animals.enclosure_id
WHERE  enclosures.id= 4;


--2. Find the names of the employees working in a given enclosure: 

SELECT employees.name, enclosures.name
FROM employees
INNER JOIN assignments
ON employees.id = assignments.employee_id
INNER JOIN enclosures
ON enclosures.id = assignments.enclosure_id
WHERE enclosures.id = 1;

--EXTENSIONS QUERIES -----------------------------------------------------------------------------------------------------------------------------

--1. The names of staff working in enclosures which are closed for maintenance

SELECT employees.name, enclosures.name, enclosures.closed_for_maintenance
FROM employees
INNER JOIN assignments 
ON employees.id = assignments.employee_id
INNER JOIN enclosures 
ON enclosures.id = assignments.enclosure_id
WHERE closed_for_maintenance = true;

--2. The name of the enclosure where the oldest animal lives. If there are two animals who are the same age choose the first one alphabetically.

SELECT enclosures.name,
FROM enclosures
INNER JOIN animals 
ON enclosures.id = animals.enclosure_id
ORDER BY age DESC, animals.name LIMIT 1 

--3 The number of diSELECT COUNT(DISTINCT animals.type)----------------------------------------------------------------------------------------------
FROM animals
INNER JOIN enclosures
ON animals.enclosure_id = enclosures.id 
INNER JOIN assignments 
ON enclosures.id = assignments.enclosure_id
WHERE assignments.employee_id = 2;

--4 The number of different keepers who have been assigned to work in a given enclosure---------------------------------------------------------------
SELECT COUNT(DISTINCT employees.name)
FROM employees
INNER JOIN assignments 
ON assignments.employee_id= employees.id 
WHERE enclosure_id = 2  


--5 The names of the other animals sharing an enclosure with a given animal (eg. find the names of all the animals sharing the big cat field with Tony)------

SELECT animals.name
FROM animals
INNER JOIN enclosures
ON animals.enclosure_id = enclosures.id
WHERE enclosures.id IN (SELECT animals.enclosure_id FROM animals WHERE animals.name = 'Polly');



--Note:

-- The syntax for the IN condition in SQL is:

-- expression IN (value1, value2, .... value_n);
-- OR

-- expression IN (subquery);
-- Parameters or Arguments
-- expression
-- This is a value to test.
-- value1, value2 ..., alue_n
-- These are the values to test against expression. If any of these values matches expression, then the IN condition will evaluate to true.
-- subquery
-- This is a SELECT statement whose result set will be tested against expression. If any of these values matches expression, then the IN condition will evaluate to true.
