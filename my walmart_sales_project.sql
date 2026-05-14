select * from walmart_sales

select payment_method,count(*) from walmart_sales
group by payment_method

select count(distinct branch) from walmart_sales
-- bussiness problem 
-- What are the different payment methods, and how many transactions and items were sold with each method?
select payment_method,count(*) from walmart_sales
group by payment_method

-- Which category received the highest average rating in each branch?
select branch, category, avg(rating) as avg_rating, rank() over(partition by branch order by avg(rating) desc) from walmart_sales
group by branch, category
order by branch, avg(rating) desc

--  What is the busiest day of the week for each branch based on transaction volume?
SELECT branch,
       day_name,
       total_transactions
FROM (
    SELECT branch,
           TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') AS day_name,
           COUNT(*) AS total_transactions,
           RANK() OVER(
               PARTITION BY branch
               ORDER BY COUNT(*) DESC
           ) AS rank
    FROM walmart_sales
    GROUP BY branch, day_name
) t
WHERE rank = 1;

-- How many items were sold through each payment method?
select distinct payment_method, count(*),sum(quantity) as quantity_sold  from walmart_sales
group by payment_method

--What are the average, minimum, and maximum ratings for each category in each city?
select  distinct city,category,avg(rating) as avg_rating,min(rating) as min_rating,max(rating) as max_rating from walmart_sales
group by 1,2

-- What is the total profit for each category, ranked from highest to lowest?
select distinct category, sum(total) as total_revenue,sum(profit_margin*total) as profit from walmart_sales
group by 1
order by sum(profit_margin*total) desc

-- What is the most frequently used payment method in each branch?
select branch,payment_method, count(*) as no, 
rank()over(partition by branch order by count(*) desc) as rank from walmart_sales
group by 1,2

-- How many transactions occur in each shift (Morning, Afternoon, Evening) across branches?
SELECT branch,
       shift,
       COUNT(*) AS total_transactions
FROM (
    SELECT branch,
           CASE
               WHEN EXTRACT(HOUR FROM time::time) < 12
                    THEN 'Morning'

               WHEN EXTRACT(HOUR FROM time::time) BETWEEN 12 AND 17
                    THEN 'Afternoon'

               ELSE 'Evening'
           END AS shift
    FROM walmart_sales
) t
GROUP BY branch, shift
ORDER BY branch, total_transactions DESC;

-- Which branches experienced the largest decrease in revenue compared to the previous year?
WITH yearly_revenue AS (

    SELECT branch,
           EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) AS year,
           SUM(unit_price * quantity) AS revenue
    FROM walmart_sales
    GROUP BY branch, year
),

revenue_diff AS (

    SELECT branch,
           year,
           revenue,
           LAG(revenue) OVER(
               PARTITION BY branch
               ORDER BY year
           ) AS previous_year_revenue
    FROM yearly_revenue
)

SELECT branch,
       year,
       revenue,
       previous_year_revenue,
       (revenue - previous_year_revenue) AS revenue_change
FROM revenue_diff
WHERE revenue < previous_year_revenue
ORDER BY revenue_change ASC;


select * from walmart_sales





























