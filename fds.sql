DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Managers CASCADE;
DROP TABLE IF EXISTS Riders CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS Staffs CASCADE;
DROP TABLE IF EXISTS Schedules CASCADE;
DROP TABLE IF EXISTS Delivers CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Restaurants CASCADE;
DROP TABLE IF EXISTS Menu CASCADE;
DROP TABLE IF EXISTS FoodItems CASCADE;
DROP TABLE IF EXISTS Promotes CASCADE;
DROP TABLE IF EXISTS Promotions CASCADE;
DROP TABLE IF EXISTS Manages CASCADE;
DROP TABLE IF EXISTS Percentage CASCADE;
DROP TABLE IF EXISTS Flat CASCADE;
DROP TABLE IF EXISTS PartTimeRiders CASCADE;
DROP TABLE IF EXISTS FullTimeRiders CASCADE;
DROP TABLE IF EXISTS WeeklyWorks CASCADE;
DROP TABLE IF EXISTS MonthlyWorks CASCADE;


CREATE TABLE Users (
	uid					INTEGER,
	username			VARCHAR(32) UNIQUE NOT NULL,
	password			VARCHAR(32) NOT NULL,
	phone 				INTEGER UNIQUE NOT NULL,
	PRIMARY KEY (uid),
	CHECK (phone < 100000000 AND phone > 9999999)
);

CREATE TABLE Managers (
	uid					INTEGER,
	PRIMARY KEY (uid),
	FOREIGN KEY (uid) REFERENCES Users
);

CREATE TABLE Staffs (
	uid					INTEGER,
	PRIMARY KEY (uid),
	FOREIGN KEY (uid) REFERENCES Users
);

CREATE TABLE Riders (
	uid					INTEGER,
	PRIMARY KEY (uid),
	FOREIGN KEY (uid) REFERENCES Users
);

CREATE TABLE Customers (
	uid					INTEGER,
	creditCardNumber	BIGINT CONSTRAINT sixteen_digit CHECK (creditCardNumber > 999999999999999 AND creditCardNumber < 10000000000000000),
	cvv 				INT CONSTRAINT three_digit CHECK (cvv > 99 AND cvv < 1000),
	rewardPoints		INTEGER NOT NULL,
	registerDate		DATE NOT NULL,
	PRIMARY KEY (uid),
	FOREIGN KEY (uid) REFERENCES Users
);

CREATE TABLE Schedules (
	sid 				INTEGER,
	startTime 			TIME (0) NOT NULL CHECK (EXTRACT(MINUTE FROM endTime) = 0),
	endTime 			TIME (0) NOT NULL CHECK (EXTRACT(MINUTE FROM endTime) = 0),
	dayOfWeek			INTEGER,
	PRIMARY KEY (sid),
	UNIQUE (startTime, endTime, dayOfWeek),
	CHECK (EXTRACT(HOUR FROM endTime) - EXTRACT(HOUR FROM startTime) < 5 AND 0 < dayOfWeek AND dayOfWeek < 8
		   AND 9 < EXTRACT(HOUR FROM startTime) AND EXTRACT(HOUR FROM startTime) < 23
		   AND 9 < EXTRACT(HOUR FROM endTime) AND EXTRACT(HOUR FROM endTime) < 23)
);

CREATE TABLE Restaurants (
	rid					INTEGER,
	rName				VARCHAR(32) UNIQUE NOT NULL,
	rCategory			VARCHAR(16) NOT NULL,
	location			TEXT NOT NULL,
	minSpent 			FLOAT,
	PRIMARY KEY (rid)
);

CREATE TABLE FoodItems (
	fid					INTEGER,
	fName				VARCHAR(32) NOT NULL,
	fCategory			VARCHAR(32) NOT NULL,
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
	orderTime			TIMESTAMP NOT NULL,
	rid 				INTEGER REFERENCES Restaurants (rid),
	fid					INTEGER REFERENCES FoodItems (fid),
	cid 				INTEGER REFERENCES Customers (uid),
	PRIMARY KEY (oid)
);

CREATE TABLE Delivers (
	uid					INTEGER,
	oid 				INTEGER UNIQUE NOT NULL,
	startTime			TIMESTAMP,
	departTime 			TIMESTAMP,
	completeTime		TIMESTAMP,
	deliverCost			FLOAT NOT NULL,
	location			TEXT NOT NULL,
	rating				INTEGER,
	PRIMARY KEY (uid, oid),
	FOREIGN KEY (uid) REFERENCES Riders,
	FOREIGN KEY (oid) REFERENCES Orders,
	CHECK (departTime >= startTime AND completeTime >= departTime AND 0 < rating AND rating < 6)
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
	percent 			FLOAT NOT NULL,
	maxAmount			FLOAT,
	PRIMARY KEY (pid),
	FOREIGN KEY (pid) REFERENCES Promotions
);

CREATE TABLE Flat (
	pid 				INTEGER,
	flatAmount			FLOAT NOT NULL,
	minAmount			FLOAT,
	PRIMARY KEY (pid),
	FOREIGN KEY (pid) REFERENCES Promotions
);

CREATE TABLE Promotes (
	pid					INTEGER,
	rid					INTEGER,
	fid					INTEGER,
	PRIMARY KEY (pid),
	FOREIGN KEY (pid) REFERENCES Promotions,
	FOREIGN KEY (rid) REFERENCES Restaurants,
	FOREIGN KEY (fid) REFERENCES FoodItems
);

CREATE TABLE Manages (
	uid					INTEGER UNIQUE,
	rid 				INTEGER,
	PRIMARY KEY (uid, rid),
	FOREIGN KEY (uid) REFERENCES Staffs,
	FOREIGN KEY (rid) REFERENCES Restaurants
);

CREATE TABLE PartTimeRiders (
	uid					INTEGER,
	psalary				INTEGER NOT NULL,
	PRIMARY KEY (uid),
	FOREIGN KEY (uid) REFERENCES Riders
);


CREATE TABLE FullTimeRiders (
	uid					INTEGER,
	fsalary				INTEGER NOT NULL,
	PRIMARY KEY (uid),
	FOREIGN KEY (uid) REFERENCES Riders
);

CREATE TABLE WeeklyWorks (
	uid					INTEGER,
	sid 				INTEGER,
	PRIMARY KEY (uid, sid),
	FOREIGN KEY (uid) REFERENCES PartTimeRiders,
	FOREIGN KEY (sid) REFERENCES Schedules
);


CREATE TABLE MonthlyWorks (
	uid					INTEGER,
	sid 				INTEGER,
	PRIMARY KEY (uid, sid),
	FOREIGN KEY (uid) REFERENCES FullTimeRiders,
	FOREIGN KEY (sid) REFERENCES Schedules
);

insert into Users (uid, username, password, phone) values (1, 'pwheatcroft0', 'vhvxjCY', 56953625);
insert into Users (uid, username, password, phone) values (2, 'solenikov1', 'pyInnrR', 72279365);
insert into Users (uid, username, password, phone) values (3, 'dtearle2', 'X1X6dBcmi', 42736588);
insert into Users (uid, username, password, phone) values (4, 'jgoymer3', 'RV0kTTvT87', 44332216);
insert into Users (uid, username, password, phone) values (5, 'msummerrell4', 'MpTraq8GK8dl', 22746814);
insert into Users (uid, username, password, phone) values (6, 'pmacrorie5', 'FIl0LrfsU', 37094369);
insert into Users (uid, username, password, phone) values (7, 'cbonicelli6', '0e38WmFimyjm', 39925131);
insert into Users (uid, username, password, phone) values (8, 'mhugin7', 'fTG9Q49ItgP', 83707746);
insert into Users (uid, username, password, phone) values (9, 'rlangfat8', 'r5pOSpQNzBT', 52548204);
insert into Users (uid, username, password, phone) values (10, 'jstrettle9', 'DAEsFEuT', 16821875);
insert into Users (uid, username, password, phone) values (11, 'sburchetta', 'ZJh7uRQ', 15730156);
insert into Users (uid, username, password, phone) values (12, 'jsandleb', '3c7pwdvO', 50283412);
insert into Users (uid, username, password, phone) values (13, 'jbarwackc', 'HNL6KCuWh5', 75366798);
insert into Users (uid, username, password, phone) values (14, 'avanderweedenburgd', 'e9mRcmdsXfWg', 83060447);
insert into Users (uid, username, password, phone) values (15, 'hagatee', 'r4gCCK95', 41140252);
insert into Users (uid, username, password, phone) values (16, 'odumsdayf', 'i8gIZ7Kh2', 89740447);
insert into Users (uid, username, password, phone) values (17, 'gferraig', 'jCwqlmW', 65788205);
insert into Users (uid, username, password, phone) values (18, 'wyitshakh', 'rgmxkLo', 31482917);
insert into Users (uid, username, password, phone) values (19, 'yhartmanni', '3jAKS1BEJsE6', 44333290);
insert into Users (uid, username, password, phone) values (20, 'ndefewj', 'W5MFIRuGQ2m0', 18598155);
insert into Users (uid, username, password, phone) values (21, 'mdelahayk', 'bLlB8GB', 12458551);
insert into Users (uid, username, password, phone) values (22, 'mbradenl', 'YjVCppl', 80019265);
insert into Users (uid, username, password, phone) values (23, 'teadsm', 'qQMZ3SrgeA', 32665527);
insert into Users (uid, username, password, phone) values (24, 'aimasonn', 'JWIVyxTl', 97297822);
insert into Users (uid, username, password, phone) values (25, 'riversono', 'sb2mzcuGBy', 18075541);
insert into Users (uid, username, password, phone) values (26, 'tbartlomiejp', 'cKhQg3Is2A', 59764558);
insert into Users (uid, username, password, phone) values (27, 'mdonnanq', 'L8yXZbsNxD', 18359378);
insert into Users (uid, username, password, phone) values (28, 'mtoozer', 'wJn9ul9UrV', 95274801);
insert into Users (uid, username, password, phone) values (29, 'hvartys', 'WMXOJ5p', 45624814);
insert into Users (uid, username, password, phone) values (30, 'swightt', 'ryJkmGd41nW', 32768463);
insert into Users (uid, username, password, phone) values (31, 'smacdermottu', '43i0zjHtif', 95326318);
insert into Users (uid, username, password, phone) values (32, 'rdwelleyv', 'p53xjXr', 48578118);
insert into Users (uid, username, password, phone) values (33, 'vhordlew', '0Abv97rU', 60015289);
insert into Users (uid, username, password, phone) values (34, 'etotherx', 'uVfA1W02', 77326893);
insert into Users (uid, username, password, phone) values (35, 'cidilly', 'iDEi3N7l', 15791455);
insert into Users (uid, username, password, phone) values (36, 'llumoxz', '2KoKPvj4QbL', 51309356);
insert into Users (uid, username, password, phone) values (37, 'hpowter10', '25NkYs', 64992615);
insert into Users (uid, username, password, phone) values (38, 'rdignon11', 'ZdyaYKqI', 66121024);
insert into Users (uid, username, password, phone) values (39, 'jdikles12', 'DrlPMV', 50603064);
insert into Users (uid, username, password, phone) values (40, 'fwilkisson13', 'NP0oYPsZV', 53331398);
insert into Users (uid, username, password, phone) values (41, 'mfibbings14', 'weJXpf6Qh', 79518680);
insert into Users (uid, username, password, phone) values (42, 'acribbin15', 'r8SM5c', 93858243);
insert into Users (uid, username, password, phone) values (43, 'lflanigan16', 'OqUpmc1Bn', 34696005);
insert into Users (uid, username, password, phone) values (44, 'spryer17', 'u07nBWj', 85546116);
insert into Users (uid, username, password, phone) values (45, 'mperrat18', '4x6T47Jba3Zd', 69339336);
insert into Users (uid, username, password, phone) values (46, 'abollam19', 'lQjIiVT', 41803832);
insert into Users (uid, username, password, phone) values (47, 'kdaddow1a', 'CZpLLunP7vWC', 26830078);
insert into Users (uid, username, password, phone) values (48, 'jdinsmore1b', 'kSnDUjult', 93576371);
insert into Users (uid, username, password, phone) values (49, 'aburgwyn1c', '9coyxay5Y', 16950597);
insert into Users (uid, username, password, phone) values (50, 'sstpierre1d', 'Xy1RRK4iQ', 86641338);
insert into Users (uid, username, password, phone) values (51, 'lrorke1e', 'XVC9QMymdk', 98383623);
insert into Users (uid, username, password, phone) values (52, 'pjuares1f', 'Ta0zdMsvk', 99691149);
insert into Users (uid, username, password, phone) values (53, 'dbeiderbecke1g', 'ep7b7a', 77925512);
insert into Users (uid, username, password, phone) values (54, 'afladgate1h', 'CRx19Nt', 26130581);
insert into Users (uid, username, password, phone) values (55, 'hconnar1i', '7yhC7I', 38215639);
insert into Users (uid, username, password, phone) values (56, 'sdaunter1j', 'FmzCE4jE', 31472412);
insert into Users (uid, username, password, phone) values (57, 'rgrindle1k', '0xqxGlD', 94276685);
insert into Users (uid, username, password, phone) values (58, 'preoch1l', 'dT0jVR6', 74263688);
insert into Users (uid, username, password, phone) values (59, 'jbetje1m', 'zcJ8Ojr', 60659578);
insert into Users (uid, username, password, phone) values (60, 'pvennings1n', '5V8I6SrWoUNR', 55012195);
insert into Users (uid, username, password, phone) values (61, 'aenion1o', '0xopyyOdEh', 40129976);
insert into Users (uid, username, password, phone) values (62, 'bzielinski1p', 'OWgyVhc', 80796276);
insert into Users (uid, username, password, phone) values (63, 'ebarwack1q', '20LJIbbhC', 84655173);
insert into Users (uid, username, password, phone) values (64, 'renticknap1r', 'Ty0KgSusctu', 73238793);
insert into Users (uid, username, password, phone) values (65, 'vleal1s', 'Dqxj0V', 40742589);
insert into Users (uid, username, password, phone) values (66, 'mjacqueminot1t', 'k3Py9OhHQK', 91718049);
insert into Users (uid, username, password, phone) values (67, 'odmitrienko1u', 'Fotljw', 24022400);
insert into Users (uid, username, password, phone) values (68, 'fcomelini1v', 'qXDQtN', 26374405);
insert into Users (uid, username, password, phone) values (69, 'vfairtlough1w', 'ClplALvwt', 24162572);
insert into Users (uid, username, password, phone) values (70, 'karnaldi1x', 'vr087vPW', 81023233);
insert into Users (uid, username, password, phone) values (71, 'mbredgeland1y', 'GnxLqx7jrCUs', 67906179);
insert into Users (uid, username, password, phone) values (72, 'charbertson1z', 'TJMSkPL6', 23690001);
insert into Users (uid, username, password, phone) values (73, 'emcmurty20', 'tquWAOzo', 45151232);
insert into Users (uid, username, password, phone) values (74, 'gapril21', 'ySoB09', 59268474);
insert into Users (uid, username, password, phone) values (75, 'cadolphine22', 'pY8NC7', 64149354);
insert into Users (uid, username, password, phone) values (76, 'jjenteau23', 'YGuAafU6', 33873446);
insert into Users (uid, username, password, phone) values (77, 'rbankhurst24', 'liKrbV', 43186265);
insert into Users (uid, username, password, phone) values (78, 'ecarswell25', 'sTFPGxmZ', 16219163);
insert into Users (uid, username, password, phone) values (79, 'rwands26', 'LF4xhd', 57506296);
insert into Users (uid, username, password, phone) values (80, 'ccrinion27', 'aZT7m7A', 29867715);
insert into Users (uid, username, password, phone) values (81, 'lwye28', '2MwOGU39', 61286023);
insert into Users (uid, username, password, phone) values (82, 'iraddenbury29', 'DiGNWqVY', 89099341);
insert into Users (uid, username, password, phone) values (83, 'dscolding2a', 'fwg0q9OR9', 18873792);
insert into Users (uid, username, password, phone) values (84, 'rboliver2b', '3iKoQKvN', 48831455);
insert into Users (uid, username, password, phone) values (85, 'swalbrook2c', 'Nu2381WEZU0', 60063663);
insert into Users (uid, username, password, phone) values (86, 'petches2d', 'FMxc00HM', 67535437);
insert into Users (uid, username, password, phone) values (87, 'gbridgeman2e', 'cUDO8w', 81446716);
insert into Users (uid, username, password, phone) values (88, 'spatkin2f', 'wUy2bnQuSpe', 60810205);
insert into Users (uid, username, password, phone) values (89, 'gkibbye2g', 'qdtuBo', 65076934);
insert into Users (uid, username, password, phone) values (90, 'hwallenger2h', 'fCTdz4UMV', 31124252);
insert into Users (uid, username, password, phone) values (91, 'dsoutter2i', '4r78pf6XG1kA', 56932690);
insert into Users (uid, username, password, phone) values (92, 'ledelheit2j', 'AeNqTx4HHKZ', 62969750);
insert into Users (uid, username, password, phone) values (93, 'kdoel2k', 'aK5wfvoUitwz', 43573566);
insert into Users (uid, username, password, phone) values (94, 'nleatherland2l', 'Hk5rHRvDY', 76464414);
insert into Users (uid, username, password, phone) values (95, 'nkaufman2m', 'Sx7SZrDwqwl', 42294811);
insert into Users (uid, username, password, phone) values (96, 'zdeevey2n', 'OEPOWO', 47874302);
insert into Users (uid, username, password, phone) values (97, 'vantonoyev2o', 'DYnOdMzrs', 90661579);
insert into Users (uid, username, password, phone) values (98, 'adalesco2p', 'wozQH6', 87248570);
insert into Users (uid, username, password, phone) values (99, 'fpreuvost2q', 'YWLkUVm', 95231133);
insert into Users (uid, username, password, phone) values (100, 'dandrewartha2r', 'IEPE09VVuXQ', 26414458);

insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (1, 1060518948396580, 862, 1156, '2020-01-01');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (2, 9051548019567307, 121, 1917, '2020-01-01');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (3, 9371269233364764, 848, 188, '2020-01-02');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (4, 6898259634980040, 381, 1036, '2020-01-02');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (5, 2904763716243819, 284, 71, '2020-01-02');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (6, 4284775028924061, 678, 217, '2020-01-03');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (7, 8605051445857364, 601, 933, '2020-01-04');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (8, 1358722176848219, 604, 1326, '2020-01-05');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (9, 1874188628086981, 162, 1833, '2020-01-06');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (10, 3091534387211791, 382, 472, '2020-01-10');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (11, 9468666772585379, 540, 250, '2020-02-29');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (12, 6095107872768918, 760, 794, '2020-01-07');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (13, 2716099892512063, 833, 297, '2020-03-12');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (14, 5898086294874304, 282, 66, '2020-02-08');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (15, 1188560853289270, 511, 108, '2020-03-29');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (16, 8934700695763830, 305, 337, '2020-02-02');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (17, 5682934249695600, 172, 1729, '2020-01-27');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (18, 4170287523537018, 168, 1142, '2020-03-26');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (19, 6609290002085339, 772, 1332, '2020-02-05');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (20, 5658736394264512, 769, 894, '2020-02-28');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (21, 9747914336813844, 537, 800, '2020-03-17');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (22, 2307583100441084, 953, 676, '2020-01-09');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (23, 7542032738947216, 439, 807, '2020-03-18');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (24, 7528668154518979, 420, 772, '2020-03-11');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (25, 7311856452596853, 887, 145, '2020-01-03');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (26, 5332212310466738, 719, 1804, '2020-03-17');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (27, 9473438701575103, 984, 1277, '2020-01-02');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (28, 3416720443431884, 267, 1709, '2020-03-20');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (29, 5443495964131491, 301, 1788, '2020-01-06');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (30, 1069237123954481, 765, 1631, '2020-02-26');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (31, 9041155321785513, 581, 984, '2020-01-07');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (32, 7960955876715116, 119, 1709, '2020-02-05');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (33, 9272643267749550, 691, 1943, '2020-02-29');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (34, 9720987954131681, 555, 382, '2020-03-10');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (35, 8180551247059043, 495, 872, '2020-01-08');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (36, 7093040172885541, 832, 1146, '2020-01-18');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (37, 5959731337047924, 680, 162, '2020-01-17');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (38, 9602686253821247, 709, 116, '2020-03-02');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (39, 1945683856364027, 175, 1755, '2020-01-04');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (40, 6324964896861040, 789, 733, '2020-02-16');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (41, 2174387429407810, 869, 928, '2020-03-24');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (42, 9303208910396797, 685, 1661, '2020-02-27');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (43, 5765848061362362, 856, 954, '2020-03-11');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (44, 9700090051889695, 129, 866, '2020-01-03');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (45, 5077632685823797, 398, 991, '2020-02-15');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (46, 3540417000474482, 938, 520, '2020-01-13');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (47, 3700484862354190, 618, 1899, '2020-02-12');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (48, 2720653166473352, 209, 1115, '2020-02-25');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (49, 1162481408608009, 308, 1603, '2020-02-07');
insert into Customers (uid, creditCardNumber, cvv, rewardPoints, registerDate) values (50, 2654757333874418, 652, 1362, '2020-02-21');

insert into Managers (uid) values (51);
insert into Managers (uid) values (52);
insert into Managers (uid) values (53);
insert into Managers (uid) values (54);
insert into Managers (uid) values (55);
insert into Managers (uid) values (56);
insert into Managers (uid) values (57);
insert into Managers (uid) values (58);
insert into Managers (uid) values (59);
insert into Managers (uid) values (60);

insert into Staffs (uid) values (61);
insert into Staffs (uid) values (62);
insert into Staffs (uid) values (63);
insert into Staffs (uid) values (64);
insert into Staffs (uid) values (65);
insert into Staffs (uid) values (66);
insert into Staffs (uid) values (67);
insert into Staffs (uid) values (68);
insert into Staffs (uid) values (69);
insert into Staffs (uid) values (70);
insert into Staffs (uid) values (71);
insert into Staffs (uid) values (72);
insert into Staffs (uid) values (73);
insert into Staffs (uid) values (74);
insert into Staffs (uid) values (75);
insert into Staffs (uid) values (76);
insert into Staffs (uid) values (77);
insert into Staffs (uid) values (78);
insert into Staffs (uid) values (79);
insert into Staffs (uid) values (80);

insert into Riders (uid) values (81);
insert into Riders (uid) values (82);
insert into Riders (uid) values (83);
insert into Riders (uid) values (84);
insert into Riders (uid) values (85);
insert into Riders (uid) values (86);
insert into Riders (uid) values (87);
insert into Riders (uid) values (88);
insert into Riders (uid) values (89);
insert into Riders (uid) values (90);
insert into Riders (uid) values (91);
insert into Riders (uid) values (92);
insert into Riders (uid) values (93);
insert into Riders (uid) values (94);
insert into Riders (uid) values (95);
insert into Riders (uid) values (96);
insert into Riders (uid) values (97);
insert into Riders (uid) values (98);
insert into Riders (uid) values (99);
insert into Riders (uid) values (100);

insert into PartTimeRiders (uid, psalary) values (81, 12);
insert into PartTimeRiders (uid, psalary) values (82, 12);
insert into PartTimeRiders (uid, psalary) values (83, 12);
insert into PartTimeRiders (uid, psalary) values (84, 12);
insert into PartTimeRiders (uid, psalary) values (85, 12);
insert into PartTimeRiders (uid, psalary) values (86, 12);
insert into PartTimeRiders (uid, psalary) values (87, 12);
insert into PartTimeRiders (uid, psalary) values (88, 12);
insert into PartTimeRiders (uid, psalary) values (89, 12);
insert into PartTimeRiders (uid, psalary) values (90, 12);

insert into FullTimeRiders (uid, fsalary) values (91, 40);
insert into FullTimeRiders (uid, fsalary) values (92, 40);
insert into FullTimeRiders (uid, fsalary) values (93, 40);
insert into FullTimeRiders (uid, fsalary) values (94, 40);
insert into FullTimeRiders (uid, fsalary) values (95, 40);
insert into FullTimeRiders (uid, fsalary) values (96, 40);
insert into FullTimeRiders (uid, fsalary) values (97, 40);
insert into FullTimeRiders (uid, fsalary) values (98, 40);
insert into FullTimeRiders (uid, fsalary) values (99, 40);
insert into FullTimeRiders (uid, fsalary) values (100, 40);

insert into Restaurants (rid, rName, rCategory, location, minSpent) values (1, 'Alfa', 'Western', '4939 Mccormick Alley', 4.8);
insert into Restaurants (rid, rName, rCategory, location, minSpent) values (2, 'Xray', 'Chinese', '37 Old Shore Drive', 13.4);
insert into Restaurants (rid, rName, rCategory, location, minSpent) values (3, 'Quebec', 'Mexican', '38 Loomis Parkway', 26.3);
insert into Restaurants (rid, rName, rCategory, location, minSpent) values (4, 'Charlie', 'Fast Food', '5 Prentice Place', 2.6);
insert into Restaurants (rid, rName, rCategory, location, minSpent) values (5, 'Beta', 'Fast Food', '70 Arizona Point', 14.3);

insert into FoodItems (fid, fName, fCategory) values (1, 'Pizza', 'Main');
insert into FoodItems (fid, fName, fCategory) values (2, 'Spaghetti', 'Main');
insert into FoodItems (fid, fName, fCategory) values (3, 'Salad', 'Appetizer');
insert into FoodItems (fid, fName, fCategory) values (4, 'Steak', 'Main');
insert into FoodItems (fid, fName, fCategory) values (5, 'Ice Cream', 'Dessert');
insert into FoodItems (fid, fName, fCategory) values (6, 'Roasted Duck', 'Main');
insert into FoodItems (fid, fName, fCategory) values (7, 'Noodle', 'Main');
insert into FoodItems (fid, fName, fCategory) values (8, 'Dumpling', 'Appetizer');
insert into FoodItems (fid, fName, fCategory) values (9, 'Xiao Long Bao', 'Appetizer');
insert into FoodItems (fid, fName, fCategory) values (10, 'Donut', 'Dessert');
insert into FoodItems (fid, fName, fCategory) values (11, 'Taco', 'Main');
insert into FoodItems (fid, fName, fCategory) values (12, 'Fajita', 'Main');
insert into FoodItems (fid, fName, fCategory) values (13, 'Burrito', 'Main');
insert into FoodItems (fid, fName, fCategory) values (14, 'Queso', 'Sides');
insert into FoodItems (fid, fName, fCategory) values (15, 'Rice', 'Sides');
insert into FoodItems (fid, fName, fCategory) values (16, 'Burger', 'Main');
insert into FoodItems (fid, fName, fCategory) values (17, 'French Fries', 'Sides');
insert into FoodItems (fid, fName, fCategory) values (18, 'Coke', 'Drink');
insert into FoodItems (fid, fName, fCategory) values (19, 'Tea', 'Drink');
insert into FoodItems (fid, fName, fCategory) values (20, 'Water', 'Drink');

insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (1, 1, true, 100, 0, 20);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (1, 2, true, 100, 0, 15);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (1, 3, true, 100, 0, 10);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (1, 4, true, 100, 0, 30);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (1, 5, true, 100, 0, 5);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (1, 18, true, 100, 0, 2.5);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (1, 19, true, 100, 0, 2.5);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (1, 20, true, 100, 0, 2);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (2, 6, true, 100, 0, 40);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (2, 7, true, 100, 0, 10);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (2, 8, true, 100, 0, 10);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (2, 9, true, 100, 0, 15);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (2, 10, true, 100, 0, 8);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (2, 18, true, 100, 0, 2);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (2, 19, true, 100, 0, 2);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (2, 20, true, 100, 0, 1.5);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (3, 11, true, 100, 0, 12);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (3, 12, true, 100, 0, 20);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (3, 13, true, 100, 0, 15);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (3, 14, true, 100, 0, 15);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (3, 15, true, 100, 0, 7);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (3, 18, true, 100, 0, 2.5);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (3, 19, true, 100, 0, 2.5);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (4, 16, true, 100, 0, 10);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (4, 17, true, 100, 0, 7);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (4, 18, true, 100, 0, 3);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (4, 19, true, 100, 0, 3);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (5, 16, true, 100, 0, 12);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (5, 17, true, 100, 0, 8);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (5, 18, true, 100, 0, 2);
insert into Menu (rid, fid, availability, dayLimit, noOfOrders, price) values (5, 19, true, 100, 0, 2);

insert into Promotions (pid, startDate, endDate) values (1, '2020-03-10', '2020-04-10');
insert into Promotions (pid, startDate, endDate) values (2, '2020-01-10', '2020-01-15');
insert into Promotions (pid, startDate, endDate) values (3, '2020-01-01', '2020-05-31');
insert into Promotions (pid, startDate, endDate) values (4, '2020-01-01', '2020-12-31');
insert into Promotions (pid, startDate, endDate) values (5, '2020-01-01', '2020-04-30');

insert into Percentage (pid, percent, maxAmount) values (1, 0.25, 10);
insert into Percentage (pid, percent, maxAmount) values (2, 0.2, 20);
insert into Percentage (pid, percent, maxAmount) values (3, 0.1, NULL);
insert into Flat (pid, flatAmount, minAmount) values (4, 5.5, NULL);
insert into Flat (pid, flatAmount, minAmount) values (5, 3, 10);

insert into Promotes (pid, rid, fid) values (1, 1, NULL);
insert into Promotes (pid, rid, fid) values (2, NULL, NULL);
insert into Promotes (pid, rid, fid) values (3, 1, 4);
insert into Promotes (pid, rid, fid) values (4, 3, 12);
insert into Promotes (pid, rid, fid) values (5, 5, NULL);

insert into Schedules (sid, startTime, endTime, dayOfWeek) values (1, '10:00', '14:00', 1);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (2, '11:00', '15:00', 1);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (3, '12:00', '16:00', 1);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (4, '13:00', '17:00', 1);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (5, '15:00', '19:00', 1);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (6, '16:00', '20:00', 1);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (7, '17:00', '21:00', 1);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (8, '18:00', '22:00', 1);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (9, '10:00', '14:00', 2);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (10, '11:00', '15:00', 2);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (11, '12:00', '16:00', 2);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (12, '13:00', '17:00', 2);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (13, '15:00', '19:00', 2);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (14, '16:00', '20:00', 2);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (15, '17:00', '21:00', 2);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (16, '18:00', '22:00', 2);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (17, '10:00', '14:00', 3);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (18, '11:00', '15:00', 3);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (19, '12:00', '16:00', 3);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (20, '13:00', '17:00', 3);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (21, '15:00', '19:00', 3);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (22, '16:00', '20:00', 3);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (23, '17:00', '21:00', 3);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (24, '18:00', '22:00', 3);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (25, '10:00', '14:00', 4);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (26, '11:00', '15:00', 4);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (27, '12:00', '16:00', 4);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (28, '13:00', '17:00', 4);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (29, '15:00', '19:00', 4);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (30, '16:00', '20:00', 4);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (31, '17:00', '21:00', 4);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (32, '18:00', '22:00', 4);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (33, '10:00', '14:00', 5);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (34, '11:00', '15:00', 5);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (35, '12:00', '16:00', 5);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (36, '13:00', '17:00', 5);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (37, '15:00', '19:00', 5);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (38, '16:00', '20:00', 5);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (39, '17:00', '21:00', 5);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (40, '18:00', '22:00', 5);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (41, '10:00', '14:00', 6);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (42, '11:00', '15:00', 6);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (43, '12:00', '16:00', 6);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (44, '13:00', '17:00', 6);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (45, '15:00', '19:00', 6);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (46, '16:00', '20:00', 6);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (47, '17:00', '21:00', 6);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (48, '18:00', '22:00', 6);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (49, '10:00', '14:00', 7);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (50, '11:00', '15:00', 7);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (51, '12:00', '16:00', 7);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (52, '13:00', '17:00', 7);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (53, '15:00', '19:00', 7);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (54, '16:00', '20:00', 7);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (55, '17:00', '21:00', 7);
insert into Schedules (sid, startTime, endTime, dayOfWeek) values (56, '18:00', '22:00', 7);

insert into WeeklyWorks (uid, sid) values (81, 1);
insert into WeeklyWorks (uid, sid) values (81, 5);
insert into WeeklyWorks (uid, sid) values (81, 9);
insert into WeeklyWorks (uid, sid) values (82, 3);
insert into WeeklyWorks (uid, sid) values (82, 27);
insert into WeeklyWorks (uid, sid) values (82, 35);
insert into WeeklyWorks (uid, sid) values (83, 3);
insert into WeeklyWorks (uid, sid) values (83, 7);
insert into WeeklyWorks (uid, sid) values (83, 56);
insert into WeeklyWorks (uid, sid) values (84, 41);
insert into WeeklyWorks (uid, sid) values (84, 45);
insert into WeeklyWorks (uid, sid) values (84, 49);
insert into WeeklyWorks (uid, sid) values (85, 44);
insert into WeeklyWorks (uid, sid) values (85, 48);
insert into WeeklyWorks (uid, sid) values (85, 55);
insert into WeeklyWorks (uid, sid) values (86, 2);
insert into WeeklyWorks (uid, sid) values (86, 10);
insert into WeeklyWorks (uid, sid) values (86, 18);
insert into WeeklyWorks (uid, sid) values (87, 14);
insert into WeeklyWorks (uid, sid) values (87, 22);
insert into WeeklyWorks (uid, sid) values (87, 30);
insert into WeeklyWorks (uid, sid) values (88, 10);
insert into WeeklyWorks (uid, sid) values (88, 20);
insert into WeeklyWorks (uid, sid) values (88, 30);
insert into WeeklyWorks (uid, sid) values (89, 29);
insert into WeeklyWorks (uid, sid) values (89, 39);
insert into WeeklyWorks (uid, sid) values (89, 49);
insert into WeeklyWorks (uid, sid) values (90, 11);
insert into WeeklyWorks (uid, sid) values (90, 22);
insert into WeeklyWorks (uid, sid) values (90, 33);

insert into MonthlyWorks (uid, sid) values (91, 1);
insert into MonthlyWorks (uid, sid) values (91, 5);
insert into MonthlyWorks (uid, sid) values (91, 9);
insert into MonthlyWorks (uid, sid) values (91, 13);
insert into MonthlyWorks (uid, sid) values (91, 17);
insert into MonthlyWorks (uid, sid) values (91, 21);
insert into MonthlyWorks (uid, sid) values (91, 25);
insert into MonthlyWorks (uid, sid) values (91, 29);
insert into MonthlyWorks (uid, sid) values (91, 33);
insert into MonthlyWorks (uid, sid) values (91, 37);

insert into MonthlyWorks (uid, sid) values (92, 2);
insert into MonthlyWorks (uid, sid) values (92, 6);
insert into MonthlyWorks (uid, sid) values (92, 10);
insert into MonthlyWorks (uid, sid) values (92, 14);
insert into MonthlyWorks (uid, sid) values (92, 18);
insert into MonthlyWorks (uid, sid) values (92, 22);
insert into MonthlyWorks (uid, sid) values (92, 26);
insert into MonthlyWorks (uid, sid) values (92, 30);
insert into MonthlyWorks (uid, sid) values (92, 34);
insert into MonthlyWorks (uid, sid) values (92, 38);

insert into MonthlyWorks (uid, sid) values (93, 3);
insert into MonthlyWorks (uid, sid) values (93, 7);
insert into MonthlyWorks (uid, sid) values (93, 11);
insert into MonthlyWorks (uid, sid) values (93, 15);
insert into MonthlyWorks (uid, sid) values (93, 19);
insert into MonthlyWorks (uid, sid) values (93, 23);
insert into MonthlyWorks (uid, sid) values (93, 27);
insert into MonthlyWorks (uid, sid) values (93, 31);
insert into MonthlyWorks (uid, sid) values (93, 35);
insert into MonthlyWorks (uid, sid) values (93, 39);

insert into MonthlyWorks (uid, sid) values (94, 4);
insert into MonthlyWorks (uid, sid) values (94, 8);
insert into MonthlyWorks (uid, sid) values (94, 12);
insert into MonthlyWorks (uid, sid) values (94, 16);
insert into MonthlyWorks (uid, sid) values (94, 20);
insert into MonthlyWorks (uid, sid) values (94, 24);
insert into MonthlyWorks (uid, sid) values (94, 28);
insert into MonthlyWorks (uid, sid) values (94, 32);
insert into MonthlyWorks (uid, sid) values (94, 36);
insert into MonthlyWorks (uid, sid) values (94, 40);

insert into MonthlyWorks (uid, sid) values (95, 9);
insert into MonthlyWorks (uid, sid) values (95, 13);
insert into MonthlyWorks (uid, sid) values (95, 17);
insert into MonthlyWorks (uid, sid) values (95, 21);
insert into MonthlyWorks (uid, sid) values (95, 25);
insert into MonthlyWorks (uid, sid) values (95, 29);
insert into MonthlyWorks (uid, sid) values (95, 33);
insert into MonthlyWorks (uid, sid) values (95, 37);
insert into MonthlyWorks (uid, sid) values (95, 41);
insert into MonthlyWorks (uid, sid) values (95, 45);

insert into MonthlyWorks (uid, sid) values (96, 10);
insert into MonthlyWorks (uid, sid) values (96, 14);
insert into MonthlyWorks (uid, sid) values (96, 18);
insert into MonthlyWorks (uid, sid) values (96, 22);
insert into MonthlyWorks (uid, sid) values (96, 26);
insert into MonthlyWorks (uid, sid) values (96, 30);
insert into MonthlyWorks (uid, sid) values (96, 34);
insert into MonthlyWorks (uid, sid) values (96, 38);
insert into MonthlyWorks (uid, sid) values (96, 42);
insert into MonthlyWorks (uid, sid) values (96, 46);

insert into MonthlyWorks (uid, sid) values (97, 20);
insert into MonthlyWorks (uid, sid) values (97, 24);
insert into MonthlyWorks (uid, sid) values (97, 28);
insert into MonthlyWorks (uid, sid) values (97, 32);
insert into MonthlyWorks (uid, sid) values (97, 36);
insert into MonthlyWorks (uid, sid) values (97, 40);
insert into MonthlyWorks (uid, sid) values (97, 44);
insert into MonthlyWorks (uid, sid) values (97, 48);
insert into MonthlyWorks (uid, sid) values (97, 52);
insert into MonthlyWorks (uid, sid) values (97, 56);

insert into MonthlyWorks (uid, sid) values (98, 19);
insert into MonthlyWorks (uid, sid) values (98, 23);
insert into MonthlyWorks (uid, sid) values (98, 27);
insert into MonthlyWorks (uid, sid) values (98, 31);
insert into MonthlyWorks (uid, sid) values (98, 35);
insert into MonthlyWorks (uid, sid) values (98, 39);
insert into MonthlyWorks (uid, sid) values (98, 43);
insert into MonthlyWorks (uid, sid) values (98, 47);
insert into MonthlyWorks (uid, sid) values (98, 51);
insert into MonthlyWorks (uid, sid) values (98, 55);

insert into MonthlyWorks (uid, sid) values (99, 18);
insert into MonthlyWorks (uid, sid) values (99, 22);
insert into MonthlyWorks (uid, sid) values (99, 26);
insert into MonthlyWorks (uid, sid) values (99, 30);
insert into MonthlyWorks (uid, sid) values (99, 34);
insert into MonthlyWorks (uid, sid) values (99, 38);
insert into MonthlyWorks (uid, sid) values (99, 42);
insert into MonthlyWorks (uid, sid) values (99, 46);
insert into MonthlyWorks (uid, sid) values (99, 50);
insert into MonthlyWorks (uid, sid) values (99, 54);

insert into MonthlyWorks (uid, sid) values (100, 17);
insert into MonthlyWorks (uid, sid) values (100, 21);
insert into MonthlyWorks (uid, sid) values (100, 25);
insert into MonthlyWorks (uid, sid) values (100, 29);
insert into MonthlyWorks (uid, sid) values (100, 33);
insert into MonthlyWorks (uid, sid) values (100, 37);
insert into MonthlyWorks (uid, sid) values (100, 41);
insert into MonthlyWorks (uid, sid) values (100, 45);
insert into MonthlyWorks (uid, sid) values (100, 49);
insert into MonthlyWorks (uid, sid) values (100, 53);

insert into Manages (uid, rid) values (61, 1);
insert into Manages (uid, rid) values (62, 1);
insert into Manages (uid, rid) values (63, 1);
insert into Manages (uid, rid) values (64, 1);
insert into Manages (uid, rid) values (65, 2);	
insert into Manages (uid, rid) values (66, 2);
insert into Manages (uid, rid) values (67, 2);
insert into Manages (uid, rid) values (68, 2);
insert into Manages (uid, rid) values (69, 3);
insert into Manages (uid, rid) values (70, 3);
insert into Manages (uid, rid) values (71, 3);
insert into Manages (uid, rid) values (72, 3);
insert into Manages (uid, rid) values (73, 4);
insert into Manages (uid, rid) values (74, 4);
insert into Manages (uid, rid) values (75, 4);
insert into Manages (uid, rid) values (76, 4);
insert into Manages (uid, rid) values (77, 5);
insert into Manages (uid, rid) values (78, 5);
insert into Manages (uid, rid) values (79, 5);
insert into Manages (uid, rid) values (80, 5);

insert into Orders (oid, review, orderTime, rid, fid, cid) values (1, 'Good food', '2020-01-06 10:01:02', 1, 4, 1);
insert into Orders (oid, review, orderTime, rid, fid, cid) values (2, 'Could have been better', '2020-01-07 12:00:00', 1, 1, 1);
insert into Orders (oid, review, orderTime, rid, fid, cid) values (3, NULL, '2020-01-07 14:12:34', 4, 16, 2);
insert into Orders (oid, review, orderTime, rid, fid, cid) values (4, NULL, '2020-01-07 15:59:00', 1, 4, 3);
insert into Orders (oid, review, orderTime, rid, fid, cid) values (5, NULL, '2020-01-08 16:13:17', 1, 4, 3);
insert into Orders (oid, review, orderTime, rid, fid, cid) values (6, 'Too salty', '2020-01-10 11:19:02', 5, 16, 4);
insert into Orders (oid, review, orderTime, rid, fid, cid) values (7, NULL, '2020-01-10 13:11:53', 5, 17, 5);
insert into Orders (oid, review, orderTime, rid, fid, cid) values (8, NULL, '2020-01-10 17:51:49', 2, 6, 6);
insert into Orders (oid, review, orderTime, rid, fid, cid) values (9, 'Love it!', '2020-01-12 20:12:24', 2, 8, 7);
insert into Orders (oid, review, orderTime, rid, fid, cid) values (10, 'Too dry', '2020-01-12 21:30:51', 3, 12, 8);

insert into Delivers (uid, oid, startTime, departTime, completeTime, deliverCost, location, rating) values (81, 1, '2020-01-06 10:01:30', '2020-01-06 10:18:32', '2020-01-06 10:23:49', 27, 'PGPR NUS Block 2', 4);
insert into Delivers (uid, oid, startTime, departTime, completeTime, deliverCost, location, rating) values (81, 2, '2020-01-07 12:00:17', '2020-01-07 12:11:53', '2020-01-07 12:20:17', 20, 'PGPR NUS Block 2', NULL);
insert into Delivers (uid, oid, startTime, departTime, completeTime, deliverCost, location, rating) values (92, 3, '2020-01-07 14:12:54', '2020-01-07 14:30:11', '2020-01-07 14:37:50', 10, 'Clementi MRT', 5);
insert into Delivers (uid, oid, startTime, departTime, completeTime, deliverCost, location, rating) values (93, 4, '2020-01-07 15:59:14', '2020-01-07 16:18:45', '2020-01-07 16:30:12', 24, 'Kent Ridge Hall', 5);
insert into Delivers (uid, oid, startTime, departTime, completeTime, deliverCost, location, rating) values (92, 5, '2020-01-08 16:13:32', '2020-01-08 16:40:43', '2020-01-08 17:01:30', 24, 'Kent Ridge Hall', 4);
insert into Delivers (uid, oid, startTime, departTime, completeTime, deliverCost, location, rating) values (91, 6, '2020-01-10 11:19:25', '2020-01-10 11:31:26', '2020-01-10 11:42:58', 9, 'RVRC Block B', NULL);
insert into Delivers (uid, oid, startTime, departTime, completeTime, deliverCost, location, rating) values (82, 7, '2020-01-10 13:12:09', '2020-01-10 13:30:00', '2020-01-10 13:36:54', 8, 'PGPR NUS Block 28', NULL);
insert into Delivers (uid, oid, startTime, departTime, completeTime, deliverCost, location, rating) values (91, 8, '2020-01-10 17:52:00', '2020-01-10 18:08:29', '2020-01-10 18:18:18', 38.5, 'Yusof Ishak House', 3);
insert into Delivers (uid, oid, startTime, departTime, completeTime, deliverCost, location, rating) values (83, 9, '2020-01-12 20:12:39', '2020-01-12 20:18:57', '2020-01-12 20:28:03', 10, 'University Town', 4);
insert into Delivers (uid, oid, startTime, departTime, completeTime, deliverCost, location, rating) values (83, 10, '2020-01-12 21:31:10', '2020-01-12 21:50:23', '2020-01-12 21:58:20', 14.5, 'Raffles Hall', 5);

CREATE OR REPLACE FUNCTION check_hours_constraint () RETURNS TRIGGER AS $$ 
DECLARE
	totalHours		INTEGER;
	additional		INTEGER;
BEGIN
	SELECT SUM(EXTRACT(HOUR FROM s.endTime) - EXTRACT(HOUR FROM s.startTime)) INTO totalHours
		FROM WeeklyWorks w JOIN Riders r USING (uid)
		JOIN Schedules s USING (sid)
		WHERE r.uid = NEW.uid;
	IF (TG_OP = 'INSERT') THEN 
		SELECT EXTRACT(HOUR FROM s.endTime) - EXTRACT(HOUR FROM s.startTime) INTO additional
			FROM Schedules s
			WHERE s.sid = NEW.sid;
		IF totalHours + additional > 48 THEN
			RAISE exception 'Maximum hours to work per week is 48' ;
		END IF;
		RETURN NEW;
	ELSIF (TG_OP = 'DELETE') THEN 
		SELECT EXTRACT(HOUR FROM s.endTime) - EXTRACT(HOUR FROM s.startTime) INTO additional
			FROM Schedules s
			WHERE s.sid = NEW.sid;
		IF totalHours - additional < 10 THEN
			RAISE exception 'Minimum hours to work per week is 10' ;
		END IF;
		RETURN OLD;
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS hours_trigger ON WeeklyWorks;
CREATE TRIGGER hours_trigger
	BEFORE INSERT OR DELETE
	ON WeeklyWorks
	FOR EACH ROW EXECUTE FUNCTION check_hours_constraint () ;


CREATE OR REPLACE FUNCTION menu_availability_constraint() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.noOfOrders = NEW.dayLimit THEN
        NEW."availability" := FALSE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS availability_trigger on Menu;
CREATE TRIGGER availability_trigger
    BEFORE UPDATE OF noOfOrders ON Menu
    FOR EACH ROW EXECUTE FUNCTION menu_availability_constraint () ;