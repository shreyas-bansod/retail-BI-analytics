CREATE DATABASE IF NOT EXISTS retail_bi;

USE retail_bi;


-- =========================================================
-- CUSTOMERS
-- =========================================================

CREATE TABLE customers (

    customer_id INT PRIMARY KEY,

    first_name VARCHAR(50) NOT NULL,

    last_name VARCHAR(50) NOT NULL,

    email VARCHAR(100) UNIQUE NOT NULL,

    phone VARCHAR(20),

    gender ENUM('Male','Female','Other'),

    date_of_birth DATE,

    join_date DATE NOT NULL,

    city VARCHAR(50),

    state VARCHAR(50),

    country VARCHAR(50),

    loyalty_points INT DEFAULT 0

);


-- =========================================================
-- CATEGORIES
-- =========================================================

CREATE TABLE categories (

    category_id INT PRIMARY KEY,

    category_name VARCHAR(100) NOT NULL UNIQUE

);


-- =========================================================
-- SUPPLIERS
-- =========================================================

CREATE TABLE suppliers (

    supplier_id INT PRIMARY KEY,

    supplier_name VARCHAR(100) NOT NULL,

    country VARCHAR(50),

    rating DECIMAL(2,1),

    contact_email VARCHAR(100)

);


-- =========================================================
-- PRODUCTS
-- =========================================================

CREATE TABLE products (

    product_id INT PRIMARY KEY,

    category_id INT NOT NULL,

    supplier_id INT NOT NULL,

    product_name VARCHAR(150) NOT NULL,

    brand VARCHAR(100),

    cost_price DECIMAL(10,2) NOT NULL,

    selling_price DECIMAL(10,2) NOT NULL,

    stock_quantity INT DEFAULT 0,

    weight DECIMAL(8,2),

    FOREIGN KEY (category_id)
        REFERENCES categories(category_id),

    FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)

);


-- =========================================================
-- PAYMENTS
-- =========================================================

CREATE TABLE payments (

    payment_id INT PRIMARY KEY,

    payment_method VARCHAR(30),

    payment_status VARCHAR(30),

    amount DECIMAL(10,2)

);


-- =========================================================
-- SHIPPING
-- =========================================================

CREATE TABLE shipping (

    shipping_id INT PRIMARY KEY,

    carrier VARCHAR(50),

    shipping_cost DECIMAL(10,2),

    estimated_days INT,

    actual_delivery_days INT,

    delivery_status VARCHAR(30)

);


-- =========================================================
-- ORDERS
-- =========================================================

CREATE TABLE orders (

    order_id INT PRIMARY KEY,

    customer_id INT NOT NULL,

    payment_id INT,

    shipping_id INT,

    order_date DATE NOT NULL,

    status VARCHAR(30),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (payment_id)
        REFERENCES payments(payment_id),

    FOREIGN KEY (shipping_id)
        REFERENCES shipping(shipping_id)

);


-- =========================================================
-- ORDER ITEMS
-- =========================================================

CREATE TABLE order_items (

    order_item_id INT PRIMARY KEY,

    order_id INT NOT NULL,

    product_id INT NOT NULL,

    quantity INT NOT NULL,

    unit_price DECIMAL(10,2),

    discount DECIMAL(5,2) DEFAULT 0,

    revenue DECIMAL(12,2),

    cost_price DECIMAL(10,2),

    profit DECIMAL(12,2),

    profit_margin DECIMAL(8,2),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)

);


-- =========================================================
-- RETURNS
-- =========================================================

CREATE TABLE returns (

    return_id INT PRIMARY KEY,

    order_id INT NOT NULL,

    return_reason VARCHAR(255),

    refund_amount DECIMAL(10,2),

    return_date DATE,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)

);


-- =========================================================
-- REVIEWS
-- =========================================================

CREATE TABLE reviews (

    review_id INT PRIMARY KEY,

    customer_id INT,

    product_id INT,

    rating DECIMAL(2,1),

    review_text TEXT,

    review_date DATE,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)

);


-- =========================================================
-- INDEXES
-- =========================================================

CREATE INDEX idx_customer
ON orders(customer_id);

CREATE INDEX idx_order_date
ON orders(order_date);

CREATE INDEX idx_product
ON order_items(product_id);

CREATE INDEX idx_category
ON products(category_id);

CREATE INDEX idx_supplier
ON products(supplier_id);