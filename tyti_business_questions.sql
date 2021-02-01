use _team10_airbnb2;

-- 1. Where/group by, join: Which department does the employee with ID 477112021 work for? 

select 
	departmentName, 
    employeeID
from 
	departments d
	join 
		employees e using(departmentID)
where employeeID = 477112021;
# They work for the marketing department. 

-- 2. Where/group by, join: How many support tickets were submitted in the month of December, 2011 for the Customer Service department? 
select 
	monthname(ticket_date) Month,
    year(ticket_date) Year,
	count(distinct(ticketID)) ticketCount,
    departmentName
from 
	servicerequests
	join services s using (ticketID)
	join employees using(serviceID)
	join departments using(departmentID)	
where  
	year(ticket_date) = 2011
and
	departmentName = 'Customer Service'
and
	monthname(ticket_date) = 'January'
group by 
	year(ticket_date);
# 2 Support tickets were submitted in December of 2011 in the Customer Service Department


-- 3. Where: Which owner(s) use emails which are from a university domain? (Hint: University domains end with .edu
select
	renter_firstName 'First Name', 
    renter_lastName 'Last Name',
    email,
    SUBSTRING(email, LOCATE('@', email) + 1) domain
from
	renters
where
	SUBSTRING(email, LOCATE('@', email) + 1) LIKE '%.edu';
# This output is useful to find which users work at schools, critically important to verifying promotional discounts, and finding location data on customers. 

-- 4. Subquery, window function, ranking: Which departments have the most employees? Rank each department by number of employees. Only include the top two. 
select
	departmentName, 
    count(employeeID) employees
from departments 
	join employees using(departmentID)
group by departmentID
order by employees desc
limit 2;

# 5. What is the longest time between any stay in each country?
with rankedlag as (
select 
	country_name,
    # count(p.propertyID) stays,
lag(bookingdate, 1) over (
	partition by r.countryID
	order by bookingDate) prevBooking,
(datediff(bookingDate, (lag(bookingDate, 1) over (
	partition by r.countryID
	order by bookingDate)))) bookingLag
from properties p
	join bookings b using(propertyID)
	join renters r using(renterID)
    join countries c on r.countryID = c.countryID
order by bookingLag desc, c.country_name)
select 
	country_name, 
    avg(bookinglag) avgDaysBtStays
from rankedlag
group by country_name
order by avgDaysBtStays desc;


