use music_store;

/*	Question Set 1 - Easy */

/* Q1: Who is the senior most employee based on job title? */

select title,first_name,last_name from employee order by title desc limit 1;

/* Q2: Which countries have the most Invoices? */

select count(*),billing_country from invoice group by billing_country order by count(*) desc;

/* Q3: What are top 3 values of total invoice? */

select * from invoice order by total desc limit 3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select billing_city,sum(total) from invoice group by billing_city order by sum(total) desc limit 1;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT customer.customer_id,customer.first_name,customer.last_name,sum(invoice.total) 
from customer,invoice where customer.customer_id=invoice.customer_id 
group by customer.customer_id,customer.first_name,customer.last_name order by sum(invoice.total) desc limit 1;

/* Question Set 2 - Moderate & Advance*/

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

select customer.first_name,customer.last_name,customer.email,genre.name 
from customer,invoice,invoice_line,track,genre 
where customer.customer_id=invoice.customer_id and
invoice.invoice_id=invoice_line.invoice_id and
invoice_line.track_id=track.track_id and
track.genre_id=genre.genre_id and
genre.name="rock"
order by customer.email;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select artist.name,count(track.track_id) from artist
join album2 on artist.artist_id=album2.artist_id
join track on track.album_id=album2.album_id
join genre on genre.genre_id=track.genre_id
where genre.name like "rock"
group by 1
order by count(track.track_id) desc limit 10;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name,milliseconds from track 
where milliseconds>(select avg(milliseconds)from track)
order by milliseconds desc limit 1;

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */

select customer.first_name,artist.name,sum(invoice_line.quantity*invoice_line.unit_price) 
from customer,invoice,invoice_line,track,album2,artist
where customer.customer_id=invoice.customer_id and 
invoice.invoice_id=invoice_line.invoice_id and 
invoice_line.track_id=track.track_id and
track.album_id=album2.album_id and 
album2.artist_id=artist.artist_id 
group by customer.first_name,artist.name 
order by sum(invoice_line.quantity*invoice_line.unit_price) desc;