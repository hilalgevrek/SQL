
/* 
Charlie's Chocolate Factory company produces chocolates. The following product information is stored: product name, 
product ID, and quantity on hand. These chocolates are made up of many components. Each component can be supplied by 
one or more suppliers. The following component information is kept: component ID, name, description, quantity on hand, 
suppliers who supply them, when and how much they supplied, and products in which they are used. On the other hand 
following supplier information is stored: supplier ID, name, and activation status.

Assumptions

A supplier can exist without providing components.
A component does not have to be associated with a supplier. It may already have been in the inventory.
A component does not have to be associated with a product. Not all components are used in products.
A product cannot exist without components. 
*/

CREATE DATABASE ManufacturerDatabase;
USE ManufacturerDatabase;

-- Component-Product (Many to one)
-- Supplier-Component (Many to many)

CREATE TABLE Product
(
    [Prod_ID] INT PRIMARY KEY NOT NULL,
    [Prod_Name] VARCHAR(50),
    [Quantity] INT,   
);

CREATE TABLE Component
(
    [Comp_ID] INT PRIMARY KEY NOT NULL,
    [Comp_Name] VARCHAR(50),
	[Description] VARCHAR(50),
    [Quantity_Comp] INT,   
);

CREATE TABLE Supplier
(
    [Supp_ID] INT PRIMARY KEY NOT NULL,
    [Supp_Name] VARCHAR(50),
	[Supp_Location] VARCHAR(50),
    [Supp_Country] VARCHAR(50),   
	[IS_Active] BIT,  
);

CREATE TABLE Prod_Comp
(
    [Prod_ID] INT NOT NULL,
    [Comp_ID] INT NOT NULL,
	[Quantity_Comp] INT, 
	PRIMARY KEY ([Prod_ID], [Comp_ID]) 
);

CREATE TABLE Comp_Supp
(
    [Supp_ID] INT NOT NULL,
    [Comp_ID] INT NOT NULL,
	[Order_Date] DATE,
    [Quantity] INT,
	PRIMARY KEY ([Supp_ID], [Comp_ID])
);

ALTER TABLE Prod_Comp  -- FK1 for Prod_Comp Table / If a product is to be produced, that product must be in the Product table.
ADD CONSTRAINT FK_Product 
FOREIGN KEY (Prod_ID)
REFERENCES Product (Prod_ID)

ALTER TABLE Prod_Comp  -- FK2 for Prod_Comp Table / The component to be used in production must be in the Component table.
ADD CONSTRAINT FK_Component  
FOREIGN KEY (Comp_ID)
REFERENCES Component (Comp_ID)

ALTER TABLE Comp_Supp  -- FK1 for Comp_Supp Table / If a product is to be purchased from a supplier, that supplier must be in the Supplier table.
ADD CONSTRAINT FK_Supplier  
FOREIGN KEY (Supp_ID)
REFERENCES Supplier (Supp_ID)

ALTER TABLE Comp_Supp  -- FK2 for Comp_Supp Table / The supplied component must definitely be in the Component table
ADD CONSTRAINT FK_Component2 
FOREIGN KEY (Comp_ID)
REFERENCES Component (Comp_ID)

