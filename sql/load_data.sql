-- =========================================================
-- RETAIL BI
-- LOAD CLEANED DATA INTO MYSQL
-- =========================================================

USE retail_bi;


-- =========================================================
-- 1. CATEGORIES
-- =========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Shreyash Bansod/Desktop/retail BI analytics/data/cleaned/categories_clean.csv'

INTO TABLE categories

FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(category_id, category_name);


-- =========================================================
-- 2. SUPPLIERS
-- =========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Shreyash Bansod/Desktop/retail BI analytics/data/cleaned/suppliers_clean.csv'

INTO TABLE suppliers

FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(
    supplier_id,
    supplier_name,
    country,
    rating,
    contact_email
);


-- =========================================================
-- 3. CUSTOMERS
-- =========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Shreyash Bansod/Desktop/retail BI analytics/data/cleaned/customers_clean.csv'

INTO TABLE customers

FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    gender,
    date_of_birth,
    join_date,
    city,
    state,
    country,
    loyalty_points
);


-- =========================================================
-- 4. PAYMENTS
-- =========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Shreyash Bansod/Desktop/retail BI analytics/data/cleaned/payments_clean.csv'

INTO TABLE payments

FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(
    payment_id,
    payment_method,
    payment_status,
    amount
);


-- =========================================================
-- 5. SHIPPING
-- =========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Shreyash Bansod/Desktop/retail BI analytics/data/cleaned/shipping_clean.csv'

INTO TABLE shipping

FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(
    shipping_id,
    carrier,
    shipping_cost,
    estimated_days,
    actual_delivery_days,
    delivery_status
);

+-- =========================================================
-- 6. PRODUCTS
-- =========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Shreyash Bansod/Desktop/retail BI analytics/data/cleaned/products_clean.csv'

INTO TABLE products

FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(
    product_id,
    category_id,
    supplier_id,
    product_name,
    brand,
    cost_price,
    selling_price,
    stock_quantity,
    weight
);


-- =========================================================
-- 7. ORDERS
-- =========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Shreyash Bansod/Desktop/retail BI analytics/data/cleaned/orders_clean.csv'

INTO TABLE orders

FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(
    order_id,
    customer_id,
    payment_id,
    shipping_id,
    order_date,
    status
);


-- =========================================================
-- 8. ORDER ITEMS
-- =========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Shreyash Bansod/Desktop/retail BI analytics/data/cleaned/order_items_clean.csv'

INTO TABLE order_items

FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount,
    revenue,
    cost_price,
    profit,
    profit_margin
);


-- =========================================================
-- 9. RETURNS
-- =========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Shreyash Bansod/Desktop/retail BI analytics/data/cleaned/returns_clean.csv'

INTO TABLE returns

FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(
    return_id,
    order_id,
    return_reason,
    refund_amount,
    return_date
);


-- =========================================================
-- 10. REVIEWS
-- =========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Shreyash Bansod/Desktop/retail BI analytics/data/cleaned/reviews_clean.csv'

INTO TABLE reviews

FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'

LINES TERMINATED BY '\n'

IGNORE 1 ROWS

(
    review_id,
    customer_id,
    product_id,
    rating,
    review_text,
    review_date
);


-- =========================================================
-- FINISHED
-- =========================================================

SELECT 'All data loaded successfully!' AS message;