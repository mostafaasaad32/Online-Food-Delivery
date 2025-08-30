from faker import Faker
import random

fake = Faker(locale='en')

def generate_customers(n=10):
    customers = []
    for _ in range(n):
        customers.append({
            "first_name": fake.first_name(),
            "last_name": fake.last_name(),
            "gender": random.choice(["Male", "Female", "Other"]),
            "phone_number": fake.phone_number(),
            "email": fake.unique.email(),
            "address": fake.address()
        })
    return customers


customers = generate_customers(100)
for c in customers:
    print(c)


import pyodbc

conn = pyodbc.connect(
    'DRIVER={SQL Server};'
    'SERVER=DESKTOP-JO9S3ED\SQLEXPRESS;'
    'DATABASE=Online_Food_Delivery;'
    'Trusted_Connection=yes;'
)

cursor = conn.cursor()


customers = generate_customers(100)

for c in customers:
    cursor.execute('''
        INSERT INTO Customers (first_name, last_name, gender, phone_number, email, address)
        VALUES (?, ?, ?, ?, ?, ?)
    ''', (c["first_name"], c["last_name"], c["gender"], c["phone_number"], c["email"], c["address"]))

conn.commit()


def generate_restaurants(n=20):
    data = []
    for _ in range(n):
        data.append((
            fake.company() + " Restaurant",
            fake.city(),
            fake.phone_number(),
            random.choice(["Pizza","Burger","Indian","Chinese","Seafood","Grill"]),
            "10 AM - 11 PM"
        ))
    return data

restaurants = generate_restaurants(20)
cursor.executemany('''
    INSERT INTO Restaurants (restaurant_name, location, phone_number, cuisine_type, opening_hours)
    VALUES (?, ?, ?, ?, ?)
''', restaurants)
conn.commit()



cursor.execute("SELECT restaurant_id FROM Restaurants")
restaurant_ids = [row[0] for row in cursor.fetchall()]

def generate_menuitems(restaurant_ids, n=20):
    data = []
    for _ in range(n):
        rid = random.choice(restaurant_ids)
        data.append((
            rid,
            fake.word().capitalize() + " Dish",
            fake.sentence(nb_words=5),
            round(random.uniform(30, 150), 2),
            1
        ))
    return data

menuitems = generate_menuitems(restaurant_ids, 40)
cursor.executemany('''
    INSERT INTO MenuItems (restaurant_id, item_name, description, price, availability)
    VALUES (?, ?, ?, ?, ?)
''', menuitems)
conn.commit()



cursor.execute("SELECT customer_id FROM Customers")
customer_ids = [row[0] for row in cursor.fetchall()]

def generate_orders(customer_ids, restaurant_ids, n=1000):
    data = []
    for _ in range(n):
        cid = random.choice(customer_ids)
        rid = random.choice(restaurant_ids)
        data.append((
            cid,
            rid,
            fake.date_time_this_year(),
            random.choice(["Pending","Preparing","On the Way","Delivered","Cancelled"]),
            random.choice(["Cash","Card","Wallet"]),
            round(random.uniform(100, 500), 2)
        ))
    return data

orders = generate_orders(customer_ids, restaurant_ids, 1000)
cursor.executemany('''
    INSERT INTO Orders (customer_id, restaurant_id, order_date, order_status, payment_method, total_price)
    VALUES (?, ?, ?, ?, ?, ?)
''', orders)
conn.commit()





cursor.execute("SELECT order_id FROM Orders")
order_ids = [row[0] for row in cursor.fetchall()]

cursor.execute("SELECT item_id, price FROM MenuItems")
items = [(row[0], row[1]) for row in cursor.fetchall()]

order_details = []
for oid in order_ids:
    for _ in range(random.randint(1, 3)):  # كل طلب فيه 1-3 أكلات
        item_id, price = random.choice(items)
        qty = random.randint(1, 3)
        order_details.append((oid, item_id, qty, price))

cursor.executemany('''
    INSERT INTO OrderDetails (order_id, item_id, quantity, item_price)
    VALUES (?, ?, ?, ?)
''', order_details)
conn.commit()


reviews = []
for oid in order_ids:
    reviews.append((
        oid,
        random.choice(customer_ids),
        random.choice(restaurant_ids),
        random.randint(1, 5),
        fake.sentence(nb_words=10),
        fake.date_time_this_year()
    ))

cursor.executemany('''
    INSERT INTO Reviews (order_id, customer_id, restaurant_id, rating, comment, review_date)
    VALUES (?, ?, ?, ?, ?, ?)
''', reviews)
conn.commit()


def generate_drivers(n=20):
    data = []
    for _ in range(n):
        data.append((
            fake.first_name(),
            fake.last_name(),
            fake.phone_number(),
            random.choice(["Car","Bike","Scooter"]),
            fake.license_plate()
        ))
    return data

drivers = generate_drivers(20)
cursor.executemany('''
    INSERT INTO DeliveryDrivers (first_name, last_name, phone_number, vehicle_type, license_number)
    VALUES (?, ?, ?, ?, ?)
''', drivers)
conn.commit()

cursor.execute("SELECT driver_id FROM DeliveryDrivers")
driver_ids = [row[0] for row in cursor.fetchall()]

assignments = []
for oid in order_ids:
    did = random.choice(driver_ids)
    assignments.append((
        oid,
        did,
        fake.date_time_this_year(),
        fake.date_time_this_year(),
        random.choice(["Assigned","Picked Up","On the Way","Delivered","Failed"])
    ))

cursor.executemany('''
    INSERT INTO DeliveryAssignments (order_id, driver_id, assigned_time, delivered_time, delivery_status)
    VALUES (?, ?, ?, ?, ?)
''', assignments)
conn.commit()



conn.close()
