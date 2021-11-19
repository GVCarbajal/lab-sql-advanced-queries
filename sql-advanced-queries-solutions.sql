-- List each pair of actors that have worked together.

with actor_film_ids as(
	select a.actor_id, a.first_name, a.last_name, f.film_id, p.title from actor a
	join film_actor f on a.actor_id = f.actor_id
    join film p on f.film_id = p.film_id
    )
select distinct t1.first_name name_actor1, t1.last_name surname_actor1, 
t1.title co_starred_film,
t2.first_name name_actor2, t2.last_name surname_actor2 
from actor_film_ids t1
join actor_film_ids t2 on t1.film_id = t2.film_id and t1.actor_id > t2.actor_id;


-- For each film, list actor that has acted in more films.

with ranking as (
	select film_id, actor_id, count(film_id) starred_films, 
	rank() over (partition by film_id order by count(film_id) desc) as ranks
	from film_actor
	group by actor_id
    )
select title, first_name, last_name, starred_films from ranking r
join actor a on r.actor_id = a.actor_id
join film f on r.film_id = f.film_id
where ranks = 1;