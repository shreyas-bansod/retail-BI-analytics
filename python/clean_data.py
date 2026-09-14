import os
import pandas as pd
import numpy as np

# -----------------------------
# Paths
# -----------------------------

raw_path = "../data/raw/"
clean_path = "../data/cleaned/"

os.makedirs(clean_path, exist_ok=True)

print("Starting data cleaning...\n")


# -----------------------------
# Load Raw Data
# -----------------------------

categories_df = pd.read_csv(raw_path + "categories.csv")
suppliers_df = pd.read_csv(raw_path + "suppliers.csv")
products_df = pd.read_csv(raw_path + "products.csv")
customers_df = pd.read_csv(raw_path + "customers.csv")
payments_df = pd.read_csv(raw_path + "payments.csv")
shipping_df = pd.read_csv(raw_path + "shipping.csv")
orders_df = pd.read_csv(raw_path + "orders.csv")
order_items_df = pd.read_csv(raw_path + "order_items.csv")
returns_df = pd.read_csv(raw_path + "returns.csv")
reviews_df = pd.read_csv(raw_path + "reviews.csv")


print("All datasets loaded successfully!\n")


# -----------------------------
# Record Counts
# -----------------------------

datasets = {
    "Categories": categories_df,
    "Suppliers": suppliers_df,
    "Products": products_df,
    "Customers": customers_df,
    "Payments": payments_df,
    "Shipping": shipping_df,
    "Orders": orders_df,
    "Order Items": order_items_df,
    "Returns": returns_df,
    "Reviews": reviews_df
}

print("Record Counts")
print("-" * 40)

for name, df in datasets.items():
    print(f"{name:<15} : {len(df):,}")


# -----------------------------
# Missing Value Check
# -----------------------------

print("\nMissing Values")
print("-" * 40)

for name, df in datasets.items():

    missing = df.isnull().sum()

    total_missing = missing.sum()

    print(f"{name:<15} : {total_missing} missing values")


# -----------------------------
# Duplicate Check
# -----------------------------

print("\nDuplicate Records")
print("-" * 40)

for name, df in datasets.items():

    duplicates = df.duplicated().sum()

    print(f"{name:<15} : {duplicates} duplicates")


# -----------------------------
# Data Types
# -----------------------------

print("\nOrders Data Types")
print("-" * 40)

print(orders_df.dtypes)

# -----------------------------
# Shipping Missing Value Analysis
# -----------------------------

print("\nShipping Missing Value Analysis")
print("-" * 40)

print(
    shipping_df[
        shipping_df["actual_delivery_days"].isna()
    ]["delivery_status"].value_counts()
)


# -----------------------------
# Convert Date Columns
# -----------------------------

orders_df["order_date"] = pd.to_datetime(
    orders_df["order_date"]
)

customers_df["date_of_birth"] = pd.to_datetime(
    customers_df["date_of_birth"]
)

customers_df["join_date"] = pd.to_datetime(
    customers_df["join_date"]
)

returns_df["return_date"] = pd.to_datetime(
    returns_df["return_date"]
)

reviews_df["review_date"] = pd.to_datetime(
    reviews_df["review_date"]
)

print("\nDate columns converted successfully!")


print("\nUpdated Date Data Types")
print("-" * 40)

print("Orders:")
print(orders_df["order_date"].dtype)

print("\nCustomers:")
print(customers_df[["date_of_birth", "join_date"]].dtypes)

print("\nReturns:")
print(returns_df["return_date"].dtype)

print("\nReviews:")
print(reviews_df["review_date"].dtype)

# -----------------------------
# Foreign Key Validation
# -----------------------------

print("\nForeign Key Validation")
print("-" * 50)


# Orders → Customers
invalid_customers = orders_df[
    ~orders_df["customer_id"].isin(
        customers_df["customer_id"]
    )
]

print(
    f"Orders → Customers : "
    f"{len(invalid_customers)} invalid"
)


# Orders → Payments
invalid_payments = orders_df[
    ~orders_df["payment_id"].isin(
        payments_df["payment_id"]
    )
]

print(
    f"Orders → Payments  : "
    f"{len(invalid_payments)} invalid"
)


# Orders → Shipping
invalid_shipping = orders_df[
    ~orders_df["shipping_id"].isin(
        shipping_df["shipping_id"]
    )
]

print(
    f"Orders → Shipping   : "
    f"{len(invalid_shipping)} invalid"
)


# Order Items → Orders
invalid_order_items = order_items_df[
    ~order_items_df["order_id"].isin(
        orders_df["order_id"]
    )
]

print(
    f"Order Items → Orders : "
    f"{len(invalid_order_items)} invalid"
)


# Order Items → Products
invalid_products = order_items_df[
    ~order_items_df["product_id"].isin(
        products_df["product_id"]
    )
]

print(
    f"Order Items → Products : "
    f"{len(invalid_products)} invalid"
)


# Products → Categories
invalid_categories = products_df[
    ~products_df["category_id"].isin(
        categories_df["category_id"]
    )
]

print(
    f"Products → Categories : "
    f"{len(invalid_categories)} invalid"
)


# Products → Suppliers
invalid_suppliers = products_df[
    ~products_df["supplier_id"].isin(
        suppliers_df["supplier_id"]
    )
]

print(
    f"Products → Suppliers : "
    f"{len(invalid_suppliers)} invalid"
)


# Returns → Orders
invalid_return_orders = returns_df[
    ~returns_df["order_id"].isin(
        orders_df["order_id"]
    )
]

print(
    f"Returns → Orders : "
    f"{len(invalid_return_orders)} invalid"
)


# Reviews → Customers
invalid_review_customers = reviews_df[
    ~reviews_df["customer_id"].isin(
        customers_df["customer_id"]
    )
]

print(
    f"Reviews → Customers : "
    f"{len(invalid_review_customers)} invalid"
)


# Reviews → Products
invalid_review_products = reviews_df[
    ~reviews_df["product_id"].isin(
        products_df["product_id"]
    )
]

print(
    f"Reviews → Products : "
    f"{len(invalid_review_products)} invalid"
)

# -----------------------------
# Data Cleaning
# -----------------------------

print("\nStarting data cleaning...")


# -----------------------------
# Remove Duplicate Records
# -----------------------------

categories_df = categories_df.drop_duplicates()
suppliers_df = suppliers_df.drop_duplicates()
products_df = products_df.drop_duplicates()
customers_df = customers_df.drop_duplicates()
payments_df = payments_df.drop_duplicates()
shipping_df = shipping_df.drop_duplicates()
orders_df = orders_df.drop_duplicates()
order_items_df = order_items_df.drop_duplicates()
returns_df = returns_df.drop_duplicates()
reviews_df = reviews_df.drop_duplicates()


# -----------------------------
# Validate Numeric Columns
# -----------------------------

products_df["cost_price"] = pd.to_numeric(
    products_df["cost_price"],
    errors="coerce"
)

products_df["selling_price"] = pd.to_numeric(
    products_df["selling_price"],
    errors="coerce"
)

products_df["stock_quantity"] = pd.to_numeric(
    products_df["stock_quantity"],
    errors="coerce"
)

order_items_df["quantity"] = pd.to_numeric(
    order_items_df["quantity"],
    errors="coerce"
)

order_items_df["unit_price"] = pd.to_numeric(
    order_items_df["unit_price"],
    errors="coerce"
)

order_items_df["discount"] = pd.to_numeric(
    order_items_df["discount"],
    errors="coerce"
)


# -----------------------------
# Create Revenue Column
# -----------------------------

order_items_df["revenue"] = (
    order_items_df["quantity"]
    * order_items_df["unit_price"]
    * (1 - order_items_df["discount"] / 100)
)


# Round revenue
order_items_df["revenue"] = order_items_df[
    "revenue"
].round(2)


# -----------------------------
# Create Product Profit Column
# -----------------------------

order_items_df = order_items_df.merge(
    products_df[
        [
            "product_id",
            "cost_price"
        ]
    ],
    on="product_id",
    how="left"
)


order_items_df["profit"] = (
    order_items_df["revenue"]
    - (
        order_items_df["quantity"]
        * order_items_df["cost_price"]
    )
)


order_items_df["profit"] = order_items_df[
    "profit"
].round(2)


# -----------------------------
# Create Profit Margin
# -----------------------------

order_items_df["profit_margin"] = np.where(
    order_items_df["revenue"] != 0,
    (
        order_items_df["profit"]
        / order_items_df["revenue"]
    ) * 100,
    0
)

order_items_df["profit_margin"] = (
    order_items_df["profit_margin"].round(2)
)


print("Data cleaning completed!")

# -----------------------------
# Save Cleaned Data
# -----------------------------

print("\nSaving cleaned datasets...")


categories_df.to_csv(
    clean_path + "categories_clean.csv",
    index=False
)

suppliers_df.to_csv(
    clean_path + "suppliers_clean.csv",
    index=False
)

products_df.to_csv(
    clean_path + "products_clean.csv",
    index=False
)

customers_df.to_csv(
    clean_path + "customers_clean.csv",
    index=False
)

payments_df.to_csv(
    clean_path + "payments_clean.csv",
    index=False
)

shipping_df.to_csv(
    clean_path + "shipping_clean.csv",
    index=False
)

orders_df.to_csv(
    clean_path + "orders_clean.csv",
    index=False
)

order_items_df.to_csv(
    clean_path + "order_items_clean.csv",
    index=False
)

returns_df.to_csv(
    clean_path + "returns_clean.csv",
    index=False
)

reviews_df.to_csv(
    clean_path + "reviews_clean.csv",
    index=False
)


print("All cleaned datasets saved successfully!")

# -----------------------------
# Final Summary
# -----------------------------

print("\nCleaned Dataset Summary")
print("-" * 50)

cleaned_datasets = {
    "Categories": categories_df,
    "Suppliers": suppliers_df,
    "Products": products_df,
    "Customers": customers_df,
    "Payments": payments_df,
    "Shipping": shipping_df,
    "Orders": orders_df,
    "Order Items": order_items_df,
    "Returns": returns_df,
    "Reviews": reviews_df
}

for name, df in cleaned_datasets.items():
    print(f"{name:<15} : {len(df):,} rows")