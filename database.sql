/* Running this file will create the RML Database and populate the tables with some tuples :) */
/* Feel free to add more tuples in here, but just highlight your query and run it (otherwise the whole script will run and you'll probably get an error if you already have the database) */
/* IMPORTANT! you need to disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect (otherwise tuples won't delete) */

DROP DATABASE RateMyLandlord;
CREATE DATABASE RateMyLandlord;
USE RateMyLandlord;

/********************************/
/********* ADMIN TABLE **********/
/********************************/
CREATE TABLE Admin (
	adminID INT PRIMARY KEY AUTO_INCREMENT,
	name varchar(100)
);

/*** Admin: Insert ***/
INSERT INTO Admin (name) VALUES('Sandra');
INSERT INTO Admin (name) VALUES('Marshal');
INSERT INTO Admin (name) VALUES('Yuxiang');

/********************************/
/********* USER TABLE **********/
/********************************/
CREATE TABLE User (
	userID INT PRIMARY KEY AUTO_INCREMENT,
	userName VARCHAR(100),
	userAbout VARCHAR(500),
	userType VARCHAR(50),
	userPassword VARCHAR(50)
);

/*** User: Insert ***/
INSERT INTO User (userName, userAbout, userType, userPassword) VALUES('JimHalpert', 'Paper salesman', 'landlord', 'password123');
INSERT INTO User (userName, userAbout, userType, userPassword) VALUES('PamBH', 'Office Admin, I have 2 kids.', 'landlord', 'password123');
INSERT INTO User (userName, userAbout, userType, userPassword) VALUES('KevMalone', 'Accountant', 'tenant', 'password');
INSERT INTO User (userName, userAbout, userType, userPassword) VALUES('ErinH', 'Secretary', 'tenant', 'password');
INSERT INTO User (userName, userAbout, userType, userPassword) VALUES('MichaelScott', 'I manage people. I have a condo.', 'landlord', 'password');
INSERT INTO User (userName, userAbout, userType, userPassword) VALUES('DwightKS', 'Proud assistant to the regional manager. Owner of a large beet farm.', 'landlord', 'battlestargalactica');
INSERT INTO User (userName, userAbout, userType, userPassword) VALUES('OscarM', 'I like a tidy apartment', 'tenant', 'password');


/********************************/
/********* TENANT TABLE **********/
/********************************/
CREATE TABLE Tenant (
	userID INT PRIMARY KEY NOT NULL,
	FOREIGN KEY (userID) REFERENCES
		User(userID)
	ON DELETE CASCADE
);

/*** Tenant: Insert ***/
INSERT INTO Tenant VALUES(3);
INSERT INTO Tenant VALUES(4);
INSERT INTO Tenant VALUES(7);


/********************************/
/********* LANDLORD TABLE (not to be confused with LandlordProfile Table) **********/ 
/********************************/
CREATE TABLE Landlord (
	userID INT PRIMARY KEY NOT NULL,
	FOREIGN KEY (userID) REFERENCES
		User(userID)
	ON DELETE CASCADE
);

/*** Landlord: Insert ***/
INSERT INTO Landlord VALUES(1);
INSERT INTO Landlord VALUES(2);
INSERT INTO Landlord VALUES(5);
INSERT INTO Landlord VALUES(6);

/*******************************************/
/********* LANDLORD PROFILE TABLE **********/
/*******************************************/
CREATE TABLE LandlordProfile (
	profileID INT PRIMARY KEY AUTO_INCREMENT,
    profileName VARCHAR(75) NOT NULL,
	profileCity VARCHAR(500),
	userID INT,
	FOREIGN KEY (userID) REFERENCES
		User(userID) 
	ON DELETE SET NULL
);

/*** LandlordProfile: Insert ***/
INSERT INTO LandlordProfile (profileName, profileCity, userID) VALUES('David Wallace', 'Vancouver', 3);
INSERT INTO LandlordProfile (profileName, profileCity, userID) VALUES('Robert Dunder', 'Vancouver', 3);
INSERT INTO LandlordProfile (profileName, profileCity, userID) VALUES('Jan Levinson', 'Victoria', 7);
INSERT INTO LandlordProfile (profileName, profileCity, userID) VALUES('Creed Bratton', 'Vancouver', 4);
INSERT INTO LandlordProfile (profileName, profileCity, userID) VALUES('Bob Vance', 'Vancouver', 4);
INSERT INTO LandlordProfile (profileName, profileCity, userID) VALUES('David Smith', 'Victoria', 7);

/************************************************************/
/********* MUNICIPALITY TABLE (sub table of property) *******/
/************************************************************/

CREATE TABLE Municipality(
	propertyPostal VARCHAR(10) PRIMARY KEY,
	propertyCity VARCHAR(100)
); 

/*** Municipality: Insert ***/
INSERT INTO Municipality VALUES('V8G3G5', 'Vancouver');
INSERT INTO Municipality VALUES('V8G1H9', 'Victoria');
INSERT INTO Municipality VALUES('V3Z5K3', 'Vancouver');
INSERT INTO Municipality VALUES('V3S6H2', 'Vancouver');
INSERT INTO Municipality VALUES('V3Q3D6', 'Vancouver');

/************************************************************/
/********* PROPERTY LOCATION TABLE (sub table of property) **/
/************************************************************/
CREATE TABLE PropertyLocation(
	propertyStreetAddress VARCHAR(100) PRIMARY KEY,
	propertyPostal VARCHAR(10),
	FOREIGN KEY (propertyPostal) REFERENCES
		Municipality(propertyPostal)
	ON DELETE SET NULL
);

/*** PropertyLocation: Insert ***/
INSERT INTO PropertyLocation VALUES('789-15918 24 Ave', 'V3Z5K3');
INSERT INTO PropertyLocation VALUES('3312 Agar Street', 'V3S6H2');
INSERT INTO PropertyLocation VALUES('1234 West 6th Ave', 'V8G3G5');
INSERT INTO PropertyLocation VALUES('987 Sesame Street', 'V8G1H9');
INSERT INTO PropertyLocation VALUES('456 2nd Ave', 'V3Q3D6');


/*******************************************/
/************** PROPERTY TABLE *************/
/*******************************************/
CREATE TABLE Property (
	propertyID INT PRIMARY KEY AUTO_INCREMENT,
	propertyStreetAddress VARCHAR(100), 
	propertyDescription VARCHAR(500),
	propertyType VARCHAR(40),
	FOREIGN KEY (propertyStreetAddress) REFERENCES
		PropertyLocation(propertyStreetAddress)
	ON DELETE SET NULL
);

/*** Property: Insert ***/
INSERT INTO Property (propertyStreetAddress, propertyDescription, propertyType) VALUES('789-15918 24 Ave', 'A spacious downtown condo, newly renovated.','condo');
INSERT INTO Property (propertyStreetAddress, propertyDescription, propertyType) VALUES('456 2nd Ave', 'Perfect for a single person. A nice property.','condo');
INSERT INTO Property (propertyStreetAddress, propertyDescription, propertyType) VALUES('1234 West 6th Ave', 'FAMILY TOWNHOUSE. Close to schools.','townhouse');
INSERT INTO Property (propertyStreetAddress, propertyDescription, propertyType) VALUES('987 Sesame Street', 'Close to skytrain. Kinda old.','detached house');
INSERT INTO Property (propertyStreetAddress, propertyDescription, propertyType) VALUES('3312 Agar Street', 'Bright place. Pets allowed!','townhouse');


/*************************************/
/************** OWNS *****************/
/*************************************/
CREATE TABLE Owns (
	profileID INT NOT NULL,
	propertyID INT NOT NULL,
	PRIMARY KEY (profileID, propertyID),
	FOREIGN KEY (profileID) REFERENCES
	LandlordProfile(profileID)
	ON DELETE CASCADE,
	FOREIGN KEY (propertyID) REFERENCES
	Property(propertyID)
	ON DELETE CASCADE
);

/*** Owns: Insert ***/
INSERT INTO Owns VALUES(2, 1);
INSERT INTO Owns VALUES(1,2);
INSERT INTO Owns VALUES(4,3);
INSERT INTO Owns VALUES(3,4);
INSERT INTO Owns VALUES(5,5);

/****************************************/
/************** LISTING *****************/
/****************************************/
CREATE TABLE Listing (
	listingID INT PRIMARY KEY AUTO_INCREMENT,
	uploaderID INT,
	listingTitle VARCHAR(150),
	listingArea VARCHAR(50),
	listingDescription VARCHAR(500),
	listingPrice VARCHAR(100),
	FOREIGN KEY (uploaderID) REFERENCES
		User(userID) 
	ON DELETE CASCADE
);

/*** Listing: Insert ***/
INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingPrice) VALUES(1, 'New Apartment for Rent', 'Vancouver', 'Close to skytrain, brand new!', '$800/month');
INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingPrice) VALUES(2, 'Downtown Condo for Rent!', 'Vancouver', 'Walking distance to mall', '$1200/month');
INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingPrice) VALUES(6, 'Townhouse Available', 'Vancouver', 'Peaceful mountain views', '$2500/month');


/*********************************************/
/****************** REVIEW *******************/
/*********************************************/
CREATE TABLE Review (
	reviewID INT PRIMARY KEY AUTO_INCREMENT,
	userID INT,
	reviewText VARCHAR(1024),
    starRating INT,
    profileID INT,
	FOREIGN KEY (userID) REFERENCES 
		User(userID),
	FOREIGN KEY (profileID) REFERENCES 
		LandlordProfile(profileID)
	ON DELETE SET NULL
 );

/*** Review: Insert ***/
INSERT INTO Review (userID, reviewText, starRating, profileID) VALUES(3, 'BEST. LANDLORD. EVER. They are soooo personable and super understanding. Very responsive too.', 5, 1);
INSERT INTO Review (userID, reviewText, starRating, profileID)  VALUES(4, 'Pretty reasonable landlord.', 4, 1);
INSERT INTO Review (userID, reviewText, starRating, profileID)  VALUES(6, 'Holy moly this landlord is crap. If I could give a negative 10 stars I would.', 1, 2);


/*********************************************/
/************** VERIFICATION *****************/
/*********************************************/
CREATE TABLE Verification (
	verificationID INT AUTO_INCREMENT,
    reviewID INT,
	adminID INT,
	verificationStatus BOOL,
	document VARCHAR(255),
	PRIMARY KEY (verificationID, adminID),
	FOREIGN KEY (adminID) REFERENCES 
		Admin(adminID)
 );

/*** Verification: Insert ***/
INSERT INTO Verification (reviewID, adminID, verificationStatus, document) VALUES(1, 1, 1, 'contracts');
INSERT INTO Verification (reviewID, adminID, verificationStatus, document) VALUES(2, 1, 0, 'contracts');
INSERT INTO Verification (reviewID, adminID, verificationStatus, document) VALUES(3, 2, 1, 'contracts');

/*********************************************/
/************** VERIFICATION_LOG (claims sub-table) *****************/
/*********************************************/
CREATE TABLE Verification_Log(
	verificationID INT PRIMARY KEY,
	claimDateTime DATE NOT NULL,
	FOREIGN KEY (verificationID) REFERENCES 
		Verification(verificationID)
	ON DELETE CASCADE
);

/*** Verification: Insert ***/
INSERT INTO Verification_Log VALUES(1, '2019-06-15');

/*********************************************/
/************** VERIFICATION_CLAIM (claims sub-table) *****************/
/*********************************************/
CREATE TABLE Verification_Claim(
	profileID INT,
	userID INT,
	verificationID INT,
	PRIMARY KEY (profileID, userID),
	FOREIGN KEY (profileID) REFERENCES 
		LandlordProfile(profileID)
	ON DELETE CASCADE,
	FOREIGN KEY (userID) REFERENCES 
		User(userID)
	ON DELETE CASCADE
);

/*** Verification: Insert ***/
INSERT INTO Verification_Claim VALUES(1, 3, 1);





