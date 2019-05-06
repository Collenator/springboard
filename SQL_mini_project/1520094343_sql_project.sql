/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

Facilities_id_charge_members = 0, 1, 4, 5, 6

#code:
SELECT facid, membercost
FROM  `Facilities`
WHERE membercost IS NOT NULL
AND membercost >0
ORDER BY membercost
LIMIT 0 , 30


/* Q2: How many facilities do not charge a fee to members? */

Facilities_id_charge_members = 2, 3, 7, 8

#code:
SELECT facid, membercost
FROM  `Facilities`
WHERE membercost IS NULL
OR membercost =0
ORDER BY membercost
LIMIT 0 , 30

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

#code
SELECT facid, membercost, monthlymaintenance
FROM  `Facilities`
WHERE membercost >0
AND membercost < ( .2 * monthlymaintenance )
ORDER BY membercost
LIMIT 0 , 30


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT *
FROM  `Facilities`
WHERE facid
IN ( 1, 5 )
LIMIT 0 , 30

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, CASE WHEN monthlymaintenance >100
THEN  'expensive'
ELSE  'cheap'
END AS maintenance
FROM  `Facilities`
LIMIT 0 , 30

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT joindate, firstname, surname
FROM  `Members`
WHERE joindate
BETWEEN  '2012-09-01'
AND  '2012-09-30'
ORDER BY joindate DESC
LIMIT 0 , 30

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT f.name, CONCAT( m.firstname,  ' ', m.surname ) AS mem_name
FROM  `Bookings` b
JOIN  `Members` m ON m.memid = b.memid
JOIN  `Facilities` f ON b.facid = f.facid
HAVING f.name LIKE  '%Tennis Court%'
ORDER BY mem_name
LIMIT 0 , 30


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT f.name,
m.firstname,
m.surname,
f.membercost,
f.guestcost,
f.membercost + f.guestcost AS total_cost
FROM `Bookings` b
JOIN `Members` m ON m.memid = b.memid
JOIN `Facilities` f ON b.facid = f.facid
WHERE b.starttime
BETWEEN  '2012-09-14'
AND  '2012-09-15'
AND (f.membercost > 30 OR f.guestcost >30 )
ORDER BY total_cost DESC
LIMIT 0 , 30


/* Q9: This time, produce the same result as in Q8, but using a subquery. */


SELECT CONCAT( firstname,  ' ', surname ) AS member, name AS facility, cost
FROM (

      SELECT firstname, surname, name,
      CASE WHEN firstname =  'GUEST'
      THEN guestcost * slots
      ELSE membercost * slots
      END AS cost, starttime
      FROM  `Bookings` b
      JOIN  `Members` m ON m.memid = b.memid
      JOIN  `Facilities` f ON b.facid = f.facid
      ) AS inner_table
WHERE starttime >=  '2012-09-14'
AND starttime <  '2012-09-15'
AND cost >30
ORDER BY cost DESC


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT name, SUM( guestcost + membercost ) AS revenue
FROM  `Facilities`
GROUP BY name
HAVING revenue <1000
ORDER BY revenue
LIMIT 0 , 30
