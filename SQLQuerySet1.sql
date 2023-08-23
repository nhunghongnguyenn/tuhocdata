-- Q1 who is the most senior employee base on job title?

select * from employee
order by levels desc;

-- Q2 which country have the most invoices?

select count(invoice_id) as number_of_invoices, billing_country
from invoice

group by billing_country
order by number_of_invoices desc;

-- Q3 what are top 3 values of total_invoice?

select * from invoice
order by total desc;

-- Q4 which city has the best customer? we would like to throw a promotional Music Festival in the city we made the most money wite a query that returns one city that has the highest sum of invoice totals.
--return both the city name & sum of all invoice totals?

select sum(total) as invoice_total, billing_city from invoice
group by billing_city
order by invoice_total desc;

-- Q5 who is the best customer? the customer who has spent the most money will be declared the best customer.write a query that return the person who spent the most money.
select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total
from customer
inner join invoice  on invoice.customer_id = customer.customer_id
group by customer.customer_id, customer.first_name, customer.last_name
order by total desc ;

--write query to return the email, first name, last name  & genre of all rock music listeners. return your list ordered alphabetically by email startin with A

select distinct first_name, last_name, email 
from customer
inner join invoice on invoice.customer_id = customer.customer_id
inner join invoice_line on invoice_line.invoice_id = invoice.invoice_id
where track_id in
		(select track_id from track
		inner join genre on genre.genre_id = track.genre_id
		where genre.name like '%Rock%')
order by email;

-- let's invite artists who have written the most rock music in our dataset. 
--write a query that return the artist name and total track count of the top 10 rock bands
select artist.artist_id, artist.name, count(artist.artist_id) AS number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id= track.genre_id
where genre.name like 'Rock'
group by artist.name
order by number_of_songs desc;

--return all the track names that have a song length longer than the average song length.
--return the name and each track. order by the song length with the longest first.

select name, milliseconds 
from track
where milliseconds >
		(select AVG(milliseconds) as average_song_length
		from track)
order by milliseconds desc;

--SET 3 ADVANCE
---	find how much amount spent by each customers on artists? write a query to show customer name, artist name and total spend

with best_selling_artist as
	(select artist.artist_id as artist_id, artist.name as name, sum(invoice_line.quantity*invoice_line.unit_price)
	from invoice_line
	join track on track.track_id = invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by 1
	order by 3 desc
	)
select c.customer_id,c.first_name, c.last_name, bsa.name
from invoice i
join customer c on c.customer_id = i.customer_id 
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 3 desc;
