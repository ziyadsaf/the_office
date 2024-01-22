----------------------------------------------------------------------------------------------
-----------------------------------Table Creation----------------------------------------------
----------------------------------------------------------------------------------------------

CREATE TABLE employee (
    employee_id INT AUTO_INCREMENT,
    forename VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL,
    dob DATE NOT NULL,
    sex VARCHAR(1) NOT NULL,
    salary INT NOT NULL,
    super_id INT,
    branch_id INT,
    desk INT
    PRIMARY KEY(employee_id)
);

CREATE TABLE branch(
    branch_id INT AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    manager_id INT NOT NULL,
    FOREIGN KEY manager_id REFERENCES employee(employee_id),
    PRIMARY KEY(branch_id)
);

CREATE TABLE supplier (
    supplier_id INT AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    type VARCHAR(10) NOT NULL,
    branch_id INT,
    PRIMARY KEY (supplier_id),
    FOREIGN KEY (branch_id) REFERENCES branch (branch_id)
);

CREATE TABLE client (
    client_id INT AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    branch_id INT,
    PRIMARY KEY (client_id),
    FOREIGN KEY (branch_id) REFERENCES branch (branch_id)
);

CREATE TABLE client_employee_rel (
    employee_id INT,
    client_id INT,
    sales INT,
    PRIMARY KEY(employee_id, client_id),
    FOREIGN KEY(employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

DESCRIBE client_employee_rel;
----------------------------------------------------------------------------------------------
--------------------------------Inserting and modifying data----------------------------------
----------------------------------------------------------------------------------------------

INSERT INTO employee(employee_id,forename,surname,dob,sex,salary) VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000);
INSERT INTO branch VALUES('Corporate',100);

UPDATE employee
SET branch_id = 1
WHERE employee_id = 100;

INSERT INTO employee(forename,surname,dob,sex,salary,supervisor_id) VALUES('Jan', 'Levinson', '1961-05-11', 'F', 100000,100);
INSERT INTO employee(forename,surname,dob,sex,salary, supervisor_id) VALUES('Michael', 'Scott', '1964-03-15', 'M', 70000,101);
INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2,'Y');
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2,'Y');
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2,'Y');

INSERT INTO branch VALUES (2,'Scranton',102);
INSERT INTO branch(branch_id,name) VALUES (3,'Stamford');

INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, 3,'Y');
INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3,'Y');
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3,'Y');
INSERT INTO employee VALUES(109, 'Dwight', 'Schrute', '1968-01-20', 'M', 65000, 102, 2,'Y','Assistant to the Regional Manager');

UPDATE employee
SET branch_id = 1
WHERE employee_id = 101;

INSERT INTO supplier VALUES(1, 'Hammer Mill', 'Paper',2);
INSERT INTO supplier VALUES(2, 'Uni-ball', 'Writing Utensils',3);
INSERT INTO supplier VALUES(3, 'Patriot Paper', 'Paper',3);
INSERT INTO supplier VALUES(4, 'J.T. Forms & Labels', 'Custom Forms',2);
INSERT INTO supplier VALUES(5, 'Stamford Lables', 'Custom Forms',2);
UPDATE supplier
SET name = 'Stamford Labels'
WHERE supplier_id = 5;

ALTER TABLE supplier MODIFY COLUMN name VARCHAR(30);
ALTER TABLE employee MODIFY COLUMN job VARCHAR(40);

INSERT INTO client_employee_rel VALUES(105, 400, 55000);
INSERT INTO client_employee_rel VALUES(102, 401, 267000);
INSERT INTO client_employee_rel VALUES(108, 402, 22500);
INSERT INTO client_employee_rel VALUES(107, 403, 5000);
INSERT INTO client_employee_rel VALUES(108, 403, 12000);
INSERT INTO client_employee_rel VALUES(105, 404, 33000);
INSERT INTO client_employee_rel VALUES(107, 405, 26000);
INSERT INTO client_employee_rel VALUES(102, 406, 15000);
INSERT INTO client_employee_rel VALUES(105, 406, 130000);

INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

ALTER TABLE employee
MODIFY COLUMN desk 
CHAR(1);

ALTER TABLE employee
ADD COLUMN
job VARCHAR(10);

UPDATE employee
SET job = 'Sales'
WHERE employee_id NOT IN (100,101,102);

UPDATE employee
SET job = 'Regional Manager'
WHERE employee_id = 102;

----------------------------------------------------------------------------------------------
------------------------------------------- QUERIES -----------------------------------------
----------------------------------------------------------------------------------------------

-- Find all employees ordered by salary
SELECT *
FROM employee
ORDER BY salary DESC;

--Find all employees ordered by sex then name
SELECT *
FROM employee
ORDER BY sex, surname, forename DESC;

-- Find first 5 employees
SELECT *
FROM employee
LIMIT 5;

--Find the forename and surnames of all employees
SELECT forename, surname
FROM employee;

--Find the forename and surnames of all employees and rename columns
SELECT forename AS first_name, surname AS last_name
FROM employee;

--Find out all the different genders
SELECT DISTINCT sex
FROM employee;

-- Find all different suppliers
SELECT DISTINCT supplier_id 
FROM supplier
ORDER BY supplier_id;

--Find the number of employees
SELECT COUNT(employee_id)
FROM employee;

-- Find number of female employees born after 1970
SELECT COUNT(employee_id)
FROM employee
WHERE sex = 'F' AND dob > '1970-01-01';
 
 -- Find average of all employee salaries
SELECT AVG(salary)
FROM employee;

  -- Find sum of all employee salaries
SELECT SUM(salary)
FROM employee;

 --Find out how many males and females there are using AGGREGATION (GROUP BY)
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;



SELECT * FROM client_employee_rel;
SELECT * FROM client;

---------------------------------------------Wildcards-----------------------------------------
-- % = any # characters
-- _ = one character


-- Find clients who are an LLC
SELECT *
FROM client
WHERE client.name LIKE '%LLC';

--Find any branch suppliers who are in the label business
SELECT *
FROM supplier
WHERE supplier.name LIKE '%label%';

--Find any employee born in october
SELECT *
FROM employee
WHERE employee.dob LIKE '%-10-%';

--------------------------------------------Unions------------------------------------------
-- Must have same number of columns in all selects
-- Must have similar data type in selects

-- Find a list of employee and branch names

SELECT forename AS company_names
FROM employee
UNION
SELECT name 
FROM branch
UNION
SELECT name 
FROM client;

--------------------------------------------Joins----------------------------------------------

--Find total sales of each salesmen and show their names
SELECT SUM(sales), c.employee_id, e.forename, e.surname
FROM client_employee_rel AS c
INNER JOIN employee AS e ON c.employee_id=e.employee_id
GROUP BY c.employee_id;

--Find total expenditure of each client and show their names and branch they are associated with
SELECT SUM(sales), ce.client_id,c.name AS client_name, b.branch_id, b.name AS branch_name
FROM client_employee_rel AS ce
INNER JOIN client AS c 
ON ce.client_id = c.client_id
INNER JOIN branch as b 
ON c.branch_id = b.branch_id
GROUP BY ce.client_id
ORDER BY c.name;

--Find all branches and the names of their managers
SELECT b.name, e.forename, e.surname, e.employee_id
FROM branch as b 
JOIN employee as e ON b.manager_id = e.employee_id;

--Using left join
SELECT e.employee_id,e.forename, e.surname,b.name
FROM employee as e
LEFT JOIN branch as b 
ON b.manager_id = e.employee_id
ORDER BY b.name DESC;

-- all employees are included from the left table (employee)
-- left join includes all rows from left table even if they dont manage a branch

--Using RIGHT join
SELECT e.employee_id,e.forename, e.surname,b.name
FROM employee as e
RIGHT JOIN branch as b 
ON b.manager_id = e.employee_id
ORDER BY b.name DESC;

-- Will include all rows from the right table (branch) even if they dont have a manager


-------------------------------------------Nested Queries----------------------------------------

--Find names of all employees who have sold over 30000 to a single client

--First select all the employee ids that sold over 30000 - befoire getting names
SELECT DISTINCT c.employee_id
FROM client_employee_rel AS c
WHERE sales > 30000;

--Next, selectall names where id = id from client_employee_rel
SELECT DISTINCT e.forename, e.surname
FROM employee AS e
JOIN client_employee_rel AS c 
ON e.employee_id = c.employee_id;

-- but dont need join when using nested..
SELECT DISTINCT e.forename, e.surname
FROM employee AS e
WHERE e.employee_id IN client_employee_rel;

-- Then combine with IN:
SELECT DISTINCT e.forename, e.surname
FROM employee AS e
WHERE e.employee_id IN  (
    SELECT DISTINCT c.employee_id
    FROM client_employee_rel AS c
    WHERE sales > 30000

);

-- Find all clients who are handled by the branch that Michael Scott manages
-- First get branch michael scott managers
SELECT b.branch_id
FROM branch as b 
WHERE manager_id = 106;

-- Second, get all clients handled by branch id 
SELECT name
FROM client 
WHERE branch_id IN (
    SELECT b.branch_id
    FROM branch as b 
    WHERE manager_id = 102
);
Showing 313 of 313 linesShow less

Result
(0 Rows)
No Results found
/queries/-NolW3Jc2r-a2MhbPfH6/the-office
