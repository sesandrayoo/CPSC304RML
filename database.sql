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
	adminID varchar(50) PRIMARY KEY,
	name varchar(100)
);

/*** Admin: Insert ***/
INSERT INTO Admin VALUES('admin1', 'Sandra');
INSERT INTO Admin VALUES('admin2', 'Marshal');
INSERT INTO Admin VALUES('admin3', 'Yuxiang');

/********************************/
/********* USER TABLE **********/
/********************************/
CREATE TABLE User (
	userID VARCHAR(50) PRIMARY KEY,
	userName VARCHAR(100),
	userAbout VARCHAR(500),
	userType VARCHAR(50),
	userPassword VARCHAR(50)
);

/*** User: Insert ***/
INSERT INTO User VALUES('user1', 'JimHalpert', 'Paper salesman', 'landlord', 'password123');
INSERT INTO User VALUES('user2', 'PamBH', 'Office Admin, I have 2 kids.', 'landlord', 'password123');
INSERT INTO User VALUES('user3', 'KevMalone', 'Accountant', 'tenant', 'password');
INSERT INTO User VALUES('user4', 'ErinH', 'Secretary', 'tenant', 'password');
INSERT INTO User VALUES('user5', 'MichaelScott', 'I manage people. I have a condo.', 'landlord', 'password');
INSERT INTO User VALUES('user6', 'DwightKS', 'Proud assistant to the regional manager. Owner of a large beet farm.', 'landlord', 'battlestargalactica');
INSERT INTO User VALUES('user7', 'OscarM', 'I like a tidy apartment', 'tenant', 'password');


/********************************/
/********* TENANT TABLE **********/
/********************************/
CREATE TABLE Tenant (
	userID VARCHAR(50) PRIMARY KEY NOT NULL,
	FOREIGN KEY (userID) REFERENCES
		User(userID)
	ON DELETE CASCADE
);

/*** Tenant: Insert ***/
INSERT INTO Tenant VALUES('user3');
INSERT INTO Tenant VALUES('user4');
INSERT INTO Tenant VALUES('user7');


/********************************/
/********* LANDLORD TABLE (not to be confused with LandlordProfile Table) **********/ 
/********************************/
CREATE TABLE Landlord (
	userID VARCHAR(50) PRIMARY KEY NOT NULL,
	FOREIGN KEY (userID) REFERENCES
		User(userID)
	ON DELETE CASCADE
);

/*** Landlord: Insert ***/
INSERT INTO Landlord VALUES('user1');
INSERT INTO Landlord VALUES('user2');
INSERT INTO Landlord VALUES('user5');
INSERT INTO Landlord VALUES('user6');

/*******************************************/
/********* LANDLORD PROFILE TABLE **********/
/*******************************************/
CREATE TABLE LandlordProfile (
	profileID VARCHAR(50) PRIMARY KEY,
    profileName VARCHAR(75) NOT NULL,
	profileCity VARCHAR(500),
	userID VARCHAR(50),
	FOREIGN KEY (userID) REFERENCES
		User(userID) 
	ON DELETE SET NULL
);

/*** LandlordProfile: Insert ***/
INSERT INTO LandlordProfile VALUES('profile1', 'David Wallace', 'Vancouver', 'user3');
INSERT INTO LandlordProfile VALUES('profile2', 'Robert Dunder', 'Vancouver', 'user3');
INSERT INTO LandlordProfile VALUES('profile3', 'Jan Levinson', 'Victoria', 'user7');
INSERT INTO LandlordProfile VALUES('profile4', 'Creed Bratton', 'Vancouver', 'user4');
INSERT INTO LandlordProfile VALUES('profile5', 'Bob Vance', 'Vancouver', 'user4');

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
	propertyID VARCHAR(50) PRIMARY KEY, 
	propertyAvailability BOOL, 
	propertyStreetAddress VARCHAR(100), 
	propertyDescription VARCHAR(500), 
	Bathrooms DECIMAL(2, 1), 
	Bedrooms INT, 
	propertyType VARCHAR(40),
	FOREIGN KEY (propertyStreetAddress) REFERENCES
		PropertyLocation(propertyStreetAddress)
	ON DELETE SET NULL
);

/*** Property: Insert ***/
INSERT INTO Property VALUES('property1', 1, '789-15918 24 Ave', 'A spacious downtown condo, newly renovated.', 1, 2, 'condo');
INSERT INTO Property VALUES('property2', 0, '456 2nd Ave', 'Perfect for a single person. A nice property.', 1, null, 'condo');
INSERT INTO Property VALUES('property3', 0, '1234 West 6th Ave', 'FAMILY TOWNHOUSE. Close to schools.', 2.5, 4, 'townhouse');
INSERT INTO Property VALUES('property4', 1, '987 Sesame Street', 'Close to skytrain. Kinda old.', null, null, 'detached house');
INSERT INTO Property VALUES('property5', 1, '3312 Agar Street', 'Bright place. Pets allowed!', '2', 2, 'townhouse');


/*************************************/
/************** OWNS *****************/
/*************************************/
CREATE TABLE Owns (
	profileID VARCHAR(50) NOT NULL,
	propertyID VARCHAR(50) NOT NULL,
	PRIMARY KEY (profileID, propertyID),
	FOREIGN KEY (profileID) REFERENCES
	LandlordProfile(profileID)
	ON DELETE CASCADE,
	FOREIGN KEY (propertyID) REFERENCES
	Property(propertyID)
	ON DELETE CASCADE
);

/*** Owns: Insert ***/
INSERT INTO Owns VALUES('profile2', 'property1');
INSERT INTO Owns VALUES('profile1', 'property2');
INSERT INTO Owns VALUES('profile4', 'property3');
INSERT INTO Owns VALUES('profile3', 'property4');
INSERT INTO Owns VALUES('profile5', 'property5');

/****************************************/
/************** LISTING *****************/
/****************************************/
CREATE TABLE Listing (
	listingID VARCHAR(50) PRIMARY KEY,
	uploaderID VARCHAR(50),
	listingTitle VARCHAR(150),
	listingArea VARCHAR(50),
	listingDescription VARCHAR(500),
	listingPrice VARCHAR(100),
	FOREIGN KEY (uploaderID) REFERENCES
		User(userID) 
	ON DELETE CASCADE
);

/*** Listing: Insert ***/
INSERT INTO Listing VALUES('listing1', 'user1', 'New Apartment for Rent', 'Vancouver', 'Close to skytrain, brand new!', '$800/month');
INSERT INTO Listing VALUES('listing2', 'user2', 'Downtown Condo for Rent!', 'Vancouver', 'Walking distance to mall', '$1200/month');
INSERT INTO Listing VALUES('listing3', 'user6', 'Townhouse Available', 'Vancouver', 'Peaceful mountain views', '$2500/month');


/*********************************************/
/************** REVIEW *****************/
/*********************************************/
CREATE TABLE Review (
	reviewID VARCHAR(50) PRIMARY KEY,
	userID VARCHAR(50),
	text VARCHAR(1024),
    starRating INT,
	FOREIGN KEY (userID) REFERENCES 
		User(userID)
	ON DELETE SET NULL
 );

/*** Review: Insert ***/
INSERT INTO Review VALUES('review1', 'user3', 'BEST. LANDLORD. EVER. They are soooo personable and super understanding. Very responsive too.', 5);
INSERT INTO Review VALUES('review2', 'user4', 'Pretty reasonable landlord.', 4);
INSERT INTO Review VALUES('review3', 'user6', 'Holy moly this landlord is crap. If I could give a negative 10 stars I would.', 1);


/*********************************************/
/************** VERIFICATION *****************/
/*********************************************/
CREATE TABLE Verification (
	verificationID VARCHAR(50),
    reviewID VARCHAR(50),
	adminID VARCHAR(50),
	verificationStatus BOOL,
	document VARCHAR(255),
	PRIMARY KEY (verificationID, adminID),
	FOREIGN KEY (adminID) REFERENCES 
		Admin(adminID)
 );

/*** Verification: Insert ***/
INSERT INTO Verification VALUES('verification1', 'review1', 'admin1', 1, 'contracts');
INSERT INTO Verification VALUES('verification2', 'review2', 'admin1', 0, 'contracts');
INSERT INTO Verification VALUES('verification3', 'review3', 'admin2', 1, 'contracts');

/*********************************************/
/************** VERIFICATION_LOG (claims sub-table) *****************/
/*********************************************/
CREATE TABLE Verification_Log(
	verificationID VARCHAR(50) PRIMARY KEY,
	claimDateTime DATE NOT NULL,
	FOREIGN KEY (verificationID) REFERENCES 
		Verification(verificationID)
	ON DELETE CASCADE
);

/*** Verification: Insert ***/
INSERT INTO Verification_Log VALUES('verification1', '2019-06-15');

/*********************************************/
/************** VERIFICATION_CLAIM (claims sub-table) *****************/
/*********************************************/
CREATE TABLE Verification_Claim(
	profileID VARCHAR(50),
	userID VARCHAR(50),
	verificationID VARCHAR(50),
	PRIMARY KEY (profileID, userID),
	FOREIGN KEY (profileID) REFERENCES 
		LandlordProfile(profileID)
	ON DELETE CASCADE,
	FOREIGN KEY (userID) REFERENCES 
		User(userID)
	ON DELETE CASCADE
);

/*** Verification: Insert ***/
INSERT INTO Verification_Claim VALUES('profile1', 'user3', 'verification1');





