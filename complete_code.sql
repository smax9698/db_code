-- PREPROCESS

DROP TABLE IF EXISTS Purchases;
DROP TABLE IF EXISTS AllPurchases;
DROP TABLE IF EXISTS TotPurByProd;
DROP TABLE IF EXISTS LastTotPurByProd;
DROP TABLE IF EXISTS Intermediate;


CREATE TABLE Purchases (
id INTEGER PRIMARY KEY,
time INTEGER NOT NULL,
province INTEGER NOT NULL,
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);
--

-- E0
CREATE TABLE AllPurchases (
id INTEGER PRIMARY KEY,
time INTEGER NOT NULL,
province INTEGER NOT NULL,
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);
CREATE TABLE TotPurByProd(
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);
CREATE TABLE LastTotPurByProd(
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);
CREATE TABLE Intermediate(
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);

--

-- P1
INSERT INTO Purchases SELECT * FROM period1.Purchases;
--

-- E1

DELETE FROM Purchases WHERE id <= (SELECT MAX(id) FROM AllPurchases);
INSERT INTO AllPurchases SELECT * FROM Purchases;

DELETE FROM LastTotPurByProd;
INSERT INTO LastTotPurByProd SELECT product, SUM(qty) AS 'cnt' FROM Purchases GROUP BY product;

WITH Tot AS (SELECT product, SUM(qty) AS qty FROM (SELECT * FROM LastTotPurByProd UNION SELECT * FROM TotPurByProd) GROUP BY product)
INSERT INTO Intermediate SELECT * FROM Tot;

DELETE FROM TotPurByProd;
INSERT INTO TotPurByProd SELECT * FROM Intermediate;
DELETE FROM Intermediate;

--

-- Q1-10

-- Q1
WITH A AS (SELECT name, country, ROWID FROM Province),
B AS (SELECT province AS 'name_id' , COUNT() AS 'cnt' FROM Purchases GROUP BY name_id),
S AS (SELECT A.country, SUM(B.cnt) AS 'cnt' FROM A INNER JOIN B ON A.ROWID = B.name_id GROUP BY country)


SELECT Country.name, S.cnt FROM S INNER JOIN Country ON Country.code = S.country WHERE cnt >= (SELECT MIN(cnt) FROM (SELECT S.cnt AS cnt FROM S INNER JOIN Country ON Country.code = S.country ORDER BY S.cnt DESC LIMIT 10)) ORDER  BY cnt DESC;


-- Q2
SELECT product, COUNT() AS 'cnt' FROM Purchases GROUP BY product;

-- Q3
WITH A AS (SELECT name, country, ROWID FROM Province),
B AS (SELECT province, COUNT() AS 'cnt' FROM Purchases WHERE product = 0 GROUP BY province),
C AS (SELECT country, name AS 'province' , max(cnt) AS 'abs',  CAST(max(cnt) AS float) /CAST(sum(cnt) AS foat) AS 'prop' FROM A INNER JOIN B ON A.ROWID = B.province GROUP BY country),
D AS (SELECT code, name FROM Country)

SELECT name AS country, province, abs, prop FROM C INNER JOIN D ON D.code = C.country ORDER BY prop DESC;

--Q4
WITH B AS (SELECT province AS 'province_id', qty, count(qty) AS 'cnt'  FROM Purchases GROUP BY province, qty),
C AS (SELECT country, continent FROM Encompasses WHERE percentage = 100),
D AS (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A JOIN B ON A.ROWID = B.province_id GROUP BY country, qty)

SELECT continent, qty, SUM(cnt) AS 'cnt' FROM D JOIN C ON C.country = D.country GROUP BY continent, qty;


-- Q5
SELECT product, count(product) FROM Purchases WHERE (time >= date('now','-10 day') AND time <=  date('now')) GROUP BY product;


-- Q6
SELECT time, count(time) FROM Purchases WHERE (time >= date('now','-10 day') AND time <=  date('now')) GROUP BY time;


-- Q7
SELECT ROWID AS 'ids'  FROM Purchases WHERE
(time = (SELECT max(time) from Purchases)
AND
(province = (SELECT ROWID FROM Province WHERE name = 'Brabant')));


-- Q8
SELECT ROWID AS 'ids'  FROM Purchases WHERE
(time = (SELECT max(time) from Purchases)
AND
(province = (SELECT ROWID FROM Province WHERE name = 'Vienna')));


-- Q9
WITH B AS (SELECT province AS 'provinceid', qty, count(qty) AS 'cnt' FROM Purchases WHERE (time>=  '2018-03-21'  AND time<= '2018-03-31') GROUP BY province, qty),
C AS (SELECT country, continent FROM Encompasses WHERE percentage = 100),
D AS (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A JOIN B ON A.ROWID = B.provinceid GROUP BY country,qty)

SELECT continent, qty, SUM(cnt) AS 'cnt' FROM D JOIN C ON C.country = D.country GROUP BY continent, qty;


-- Q10
WITH A AS (SELECT province AS 'province1', SUM(qty) AS 'cnt1' FROM Purchases WHERE (time <= '2018-03-31' AND time >= '2018-03-21') GROUP BY province),
B AS (SELECT province AS 'province2' , SUM(qty) AS 'cnt2' FROM Purchases WHERE (time <= '2018-03-20' AND time >= '2018-03-10') GROUP BY province),
C AS (SELECT province1, cnt1 AS 'qty_last10', cnt2 AS 'qty_1020', cnt1-cnt2 AS 'diff' FROM A JOIN B ON A.province1 = B.province2 ORDER BY diff DESC LIMIT 10),
D AS (SELECT ROWID, name, country FROM Province),
F AS (SELECT name, code FROM Country)

SELECT E.name AS 'province', F.name AS 'country', qty_last10, qty_1020 FROM (C JOIN D ON C.province1 = D.ROWID) E JOIN F ON E.country = F.code;
--

-- P2
INSERT INTO Purchases SELECT * FROM period2.Purchases;
--

-- E2
DELETE FROM Purchases WHERE id <= (SELECT MAX(id) FROM AllPurchases);
INSERT INTO AllPurchases SELECT * FROM Purchases;

DELETE FROM LastTotPurByProd;
INSERT INTO LastTotPurByProd SELECT product, SUM(qty) AS 'cnt' FROM Purchases GROUP BY product;

WITH Tot AS (SELECT product, SUM(qty) AS qty FROM (SELECT * FROM LastTotPurByProd UNION SELECT * FROM TotPurByProd) GROUP BY product)
INSERT INTO Intermediate SELECT * FROM Tot;

DELETE FROM TotPurByProd;
INSERT INTO TotPurByProd SELECT * FROM Intermediate;
DELETE FROM Intermediate;
--

-- Q1-10

-- Q1
WITH A AS (SELECT name, country, ROWID FROM Province),
B AS (SELECT province AS 'name_id' , COUNT() AS 'cnt' FROM Purchases GROUP BY name_id),
S AS (SELECT A.country, SUM(B.cnt) AS 'cnt' FROM A INNER JOIN B ON A.ROWID = B.name_id GROUP BY country)


SELECT Country.name, S.cnt FROM S INNER JOIN Country ON Country.code = S.country WHERE cnt >= (SELECT MIN(cnt) FROM (SELECT S.cnt AS cnt FROM S INNER JOIN Country ON Country.code = S.country ORDER BY S.cnt DESC LIMIT 10)) ORDER  BY cnt DESC;


-- Q2
SELECT product, COUNT() AS 'cnt' FROM Purchases GROUP BY product;

-- Q3
WITH A AS (SELECT name, country, ROWID FROM Province),
B AS (SELECT province, COUNT() AS 'cnt' FROM Purchases WHERE product = 0 GROUP BY province),
C AS (SELECT country, name AS 'province' , max(cnt) AS 'abs',  CAST(max(cnt) AS float) /CAST(sum(cnt) AS foat) AS 'prop' FROM A INNER JOIN B ON A.ROWID = B.province GROUP BY country),
D AS (SELECT code, name FROM Country)

SELECT name AS country, province, abs, prop FROM C INNER JOIN D ON D.code = C.country ORDER BY prop DESC;

--Q4
WITH B AS (SELECT province AS 'province_id', qty, count(qty) AS 'cnt'  FROM Purchases GROUP BY province, qty),
C AS (SELECT country, continent FROM Encompasses WHERE percentage = 100),
D AS (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A JOIN B ON A.ROWID = B.province_id GROUP BY country, qty)

SELECT continent, qty, SUM(cnt) AS 'cnt' FROM D JOIN C ON C.country = D.country GROUP BY continent, qty;


-- Q5
SELECT product, count(product) FROM Purchases WHERE (time >= date('now','-10 day') AND time <=  date('now')) GROUP BY product;


-- Q6
SELECT time, count(time) FROM Purchases WHERE (time >= date('now','-10 day') AND time <=  date('now')) GROUP BY time;


-- Q7
SELECT ROWID AS 'ids'  FROM Purchases WHERE
(time = (SELECT max(time) from Purchases)
AND
(province = (SELECT ROWID FROM Province WHERE name = 'Brabant')));


-- Q8
SELECT ROWID AS 'ids'  FROM Purchases WHERE
(time = (SELECT max(time) from Purchases)
AND
(province = (SELECT ROWID FROM Province WHERE name = 'Vienna')));


-- Q9
WITH B AS (SELECT province AS 'provinceid', qty, count(qty) AS 'cnt' FROM Purchases WHERE (time>=  '2018-03-21'  AND time<= '2018-03-31') GROUP BY province, qty),
C AS (SELECT country, continent FROM Encompasses WHERE percentage = 100),
D AS (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A JOIN B ON A.ROWID = B.provinceid GROUP BY country,qty)

SELECT continent, qty, SUM(cnt) AS 'cnt' FROM D JOIN C ON C.country = D.country GROUP BY continent, qty;


-- Q10
WITH A AS (SELECT province AS 'province1', SUM(qty) AS 'cnt1' FROM Purchases WHERE (time <= '2018-03-31' AND time >= '2018-03-21') GROUP BY province),
B AS (SELECT province AS 'province2' , SUM(qty) AS 'cnt2' FROM Purchases WHERE (time <= '2018-03-20' AND time >= '2018-03-10') GROUP BY province),
C AS (SELECT province1, cnt1 AS 'qty_last10', cnt2 AS 'qty_1020', cnt1-cnt2 AS 'diff' FROM A JOIN B ON A.province1 = B.province2 ORDER BY diff DESC LIMIT 10),
D AS (SELECT ROWID, name, country FROM Province),
F AS (SELECT name, code FROM Country)

SELECT E.name AS 'province', F.name AS 'country', qty_last10, qty_1020 FROM (C JOIN D ON C.province1 = D.ROWID) E JOIN F ON E.country = F.code;
--

-- P3
INSERT INTO Purchases SELECT * FROM period3.Purchases;
--

-- E3
DELETE FROM Purchases WHERE id IN (SELECT id FROM AllPurchases);
INSERT INTO AllPurchases SELECT * FROM Purchases;

DELETE FROM LastTotPurByProd;
INSERT INTO LastTotPurByProd SELECT product, SUM(qty) AS 'cnt' FROM Purchases GROUP BY product;

WITH Tot AS (SELECT product, SUM(qty) AS qty FROM (SELECT * FROM LastTotPurByProd UNION SELECT * FROM TotPurByProd) GROUP BY product)
INSERT INTO Intermediate SELECT * FROM Tot;

DELETE FROM TotPurByProd;
INSERT INTO TotPurByProd SELECT * FROM Intermediate;
DELETE FROM Intermediate;
--

-- Q1-10

-- Q1
WITH A AS (SELECT name, country, ROWID FROM Province),
B AS (SELECT province AS 'name_id' , COUNT() AS 'cnt' FROM Purchases GROUP BY name_id),
S AS (SELECT A.country, SUM(B.cnt) AS 'cnt' FROM A INNER JOIN B ON A.ROWID = B.name_id GROUP BY country)


SELECT Country.name, S.cnt FROM S INNER JOIN Country ON Country.code = S.country WHERE cnt >= (SELECT MIN(cnt) FROM (SELECT S.cnt AS cnt FROM S INNER JOIN Country ON Country.code = S.country ORDER BY S.cnt DESC LIMIT 10)) ORDER  BY cnt DESC;


-- Q2
SELECT product, COUNT() AS 'cnt' FROM Purchases GROUP BY product;

-- Q3
WITH A AS (SELECT name, country, ROWID FROM Province),
B AS (SELECT province, COUNT() AS 'cnt' FROM Purchases WHERE product = 0 GROUP BY province),
C AS (SELECT country, name AS 'province' , max(cnt) AS 'abs',  CAST(max(cnt) AS float) /CAST(sum(cnt) AS foat) AS 'prop' FROM A INNER JOIN B ON A.ROWID = B.province GROUP BY country),
D AS (SELECT code, name FROM Country)

SELECT name AS country, province, abs, prop FROM C INNER JOIN D ON D.code = C.country ORDER BY prop DESC;

--Q4
WITH B AS (SELECT province AS 'province_id', qty, count(qty) AS 'cnt'  FROM Purchases GROUP BY province, qty),
C AS (SELECT country, continent FROM Encompasses WHERE percentage = 100),
D AS (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A JOIN B ON A.ROWID = B.province_id GROUP BY country, qty)

SELECT continent, qty, SUM(cnt) AS 'cnt' FROM D JOIN C ON C.country = D.country GROUP BY continent, qty;


-- Q5
SELECT product, count(product) FROM Purchases WHERE (time >= date('now','-10 day') AND time <=  date('now')) GROUP BY product;


-- Q6
SELECT time, count(time) FROM Purchases WHERE (time >= date('now','-10 day') AND time <=  date('now')) GROUP BY time;


-- Q7
SELECT ROWID AS 'ids'  FROM Purchases WHERE
(time = (SELECT max(time) from Purchases)
AND
(province = (SELECT ROWID FROM Province WHERE name = 'Brabant')));


-- Q8
SELECT ROWID AS 'ids'  FROM Purchases WHERE
(time = (SELECT max(time) from Purchases)
AND
(province = (SELECT ROWID FROM Province WHERE name = 'Vienna')));


-- Q9
WITH B AS (SELECT province AS 'provinceid', qty, count(qty) AS 'cnt' FROM Purchases WHERE (time>=  '2018-03-21'  AND time<= '2018-03-31') GROUP BY province, qty),
C AS (SELECT country, continent FROM Encompasses WHERE percentage = 100),
D AS (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A JOIN B ON A.ROWID = B.provinceid GROUP BY country,qty)

SELECT continent, qty, SUM(cnt) AS 'cnt' FROM D JOIN C ON C.country = D.country GROUP BY continent, qty;


-- Q10
WITH A AS (SELECT province AS 'province1', SUM(qty) AS 'cnt1' FROM Purchases WHERE (time <= '2018-03-31' AND time >= '2018-03-21') GROUP BY province),
B AS (SELECT province AS 'province2' , SUM(qty) AS 'cnt2' FROM Purchases WHERE (time <= '2018-03-20' AND time >= '2018-03-10') GROUP BY province),
C AS (SELECT province1, cnt1 AS 'qty_last10', cnt2 AS 'qty_1020', cnt1-cnt2 AS 'diff' FROM A JOIN B ON A.province1 = B.province2 ORDER BY diff DESC LIMIT 10),
D AS (SELECT ROWID, name, country FROM Province),
F AS (SELECT name, code FROM Country)

SELECT E.name AS 'province', F.name AS 'country', qty_last10, qty_1020 FROM (C JOIN D ON C.province1 = D.ROWID) E JOIN F ON E.country = F.code;
--
