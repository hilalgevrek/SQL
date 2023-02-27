-- Hangi sorguyu seçersek onu çalýþtýrýr.

CREATE DATABASE LibDatabase;  /* Database oluþturduk */
USE LibDatabase;  /* Hangi veritabanýný kullandýðýmýzý belirttik */

CREATE SCHEMA Book;  /* Þemalarýn tam bir mantýðý yoktur ama tablolarý sýnýflandýrmamýzý saðlar. Bu veritabaný için 2 þema oluþturduk. */ 

CREATE SCHEMA Person;

--Create Book Table  /* Book.Book þeklinde belirterek tabloyu hangi þemanýn altýna kaydetmesi gerektiðini söylüyoruz. */
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
CREATE TABLE [Book].[Publisher]  /* IDENTITY ile 1'den baþla 1 artýrarak say dedik */
(
    [Publisher_ID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
    [Publisher_Name] [nvarchar](100) NULL
);

/* CREATE TABLE Book.Publisher  /* Bu þekilde parantez kullanmadan da yazabiliriz */ 
(
  Publisher_ID int PRIMARY KEY IDENTITY(1,1) NOT NULL,  
  Publisher_Name nvarchar(100) NULL
); */

--Create Person Table  /* Person.Person þeklinde belirterek tabloyu hangi þemanýn altýna kaydetmesi gerektiðini söylüyoruz. */
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

-- DDL tablo, þema, veritabaný create etmedir. Daha çok yapýyý oluþturmak ile ilgilenir. 
-- DML tablonun içine veri eklenmesi, veri silinmesi gibi þeylerle ilgilenir. Daha çok veri ile ilgilenir.

-- INSERT --

INSERT INTO Person.Person  /* Person tablosunun içine veri giriþi yaptýk */ 
(SSN, Person_FirstName, Person_LastName)
VALUES (75056659595,'Zehra', 'Tekin');

SELECT * FROM Person.Person  /* Girdiðimiz veriyi çaðýrdýk. */

INSERT INTO Person.Person 
(SSN, Person_FirstName) 
VALUES (889623212466,'Kerem')  -- Yalnýzca SSN için NOT NULL demiþiz, diðerleri NULL olabilir. Bu yüzden soyismini girmediðimizde çalýþtý.

INSERT Person.Person 
VALUES (15078893526,'Mert','Yetiþ')

INSERT Person.Person 
VALUES (55556698752, 'Esra', Null)

INSERT Person.Person VALUES (35532888963,'Ali','Tekin');  -- Tüm tablolara deðer atanacaðý varsayýlmýþtýr.
INSERT Person.Person VALUES (88232556264,'Metin','Sakin')

INSERT INTO Person.Person_Mail (Mail, SSN) 
VALUES ('zehtek@gmail.com', 75056659595),
	   ('meyet@gmail.com', 15078893526),
	   ('metsak@gmail.com', 35532558963)

SELECT * FROM Person.Person_Mail

-- Global variableler new query dediðimde o sayfada da çalýþan variablelerdir. @@ iþareti kullanýlýr.

SELECT @@IDENTITY  -- Global variabledir. Bir önceki sorguda identity'i en son 3'e kadar saydýðý anlamýna geliyor. New query'de yeni bir giriþ olduðunda bunun üzerinden devam eder.

SELECT @@ROWCOUNT  -- Global variabledir. En son çalýþtýrdýðýmýz sorguda kaç tane sonuç listelendiðini gösterir.

SELECT * FROM Person.Person

SELECT * INTO Person.Person2 FROM Person.Person  --Ýçeriðinde üstteki sorgunun içeriðini barýndýran Person2 adýnda yeni bir tablo oluþturdu.

SELECT * FROM Person.Person WHERE Person_FirstName LIKE 'M%'  -- Adý M ile baþlayanlarý getirir.

INSERT INTO Person.Person2 
SELECT * FROM Person.Person 
WHERE Person_FirstName LIKE 'M%'

SELECT * FROM Person.Person2  -- Üstte eklediðimiz 2 satýr gelmiþ mi diye baktýk.

INSERT INTO Book.Publisher  -- Sadece default deðerleri getirmesini istedik 
DEFAULT VALUES;

SELECT * FROM Book.Publisher

UPDATE Person.Person2 
SET Person_FirstName = 'Default_Name'  -- Spesifik olarak yer belirtmediðimiz için hepsini deðiþtirir.

SELECT * FROM Person.Person2

UPDATE Person.Person2
SET Person_FirstName = 'Can'
WHERE SSN = 75056659595  -- Sosyal security numarasý 75.. olan kiþinin ismini Can yap dedik.

SELECT *
FROM Person.Person2 AS A  -- Ýki tablonun sütun isimleri de ayný olduðu için hangi tablodan geldiðini A, B gibi belirtmemiz lazým
Inner Join Person.Person AS B
ON A.SSN=B.SSN  -- SSN'den birleþtir dedik   

SELECT *
FROM Person.Person2 AS A  -- Ýki tablonun sütun isimleri de ayný olduðu için hangi tablodan geldiðini A, B gibi belirtmemiz lazým
Inner Join Person.Person AS B
ON A.SSN=B.SSN
WHERE B.SSN = 75056659595

UPDATE Person.Person2
SET Person_FirstName = B.Person_FirstName
FROM Person.Person2 AS A  -- Ýki tablonun sütun isimleri de ayný olduðu için hangi tablodan geldiðini A, B gibi belirtmemiz lazým
Inner Join Person.Person AS B
ON A.SSN=B.SSN
WHERE B.SSN = 75056659595

SELECT *
FROM Person.Person2

-- DELETE --

DELETE FROM Book.Publisher  -- Publisher tablosundaki tüm deðerleri sildirdik

TRUNCATE TABLE Book.Publisher  -- Tablodaki tüm deðerleri (içeriði) siler. Üstte delete edeceði yerleri belirtmediðimiz için üstteki de ayný iþlevi yaptý

SELECT * FROM Book.Publisher 

INSERT Book.Publisher VALUES ('ÝLETÝÞÝM')  -- insert ile iletiþim adýnda yeni veri ekledik

INSERT Book.Publisher VALUES ('BÝLÝÞÝM') 

DELETE FROM Book.Publisher 
WHERE Publisher_Name = 'BÝLÝÞÝM'

DROP TABLE Person.Person2;
DROP TABLE Person.Person3;

TRUNCATE TABLE Person.Person_Mail
TRUNCATE TABLE Person.Person
TRUNCATE TABLE Book.Publisher

-- ERD --

ALTER TABLE Book.Author  -- Primary key olarak gireceðimiz deðer NULL olamaz. Bu nedenle NOT NULL olarak güncelledik.
ALTER COLUMN Author_ID
INT NOT NULL

ALTER TABLE Book.Author
ADD CONSTRAINT pk_author
PRIMARY KEY (Author_ID)

ALTER TABLE Book.Book
ADD CONSTRAINT FK_Author
FOREIGN KEY (Author_ID)
REFERENCES Book.Author (Author_ID)

ALTER TABLE Person.Loan  -- Bir kiþi benden kitap kiralayacaksa bu kiþi kesinlikle benim person tablomda olmalý dedik
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



