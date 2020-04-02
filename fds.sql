DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Managers CASCADE;
DROP TABLE IF EXISTS Riders CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS Staffs CASCADE;
DROP TABLE IF EXISTS Works CASCADE;
DROP TABLE IF EXISTS Schedules CASCADE;
DROP TABLE IF EXISTS Delivers CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Restaurants CASCADE;
DROP TABLE IF EXISTS Menu CASCADE;
DROP TABLE IF EXISTS FoodItems CASCADE;
DROP TABLE IF EXISTS Promotes CASCADE;
DROP TABLE IF EXISTS Promotions CASCADE;
DROP TABLE IF EXISTS Manages CASCADE;
DROP TABLE IF EXISTS Reviews CASCADE;
DROP TABLE IF EXISTS Percentage CASCADE;
DROP TABLE IF EXISTS Flat CASCADE;

CREATE TABLE Users (
	username			VARCHAR(32),
	password			VARCHAR(32) NOT NULL,
	phone 				INTEGER UNIQUE NOT NULL,
	PRIMARY KEY (username),
	CHECK (phone < 100000000 AND phone > 9999999)
);

CREATE TABLE Managers (
	username			VARCHAR(32),
	PRIMARY KEY (username),
	FOREIGN KEY (username) REFERENCES Users
);

CREATE TABLE Staffs (
	username			VARCHAR(32),
	PRIMARY KEY (username),
	FOREIGN KEY (username) REFERENCES Users
);

CREATE TABLE Riders (
	username			VARCHAR(32),
	PRIMARY KEY (username),
	FOREIGN KEY (username) REFERENCES Users
);

CREATE TABLE Customers (
	username			VARCHAR(32),
	creditCardNumber	BIGINT CONSTRAINT sixteen_digit CHECK (creditCardNumber > 999999999999999 AND creditCardNumber < 10000000000000000),
	ccv 				INT CONSTRAINT three_digit CHECK (ccv > 99 AND ccv < 1000),
	rewardPoints		INTEGER NOT NULL,
	PRIMARY KEY (username),
	FOREIGN KEY (username) REFERENCES Users
);

CREATE TABLE Schedules (
	sid 				INTEGER,
	startTime 			TIMESTAMP NOT NULL CHECK (EXTRACT(MINUTE FROM endTime) = 0),
	endTime 			TIMESTAMP NOT NULL CHECK (EXTRACT(MINUTE FROM endTime) = 0),
	PRIMARY KEY (sid),
	UNIQUE (startTime, endTime),
	CHECK (EXTRACT(HOUR FROM endTime) - EXTRACT(HOUR FROM startTime) < 5)
);

CREATE TABLE Restaurants (
	rid					INTEGER,
	rName				VARCHAR(32) UNIQUE NOT NULL,
	rCategory			VARCHAR(16) NOT NULL,
	location			TEXT NOT NULL,
	minSpent 			FLOAT,
	PRIMARY KEY (rid)
);

CREATE TABLE Works (
	username			VARCHAR(32),
	sid 				INTEGER,
	PRIMARY KEY (username, sid),
	FOREIGN KEY (username) REFERENCES Riders,
	FOREIGN KEY (sid) REFERENCES Schedules
);

CREATE TABLE FoodItems (
	fid					INTEGER,
	name				VARCHAR(32) NOT NULL,
	category			VARCHAR(32) NOT NULL,
	PRIMARY KEY (fid)
);
	
CREATE TABLE Menu (
	rid					INTEGER,
	fid					INTEGER,
	availability		BOOLEAN NOT NULL,
	dayLimit			INTEGER NOT NULL,
	noOfOrders			INTEGER NOT NULL,
	price				FLOAT NOT NULL,
	PRIMARY KEY(rid, fid),
	FOREIGN KEY(rid) REFERENCES Restaurants,
	FOREIGN KEY(fid) REFERENCES FoodItems
);

CREATE TABLE Orders (
	oid 				INTEGER,
	review				TEXT,
	rid 				INTEGER REFERENCES Restaurants (rid),
	fid					INTEGER REFERENCES FoodItems (fid),
	cid 				VARCHAR(32) REFERENCES Customers (username),
	PRIMARY KEY (oid)
);

CREATE TABLE Delivers (
	username			VARCHAR(32),
	oid 				INTEGER UNIQUE NOT NULL,
	startTime			TIMESTAMP,
	departTime 			TIMESTAMP,
	completeTime		TIMESTAMP,
	deliverCost			FLOAT NOT NULL,
	location			TEXT NOT NULL,
	PRIMARY KEY (username, oid),
	FOREIGN KEY (username) REFERENCES Riders,
	FOREIGN KEY (oid) REFERENCES Orders,
	CHECK (departTime >= startTime AND completeTime >= departTime)
);

CREATE TABLE Promotions (
	pid					INTEGER,
	startDate			DATE NOT NULL,
	endDate				DATE NOT NULL,
	PRIMARY KEY (pid),
	CHECK (endDate >= startDate)
);

CREATE TABLE Percentage (
	pid  				INTEGER,
	maxValue			FLOAT,
	PRIMARY KEY (pid),
	FOREIGN KEY (pid) REFERENCES Promotions
);

CREATE TABLE Flat (
	pid 				INTEGER,
	minAmount			FLOAT,
	PRIMARY KEY (pid),
	FOREIGN KEY (pid) REFERENCES Promotions
);

CREATE TABLE Promotes (
	pid					INTEGER,
	rid					INTEGER,
	fid					INTEGER,
	PRIMARY KEY (pid, rid, fid),
	FOREIGN KEY (pid) REFERENCES Promotions,
	FOREIGN KEY (rid) REFERENCES Restaurants,
	FOREIGN KEY (fid) REFERENCES FoodItems
);

CREATE TABLE Manages (
	username			VARCHAR(32) UNIQUE,
	rid 				INTEGER,
	PRIMARY KEY (username, rid),
	FOREIGN KEY (username) REFERENCES Staffs,
	FOREIGN KEY (rid) REFERENCES Restaurants
);

CREATE TABLE Reviews (
	username			VARCHAR(32) UNIQUE,
	rid					INTEGER, 
	fid					INTEGER,
	PRIMARY KEY (username, rid, fid),
	FOREIGN KEY (username) REFERENCES Customers,
	FOREIGN KEY (rid) REFERENCES Restaurants,
	FOREIGN KEY (fid) REFERENCES FoodItems
);
	

