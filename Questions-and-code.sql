/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/

SELECT first_name as manager_first_name, last_name, address as manager_last_name, district, city, country
FROM  staff 
LEFT JOIN address
ON address.address_id = staff.address_id
LEFT JOIN city
ON address.city_id = city.city_id
LEFT JOIN country
ON city.country_id = country.country_id
	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

SELECT
	inventory_id, store_id, film.title, film.rating, film.rental_rate, film.replacement_cost
FROM inventory
	INNER JOIN film ON film.film_id = inventory.film_id

/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/
SELECT
	rating, store_id,
    COUNT(inventory_id)
FROM inventory
	INNER JOIN film ON film.film_id = inventory.film_id
GROUP BY rating, store_id
ORDER BY store_id

/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/
SELECT
	store_id, category.name,
    COUNT(film.film_id),
    AVG(replacement_cost),
    SUM(replacement_cost)
FROM film
	INNER JOIN inventory ON inventory.film_id = film.film_id
    INNER JOIN film_category ON film_category.film_id = film.film_id
    INNER JOIN category ON category.category_id = film_category.category_id
GROUP BY store_id, category.name
ORDEr BY store_id

/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

SELECT first_name, last_name, customer_id, active as status, city.city, country.country
FROM customer
LEFT JOIN address 
ON customer.address_id = address.address_id
LEFT JOIN city
ON city.city_id = address.city_id
LEFT JOIN country
ON country.country_id = city.country_id

/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/
SELECT
		first_name, 
        last_name,
		COUNT(rental.rental_id) as lifetime_rental,
        SUM(payment.amount) as money_spent_$
FROM customer
LEFT JOIN rental ON rental.customer_id = customer.customer_id
LEFT JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY first_name, last_name
ORDER BY money_spent_$ DESC
   
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/
SELECT advisor.first_name, advisor.last_name, NULL as 'company_name', 'Advisor' as type
FROM advisor
UNION
SELECT investor.first_name, investor.last_name, company_name, 'Invesotr' as type
FROM investor

/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

SELECT
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 Awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Oscar, Tony','Emmy, Tony') THEN '2 Awards'
        ELSE '1 Awards'
	END AS Number_of_awards,
    AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS Percentage
    
FROM actor_award

GROUP BY 
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 Awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Oscar, Tony','Emmy, Tony') THEN '2 Awards'
        ELSE '1 Awards'
	END
