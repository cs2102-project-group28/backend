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
DROP TABLE IF EXISTS Reviews CASCADE;
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
	salary				INTEGER,
	PRIMARY KEY (uid),
	FOREIGN KEY (uid) REFERENCES Users
);

CREATE TABLE Customers (
	uid					INTEGER,
	creditCardNumber	BIGINT CONSTRAINT sixteen_digit CHECK (creditCardNumber > 999999999999999 AND creditCardNumber < 10000000000000000),
	cvv 				INT CONSTRAINT three_digit CHECK (cvv > 99 AND cvv < 1000),
	rewardPoints		INTEGER NOT NULL,
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
	PRIMARY KEY (uid, oid),
	FOREIGN KEY (uid) REFERENCES Riders,
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

CREATE TABLE Reviews (
	uid					INTEGER UNIQUE,
	rid					INTEGER, 
	fid					INTEGER,
	PRIMARY KEY (uid, rid, fid),
	FOREIGN KEY (uid) REFERENCES Customers,
	FOREIGN KEY (rid) REFERENCES Restaurants,
	FOREIGN KEY (fid) REFERENCES FoodItems
);

CREATE TABLE PartTimeRiders (
	uid					INTEGER,
	PRIMARY KEY (uid),
	FOREIGN KEY (uid) REFERENCES Riders
);


CREATE TABLE FullTimeRiders (
	uid					INTEGER,
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

insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (1, 6205938526439141, 213, 0);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (2, 6080670015134003, 599, 0);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (3, 9199690668521312, 134, 0);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (4, 4902235673129731, 755, 0);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (5, 3047751615907016, 696, 384);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (6, 4676478401726700, 848, 518);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (7, 8475830413090178, 719, 970);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (8, 7848805880735187, 556, 717);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (9, 7179369420201945, 625, 708);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (10, 3070531897330590, 730, 695);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (11, 3811358837506657, 824, 501);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (12, 1740576070432224, 497, 567);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (13, 1682047131125826, 505, 902);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (14, 7173306056917831, 408, 596);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (15, 7128606896542732, 258, 783);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (16, 2825570367475332, 742, 83);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (17, 4319647658085384, 106, 188);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (18, 5023379434002091, 587, 227);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (19, 7143319783635223, 183, 315);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (20, 6235990812363391, 224, 1);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (21, 8397550286343727, 317, 34);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (22, 7568712682997110, 619, 126);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (23, 2146215024243233, 309, 935);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (24, 5387323159938328, 819, 814);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (25, 3590855805066005, 998, 76);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (26, 1900917621864588, 725, 433);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (27, 3760783353299561, 437, 372);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (28, 6744080363204237, 767, 417);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (29, 6245511546869081, 133, 635);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (30, 1330902987486440, 132, 549);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (31, 1939886205763334, 194, 340);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (32, 5792642062420556, 422, 814);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (33, 2013171925520729, 642, 964);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (34, 7833362701689934, 755, 346);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (35, 8064426903084260, 341, 310);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (36, 4876612037161838, 416, 730);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (37, 7456616213004880, 987, 549);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (38, 7615260205823254, 271, 291);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (39, 5975136197532661, 222, 346);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (40, 8459887854368480, 843, 920);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (41, 4027449621704080, 659, 279);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (42, 8494606848518884, 208, 331);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (43, 4430857662331630, 930, 778);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (44, 2149849893875049, 670, 356);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (45, 6182661167605418, 531, 494);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (46, 4997470378936459, 997, 950);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (47, 4159693379465181, 247, 753);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (48, 9110548288156392, 600, 780);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (49, 1093370340854854, 224, 637);
insert into Customers (uid, creditCardNumber, cvv, rewardPoints) values (50, 6898450557391852, 764, 986);

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

insert into Riders (uid, salary) values (81, 0);
insert into Riders (uid, salary) values (82, 0);
insert into Riders (uid, salary) values (83, 0);
insert into Riders (uid, salary) values (84, 0);
insert into Riders (uid, salary) values (85, 0);
insert into Riders (uid, salary) values (86, 0);
insert into Riders (uid, salary) values (87, 0);
insert into Riders (uid, salary) values (88, 0);
insert into Riders (uid, salary) values (89, 0);
insert into Riders (uid, salary) values (90, 0);
insert into Riders (uid, salary) values (91, 0);
insert into Riders (uid, salary) values (92, 0);
insert into Riders (uid, salary) values (93, 0);
insert into Riders (uid, salary) values (94, 0);
insert into Riders (uid, salary) values (95, 0);
insert into Riders (uid, salary) values (96, 0);
insert into Riders (uid, salary) values (97, 0);
insert into Riders (uid, salary) values (98, 0);
insert into Riders (uid, salary) values (99, 0);
insert into Riders (uid, salary) values (100, 0);

insert into PartTimeRiders (uid) values (81);
insert into PartTimeRiders (uid) values (82);
insert into PartTimeRiders (uid) values (83);
insert into PartTimeRiders (uid) values (84);
insert into PartTimeRiders (uid) values (85);
insert into PartTimeRiders (uid) values (86);
insert into PartTimeRiders (uid) values (87);
insert into PartTimeRiders (uid) values (88);
insert into PartTimeRiders (uid) values (89);
insert into PartTimeRiders (uid) values (90);

insert into FullTimeRiders (uid) values (91);
insert into FullTimeRiders (uid) values (92);
insert into FullTimeRiders (uid) values (93);
insert into FullTimeRiders (uid) values (94);
insert into FullTimeRiders (uid) values (95);
insert into FullTimeRiders (uid) values (96);
insert into FullTimeRiders (uid) values (97);
insert into FullTimeRiders (uid) values (98);
insert into FullTimeRiders (uid) values (99);
insert into FullTimeRiders (uid) values (100);

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
insert into Promotions (pid, startDate, endDate) values (2, '2020-01-20', '2020-01-25');
insert into Promotions (pid, startDate, endDate) values (3, '2020-01-01', '2020-05-31');
insert into Promotions (pid, startDate, endDate) values (4, '2020-01-01', '2020-12-31');
insert into Promotions (pid, startDate, endDate) values (5, '2020-02-01', '2020-04-30');

insert into Percentage (pid, percent, maxAmount) values (1, 0.25, 10);
insert into Percentage (pid, percent, maxAmount) values (2, 0.2, 20);
insert into Percentage (pid, percent, maxAmount) values (3, 0.1, NULL);
insert into Flat (pid, flatAmount, minAmount) values (4, 5, NULL);
insert into Flat (pid, flatAmount, minAmount) values (5, 10, 30);

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

