SELECT * FROM customer limit 10;

SELECT gender,SUM(purchase_amount) as total_revenue
FROM customer
GROUP BY gender;


SELECT customer_id,purchase_amount
FROM customer
WHERE discount_applied ="yes" and purchase_amount >= (SELECT AVG(purchase_amount) FROM customer);


SELECT item_purchased,AVG(review_rating)
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;


SELECT shipping_type,ROUND(AVG(purchase_amount),2)
FROM customer 
WHERE shipping_type IN ("Standard","EXPRESS")
GROUP BY shipping_type;


SELECT subscription_status, COUNT(customer_id) as total_customer,
ROUND(AVG(purchase_amount),2) as spent,SUM(purchase_amount) AS revenue
FROM customer
GROUP BY subscription_status;


SELECT item_purchased,
ROUND(100* SUM(CASE WHEN discount_applied ="yes" THEN 1 ELSE 0 END)/COUNT(*) ,2) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;


WITH customer_type AS (SELECT customer_id,previous_purchases,
CASE WHEN previous_purchases=1 THEN "NEW"
     WHEN previous_purchases >1 AND previous_purchases < 10 THEN "RETURNING"
     WHEN previous_purchases >=10 THEN "LOYAL"
     END AS customer_segment
FROM customer)
SELECT customer_segment,COUNT(*) AS number_of_customers
FROM customer_type
GROUP BY customer_segment;


WITH ranking AS(SELECT item_purchased,category,COUNT(customer_id) AS total_orders,
ROW_NUMBER() OVER(PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
FROM customer
GROUP BY item_purchased,category)
SELECT item_purchased,category,item_rank
FROM ranking 
WHERE item_rank <=3;


SELECT age_group, SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC

