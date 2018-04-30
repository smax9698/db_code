-- PREPROCESS

DROP TABLE IF EXISTS AllPurchases;
DROP TABLE IF EXISTS Purchases;
DROP TABLE IF EXISTS TimeMax;
DROP TABLE IF EXISTS UsefulDataPurchases;
DROP TABLE IF EXISTS Intermediate;
DROP TABLE IF EXISTS UsefulDataPurchases10;


CREATE TABLE Purchases (
id INTEGER PRIMARY KEY,
time INTEGER NOT NULL,
province INTEGER NOT NULL,
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);
--

-- E0
CREATE TABLE TimeMax(
  time INTEGER NOT NULL
);

CREATE TABLE AllPurchases (
id INTEGER PRIMARY KEY,
time INTEGER NOT NULL,
province INTEGER NOT NULL,
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);

CREATE TABLE UsefulDataPurchases(
  country TEXT NOT NULL,
  province INTEGER NOT NULL,
  province_name TEXT NOT NULL,
  product INTEGER NOT NULL,
  purchases INTEGER NOT NULL,
  qty INTEGER NOT NULL
);

CREATE TABLE UsefulDataPurchases10(
  country TEXT NOT NULL,
  province INTEGER NOT NULL,
  province_name TEXT NOT NULL,
  product INTEGER NOT NULL,
  purchases INTEGER NOT NULL,
  qty INTEGER NOT NULL
);

CREATE TABLE Intermediate(
  country TEXT NOT NULL,
  province INTEGER NOT NULL,
  province_name TEXT NOT NULL,
  product INTEGER NOT NULL,
  purchases INTEGER NOT NULL,
  qty INTEGER NOT NULL
);

--

-- P1
INSERT INTO Purchases SELECT * FROM period1.Purchases;
--

-- E1
DELETE FROM TimeMax;
INSERT INTO TimeMax SELECT Max(time) FROM Purchases;

INSERT INTO AllPurchases SELECT * FROM Purchases;

DROP TABLE UsefulDataPurchases10;
CREATE TABLE UsefulDataPurchases10(
  country TEXT NOT NULL,
  province INTEGER NOT NULL,
  province_name TEXT NOT NULL,
  product INTEGER NOT NULL,
  purchases INTEGER NOT NULL,
  qty INTEGER NOT NULL
);
DROP TABLE Intermediate;
CREATE TABLE Intermediate(
  country TEXT NOT NULL,
  province INTEGER NOT NULL,
  province_name TEXT NOT NULL,
  product INTEGER NOT NULL,
  purchases INTEGER NOT NULL,
  qty INTEGER NOT NULL
);

WITH
A AS (SELECT name AS province, country, ROWID FROM Province),
B AS (SELECT province AS province_name, name AS country, ROWID FROM A JOIN Country ON Country.code == A.country),
C AS (SELECT province, product, count() AS purchases, sum(qty) AS qty FROM Purchases GROUP BY province, product)

INSERT INTO UsefulDataPurchases10 SELECT country, province, province_name, product, purchases, qty FROM B JOIN C ON B.ROWID == C.province;

INSERT INTO Intermediate SELECT country, province, province_name, product, SUM(purchases) AS purchases, SUM(qty) AS qty FROM (SELECT * FROM UsefulDataPurchases10 UNION SELECT * FROM UsefulDataPurchases) GROUP BY country, province, province_name, product;

DROP TABLE UsefulDataPurchases;
CREATE TABLE UsefulDataPurchases(
  country TEXT NOT NULL,
  province INTEGER NOT NULL,
  province_name TEXT NOT NULL,
  product INTEGER NOT NULL,
  purchases INTEGER NOT NULL,
  qty INTEGER NOT NULL
);

INSERT INTO UsefulDataPurchases SELECT * FROM Intermediate;

DROP TABLE Purchases;
CREATE TABLE Purchases (
id INTEGER PRIMARY KEY,
time INTEGER NOT NULL,
province INTEGER NOT NULL,
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);
--

-- Q1-10

-- Q1
WITH A AS (SELECT name, country, ROWID FROM Province),
B AS (SELECT province AS 'name_id' , COUNT() AS 'cnt' FROM AllPurchases GROUP BY name_id),
S AS (SELECT A.country, SUM(B.cnt) AS 'cnt' FROM A JOIN B ON A.ROWID = B.name_id GROUP BY country)

SELECT Country.name, S.cnt FROM S JOIN Country ON Country.code = S.country ORDER  BY cnt DESC LIMIT 10;

-- Q2
SELECT product, COUNT() AS 'cnt' FROM AllPurchases GROUP BY product;

-- Q3
WITH A AS (SELECT name, country, ROWID FROM Province),
B AS (SELECT province, COUNT() AS 'cnt' FROM AllPurchases WHERE product = 0 GROUP BY province),
F AS (SELECT name, country, province, cnt AS cnt FROM A INNER JOIN B ON A.ROWID = B.province),
E AS (SELECT country AS countryE, sum(cnt) AS totByCountry, max(cnt) AS maxByCountry FROM A INNER JOIN B ON A.ROWID = B.province GROUP BY country),
C AS (SELECT country, name AS 'province' , cnt AS 'abs',  CAST(cnt AS float) / CAST(totByCountry AS foat) AS 'prop' FROM F INNER JOIN E ON E.countryE = F.country WHERE E.maxByCountry = F.cnt GROUP BY province),
D AS (SELECT code, name FROM Country)

SELECT name AS country, province, abs, prop FROM C INNER JOIN D ON D.code = C.country ORDER BY prop DESC;

--Q4
WITH B AS (SELECT province AS 'province_id', qty, count(qty) AS 'cnt'  FROM AllPurchases GROUP BY province, qty),
C AS (SELECT country, continent FROM Encompasses WHERE percentage = 100),
D AS (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A JOIN B ON A.ROWID = B.province_id GROUP BY country, qty)

SELECT continent, qty, SUM(cnt) AS 'cnt' FROM D JOIN C ON C.country = D.country GROUP BY continent, qty;


-- Q5
SELECT product, count() AS 'cnt' FROM AllPurchases WHERE (time > date((SELECT * FROM TimeMax), '-10 days')) GROUP BY product;

-- Q6
SELECT time, count() AS 'cnt' FROM Purchases WHERE (time > date((SELECT * FROM TimeMax), '-10 days')) GROUP BY time;

-- Q7
SELECT ROWID AS 'ids'  FROM Purchases WHERE
(time = date((SELECT * FROM TimeMax))
AND
(province = (SELECT ROWID FROM Province WHERE name = 'Brabant')));

-- Q8
SELECT ROWID AS 'ids'  FROM Purchases WHERE
(time = date((SELECT * FROM TimeMax))
AND
(province = (SELECT ROWID FROM Province WHERE name = 'Vienna')));

-- Q9
WITH B AS (SELECT province AS 'provinceid', qty, count(qty) AS 'cnt' FROM AllPurchases WHERE (time>  date((SELECT * FROM TimeMax), '-10 days')) GROUP BY province, qty),
C AS (SELECT country, continent FROM Encompasses WHERE percentage = 100),
D AS (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A JOIN B ON A.ROWID = B.provinceid GROUP BY country,qty)

SELECT continent, qty, SUM(cnt) AS 'cnt' FROM D JOIN C ON C.country = D.country GROUP BY continent, qty;

-- Q10
WITH A AS (SELECT province AS 'province1', SUM(qty) AS 'cnt1' FROM Purchases WHERE (time > date((SELECT * FROM TimeMax), '-10 days')) GROUP BY province),
B AS (SELECT province AS 'province2' , SUM(qty) AS 'cnt2' FROM Purchases WHERE (time <= date((SELECT * FROM TimeMax), '-10 days') AND time > date((SELECT * FROM TimeMax), '-20 days')) GROUP BY province),
C AS (SELECT province1, cnt1 AS 'qty_last10', cnt2 AS 'qty_1020', cnt1-cnt2 AS 'diff' FROM A JOIN B ON A.province1 = B.province2 ORDER BY diff DESC LIMIT 10),
D AS (SELECT ROWID, name, country FROM Province),
F AS (SELECT name, code FROM Country)

SELECT E.name AS 'province', F.name AS 'country', qty_last10, qty_1020 FROM (C JOIN D ON C.province1 = D.ROWID) E JOIN F ON E.country = F.code;

--

-- P2
INSERT INTO Purchases SELECT * FROM period2.Purchases;
--

-- E1
DELETE FROM TimeMax;
INSERT INTO TimeMax SELECT Max(time) FROM Purchases;

INSERT INTO AllPurchases SELECT * FROM Purchases;

DROP TABLE UsefulDataPurchases10;
CREATE TABLE UsefulDataPurchases10(
  country TEXT NOT NULL,
  province INTEGER NOT NULL,
  province_name TEXT NOT NULL,
  product INTEGER NOT NULL,
  purchases INTEGER NOT NULL,
  qty INTEGER NOT NULL
);
DROP TABLE Intermediate;
CREATE TABLE Intermediate(
  country TEXT NOT NULL,
  province INTEGER NOT NULL,
  province_name TEXT NOT NULL,
  product INTEGER NOT NULL,
  purchases INTEGER NOT NULL,
  qty INTEGER NOT NULL
);

WITH
A AS (SELECT name AS province, country, ROWID FROM Province),
B AS (SELECT province AS province_name, name AS country, ROWID FROM A JOIN Country ON Country.code == A.country),
C AS (SELECT province, product, count() AS purchases, sum(qty) AS qty FROM Purchases GROUP BY province, product)

INSERT INTO UsefulDataPurchases10 SELECT country, province, province_name, product, purchases, qty FROM B JOIN C ON B.ROWID == C.province;

INSERT INTO Intermediate SELECT country, province, province_name, product, SUM(purchases) AS purchases, SUM(qty) AS qty FROM (SELECT * FROM UsefulDataPurchases10 UNION SELECT * FROM UsefulDataPurchases) GROUP BY country, province, province_name, product;

DROP TABLE UsefulDataPurchases;
CREATE TABLE UsefulDataPurchases(
  country TEXT NOT NULL,
  province INTEGER NOT NULL,
  province_name TEXT NOT NULL,
  product INTEGER NOT NULL,
  purchases INTEGER NOT NULL,
  qty INTEGER NOT NULL
);

INSERT INTO UsefulDataPurchases SELECT * FROM Intermediate;

DROP TABLE Purchases;
CREATE TABLE Purchases (
id INTEGER PRIMARY KEY,
time INTEGER NOT NULL,
province INTEGER NOT NULL,
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);

--

-- Q1-10

-- Q1
WITH A AS (SELECT name, country, ROWID FROM Province),
B AS (SELECT province AS 'name_id' , COUNT() AS 'cnt' FROM AllPurchases GROUP BY name_id),
S AS (SELECT A.country, SUM(B.cnt) AS 'cnt' FROM A JOIN B ON A.ROWID = B.name_id GROUP BY country)

SELECT Country.name, S.cnt FROM S JOIN Country ON Country.code = S.country ORDER  BY cnt DESC LIMIT 10;

-- Q2
SELECT product, COUNT() AS 'cnt' FROM AllPurchases GROUP BY product;

-- Q3
WITH A AS (SELECT name, country, ROWID FROM Province),
B AS (SELECT province, COUNT() AS 'cnt' FROM AllPurchases WHERE product = 0 GROUP BY province),
F AS (SELECT name, country, province, cnt AS cnt FROM A INNER JOIN B ON A.ROWID = B.province),
E AS (SELECT country AS countryE, sum(cnt) AS totByCountry, max(cnt) AS maxByCountry FROM A INNER JOIN B ON A.ROWID = B.province GROUP BY country),
C AS (SELECT country, name AS 'province' , cnt AS 'abs',  CAST(cnt AS float) / CAST(totByCountry AS foat) AS 'prop' FROM F INNER JOIN E ON E.countryE = F.country WHERE E.maxByCountry = F.cnt GROUP BY province),
D AS (SELECT code, name FROM Country)

SELECT name AS country, province, abs, prop FROM C INNER JOIN D ON D.code = C.country ORDER BY prop DESC;

--Q4
WITH B AS (SELECT province AS 'province_id', qty, count(qty) AS 'cnt'  FROM AllPurchases GROUP BY province, qty),
C AS (SELECT country, continent FROM Encompasses WHERE percentage = 100),
D AS (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A JOIN B ON A.ROWID = B.province_id GROUP BY country, qty)

SELECT continent, qty, SUM(cnt) AS 'cnt' FROM D JOIN C ON C.country = D.country GROUP BY continent, qty;


-- Q5
SELECT product, count() AS 'cnt' FROM AllPurchases WHERE (time > date((SELECT * FROM TimeMax), '-10 days')) GROUP BY product;

-- Q6
SELECT time, count() AS 'cnt' FROM Purchases WHERE (time > date((SELECT * FROM TimeMax), '-10 days')) GROUP BY time;

-- Q7
SELECT ROWID AS 'ids'  FROM Purchases WHERE
(time = date((SELECT * FROM TimeMax))
AND
(province = (SELECT ROWID FROM Province WHERE name = 'Brabant')));

-- Q8
SELECT ROWID AS 'ids'  FROM Purchases WHERE
(time = date((SELECT * FROM TimeMax))
AND
(province = (SELECT ROWID FROM Province WHERE name = 'Vienna')));

-- Q9
WITH B AS (SELECT province AS 'provinceid', qty, count(qty) AS 'cnt' FROM AllPurchases WHERE (time>  date((SELECT * FROM TimeMax), '-10 days')) GROUP BY province, qty),
C AS (SELECT country, continent FROM Encompasses WHERE percentage = 100),
D AS (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A JOIN B ON A.ROWID = B.provinceid GROUP BY country,qty)

SELECT continent, qty, SUM(cnt) AS 'cnt' FROM D JOIN C ON C.country = D.country GROUP BY continent, qty;

-- Q10
WITH A AS (SELECT province AS 'province1', SUM(qty) AS 'cnt1' FROM Purchases WHERE (time > date((SELECT * FROM TimeMax), '-10 days')) GROUP BY province),
B AS (SELECT province AS 'province2' , SUM(qty) AS 'cnt2' FROM Purchases WHERE (time <= date((SELECT * FROM TimeMax), '-10 days') AND time > date((SELECT * FROM TimeMax), '-20 days')) GROUP BY province),
C AS (SELECT province1, cnt1 AS 'qty_last10', cnt2 AS 'qty_1020', cnt1-cnt2 AS 'diff' FROM A JOIN B ON A.province1 = B.province2 ORDER BY diff DESC LIMIT 10),
D AS (SELECT ROWID, name, country FROM Province),
F AS (SELECT name, code FROM Country)

SELECT E.name AS 'province', F.name AS 'country', qty_last10, qty_1020 FROM (C JOIN D ON C.province1 = D.ROWID) E JOIN F ON E.country = F.code;

--

-- P3
INSERT INTO Purchases SELECT * FROM period3.Purchases;
--

-- E1
DELETE FROM TimeMax;
INSERT INTO TimeMax SELECT Max(time) FROM Purchases;

INSERT INTO AllPurchases SELECT * FROM Purchases;

DROP TABLE UsefulDataPurchases10;
CREATE TABLE UsefulDataPurchases10(
  country TEXT NOT NULL,
  province INTEGER NOT NULL,
  province_name TEXT NOT NULL,
  product INTEGER NOT NULL,
  purchases INTEGER NOT NULL,
  qty INTEGER NOT NULL
);
DROP TABLE Intermediate;
CREATE TABLE Intermediate(
  country TEXT NOT NULL,
  province INTEGER NOT NULL,
  province_name TEXT NOT NULL,
  product INTEGER NOT NULL,
  purchases INTEGER NOT NULL,
  qty INTEGER NOT NULL
);

WITH
A AS (SELECT name AS province, country, ROWID FROM Province),
B AS (SELECT province AS province_name, name AS country, ROWID FROM A JOIN Country ON Country.code == A.country),
C AS (SELECT province, product, count() AS purchases, sum(qty) AS qty FROM Purchases GROUP BY province, product)

INSERT INTO UsefulDataPurchases10 SELECT country, province, province_name, product, purchases, qty FROM B JOIN C ON B.ROWID == C.province;

INSERT INTO Intermediate SELECT country, province, province_name, product, SUM(purchases) AS purchases, SUM(qty) AS qty FROM (SELECT * FROM UsefulDataPurchases10 UNION SELECT * FROM UsefulDataPurchases) GROUP BY country, province, province_name, product;

DROP TABLE UsefulDataPurchases;
CREATE TABLE UsefulDataPurchases(
  country TEXT NOT NULL,
  province INTEGER NOT NULL,
  province_name TEXT NOT NULL,
  product INTEGER NOT NULL,
  purchases INTEGER NOT NULL,
  qty INTEGER NOT NULL
);

INSERT INTO UsefulDataPurchases SELECT * FROM Intermediate;

DROP TABLE Purchases;
CREATE TABLE Purchases (
id INTEGER PRIMARY KEY,
time INTEGER NOT NULL,
province INTEGER NOT NULL,
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);

--

-- Q1-10

-- Q1
WITH A AS (SELECT name, country, ROWID FROM Province),
B AS (SELECT province AS 'name_id' , COUNT() AS 'cnt' FROM AllPurchases GROUP BY name_id),
S AS (SELECT A.country, SUM(B.cnt) AS 'cnt' FROM A JOIN B ON A.ROWID = B.name_id GROUP BY country)

SELECT Country.name, S.cnt FROM S JOIN Country ON Country.code = S.country ORDER  BY cnt DESC LIMIT 10;

-- Q2
SELECT product, COUNT() AS 'cnt' FROM AllPurchases GROUP BY product;

-- Q3
WITH A AS (SELECT name, country, ROWID FROM Province),
B AS (SELECT province, COUNT() AS 'cnt' FROM AllPurchases WHERE product = 0 GROUP BY province),
F AS (SELECT name, country, province, cnt AS cnt FROM A INNER JOIN B ON A.ROWID = B.province),
E AS (SELECT country AS countryE, sum(cnt) AS totByCountry, max(cnt) AS maxByCountry FROM A INNER JOIN B ON A.ROWID = B.province GROUP BY country),
C AS (SELECT country, name AS 'province' , cnt AS 'abs',  CAST(cnt AS float) / CAST(totByCountry AS foat) AS 'prop' FROM F INNER JOIN E ON E.countryE = F.country WHERE E.maxByCountry = F.cnt GROUP BY province),
D AS (SELECT code, name FROM Country)

SELECT name AS country, province, abs, prop FROM C INNER JOIN D ON D.code = C.country ORDER BY prop DESC;

--Q4
WITH B AS (SELECT province AS 'province_id', qty, count(qty) AS 'cnt'  FROM AllPurchases GROUP BY province, qty),
C AS (SELECT country, continent FROM Encompasses WHERE percentage = 100),
D AS (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A JOIN B ON A.ROWID = B.province_id GROUP BY country, qty)

SELECT continent, qty, SUM(cnt) AS 'cnt' FROM D JOIN C ON C.country = D.country GROUP BY continent, qty;


-- Q5
SELECT product, count() AS 'cnt' FROM AllPurchases WHERE (time > date((SELECT * FROM TimeMax), '-10 days')) GROUP BY product;

-- Q6
SELECT time, count() AS 'cnt' FROM Purchases WHERE (time > date((SELECT * FROM TimeMax), '-10 days')) GROUP BY time;

-- Q7
SELECT ROWID AS 'ids'  FROM Purchases WHERE
(time = date((SELECT * FROM TimeMax))
AND
(province = (SELECT ROWID FROM Province WHERE name = 'Brabant')));

-- Q8
SELECT ROWID AS 'ids'  FROM Purchases WHERE
(time = date((SELECT * FROM TimeMax))
AND
(province = (SELECT ROWID FROM Province WHERE name = 'Vienna')));

-- Q9
WITH B AS (SELECT province AS 'provinceid', qty, count(qty) AS 'cnt' FROM AllPurchases WHERE (time>  date((SELECT * FROM TimeMax), '-10 days')) GROUP BY province, qty),
C AS (SELECT country, continent FROM Encompasses WHERE percentage = 100),
D AS (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A JOIN B ON A.ROWID = B.provinceid GROUP BY country,qty)

SELECT continent, qty, SUM(cnt) AS 'cnt' FROM D JOIN C ON C.country = D.country GROUP BY continent, qty;

-- Q10
WITH A AS (SELECT province AS 'province1', SUM(qty) AS 'cnt1' FROM Purchases WHERE (time > date((SELECT * FROM TimeMax), '-10 days')) GROUP BY province),
B AS (SELECT province AS 'province2' , SUM(qty) AS 'cnt2' FROM Purchases WHERE (time <= date((SELECT * FROM TimeMax), '-10 days') AND time > date((SELECT * FROM TimeMax), '-20 days')) GROUP BY province),
C AS (SELECT province1, cnt1 AS 'qty_last10', cnt2 AS 'qty_1020', cnt1-cnt2 AS 'diff' FROM A JOIN B ON A.province1 = B.province2 ORDER BY diff DESC LIMIT 10),
D AS (SELECT ROWID, name, country FROM Province),
F AS (SELECT name, code FROM Country)

SELECT E.name AS 'province', F.name AS 'country', qty_last10, qty_1020 FROM (C JOIN D ON C.province1 = D.ROWID) E JOIN F ON E.country = F.code;

--
