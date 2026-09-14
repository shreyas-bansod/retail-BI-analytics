USE retail_bi;


-- =========================================================
-- RETAIL BI ANALYSIS
-- SECTION 1: EXECUTIVE KPIs
-- =========================================================


-- 1. Total Customers

SELECT
    COUNT(*) AS total_customers
FROM customers;


-- 2. Total Orders

SELECT
    COUNT(*) AS total_orders
FROM orders;


-- 3. Total Products

SELECT
    COUNT(*) AS total_products
FROM products;


-- 4. Total Categories

SELECT
    COUNT(*) AS total_categories
FROM categories;


-- 5. Total Items Sold

SELECT
    SUM(quantity) AS total_items_sold
FROM order_items;


-- 6. Total Revenue

SELECT
    ROUND(SUM(revenue), 2) AS total_revenue
FROM order_items;


-- 7. Total Profit

SELECT
    ROUND(SUM(profit), 2) AS total_profit
FROM order_items;


-- 8. Average Order Value

SELECT
    ROUND(
        SUM(revenue) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items;


-- 9. Average Profit Margin

SELECT
    ROUND(
        SUM(profit) / SUM(revenue) * 100,
        2
    ) AS average_profit_margin;


-- 10. Total Returns

SELECT
    COUNT(*) AS total_returns
FROM returns;


-- 11. Total Refund Amount

SELECT
    ROUND(SUM(refund_amount), 2) AS total_refund_amount
FROM returns;

-- =========================================================
-- SECTION 2: SALES PERFORMANCE ANALYSIS
-- =========================================================


-- 12. Revenue by Month

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(oi.revenue), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;


-- 13. Profit by Month

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(oi.profit), 2) AS profit
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;


-- 14. Orders by Month

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;


-- 15. Revenue by Order Status

SELECT
    o.status,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.revenue), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.status
ORDER BY revenue DESC;


-- 16. Revenue by Category

SELECT
    c.category_name,
    ROUND(SUM(oi.revenue), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY revenue DESC;


-- 17. Profit by Category

SELECT
    c.category_name,
    ROUND(SUM(oi.revenue), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.revenue), 0) * 100,
        2
    ) AS profit_margin
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY profit DESC;


-- 18. Top 10 Products by Revenue

SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.revenue), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 10;


-- 19. Top 10 Products by Profit

SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.profit), 2) AS profit
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY profit DESC
LIMIT 10;


-- 20. Top 10 Customers by Revenue

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.revenue), 2) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, customer_name
ORDER BY revenue DESC
LIMIT 10;

-- =========================================================
-- SECTION 3: CUSTOMER ANALYSIS
-- =========================================================


-- 21. Customers by State

SELECT
    state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY state
ORDER BY total_customers DESC;


-- 22. Revenue by State

SELECT
    c.state,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.revenue), 2) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.state
ORDER BY revenue DESC;


-- 23. Average Customer Spending

SELECT
    ROUND(
        SUM(oi.revenue) / COUNT(DISTINCT c.customer_id),
        2
    ) AS average_customer_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id;


-- 24. Customer Order Frequency

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_orders DESC
LIMIT 20;


-- 25. Top 20 Customers by Spending

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.revenue), 2) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spending DESC
LIMIT 20;


-- 26. Customer Revenue Segments

SELECT
    CASE
        WHEN total_spending >= 100000 THEN 'High Value'
        WHEN total_spending >= 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(*) AS customers,
    ROUND(SUM(total_spending), 2) AS revenue
FROM
(
    SELECT
        c.customer_id,
        SUM(oi.revenue) AS total_spending
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id
) customer_sales
GROUP BY customer_segment
ORDER BY revenue DESC;


-- 27. Customers with the Most Orders

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.revenue), 2) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, customer_name
ORDER BY total_orders DESC
LIMIT 10;


-- 28. Customers Who Have Never Ordered

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    c.state
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;


-- 29. Average Orders per Customer

SELECT
    ROUND(
        COUNT(DISTINCT o.order_id) /
        COUNT(DISTINCT c.customer_id),
        2
    ) AS average_orders_per_customer
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;


-- 30. Revenue by Gender

SELECT
    c.gender,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.revenue), 2) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.gender
ORDER BY revenue DESC;
-- =========================================================
-- RETAIL BI PROJECT
-- SECTION 3 — CUSTOMER ANALYSIS
-- =========================================================

USE retail_bi;


-- =========================================================
-- Q1. How many customers are there?
-- =========================================================

SELECT
    COUNT(*) AS total_customers
FROM customers;


-- =========================================================
-- Q2. How many customers are there in each state?
-- =========================================================

SELECT
    state,
    COUNT(*) AS customer_count
FROM customers
GROUP BY state
ORDER BY customer_count DESC;


-- =========================================================
-- Q3. What are the top 10 cities by number of customers?
-- =========================================================

SELECT
    city,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC
LIMIT 10;


-- =========================================================
-- Q4. How many new customers joined each year?
-- =========================================================

SELECT
    YEAR(join_date) AS join_year,
    COUNT(*) AS new_customers
FROM customers
GROUP BY YEAR(join_date)
ORDER BY join_year;


-- =========================================================
-- Q5. What is the average age of customers?
-- =========================================================

SELECT
    ROUND(
        AVG(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())),
        1
    ) AS average_customer_age
FROM customers;


-- =========================================================
-- Q6. Which customers have placed the most orders?
-- =========================================================

SELECT
    c.customer_id,
    c.city,
    c.state,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.city,
    c.state
ORDER BY total_orders DESC
LIMIT 10;


-- =========================================================
-- Q7. Which customers have spent the most money?
-- =========================================================

SELECT
    c.customer_id,
    c.city,
    c.state,
    ROUND(SUM(oi.revenue), 2) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.city,
    c.state
ORDER BY total_spent DESC
LIMIT 10;


-- =========================================================
-- Q8. What is the Average Order Value (AOV)?
-- =========================================================

SELECT
    ROUND(
        SUM(oi.revenue) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;


-- =========================================================
-- Q9. How many orders does the average customer place?
-- =========================================================

SELECT
    ROUND(
        COUNT(o.order_id) / COUNT(DISTINCT c.customer_id),
        2
    ) AS average_orders_per_customer
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id;


-- =========================================================
-- Q10. How many repeat customers are there?
-- Repeat customer = customer with more than 1 order
-- =========================================================

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) AS customer_orders;


-- =========================================================
-- Q11. How many one-time customers are there?
-- =========================================================

SELECT
    COUNT(*) AS one_time_customers
FROM (
    SELECT
        customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) = 1
) AS customer_orders;


-- =========================================================
-- Q12. What percentage of customers are repeat customers?
-- =========================================================

SELECT
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(DISTINCT customer_id) FROM orders),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) AS repeat_customers;


-- =========================================================
-- Q13. Which customers purchased the highest quantity of products?
-- =========================================================

SELECT
    o.customer_id,
    SUM(oi.quantity) AS total_quantity_purchased
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_quantity_purchased DESC
LIMIT 10;


-- =========================================================
-- Q14. Which customers generate the highest profit?
-- =========================================================

SELECT
    c.customer_id,
    c.city,
    c.state,
    ROUND(SUM(oi.profit), 2) AS total_profit
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.city,
    c.state
ORDER BY total_profit DESC
LIMIT 10;


-- =========================================================
-- Q15. How can customers be segmented based on spending?
-- High Value   = 50,000+
-- Medium Value = 20,000–49,999
-- Low Value    = Below 20,000
-- =========================================================

SELECT
    customer_id,
    ROUND(total_spent, 2) AS total_spent,
    CASE
        WHEN total_spent >= 50000 THEN 'High Value'
        WHEN total_spent >= 20000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM (
    SELECT
        o.customer_id,
        SUM(oi.revenue) AS total_spent
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) AS customer_spending
ORDER BY total_spent DESC;


-- =========================================================
-- Q16. How many customers belong to each spending segment?
-- =========================================================

SELECT
    customer_segment,
    COUNT(*) AS customer_count
FROM (
    SELECT
        customer_id,
        CASE
            WHEN total_spent >= 50000 THEN 'High Value'
            WHEN total_spent >= 20000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM (
        SELECT
            o.customer_id,
            SUM(oi.revenue) AS total_spent
        FROM orders o
        JOIN order_items oi
            ON o.order_id = oi.order_id
        GROUP BY o.customer_id
    ) AS spending
) AS segments
GROUP BY customer_segment
ORDER BY customer_count DESC;


-- =========================================================
-- Q17. Which states generate the highest customer revenue?
-- =========================================================

SELECT
    c.state,
    ROUND(SUM(oi.revenue), 2) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.state
ORDER BY total_revenue DESC;


-- =========================================================
-- Q18. Which cities generate the highest customer revenue?
-- =========================================================

SELECT
    c.city,
    ROUND(SUM(oi.revenue), 2) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.city
ORDER BY total_revenue DESC
LIMIT 10;


-- =========================================================
-- END OF SECTION 3
-- CUSTOMER ANALYSIS
-- =========================================================

-- =========================================================
-- RETAIL BI PROJECT
-- SECTION 4 — PRODUCT ANALYSIS
-- =========================================================

USE retail_bi;


-- =========================================================
-- Q1. How many products are there?
-- =========================================================

SELECT
    COUNT(*) AS total_products
FROM products;


-- =========================================================
-- Q2. How many products are there in each category?
-- =========================================================

SELECT
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM products p
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY product_count DESC;


-- =========================================================
-- Q3. What are the top 10 best-selling products by quantity?
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- =========================================================
-- Q4. What are the top 10 products by revenue?
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.revenue), 2) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC
LIMIT 10;


-- =========================================================
-- Q5. What are the top 10 products by profit?
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.profit), 2) AS total_profit
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_profit DESC
LIMIT 10;


-- =========================================================
-- Q6. Which categories generate the highest revenue?
-- =========================================================

SELECT
    c.category_name,
    ROUND(SUM(oi.revenue), 2) AS total_revenue
FROM categories c
JOIN products p
    ON c.category_id = p.category_id
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;


-- =========================================================
-- Q7. Which categories generate the highest profit?
-- =========================================================

SELECT
    c.category_name,
    ROUND(SUM(oi.profit), 2) AS total_profit
FROM categories c
JOIN products p
    ON c.category_id = p.category_id
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY total_profit DESC;


-- =========================================================
-- Q8. What is the average profit margin for each category?
-- =========================================================

SELECT
    c.category_name,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.revenue), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM categories c
JOIN products p
    ON c.category_id = p.category_id
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY profit_margin_percentage DESC;


-- =========================================================
-- Q9. Which products have the highest profit margin?
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.revenue), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
HAVING SUM(oi.revenue) > 0
ORDER BY profit_margin_percentage DESC
LIMIT 10;


-- =========================================================
-- Q10. Which products have the lowest profit margin?
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.revenue), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
HAVING SUM(oi.revenue) > 0
ORDER BY profit_margin_percentage ASC
LIMIT 10;


-- =========================================================
-- Q11. Which products are currently low in stock?
-- =========================================================

SELECT
    product_id,
    product_name,
    stock_quantity
FROM products
WHERE stock_quantity < 20
ORDER BY stock_quantity ASC;


-- =========================================================
-- Q12. Which products have the highest stock levels?
-- =========================================================

SELECT
    product_id,
    product_name,
    stock_quantity
FROM products
ORDER BY stock_quantity DESC
LIMIT 10;


-- =========================================================
-- Q13. Which categories sell the highest quantity of products?
-- =========================================================

SELECT
    c.category_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM categories c
JOIN products p
    ON c.category_id = p.category_id
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY total_quantity_sold DESC;


-- =========================================================
-- Q14. Which category has the highest average product selling price?
-- =========================================================

SELECT
    c.category_name,
    ROUND(AVG(p.selling_price), 2) AS average_selling_price
FROM categories c
JOIN products p
    ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY average_selling_price DESC;


-- =========================================================
-- Q15. Which suppliers provide the most products?
-- =========================================================

SELECT
    s.supplier_id,
    s.supplier_name,
    COUNT(p.product_id) AS product_count
FROM suppliers s
JOIN products p
    ON s.supplier_id = p.supplier_id
GROUP BY
    s.supplier_id,
    s.supplier_name
ORDER BY product_count DESC
LIMIT 10;


-- =========================================================
-- Q16. Which suppliers generate the highest revenue?
-- =========================================================

SELECT
    s.supplier_id,
    s.supplier_name,
    ROUND(SUM(oi.revenue), 2) AS total_revenue
FROM suppliers s
JOIN products p
    ON s.supplier_id = p.supplier_id
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    s.supplier_id,
    s.supplier_name
ORDER BY total_revenue DESC
LIMIT 10;


-- =========================================================
-- Q17. Which products have high sales but low stock?
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    p.stock_quantity
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.stock_quantity
HAVING p.stock_quantity < 20
ORDER BY total_quantity_sold DESC;


-- =========================================================
-- Q18. Which categories have the highest number of products?
-- =========================================================

SELECT
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM categories c
JOIN products p
    ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY product_count DESC;


-- =========================================================
-- Q19. What is the average discount given by category?
-- =========================================================

SELECT
    c.category_name,
    ROUND(AVG(oi.discount), 2) AS average_discount
FROM categories c
JOIN products p
    ON c.category_id = p.category_id
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY average_discount DESC;


-- =========================================================
-- Q20. Which categories have the highest total profit margin?
-- =========================================================

SELECT
    c.category_name,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.revenue), 0) * 100,
        2
    ) AS profit_margin_percentage,
    ROUND(SUM(oi.revenue), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit
FROM categories c
JOIN products p
    ON c.category_id = p.category_id
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY profit_margin_percentage DESC;


-- =========================================================
-- END OF SECTION 4
-- PRODUCT ANALYSIS
-- =========================================================

-- =========================================================
-- RETAIL BI PROJECT
-- SECTION 5 — SALES & REVENUE ANALYSIS
-- =========================================================

USE retail_bi;


-- =========================================================
-- Q1. How many total orders are there?
-- =========================================================

SELECT
    COUNT(*) AS total_orders
FROM orders;


-- =========================================================
-- Q2. What is the total revenue?
-- =========================================================

SELECT
    ROUND(SUM(revenue), 2) AS total_revenue
FROM order_items;


-- =========================================================
-- Q3. What is the total profit?
-- =========================================================

SELECT
    ROUND(SUM(profit), 2) AS total_profit
FROM order_items;


-- =========================================================
-- Q4. What is the overall profit margin?
-- =========================================================

SELECT
    ROUND(
        SUM(profit) / NULLIF(SUM(revenue), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM order_items;


-- =========================================================
-- Q5. What is the Average Order Value (AOV)?
-- =========================================================

SELECT
    ROUND(
        SUM(oi.revenue) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;


-- =========================================================
-- Q6. How many orders are there each month?
-- =========================================================

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;


-- =========================================================
-- Q7. What is the monthly revenue?
-- =========================================================

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(oi.revenue), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;


-- =========================================================
-- Q8. What is the monthly profit?
-- =========================================================

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(oi.profit), 2) AS monthly_profit
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;


-- =========================================================
-- Q9. What is the yearly revenue?
-- =========================================================

SELECT
    YEAR(o.order_date) AS year,
    ROUND(SUM(oi.revenue), 2) AS yearly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date)
ORDER BY year;


-- =========================================================
-- Q10. What is the yearly profit?
-- =========================================================

SELECT
    YEAR(o.order_date) AS year,
    ROUND(SUM(oi.profit), 2) AS yearly_profit
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_date)
ORDER BY year;


-- =========================================================
-- Q11. Which month generated the highest revenue?
-- =========================================================

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(oi.revenue), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY monthly_revenue DESC
LIMIT 1;


-- =========================================================
-- Q12. Which month generated the highest profit?
-- =========================================================

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(oi.profit), 2) AS monthly_profit
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY monthly_profit DESC
LIMIT 1;


-- =========================================================
-- Q13. What is the revenue by order status?
-- =========================================================

SELECT
    o.status AS order_status,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.revenue), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.status
ORDER BY total_revenue DESC;


-- =========================================================
-- Q14. What is the number of orders by order status?
-- =========================================================

SELECT
    status AS order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;


-- =========================================================
-- Q15. What is the revenue generated by each payment method?
-- =========================================================

SELECT
    p.payment_method,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.revenue), 2) AS total_revenue
FROM orders o
JOIN payments p
    ON o.payment_id = p.payment_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY p.payment_method
ORDER BY total_revenue DESC;


-- =========================================================
-- Q16. What is the number of orders by payment method?
-- =========================================================

SELECT
    p.payment_method,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN payments p
    ON o.payment_id = p.payment_id
GROUP BY p.payment_method
ORDER BY total_orders DESC;


-- =========================================================
-- Q17. What is the revenue by shipping status?
-- =========================================================

SELECT
    s.delivery_status,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.revenue), 2) AS total_revenue
FROM orders o
JOIN shipping s
    ON o.shipping_id = s.shipping_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY s.delivery_status
ORDER BY total_revenue DESC;


-- =========================================================
-- Q18. What percentage of orders are cancelled or returned?
-- =========================================================

SELECT
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN status IN ('Cancelled', 'Returned')
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS cancelled_returned_percentage
FROM orders;


-- =========================================================
-- Q19. How many cancelled and returned orders are there?
-- =========================================================

SELECT
    status AS order_status,
    COUNT(*) AS total_orders
FROM orders
WHERE status IN ('Cancelled', 'Returned')
GROUP BY status
ORDER BY total_orders DESC;


-- =========================================================
-- Q20. What is the average daily revenue?
-- =========================================================

SELECT
    ROUND(
        SUM(oi.revenue) / COUNT(DISTINCT DATE(o.order_date)),
        2
    ) AS average_daily_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;


-- =========================================================
-- Q21. Which date generated the highest revenue?
-- =========================================================

SELECT
    DATE(o.order_date) AS sales_date,
    ROUND(SUM(oi.revenue), 2) AS daily_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE(o.order_date)
ORDER BY daily_revenue DESC
LIMIT 1;


-- =========================================================
-- Q22. Which date generated the highest profit?
-- =========================================================

SELECT
    DATE(o.order_date) AS sales_date,
    ROUND(SUM(oi.profit), 2) AS daily_profit
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE(o.order_date)
ORDER BY daily_profit DESC
LIMIT 1;


-- =========================================================
-- Q23. What is the monthly profit margin?
-- =========================================================

SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.revenue), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;


-- =========================================================
-- Q24. What is the monthly revenue growth percentage?
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(oi.revenue) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)

SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        (
            revenue -
            LAG(revenue) OVER (ORDER BY month)
        )
        / NULLIF(
            LAG(revenue) OVER (ORDER BY month),
            0
        ) * 100,
        2
    ) AS revenue_growth_percentage
FROM monthly_sales
ORDER BY month;


-- =========================================================
-- Q25. What are the overall sales KPIs?
-- =========================================================

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.revenue), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(
        SUM(oi.profit) / NULLIF(SUM(oi.revenue), 0) * 100,
        2
    ) AS profit_margin_percentage,
    ROUND(
        SUM(oi.revenue) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;


-- =========================================================
-- END OF SECTION 5
-- =========================================================

-- =========================================================
-- RETAIL BI PROJECT
-- SECTION 6 — ORDER & OPERATIONS ANALYSIS
-- =========================================================

USE retail_bi;


-- =========================================================
-- Q1. How many orders are there for each order status?
-- =========================================================

SELECT
    status AS order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;


-- =========================================================
-- Q2. What percentage of orders belong to each order status?
-- =========================================================

SELECT
    status AS order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders),
        2
    ) AS percentage_of_orders
FROM orders
GROUP BY status
ORDER BY percentage_of_orders DESC;


-- =========================================================
-- Q3. How many cancelled orders are there?
-- =========================================================

SELECT
    COUNT(*) AS cancelled_orders
FROM orders
WHERE status = 'Cancelled';


-- =========================================================
-- Q4. How many returned orders are there?
-- =========================================================

SELECT
    COUNT(*) AS returned_orders
FROM orders
WHERE status = 'Returned';


-- =========================================================
-- Q5. What is the payment status distribution?
-- =========================================================

SELECT
    payment_status,
    COUNT(*) AS total_payments
FROM payments
GROUP BY payment_status
ORDER BY total_payments DESC;


-- =========================================================
-- Q6. What percentage of payments are successful?
-- =========================================================

SELECT
    ROUND(
        SUM(
            CASE
                WHEN payment_status = 'Completed' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS successful_payment_percentage
FROM payments;


-- =========================================================
-- Q7. How many failed payments are there?
-- =========================================================

SELECT
    COUNT(*) AS failed_payments
FROM payments
WHERE payment_status = 'Failed';


-- =========================================================
-- Q8. What is the number of payments by payment method?
-- =========================================================

SELECT
    payment_method,
    COUNT(*) AS total_payments
FROM payments
GROUP BY payment_method
ORDER BY total_payments DESC;


-- =========================================================
-- Q9. Which payment methods have the highest successful
-- payment rate?
-- =========================================================

SELECT
    payment_method,
    COUNT(*) AS total_payments,
    SUM(
        CASE
            WHEN payment_status = 'Completed' THEN 1
            ELSE 0
        END
    ) AS successful_payments,
    ROUND(
        SUM(
            CASE
                WHEN payment_status = 'Completed' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS success_rate_percentage
FROM payments
GROUP BY payment_method
ORDER BY success_rate_percentage DESC;


-- =========================================================
-- Q10. What is the order distribution by shipping carrier?
-- =========================================================

SELECT
    s.carrier,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN shipping s
    ON o.shipping_id = s.shipping_id
GROUP BY s.carrier
ORDER BY total_orders DESC;


-- =========================================================
-- Q11. What is the delivery status distribution?
-- =========================================================

SELECT
    delivery_status,
    COUNT(*) AS total_shipments
FROM shipping
GROUP BY delivery_status
ORDER BY total_shipments DESC;


-- =========================================================
-- Q12. What is the average actual delivery time?
-- =========================================================

SELECT
    ROUND(AVG(actual_delivery_days), 2) AS average_delivery_days
FROM shipping
WHERE actual_delivery_days IS NOT NULL;


-- =========================================================
-- Q13. What is the average estimated vs actual delivery time?
-- =========================================================

SELECT
    ROUND(AVG(estimated_days), 2) AS average_estimated_days,
    ROUND(AVG(actual_delivery_days), 2) AS average_actual_days
FROM shipping
WHERE actual_delivery_days IS NOT NULL;


-- =========================================================
-- Q14. How many deliveries were late?
-- Late = actual delivery days > estimated delivery days
-- =========================================================

SELECT
    COUNT(*) AS late_deliveries
FROM shipping
WHERE actual_delivery_days > estimated_days;


-- =========================================================
-- Q15. What percentage of deliveries were late?
-- =========================================================

SELECT
    ROUND(
        SUM(
            CASE
                WHEN actual_delivery_days > estimated_days THEN 1
                ELSE 0
            END
        ) * 100.0 /
        NULLIF(
            SUM(
                CASE
                    WHEN actual_delivery_days IS NOT NULL THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS late_delivery_percentage
FROM shipping;


-- =========================================================
-- Q16. Which shipping carriers have the highest average
-- delivery time?
-- =========================================================

SELECT
    carrier,
    ROUND(AVG(actual_delivery_days), 2) AS average_delivery_days
FROM shipping
WHERE actual_delivery_days IS NOT NULL
GROUP BY carrier
ORDER BY average_delivery_days DESC;


-- =========================================================
-- Q17. Which shipping carriers have the best on-time
-- delivery performance?
-- =========================================================

SELECT
    carrier,
    COUNT(*) AS total_deliveries,
    SUM(
        CASE
            WHEN actual_delivery_days <= estimated_days
            THEN 1
            ELSE 0
        END
    ) AS on_time_deliveries,
    ROUND(
        SUM(
            CASE
                WHEN actual_delivery_days <= estimated_days
                THEN 1
                ELSE 0
            END
        ) * 100.0 /
        NULLIF(
            SUM(
                CASE
                    WHEN actual_delivery_days IS NOT NULL THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS on_time_percentage
FROM shipping
GROUP BY carrier
ORDER BY on_time_percentage DESC;


-- =========================================================
-- Q18. What is the average shipping cost by carrier?
-- =========================================================

SELECT
    carrier,
    ROUND(AVG(shipping_cost), 2) AS average_shipping_cost
FROM shipping
GROUP BY carrier
ORDER BY average_shipping_cost DESC;


-- =========================================================
-- Q19. What is the total shipping cost by carrier?
-- =========================================================

SELECT
    carrier,
    ROUND(SUM(shipping_cost), 2) AS total_shipping_cost
FROM shipping
GROUP BY carrier
ORDER BY total_shipping_cost DESC;


-- =========================================================
-- Q20. What are the overall order and operations KPIs?
-- =========================================================

SELECT
    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN status = 'Completed' THEN 1
            ELSE 0
        END
    ) AS completed_orders,

    SUM(
        CASE
            WHEN status = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_orders,

    SUM(
        CASE
            WHEN status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS returned_orders,

    ROUND(
        SUM(
            CASE
                WHEN status = 'Completed' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS completion_rate_percentage,

    ROUND(
        SUM(
            CASE
                WHEN status IN ('Cancelled', 'Returned') THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS cancelled_returned_percentage

FROM orders;


-- =========================================================
-- END OF SECTION 6
-- ORDER & OPERATIONS ANALYSIS
-- =========================================================

-- =========================================================
-- SECTION 7: RETURNS & REVIEWS ANALYSIS
-- =========================================================

USE retail_bi;


-- =========================================================
-- Q1. What is the total number of returns?
-- =========================================================

SELECT
    COUNT(*) AS total_returns
FROM returns;


-- =========================================================
-- Q2. What is the overall return rate?
-- =========================================================

SELECT
    ROUND(
        COUNT(DISTINCT r.order_id) * 100.0 /
        COUNT(DISTINCT o.order_id),
        2
    ) AS return_rate_percentage
FROM orders o
LEFT JOIN returns r
    ON o.order_id = r.order_id;


-- =========================================================
-- Q3. What are the main reasons for returns?
-- =========================================================

SELECT
    return_reason,
    COUNT(*) AS return_count
FROM returns
GROUP BY return_reason
ORDER BY return_count DESC;


-- =========================================================
-- Q4. What percentage of returns comes from each reason?
-- =========================================================

SELECT
    return_reason,
    COUNT(*) AS return_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM returns),
        2
    ) AS return_percentage
FROM returns
GROUP BY return_reason
ORDER BY return_count DESC;


-- =========================================================
-- Q5. What is the total refund amount?
-- =========================================================

SELECT
    ROUND(SUM(refund_amount), 2) AS total_refund_amount
FROM returns;


-- =========================================================
-- Q6. What is the average refund amount per return?
-- =========================================================

SELECT
    ROUND(AVG(refund_amount), 2) AS average_refund_amount
FROM returns;


-- =========================================================
-- Q7. Which return reasons generate the highest refund amount?
-- =========================================================

SELECT
    return_reason,
    COUNT(*) AS return_count,
    ROUND(SUM(refund_amount), 2) AS total_refund_amount,
    ROUND(AVG(refund_amount), 2) AS average_refund_amount
FROM returns
GROUP BY return_reason
ORDER BY total_refund_amount DESC;


-- =========================================================
-- Q8. What are the monthly return trends?
-- =========================================================

SELECT
    DATE_FORMAT(return_date, '%Y-%m') AS month,
    COUNT(*) AS total_returns,
    ROUND(SUM(refund_amount), 2) AS total_refund_amount
FROM returns
GROUP BY DATE_FORMAT(return_date, '%Y-%m')
ORDER BY month;


-- =========================================================
-- Q9. Which months had the highest number of returns?
-- =========================================================

SELECT
    DATE_FORMAT(return_date, '%Y-%m') AS month,
    COUNT(*) AS total_returns
FROM returns
GROUP BY DATE_FORMAT(return_date, '%Y-%m')
ORDER BY total_returns DESC
LIMIT 10;


-- =========================================================
-- Q10. What is the average review rating?
-- =========================================================

SELECT
    ROUND(AVG(rating), 2) AS average_rating
FROM reviews;


-- =========================================================
-- Q11. How many reviews are there for each rating?
-- =========================================================

SELECT
    rating,
    COUNT(*) AS review_count
FROM reviews
GROUP BY rating
ORDER BY rating DESC;


-- =========================================================
-- Q12. What percentage of reviews belongs to each rating?
-- =========================================================

SELECT
    rating,
    COUNT(*) AS review_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM reviews),
        2
    ) AS review_percentage
FROM reviews
GROUP BY rating
ORDER BY rating DESC;


-- =========================================================
-- Q13. Which products have the highest average ratings?
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(r.review_id) AS review_count
FROM reviews r
JOIN products p
    ON r.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
HAVING COUNT(r.review_id) >= 5
ORDER BY average_rating DESC
LIMIT 10;


-- =========================================================
-- Q14. Which products have the lowest average ratings?
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(r.review_id) AS review_count
FROM reviews r
JOIN products p
    ON r.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
HAVING COUNT(r.review_id) >= 5
ORDER BY average_rating ASC
LIMIT 10;


-- =========================================================
-- Q15. Which categories receive the most reviews?
-- =========================================================

SELECT
    c.category_id,
    c.category_name,
    COUNT(r.review_id) AS review_count
FROM reviews r
JOIN products p
    ON r.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY review_count DESC;


-- =========================================================
-- Q16. What is the average rating for each category?
-- =========================================================

SELECT
    c.category_id,
    c.category_name,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(r.review_id) AS review_count
FROM reviews r
JOIN products p
    ON r.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY average_rating DESC;


-- =========================================================
-- Q17. Which products have high sales but low ratings?
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS quantity_sold,
    ROUND(SUM(oi.revenue), 2) AS revenue,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(DISTINCT r.review_id) AS review_count
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN reviews r
    ON p.product_id = r.product_id
GROUP BY
    p.product_id,
    p.product_name
HAVING
    SUM(oi.quantity) >= 50
    AND AVG(r.rating) < 3.5
ORDER BY quantity_sold DESC;


-- =========================================================
-- Q18. Which categories have the highest refund amounts?
-- =========================================================

SELECT
    c.category_name,
    COUNT(DISTINCT r.return_id) AS return_count,
    ROUND(SUM(r.refund_amount), 2) AS total_refund_amount
FROM returns r
JOIN orders o
    ON r.order_id = o.order_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_refund_amount DESC;


-- =========================================================
-- Q19. What are the most common return reasons?
-- =========================================================

SELECT
    return_reason,
    COUNT(*) AS return_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM returns),
        2
    ) AS percentage_of_returns
FROM returns
GROUP BY return_reason
ORDER BY return_count DESC;


-- =========================================================
-- Q20. What are the overall Returns & Reviews KPIs?
-- =========================================================

SELECT
    (SELECT COUNT(*) FROM returns) AS total_returns,

    (SELECT ROUND(SUM(refund_amount), 2)
     FROM returns) AS total_refund_amount,

    (SELECT ROUND(AVG(refund_amount), 2)
     FROM returns) AS average_refund_amount,

    (SELECT ROUND(AVG(rating), 2)
     FROM reviews) AS average_review_rating,

    (SELECT COUNT(*) FROM reviews) AS total_reviews,

    (SELECT COUNT(DISTINCT customer_id)
     FROM reviews) AS customers_who_reviewed;

     