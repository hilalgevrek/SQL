-- Hangi sorguyu se�ersek onu �al��t�r�r.

CREATE DATABASE LibDatabase;  /* Database olu�turduk */
USE LibDatabase;  /* Hangi veritaban�n� kulland���m�z� belirttik */

CREATE SCHEMA Book;  /* �emalar�n tam bir mant��� yoktur ama tablolar� s�n�fland�rmam�z� sa�lar. Bu veritaban� i�in 2 �ema olu�turduk. */ 

CREATE SCHEMA Person;

--Create Book Table  /* Book.Book �eklinde belirterek tabloyu hangi �eman�n alt�na kaydetmesi gerekti�ini s�yl�yoruz. */
CREATE TABLE [Book].[Book]
(
    [Book_ID] [int] PRIMARY KEY NOT NULL,
    [Book_Name] [nvarchar](50) NOT NULL,
    Author_ID INT NOT NULL,
    Publisher_ID INT NOT NULL
);

--Create Author Table
CREATE TABLE [Book].[Author]
(
    [Author_ID] [int],
    [Author_FirstName] [nvarchar](50) Not NULL,
    [Author_LastName] [nvarchar](50) Not NULL
);

--Create Publisher Table
CREATE TABLE [Book].[Publisher]  /* IDENTITY ile 1'den ba�la 1 art�rarak say dedik */
(
    [Publisher_ID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    [Publisher_Name] [nvarchar](100) NULL
);

/* CREATE TABLE Book.Publisher  /* Bu �ekilde parantez kullanmadan da yazabiliriz */ 
(
  Publisher_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,  
  Publisher_Name nvarchar(100) NULL
); */

--Create Person Table  /* Person.Person �eklinde belirterek tabloyu hangi �eman�n alt�na kaydetmesi gerekti�ini s�yl�yoruz. */
CREATE TABLE [Person].[Person]
(
    [SSN] [bigint] PRIMARY KEY NOT NULL,
    [Person_FirstName] [nvarchar](50) NULL,
    [Person_LastName] [nvarchar](50) NULL
);

--Create Loan Table
CREATE TABLE [Person].[Loan]
(
    [SSN] BIGINT NOT NULL,
    [Book_ID] INT NOT NULL,
    PRIMARY KEY ([SSN], [Book_ID])
);

--Cretae Phone Table
CREATE TABLE [Person].[Person_Phone]
(
    [Phone_Number] [bigint] PRIMARY KEY NOT NULL,
    [SSN] [bigint] NOT NULL
);

--Cretae Mail Table
CREATE TABLE [Person].[Person_Mail]
(
    [Mail_ID] INT PRIMARY KEY IDENTITY (1,1),
    [Mail] NVARCHAR(MAX) NOT NULL,
    [SSN] BIGINT UNIQUE NOT NULL
);

-- DDL tablo, �ema, veritaban� create etmedir. Daha �ok yap�y� olu�turmak ile ilgilenir. 
-- DML tablonun i�ine veri eklenmesi, veri silinmesi gibi �eylerle ilgilenir. Daha �ok veri ile ilgilenir.

-- INSERT --

INSERT INTO Person.Person  /* Person tablosunun i�ine veri giri�i yapt�k */ 
(SSN, Person_FirstName, Person_LastName)
VALUES (75056659595,'Zehra', 'Tekin');

SELECT * FROM Person.Person  /* Girdi�imiz veriyi �a��rd�k. */

INSERT INTO Person.Person 
(SSN, Person_FirstName) 
VALUES (889623212466,'Kerem')  -- Yaln�zca SSN i�in NOT NULL demi�iz, di�erleri NULL olabilir. Bu y�zden soyismini girmedi�imizde �al��t�.

INSERT Person.Person 
VALUES (15078893526,'Mert','Yeti�')

INSERT Person.Person 
VALUES (55556698752, 'Esra', Null)

INSERT Person.Person VALUES (35532888963,'Ali','Tekin');  -- T�m tablolara de�er atanaca�� varsay�lm��t�r.
INSERT Person.Person VALUES (88232556264,'Metin','Sakin')

INSERT INTO Person.Person_Mail (Mail, SSN) 
VALUES ('zehtek@gmail.com', 75056659595),
	   ('meyet@gmail.com', 15078893526),
	   ('metsak@gmail.com', 35532558963)

SELECT * FROM Person.Person_Mail

-- Global variableler new query dedi�imde o sayfada da �al��an variablelerdir. @@ i�areti kullan�l�r.

SELECT @@IDENTITY  -- Global variabledir. Bir �nceki sorguda identity'i en son 3'e kadar sayd��� anlam�na geliyor. New query'de yeni bir giri� oldu�unda bunun �zerinden devam eder.

SELECT @@ROWCOUNT  -- Global variabledir. En son �al��t�rd���m�z sorguda ka� tane sonu� listelendi�ini g�sterir.

SELECT * FROM Person.Person

SELECT * INTO Person.Person2 FROM Person.Person  --��eri�inde �stteki sorgunun i�eri�ini bar�nd�ran Person2 ad�nda yeni bir tablo olu�turdu.

SELECT * FROM Person.Person WHERE Person_FirstName LIKE 'M%'  -- Ad� M ile ba�layanlar� getirir.

INSERT INTO Person.Person2 
SELECT * FROM Person.Person 
WHERE Person_FirstName LIKE 'M%'

SELECT * FROM Person.Person2  -- �stte ekledi�imiz 2 sat�r gelmi� mi diye bakt�k.

INSERT INTO Book.Publisher  -- Sadece default de�erleri getirmesini istedik 
DEFAULT VALUES;

SELECT * FROM Book.Publisher

UPDATE Person.Person2 
SET Person_FirstName = 'Default_Name'  -- Spesifik olarak yer belirtmedi�imiz i�in hepsini de�i�tirir.

SELECT * FROM Person.Person2

UPDATE Person.Person2
SET Person_FirstName = 'Can'
WHERE SSN = 75056659595  -- Sosyal security numaras� 75.. olan ki�inin ismini Can yap dedik.

SELECT *
FROM Person.Person2 AS A  -- �ki tablonun s�tun isimleri de ayn� oldu�u i�in hangi tablodan geldi�ini A, B gibi belirtmemiz laz�m
Inner Join Person.Person AS B
ON A.SSN=B.SSN  -- SSN'den birle�tir dedik   

SELECT *
FROM Person.Person2 AS A  -- �ki tablonun s�tun isimleri de ayn� oldu�u i�in hangi tablodan geldi�ini A, B gibi belirtmemiz laz�m
Inner Join Person.Person AS B
ON A.SSN=B.SSN
WHERE B.SSN = 75056659595

UPDATE Person.Person2
SET Person_FirstName = B.Person_FirstName
FROM Person.Person2 AS A  -- �ki tablonun s�tun isimleri de ayn� oldu�u i�in hangi tablodan geldi�ini A, B gibi belirtmemiz laz�m
Inner Join Person.Person AS B
ON A.SSN=B.SSN
WHERE B.SSN = 75056659595

SELECT *
FROM Person.Person2

-- DELETE --

DELETE FROM Book.Publisher  -- Publisher tablosundaki t�m de�erleri sildirdik

TRUNCATE TABLE Book.Publisher  -- Tablodaki t�m de�erleri (i�eri�i) siler. �stte delete edece�i yerleri belirtmedi�imiz i�in �stteki de ayn� i�levi yapt�

SELECT * FROM Book.Publisher 

INSERT Book.Publisher VALUES ('�LET���M')  -- insert ile ileti�im ad�nda yeni veri ekledik

INSERT Book.Publisher VALUES ('B�L���M') 

DELETE FROM Book.Publisher 
WHERE Publisher_Name = 'B�L���M'

DROP TABLE Person.Person2;
DROP TABLE Person.Person3;

TRUNCATE TABLE Person.Person_Mail
TRUNCATE TABLE Person.Person
TRUNCATE TABLE Book.Publisher

-- ERD --

ALTER TABLE Book.Author  -- Primary key olarak girece�imiz de�er NULL olamaz. Bu nedenle NOT NULL olarak g�ncelledik.
ALTER COLUMN Author_ID
INT NOT NULL

ALTER TABLE Book.Author
ADD CONSTRAINT pk_author
PRIMARY KEY (Author_ID)

ALTER TABLE Book.Book
ADD CONSTRAINT FK_Author
FOREIGN KEY (Author_ID)
REFERENCES Book.Author (Author_ID)

ALTER TABLE Person.Loan  -- Bir ki�i benden kitap kiralayacaksa bu ki�i kesinlikle benim person tablomda olmal� dedik
ADD CONSTRAINT FK_PERSON
FOREIGN KEY (SSN)
REFERENCES Person.Person (SSN)

ALTER TABLE Person.Loan 
ADD CONSTRAINT FK_book 
FOREIGN KEY (Book_ID) 
REFERENCES Book.Book (Book_ID)

alter table Person.Person_Mail 
add constraint FK_Person4 
foreign key (SSN) 
references Person.Person(SSN)



