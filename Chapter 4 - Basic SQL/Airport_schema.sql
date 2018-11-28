-- Definition of AIRLINE database schema as shown in Figure 3.8 of
-- Fundamentals of Database Systems (Sixth Edition)
-- by Ramez Elmasri and Samakant B. Navathe

CREATE TABLE AIRPORT (
  Airport_code  CHAR(3)      NOT NULL,
  Name          VARCHAR(15)  NOT NULL,
  City          VARCHAR(15)  NOT NULL,
  State         CHAR(2)      NOT NULL,
  PRIMARY KEY(Airport_code)
);

CREATE TABLE FLIGHT (
  Flight_number VARCHAR(8)  NOT NULL,
  Airine        VARCHAR(15) NOT NULL,
  Weekdays      BOOLEAN,
  PRIMARY KEY(Flight_number)
);

CREATE TABLE FLIGHT_LEG (
  Flight_number           VARCHAR(8)  NOT NULL,
  Leg_number              INT         NOT NULL,
  Departure_airport_code  CHAR(3)     NOT NULL,
  Schedule_departure_time TIME        NOT NULL,
  Arrival_airport_code    CHAR(3)     NOT NULL,
  Schedule_arrival_time   TIME        NOT NULL,
  PRIMARY KEY(Flight_number,Leg_number),
  FOREIGN KEY(Flight_number) REFERENCES FLIGHT(Flight_number),
  FOREIGN KEY(Departure_airport_code) REFERENCES AIRPORT(Airport_code),
  FOREIGN KEY(Arrival_airport_code) REFERENCES AIRPORT(Airport_code)
);

CREATE TABLE LEG_INSTANCE (
  Flight_number             VARCHAR(8)  NOT NULL,
  Leg_number                INT         NOT NULL,
  Flight_Date               DATE        NOT NULL,
  Number_of_available_seats INT         NOT NULL,
  Airplane_id               VARCHAR(6)  NOT NULL,
  Departure_airport_code    CHAR(3)     NOT NULL,
  Departure_time            TIME        NOT NULL,
  Arrival_airport_code      CHAR(3)     NOT NULL,
  Arrival_time              TIME        NOT NULL,
  PRIMARY KEY(Flight_number,Leg_number,Flight_Date),
  FOREIGN KEY(Flight_number) REFERENCES FLIGHT(Flight_number),
  FOREIGN KEY(Leg_number) REFERENCES FLIGHT_LEG(Leg_number),
  FOREIGN KEY(Departure_airport_code) REFERENCES AIRPORT(Airport_code),
  FOREIGN KEY(Arrival_airport_code) REFERENCES AIRPORT(Airport_code)
);

CREATE TABLE FARE (
  Flight_number VARCHAR(8)  NOT NULL REFERENCES FLIGHT(Flight_number),
  Fare_Code     VARCHAR(8)  NOT NULL,
  Amount        REAL        NOT NULL,
  Restrictions  VARCHAR(100),
  PRIMARY KEY(Flight_number, Fare_Code)
);

CREATE TABLE AIRPLANE_TYPE (
  Airplane_type_name  VARCHAR(15) NOT NULL PRIMARY KEY,
  Max_seats           INT         NOT NULL,
  Company             VARCHAR(15) NOT NULL
);

CREATE TABLE CAN_LAND (
  Airplane_type_name  VARCHAR(15) NOT NULL REFERENCES AIRPLANE_TYPE(Airplane_type_name),
  Airport_code        VARCHAR(3)  NOT NULL REFERENCES AIRPORT(Airport_code),
  PRIMARY KEY(Airplane_type_name, Airport_code)
);

CREATE TABLE AIRPLANE (
  Airplane_id           VARCHAR(8)  NOT NULL PRIMARY KEY,
  Total_number_of_seats INT         NOT NULL,
  Airplane_type         VARCHAR(15) NOT NULL REFERENCES AIRPLANE_TYPE(Airplane_type_name)
);

CREATE TABLE SEAT_RESERVATION (
  Flight_number  VARCHAR(8)  NOT NULL REFERENCES FLIGHT(Flight_number),
  Leg_number     INT         NOT NULL REFERENCES FLIGHT_LEG(Leg_number),
  Flight_Date    DATE        NOT NULL REFERENCES LEG_INSTANCE(Flight_Date),
  Seat_number    VARCHAR(4)  NOT NULL,
  Customer_name  VARCHAR(30) NOT NULL,
  Customer_phone CHAR(10)    NOT NULL,
  PRIMARY KEY(Flight_number, Leg_number, Flight_Date, Seat_number)
);
