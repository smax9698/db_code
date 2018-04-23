-- PREPROCESS

DROP TABLE IF EXISTS Purchases;
DROP TABLE IF EXISTS Purchases1;
DROP TABLE IF EXISTS Purchases2;
DROP TABLE IF EXISTS Purchases3;

CREATE TABLE Purchases (
id INTEGER PRIMARY KEY,
time INTEGER NOT NULL,
province INTEGER NOT NULL,
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);
--

-- E0 

--

-- P1
INSERT INTO Purchases SELECT * FROM period1.Purchases;
--

-- E1 
CREATE TABLE Purchases1 (
id INTEGER PRIMARY KEY,
time INTEGER NOT NULL,
province INTEGER NOT NULL,
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);
INSERT INTO Purchases1 SELECT * FROM period1.Purchases;
--

-- Q1-10

-- Q1
SELECT Country.name, S.cnt
FROM 
((SELECT A.country, SUM(B.cnt) AS 'cnt' FROM (
(SELECT name, country, ROWID FROM Province) A)
INNER JOIN 
(SELECT province AS 'name_id' , SUM(qty) AS 'cnt' FROM Purchases GROUP BY name_id) B
ON
A.ROWID = B.name_id
GROUP BY
country)) S
INNER JOIN
Country
ON
Country.code = S.country;


-- Q2
SELECT product, SUM(qty) AS 'cnt' FROM Purchases GROUP BY product;


-- Q3
SELECT name, province, abs, prop
FROM
(SELECT country, name AS 'province' , max(cnt) AS 'abs',  CAST(max(cnt) AS float) /CAST(sum(cnt) AS foat) AS 'prop' FROM 
(SELECT name, country, ROWID FROM Province) A
INNER JOIN 
(SELECT province, SUM(qty) AS 'cnt' FROM Purchases WHERE product = 0 GROUP BY province) B
ON
A.ROWID = B.province
GROUP BY
country) D
INNER JOIN
(SELECT code, name FROM Country) C
ON
C.code = D.country;


--Q4
SELECT continent, qty, SUM(cnt) AS 'cnt'
FROM
(SELECT country, qty, SUM(cnt) AS 'cnt'
FROM
Province A
JOIN
(SELECT province AS 'province_id', qty, count(qty) AS 'cnt'  FROM Purchases GROUP BY province, qty) B
ON
A.ROWID = B.province_id
GROUP BY
country, qty) D
JOIN
(SELECT country, continent FROM Encompasses WHERE percentage = 100) C
ON
C.country = D.country
GROUP BY continent, qty;


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
SELECT continent, qty, SUM(cnt) AS 'cnt' 
FROM (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A 
JOIN 
(SELECT province AS 'provinceid', qty, count(qty) AS 'cnt' FROM Purchases WHERE (time>=  '2018-03-21'  AND time<= '2018-03-31') GROUP BY province, qty) B 
ON A.ROWID = B.provinceid 
GROUP BY country,qty) D 
JOIN 
(SELECT country, continent FROM Encompasses WHERE percentage = 100) C 
ON C.country = D.country 
GROUP BY continent, qty;


-- Q10
SELECT E.name AS 'province', F.name AS 'country', qty_last10, qty_1020 FROM
((SELECT province1, cnt1 AS 'qty_last10', cnt2 AS 'qty_1020', cnt1-cnt2 AS 'diff' FROM
(SELECT province AS 'province1', SUM(qty) AS 'cnt1' FROM Purchases WHERE (time <= '2018-03-31' AND time >= '2018-03-21') GROUP BY province) A 
JOIN
(SELECT province AS 'province2' , SUM(qty) AS 'cnt2' FROM Purchases WHERE (time <= '2018-03-20' AND time >= '2018-03-10') GROUP BY province) B
ON
A.province1 = B.province2
ORDER BY
diff DESC LIMIT 10) C
JOIN
(SELECT ROWID, name, country FROM Province) D
ON
C.province1 = D.ROWID) E
JOIN
(SELECT name, code FROM Country) F
ON
E.country = F.code;
--

-- P2
INSERT INTO Purchases SELECT * FROM period2.Purchases;
--

-- E2 
CREATE TABLE Purchases2 (
id INTEGER PRIMARY KEY,
time INTEGER NOT NULL,
province INTEGER NOT NULL,
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);
INSERT INTO Purchases2 SELECT * FROM period2.Purchases;
--

-- Q1-10

-- Q1
SELECT Country.name, S.cnt
FROM 
((SELECT A.country, SUM(B.cnt) AS 'cnt' FROM (
(SELECT name, country, ROWID FROM Province) A)
INNER JOIN 
(SELECT province AS 'name_id' , SUM(qty) AS 'cnt' FROM Purchases GROUP BY name_id) B
ON
A.ROWID = B.name_id
GROUP BY
country)) S
INNER JOIN
Country
ON
Country.code = S.country;


-- Q2
SELECT product, SUM(qty) AS 'cnt' FROM Purchases GROUP BY product;


-- Q3
SELECT name, province, abs, prop
FROM
(SELECT country, name AS 'province' , max(cnt) AS 'abs',  CAST(max(cnt) AS float) /CAST(sum(cnt) AS foat) AS 'prop' FROM 
(SELECT name, country, ROWID FROM Province) A
INNER JOIN 
(SELECT province, SUM(qty) AS 'cnt' FROM Purchases WHERE product = 0 GROUP BY province) B
ON
A.ROWID = B.province
GROUP BY
country) D
INNER JOIN
(SELECT code, name FROM Country) C
ON
C.code = D.country;


--Q4
SELECT continent, qty, SUM(cnt) AS 'cnt'
FROM
(SELECT country, qty, SUM(cnt) AS 'cnt'
FROM
Province A
JOIN
(SELECT province AS 'province_id', qty, count(qty) AS 'cnt'  FROM Purchases GROUP BY province, qty) B
ON
A.ROWID = B.province_id
GROUP BY
country, qty) D
JOIN
(SELECT country, continent FROM Encompasses WHERE percentage = 100) C
ON
C.country = D.country
GROUP BY continent, qty;


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
SELECT continent, qty, SUM(cnt) AS 'cnt' 
FROM (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A 
JOIN 
(SELECT province AS 'provinceid', qty, count(qty) AS 'cnt' FROM Purchases WHERE (time>=  '2018-03-21'  AND time<= '2018-03-31') GROUP BY province, qty) B 
ON A.ROWID = B.provinceid 
GROUP BY country,qty) D 
JOIN 
(SELECT country, continent FROM Encompasses WHERE percentage = 100) C 
ON C.country = D.country 
GROUP BY continent, qty;


-- Q10
SELECT E.name AS 'province', F.name AS 'country', qty_last10, qty_1020 FROM
((SELECT province1, cnt1 AS 'qty_last10', cnt2 AS 'qty_1020', cnt1-cnt2 AS 'diff' FROM
(SELECT province AS 'province1', SUM(qty) AS 'cnt1' FROM Purchases WHERE (time <= '2018-03-31' AND time >= '2018-03-21') GROUP BY province) A 
JOIN
(SELECT province AS 'province2' , SUM(qty) AS 'cnt2' FROM Purchases WHERE (time <= '2018-03-20' AND time >= '2018-03-10') GROUP BY province) B
ON
A.province1 = B.province2
ORDER BY
diff DESC LIMIT 10) C
JOIN
(SELECT ROWID, name, country FROM Province) D
ON
C.province1 = D.ROWID) E
JOIN
(SELECT name, code FROM Country) F
ON
E.country = F.code;
--

-- P3
INSERT INTO Purchases SELECT * FROM period3.Purchases;
--

-- E3
CREATE TABLE Purchases3 (
id INTEGER PRIMARY KEY,
time INTEGER NOT NULL,
province INTEGER NOT NULL,
product INTEGER NOT NULL,
qty INTEGER NOT NULL
);
INSERT INTO Purchases3 SELECT * FROM period3 .Purchases;
--

-- Q1-10

-- Q1
SELECT Country.name, S.cnt
FROM 
((SELECT A.country, SUM(B.cnt) AS 'cnt' FROM (
(SELECT name, country, ROWID FROM Province) A)
INNER JOIN 
(SELECT province AS 'name_id' , SUM(qty) AS 'cnt' FROM Purchases GROUP BY name_id) B
ON
A.ROWID = B.name_id
GROUP BY
country)) S
INNER JOIN
Country
ON
Country.code = S.country;


-- Q2
SELECT product, SUM(qty) AS 'cnt' FROM Purchases GROUP BY product;


-- Q3
SELECT name, province, abs, prop
FROM
(SELECT country, name AS 'province' , max(cnt) AS 'abs',  CAST(max(cnt) AS float) /CAST(sum(cnt) AS foat) AS 'prop' FROM 
(SELECT name, country, ROWID FROM Province) A
INNER JOIN 
(SELECT province, SUM(qty) AS 'cnt' FROM Purchases WHERE product = 0 GROUP BY province) B
ON
A.ROWID = B.province
GROUP BY
country) D
INNER JOIN
(SELECT code, name FROM Country) C
ON
C.code = D.country;


--Q4
SELECT continent, qty, SUM(cnt) AS 'cnt'
FROM
(SELECT country, qty, SUM(cnt) AS 'cnt'
FROM
Province A
JOIN
(SELECT province AS 'province_id', qty, count(qty) AS 'cnt'  FROM Purchases GROUP BY province, qty) B
ON
A.ROWID = B.province_id
GROUP BY
country, qty) D
JOIN
(SELECT country, continent FROM Encompasses WHERE percentage = 100) C
ON
C.country = D.country
GROUP BY continent, qty;


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
SELECT continent, qty, SUM(cnt) AS 'cnt' 
FROM (SELECT country, qty, SUM(cnt) AS 'cnt' FROM Province A 
JOIN 
(SELECT province AS 'provinceid', qty, count(qty) AS 'cnt' FROM Purchases WHERE (time>=  '2018-03-21'  AND time<= '2018-03-31') GROUP BY province, qty) B 
ON A.ROWID = B.provinceid 
GROUP BY country,qty) D 
JOIN 
(SELECT country, continent FROM Encompasses WHERE percentage = 100) C 
ON C.country = D.country 
GROUP BY continent, qty;


-- Q10
SELECT E.name AS 'province', F.name AS 'country', qty_last10, qty_1020 FROM
((SELECT province1, cnt1 AS 'qty_last10', cnt2 AS 'qty_1020', cnt1-cnt2 AS 'diff' FROM
(SELECT province AS 'province1', SUM(qty) AS 'cnt1' FROM Purchases WHERE (time <= '2018-03-31' AND time >= '2018-03-21') GROUP BY province) A 
JOIN
(SELECT province AS 'province2' , SUM(qty) AS 'cnt2' FROM Purchases WHERE (time <= '2018-03-20' AND time >= '2018-03-10') GROUP BY province) B
ON
A.province1 = B.province2
ORDER BY
diff DESC LIMIT 10) C
JOIN
(SELECT ROWID, name, country FROM Province) D
ON
C.province1 = D.ROWID) E
JOIN
(SELECT name, code FROM Country) F
ON
E.country = F.code;
--
