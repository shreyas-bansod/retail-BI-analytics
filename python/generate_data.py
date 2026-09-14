import os
import pandas as pd
import numpy as np
from faker import Faker
import random

# -----------------------------
# Initial Setup
# -----------------------------

fake = Faker()

random.seed(42)
np.random.seed(42)
Faker.seed(42)

# -----------------------------
# Create folders if they don't exist
# -----------------------------

os.makedirs("../data/raw", exist_ok=True)
os.makedirs("../data/cleaned", exist_ok=True)

print("Folders are ready!")

# -----------------------------
# Categories
# -----------------------------

categories = [
    "Electronics",
    "Furniture",
    "Clothing",
    "Footwear",
    "Books",
    "Sports",
    "Beauty",
    "Toys",
    "Groceries",
    "Automotive",
    "Jewelry",
    "Home Decor",
    "Kitchen",
    "Pet Supplies",
    "Health",
    "Office Supplies",
    "Gaming",
    "Music",
    "Garden",
    "Baby Products"
]

category_df = pd.DataFrame({
    "category_id": range(1, len(categories) + 1),
    "category_name": categories
})

category_df.to_csv("../data/raw/categories.csv", index=False)

print(category_df.head())

# -----------------------------
# Suppliers
# -----------------------------

countries = [
    "India", "USA", "China", "Japan", "Germany",
    "South Korea", "Vietnam", "Taiwan",
    "France", "Italy"
]

supplier_names = [
    "TechSource",
    "Global Supplies",
    "Prime Wholesale",
    "Retail Partners",
    "Vision Traders",
    "NextGen Distributors",
    "Elite Imports",
    "Future Electronics",
    "Urban Supply Co",
    "Quality Traders",
    "Swift Wholesale",
    "BlueSky Suppliers",
    "Mega Distributors",
    "Supply Hub",
    "Bright Retail"
]

suppliers = []

for supplier_id in range(1,151):

    supplier = {
        "supplier_id": supplier_id,
        "supplier_name": random.choice(supplier_names) + " " + str(supplier_id),
        "country": random.choice(countries),
        "rating": round(random.uniform(3.0,5.0),1),
        "contact_email": f"supplier{supplier_id}@retailhub.com"
    }

    suppliers.append(supplier)

supplier_df = pd.DataFrame(suppliers)

supplier_df.to_csv("../data/raw/suppliers.csv",index=False)

print("\nSuppliers Generated")
print(supplier_df.head())

# -----------------------------
# Products
# -----------------------------

product_catalog = {

    "Electronics": [
        "Laptop", "Smartphone", "Tablet", "Monitor",
        "Wireless Mouse", "Keyboard", "Smart Watch",
        "Bluetooth Speaker", "Power Bank", "Printer"
    ],

    "Furniture": [
        "Office Chair", "Study Table", "Wardrobe",
        "Bookshelf", "Coffee Table", "TV Unit",
        "Sofa", "Dining Table", "Bed", "Drawer"
    ],

    "Clothing": [
        "T-Shirt", "Jeans", "Shirt", "Hoodie",
        "Jacket", "Sweater", "Dress",
        "Shorts", "Track Pants", "Blazer"
    ],

    "Footwear": [
        "Running Shoes", "Sneakers", "Sandals",
        "Formal Shoes", "Boots", "Slippers",
        "Flip Flops", "Loafers"
    ],

    "Books": [
        "Novel", "Cookbook", "Biography",
        "Programming Book", "Science Book",
        "History Book", "Dictionary"
    ],

    "Sports": [
        "Football", "Basketball", "Cricket Bat",
        "Yoga Mat", "Badminton Racket",
        "Gym Gloves", "Skipping Rope"
    ],

    "Beauty": [
        "Face Wash", "Shampoo", "Conditioner",
        "Lipstick", "Perfume",
        "Body Lotion", "Hair Dryer"
    ],

    "Toys": [
        "Toy Car", "Puzzle", "Building Blocks",
        "Doll", "Action Figure",
        "Board Game", "Teddy Bear"
    ],

    "Groceries": [
        "Rice", "Sugar", "Tea", "Coffee",
        "Cooking Oil", "Salt",
        "Biscuits", "Pasta"
    ],

    "Automotive": [
        "Engine Oil", "Car Wax", "Helmet",
        "Seat Cover", "Tyre Inflator",
        "Air Filter"
    ],

    "Jewelry": [
        "Gold Ring", "Silver Necklace",
        "Bracelet", "Pendant",
        "Earrings", "Watch"
    ],

    "Home Decor": [
        "Wall Clock", "Mirror",
        "Flower Vase", "Table Lamp",
        "Curtains", "Photo Frame"
    ],

    "Kitchen": [
        "Pressure Cooker", "Knife Set",
        "Mixer Grinder", "Frying Pan",
        "Dinner Set", "Storage Box"
    ],

    "Pet Supplies": [
        "Dog Food", "Cat Food",
        "Pet Toy", "Pet Bed",
        "Pet Shampoo"
    ],

    "Health": [
        "Vitamin Tablets",
        "Thermometer",
        "First Aid Kit",
        "Protein Powder"
    ],

    "Office Supplies": [
        "Notebook", "Pen Set",
        "Printer Paper",
        "Calculator", "Stapler"
    ],

    "Gaming": [
        "Gaming Mouse",
        "Gaming Keyboard",
        "Gaming Chair",
        "Controller",
        "VR Headset"
    ],

    "Music": [
        "Guitar",
        "Keyboard",
        "Microphone",
        "Headphones",
        "Violin"
    ],

    "Garden": [
        "Plant Pot",
        "Garden Hose",
        "Watering Can",
        "Pruning Shears"
    ],

    "Baby Products": [
        "Baby Diapers",
        "Baby Bottle",
        "Baby Toy",
        "Baby Blanket",
        "Baby Lotion"
    ]
}

brand_catalog = {

    "Electronics": ["Samsung", "Apple", "Dell", "HP", "Lenovo", "Sony", "LG", "Mi"],

    "Furniture": ["IKEA", "Godrej", "Nilkamal", "Durian"],

    "Clothing": ["Nike", "Adidas", "Puma", "Levis", "Allen Solly"],

    "Footwear": ["Nike", "Adidas", "Puma", "Bata", "Woodland"],

    "Books": ["Penguin", "HarperCollins", "McGraw Hill", "Oxford"],

    "Sports": ["Nike", "Adidas", "Yonex", "Cosco"],

    "Beauty": ["Lakme", "Nivea", "Dove", "L'Oreal"],

    "Toys": ["Lego", "Funskool", "Hasbro", "Mattel"],

    "Groceries": ["Fortune", "Tata", "Aashirvaad", "Nestle"],

    "Automotive": ["Bosch", "Castrol", "Shell", "MRF"],

    "Jewelry": ["Tanishq", "Kalyan", "Malabar"],

    "Home Decor": ["Home Centre", "IKEA", "Urban Ladder"],

    "Kitchen": ["Prestige", "Cello", "Pigeon", "Milton"],

    "Pet Supplies": ["Pedigree", "Drools", "Whiskas"],

    "Health": ["Himalaya", "Dabur", "Horlicks"],

    "Office Supplies": ["Cello", "Classmate", "Camlin"],

    "Gaming": ["Logitech", "Razer", "Sony", "Xbox"],

    "Music": ["Yamaha", "Casio", "Roland"],

    "Garden": ["Bosch", "Falcon", "Gardena"],

    "Baby Products": ["Johnson's", "Huggies", "Pampers"]
}

products = []

NUM_PRODUCTS = 1000

for product_id in range(1, NUM_PRODUCTS + 1):

    # Select a random category
    category = category_df.sample(1).iloc[0]

    category_id = category["category_id"]
    category_name = category["category_name"]

    # Select a random supplier
    supplier_id = random.choice(supplier_df["supplier_id"].tolist())

    # Select a product from that category
    product = random.choice(product_catalog[category_name])

    # Select a brand
    brand = random.choice(brand_catalog[category_name])

    cost_price = round(random.uniform(100, 5000), 2)

    profit_margin = random.uniform(0.15, 0.60)

    selling_price = round(cost_price * (1 + profit_margin), 2)

    stock_quantity = random.randint(10, 500)

    weight = round(random.uniform(0.2, 25), 2)

    products.append({

        "product_id": product_id,

        "category_id": category_id,

        "supplier_id": supplier_id,

        "product_name": f"{brand} {product}",

        "brand": brand,

        "cost_price": cost_price,

        "selling_price": selling_price,

        "stock_quantity": stock_quantity,

        "weight": weight

    })

products_df = pd.DataFrame(products)

products_df.to_csv("../data/raw/products.csv", index=False)

print("\nProducts Generated Successfully!")
print(products_df.head())

print("\nShape:")
print(products_df.shape)

# -----------------------------
# Customers
# -----------------------------

customers = []

NUM_CUSTOMERS = 5000

city_state = {
    "Mumbai": "Maharashtra",
    "Pune": "Maharashtra",
    "Nagpur": "Maharashtra",
    "Nashik": "Maharashtra",
    "Aurangabad": "Maharashtra",

    "Delhi": "Delhi",

    "Bengaluru": "Karnataka",
    "Mysuru": "Karnataka",

    "Hyderabad": "Telangana",
    "Warangal": "Telangana",

    "Chennai": "Tamil Nadu",
    "Coimbatore": "Tamil Nadu",

    "Kolkata": "West Bengal",

    "Ahmedabad": "Gujarat",
    "Surat": "Gujarat",

    "Jaipur": "Rajasthan",

    "Lucknow": "Uttar Pradesh",

    "Indore": "Madhya Pradesh",
    "Bhopal": "Madhya Pradesh"
}

for customer_id in range(1, NUM_CUSTOMERS + 1):

    profile = fake.profile()

    first_name = profile["name"].split()[0]
    last_name = profile["name"].split()[-1]

    gender = profile["sex"]

    city = random.choice(list(city_state.keys()))
    state = city_state[city]

    email = f"{first_name.lower()}.{last_name.lower()}{customer_id}@gmail.com"

    phone = fake.numerify("9#########")

    date_of_birth = fake.date_of_birth(minimum_age=18, maximum_age=70)

    join_date = fake.date_between(start_date="-5y", end_date="today")

    loyalty_points = random.randint(0, 10000)

    country = "India"

    customers.append({
        "customer_id": customer_id,
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "phone": phone,
        "gender": gender,
        "date_of_birth": date_of_birth,
        "join_date": join_date,
        "city": city,
        "state": state,
        "country": country,
        "loyalty_points": loyalty_points
    })

customers_df = pd.DataFrame(customers)
customers_df.to_csv("../data/raw/customers.csv", index=False)
print("\nCustomers Generated Successfully!")
print(customers_df.head())

print("\nShape:")
print(customers_df.shape)

# -----------------------------
# Payments
# -----------------------------

payments = []

NUM_PAYMENTS = 15000

payment_methods = [
    "Credit Card",
    "Debit Card",
    "UPI",
    "Net Banking",
    "Cash",
    "Wallet"
]

payment_statuses = [
    "Completed",
    "Pending",
    "Failed",
    "Refunded"
]

payment_weights = [
    0.88,
    0.05,
    0.03,
    0.04
]

for payment_id in range(1, NUM_PAYMENTS + 1):

    payment_method = random.choice(payment_methods)

    payment_status = random.choices(
        payment_statuses,
        weights=payment_weights,
        k=1
    )[0]

    amount = round(random.uniform(200, 25000), 2)

    payments.append({
        "payment_id": payment_id,
        "payment_method": payment_method,
        "payment_status": payment_status,
        "amount": amount
    })

payments_df = pd.DataFrame(payments)

payments_df.to_csv("../data/raw/payments.csv", index=False)

print("\nPayments Generated Successfully!")
print(payments_df.head())

print("\nShape:")
print(payments_df.shape)

# -----------------------------
# Shipping
# -----------------------------

shipping = []

NUM_SHIPMENTS = 15000

carriers = [
    "Blue Dart",
    "Delhivery",
    "DTDC",
    "India Post",
    "FedEx",
    "Ekart",
    "XpressBees",
    "Ecom Express"
]

delivery_statuses = [
    "Delivered",
    "In Transit",
    "Cancelled",
    "Returned"
]

delivery_weights = [
    0.90,
    0.05,
    0.03,
    0.02
]

for shipping_id in range(1, NUM_SHIPMENTS + 1):

    carrier = random.choice(carriers)

    shipping_cost = round(random.uniform(40, 600), 2)

    estimated_days = random.randint(2, 7)

    delivery_status = random.choices(
        delivery_statuses,
        weights=delivery_weights,
        k=1
    )[0]

    if delivery_status == "Delivered":
        actual_delivery_days = max(
            1,
            estimated_days + random.randint(-1, 2)
        )

    elif delivery_status == "In Transit":
        actual_delivery_days = None

    elif delivery_status == "Cancelled":
        actual_delivery_days = None

    else:  # Returned
        actual_delivery_days = estimated_days + random.randint(1, 4)

    shipping.append({

        "shipping_id": shipping_id,

        "carrier": carrier,

        "shipping_cost": shipping_cost,

        "estimated_days": estimated_days,

        "actual_delivery_days": actual_delivery_days,

        "delivery_status": delivery_status

    })

shipping_df = pd.DataFrame(shipping)

shipping_df.to_csv("../data/raw/shipping.csv", index=False)

print("\nShipping Generated Successfully!")
print(shipping_df.head())

print("\nShape:")
print(shipping_df.shape)

# -----------------------------
# Orders
# -----------------------------
orders = []

NUM_ORDERS = 15000

for order_id in range(1, NUM_ORDERS + 1):

    customer_id = random.randint(1, len(customers_df))

    order_status = random.choices(
        ["Completed", "Processing", "Cancelled", "Returned"],
        weights=[82, 10, 4, 4],
        k=1
    )[0]

    if order_status == "Completed":
        payment_ids = payments_df.loc[
            payments_df["payment_status"] == "Completed",
            "payment_id"
        ].tolist()

        shipping_ids = shipping_df.loc[
            shipping_df["delivery_status"] == "Delivered",
            "shipping_id"
        ].tolist()

    elif order_status == "Processing":
        payment_ids = payments_df.loc[
            payments_df["payment_status"] == "Completed",
            "payment_id"
        ].tolist()

        shipping_ids = shipping_df.loc[
            shipping_df["delivery_status"] == "In Transit",
            "shipping_id"
        ].tolist()

    elif order_status == "Cancelled":
        payment_ids = payments_df.loc[
            payments_df["payment_status"].isin(["Pending", "Failed"]),
            "payment_id"
        ].tolist()

        shipping_ids = shipping_df.loc[
            shipping_df["delivery_status"] == "Cancelled",
            "shipping_id"
        ].tolist()

    else:  # Returned
        payment_ids = payments_df.loc[
            payments_df["payment_status"] == "Refunded",
            "payment_id"
        ].tolist()

        shipping_ids = shipping_df.loc[
            shipping_df["delivery_status"] == "Returned",
            "shipping_id"
        ].tolist()

    payment_id = random.choice(payment_ids)
    shipping_id = random.choice(shipping_ids)

    order_date = fake.date_between(
        start_date="-3y",
        end_date="today"
    )

    orders.append({
        "order_id": order_id,
        "customer_id": customer_id,
        "payment_id": payment_id,
        "shipping_id": shipping_id,
        "order_date": order_date,
        "status": order_status
    })

orders_df = pd.DataFrame(orders)

orders_df.to_csv("../data/raw/orders.csv", index=False)

print("\nOrders Generated Successfully!")
print(orders_df.head())

print("\nShape:")
print(orders_df.shape)

# -----------------------------
# Order Items
# -----------------------------

order_items = []
order_item_id = 1

for _, order in orders_df.iterrows():

    # Each order will have between 1 and 5 different products
    num_products = random.randint(1, 5)

    # Select unique products for this order
    selected_products = random.sample(
        range(1, len(products_df) + 1),
        num_products
    )

    for product_id in selected_products:

        # Get product details
        product = products_df.loc[
            products_df["product_id"] == product_id
        ].iloc[0]

        quantity = random.randint(1, 4)

        # Use the product's selling price
        unit_price = product["selling_price"]

        # Random discount percentage
        discount = random.choice([0, 5, 10, 15, 20])

        order_items.append({
            "order_item_id": order_item_id,
            "order_id": order["order_id"],
            "product_id": product_id,
            "quantity": quantity,
            "unit_price": unit_price,
            "discount": discount
        })

        order_item_id += 1

# Convert to DataFrame
order_items_df = pd.DataFrame(order_items)

# Save CSV
order_items_df.to_csv(
    "../data/raw/order_items.csv",
    index=False
)

print("\nOrder Items Generated Successfully!")
print(order_items_df.head())

print("\nShape:")
print(order_items_df.shape)

# -----------------------------
# Returns
# -----------------------------

returns = []

return_reasons = [
    "Damaged Product",
    "Wrong Product",
    "Size Issue",
    "Quality Issue",
    "Late Delivery",
    "Changed Mind"
]


return_orders = orders_df.sample(
    frac=0.07,
    random_state=42
)


return_id = 1


for _, order in return_orders.iterrows():

    order_id = order["order_id"]


    # Calculate refund from order items

    order_total = order_items_df[
        order_items_df["order_id"] == order_id
    ]


    refund_amount = (
        order_total["quantity"] *
        order_total["unit_price"] *
        (1 - order_total["discount"]/100)
    ).sum()


    return_date = fake.date_between(
        start_date=order["order_date"],
        end_date="today"
    )


    returns.append({

        "return_id": return_id,

        "order_id": order_id,

        "return_reason": random.choice(return_reasons),

        "refund_amount": round(refund_amount,2),

        "return_date": return_date

    })


    return_id += 1

returns_df = pd.DataFrame(returns)

returns_df.to_csv(
    "../data/raw/returns.csv",
    index=False
)


print("\nReturns Generated Successfully!")

print(returns_df.head())

print("\nShape:")

print(returns_df.shape)

# -----------------------------
# Reviews
# -----------------------------

reviews = []

review_texts = [

    "Excellent product, very satisfied",

    "Good quality and worth the price",

    "Average product, could be better",

    "Not happy with the quality",

    "Amazing experience, highly recommended",

    "Product matched the description",

    "Fast delivery and good packaging",

    "Value for money"

]


NUM_REVIEWS = 12000

for review_id in range(1, NUM_REVIEWS + 1):

    customer_id = random.randint(
        1,
        len(customers_df)
    )

    product_id = random.randint(
        1,
        len(products_df)
    )


    rating = random.choices(

        [1,2,3,4,5],

        weights=[5,10,20,35,30],

        k=1

    )[0]


    review_date = fake.date_between(

        start_date="-3y",

        end_date="today"

    )


    reviews.append({

        "review_id": review_id,

        "customer_id": customer_id,

        "product_id": product_id,

        "rating": rating,

        "review_text": random.choice(review_texts),

        "review_date": review_date

    })

reviews_df = pd.DataFrame(reviews)


reviews_df.to_csv(
    "../data/raw/reviews.csv",
    index=False
)


print("\nReviews Generated Successfully!")

print(reviews_df.head())


print("\nShape:")

print(reviews_df.shape)