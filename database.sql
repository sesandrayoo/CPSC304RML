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
INSERT INTO User (userName, userAbout, userType, userPassword) VALUES('NotARealUser', 'throwaway', 'landlord', '123');
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
	listingBedrooms INT,
	listingBathrooms INT,
	listingPrice INT,
	FOREIGN KEY (uploaderID) REFERENCES
		User(userID) 
	ON DELETE CASCADE
);

/*** Listing: Insert ***/
INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingBedrooms, listingBathrooms, listingPrice) VALUES(1, 'New Studio Apartment for Rent', 'Richmond', 'Close to skytrain, brand new!', '0', '1', '800');
INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingBedrooms, listingBathrooms, listingPrice) VALUES(2, 'Downtown Condo for Rent!', 'Vancouver', 'Walking distance to mall', '2', '1', '1200');
INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingBedrooms, listingBathrooms, listingPrice) VALUES(6, 'Townhouse Available', 'Vancouver', 'Peaceful mountain views', '3', '2', '4500');
INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingBedrooms, listingBathrooms, listingPrice) VALUES(3, 'Beautiful 2bdr Apartment', 'Kitsilano', 'Very close to the beach, cafes and restaurants', '2', '1', '2100');
INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingBedrooms, listingBathrooms, listingPrice) VALUES(4, 'Basement apartment near UBC', 'Point Grey', 'Peaceful mountain views', '3', '1', '2500');
INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingBedrooms, listingBathrooms, listingPrice) VALUES(5, 'Condo in quiet area', 'Point Grey', 'mountain views and quiet', '2', '2', '3500');
INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingBedrooms, listingBathrooms, listingPrice) VALUES(7, 'New apartment above garage', 'Point Grey', 'newly done, 2 bedrooms - very large', '2', '1', '2200');
INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingBedrooms, listingBathrooms, listingPrice) VALUES(8, '2bd in Hip Neighborhood!', 'East Van', 'close to commercial. lots of Cafes and restaurants within walking distance', '2', '1', '1450');
INSERT INTO Listing (uploaderID, listingTitle, listingArea, listingDescription, listingBedrooms, listingBathrooms, listingPrice) VALUES(9, 'Large 3bdr first floor apartment', 'East Van', 'charming old house with lower and upper apartment. Great landlords.', '3', '1', '1900');


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
INSERT INTO Review (userID, reviewText, starRating, profileID) VALUES(3, 'BEST. LANDLORD. EVER. They are soooo personable and super understanding. Very responsive too. He watched my dog while I was on vacation, and I dont think will ever have another landlord as good as him!', 5, 1);
INSERT INTO Review (userID, reviewText, starRating, profileID)  VALUES(4, 'Pretty reasonable landlord. I never ran into any issues, but nothing special either. The place was clean before I got there and I left it the same, got my security deposit back. Pretty flexible guy.', 4, 1);
INSERT INTO Review (userID, reviewText, starRating, profileID)  VALUES(6, 'Holy moly this landlord is crap. If I could give a negative 10 stars I would.', 1, 2);
INSERT INTO Review (userID, reviewText, starRating, profileID)  VALUES(3, 'As good as a landlord can be...', 4, 6);
INSERT INTO Review (userID, reviewText, starRating, profileID)  VALUES(4, 'Great landlord!', 5, 3);
INSERT INTO Review (userID, reviewText, starRating, profileID)  VALUES(7, 'Bad experience.', 1, 4);
INSERT INTO Review (userID, reviewText, starRating, profileID)  VALUES(7, 'Took my money!!! what a scam!', 1, 5);
INSERT INTO Review (userID, reviewText, starRating, profileID)  VALUES(7, 'Friendly guy, but he seems really stuck up and arrogant. If you can handle that kind of thing', 3, 1);



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
INSERT INTO Verification (reviewID, adminID, verificationStatus, document) VALUES(2, 2, 0, 'contracts');
INSERT INTO Verification (reviewID, adminID, verificationStatus, document) VALUES(3, 1, 1, 'contracts');
INSERT INTO Verification (reviewID, adminID, verificationStatus, document) VALUES(4, 1, 1, 'contracts');
INSERT INTO Verification (reviewID, adminID, verificationStatus, document) VALUES(5, 1, 0, 'contracts');
INSERT INTO Verification (reviewID, adminID, verificationStatus, document) VALUES(6, 1, 1, 'contracts');
INSERT INTO Verification (reviewID, adminID, verificationStatus, document) VALUES(7, 1, 0, 'contracts');
INSERT INTO Verification (reviewID, adminID, verificationStatus, document) VALUES(8, 2, 0, 'contracts');

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
INSERT INTO Verification_Log VALUES(2, '2018-01-15');
INSERT INTO Verification_Log VALUES(3, '2020-06-20');
INSERT INTO Verification_Log VALUES(4, '2020-04-20');
INSERT INTO Verification_Log VALUES(5, '2019-05-20');
INSERT INTO Verification_Log VALUES(6, '2019-02-20');
INSERT INTO Verification_Log VALUES(7, '2019-10-23');
INSERT INTO Verification_Log VALUES(8, '2019-11-28');


/*********************************************/
/************** VERIFICATION_CLAIM (claims sub-table) *****************/
/********************************************
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

/*** Verification: Insert **
INSERT INTO Verification_Claim VALUES(1, 3, 1); ****/





