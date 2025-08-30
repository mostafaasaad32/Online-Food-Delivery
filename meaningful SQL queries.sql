USE Online_Food_Delivery;

-- 1. Order the orders by price (highest first)
SELECT r.restaurant_id, r.restaurant_name, r.cuisine_type, o.total_price
FROM Restaurants r
JOIN Orders o ON o.restaurant_id = r.restaurant_id
ORDER BY o.total_price DESC;


-- 2. Top 10 rated restaurants (by average rating)
SELECT TOP (10) r.restaurant_name, AVG(rev.rating) AS avg_rating
FROM Restaurants r
JOIN Reviews rev ON rev.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
ORDER BY avg_rating DESC;


-- 3. Bottom 10 rated restaurants (by average rating)
SELECT TOP (10) r.restaurant_name, AVG(rev.rating) AS avg_rating
FROM Restaurants r
JOIN Reviews rev ON rev.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_name
ORDER BY avg_rating ASC;


-- 4. Top 10 restaurants by number of orders
SELECT TOP (10) r.restaurant_name, COUNT(o.order_id) AS total_number_of_orders
FROM Orders o
JOIN Restaurants r ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name
ORDER BY COUNT(o.order_id) DESC;


-- 5. Most ordered cuisine type
SELECT r.cuisine_type, COUNT(o.order_id) AS total_count
FROM Restaurants r
JOIN Orders o ON o.restaurant_id = r.restaurant_id
GROUP BY r.cuisine_type
ORDER BY total_count DESC;


-- 6. Most expensive dish for every restaurant
SELECT r.restaurant_name, m.item_name, MAX(od.item_price) AS most_expensive_dish
FROM MenuItems m
JOIN Restaurants r ON r.restaurant_id = m.restaurant_id
JOIN OrderDetails od ON od.item_id = m.item_id
GROUP BY r.restaurant_name, m.item_name
ORDER BY MAX(od.item_price) DESC;


-- 7. Average order value (per restaurant)
SELECT r.restaurant_name, AVG(o.total_price) AS avg_order_value
FROM Restaurants r
JOIN Orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name
ORDER BY avg_order_value DESC;


-- 8. Top 5 customers by number of orders
SELECT TOP (5) CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY total_orders DESC;


-- 9. Top 10 customer addresses by number of orders
SELECT TOP (10) c.address, COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.address
ORDER BY total_orders DESC;


-- 10. Top restaurants with the best (fastest) average delivery time
SELECT r.restaurant_id, r.restaurant_name,
       AVG(DATEDIFF(MINUTE, da.assigned_time, da.delivered_time)) AS avg_delivery_time_minutes
FROM Restaurants r
JOIN Orders o ON o.restaurant_id = r.restaurant_id
JOIN DeliveryAssignments da ON da.order_id = o.order_id
WHERE da.delivery_status = 'Delivered'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY avg_delivery_time_minutes ASC;


-- 11. Top 5 restaurants by total revenue
SELECT TOP (5) r.restaurant_id, r.restaurant_name, SUM(o.total_price) AS total_revenue
FROM Restaurants r
JOIN Orders o ON o.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY total_revenue DESC;


-- 12. Most popular day of the week for orders
SELECT DATENAME(WEEKDAY, o.order_date) AS order_day,
       COUNT(o.order_id) AS total_orders
FROM Orders o
GROUP BY DATENAME(WEEKDAY, o.order_date)
ORDER BY total_orders DESC;
