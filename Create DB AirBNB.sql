drop database if exists _team10_airbnb2;
create database if not exists _team10_airbnb2; 
use _team10_airbnb2;


-- Employees --
#services provided by airbnb i.e. cleaners, support teams, 
# drop table if exists serviceRequests;
create table if not exists serviceRequests(
	ticketID bigint not null,
	ticket_date DATE not null,
    primary key(ticketID)
);

# drop table if exists services;
create table if not exists services (
	serviceID bigint not null,
    ticketID bigint null default null,
    description varchar(100) null default null,
    primary key(serviceID),

constraint FK_services_has_serviceRequests_ticketID
	foreign key(ticketID)
    references serviceRequests (ticketID)
);
# drop table if exists departments;
create table if not exists departments(
	departmentID bigint not null,
    departmentName varchar(45) not null,
	primary key(departmentID) 
); 
# drop table if exists employees;
create table if not exists employees (
	employeeID bigint not null,
    ownerID bigint null default null,
    serviceID bigint null default null,
    departmentID bigint null default null,
    primary key(employeeID),

constraint FK_employees_has_departments_departmentID
	foreign key(departmentID)
    references departments (departmentID),
constraint FK_employees_has_services_serviceID
	foreign key(serviceID) 
    references services (serviceID)
);
-- Owners --
drop table if exists countries;
create table if not exists countries (
	countryID varchar(2),
    country_name varchar(45), 
    primary key(countryID)
);
# drop table if exists properties;
create table if not exists properties (
	propertyID bigint not null,
    ownerID bigint null default null,
    countryID varchar(2) default null,
    primary key(propertyID),
constraint FK_properties_has_countries_countryID
	foreign key(countryID)
    references countries (countryID)
);
# drop table if exists ownerReviews;
create table if not exists ownerReviews(
	ownerReviewID bigint not null,
	ownerReview_Date DATE not null,
    primary key(ownerReviewID)
);

# drop table if exists owners;
create table if not exists owners (
	ownerID bigint not null,
    firstName varchar(45) not null,
    lastName varchar(45) not null,
    propertyID bigint null default null,
    email varchar(45) not null,
    primary key(ownerID),

constraint FK_owners_has_properties_propertyID
	foreign key(propertyID)
    references properties (propertyID),
constraint FK_owners_has_ownerReviews_ownerReviewID
	foreign key(ownerID)
    references ownerReviews (ownerReviewID)
);

-- Renters --
#drop table if exists renterReviews;
create table if not exists renterReviews(
	renterReviewID bigint not null,
    renterReview_Date DATE not null,
    stars bigint not null,
    primary key(renterReviewID)
);
	
# drop table if exists renters;
create table if not exists renters (
	renterID bigint not null,
    renterReviewID bigint null default null,
    countryID varchar(2) null default null,
    renter_firstName varchar(45) not null,
    renter_lastName varchar(45) not null,
    email varchar(45) not null,
    primary key(renterID),

constraint FK_renters_has_renterReviews_renterReviewID
	foreign key(renterReviewID)
    references renterReviews (renterReviewID),
constraint FK_renters_has_countries_countryID
	foreign key(countryID)
    references countries (countryID)
);

-- Bookings -- 

# drop table if exists bookings;
create table if not exists bookings (
	bookingID bigint not null,
    bookingdate date, 
    employeeID bigint null default null,
    ownerID bigint not null,
    renterID bigint not null,
    propertyID bigint null default null,
    price_per_night decimal,
    number_of_nights int,
	primary key(bookingID),
constraint FK_bookings_has_employees_employeeID
	foreign key(employeeID)
    references employees (employeeID),
constraint FK_bookings_has_owners_ownerID
	foreign key(ownerID)
    references owners (ownerID),
constraint FK_bookings_has_renters_renterID
	foreign key(renterID)
    references renters (renterID),
constraint FK_bookings_has_properties_propertyID
	foreign key (propertyID)
    references properties (propertyID)
);

