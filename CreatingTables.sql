create database Online_Food_Delivery;


use  Online_Food_Delivery
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    gender NVARCHAR(10) CHECK (gender IN ('Male','Female','Other')),
    phone_number NVARCHAR(20),
    email NVARCHAR(100) UNIQUE,
    address NVARCHAR(255)
);


CREATE TABLE Restaurants (
    restaurant_id INT PRIMARY KEY IDENTITY(1,1),
    restaurant_name NVARCHAR(100) NOT NULL,
    location NVARCHAR(255),
    phone_number NVARCHAR(20),
    cuisine_type NVARCHAR(50),
    opening_hours NVARCHAR(50)
);


CREATE TABLE MenuItems (
    item_id INT PRIMARY KEY IDENTITY(1,1),
    restaurant_id INT NOT NULL,
    item_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10,2) NOT NULL,
    availability BIT DEFAULT 1,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);


CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    order_status NVARCHAR(20) CHECK (order_status IN ('Pending','Preparing','On the Way','Delivered','Cancelled')) DEFAULT 'Pending',
    payment_method NVARCHAR(20) CHECK (payment_method IN ('Cash','Card','Wallet')) DEFAULT 'Cash',
    total_price DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);


CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    item_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItems(item_id)
);

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    review_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);


CREATE TABLE DeliveryDrivers (
    driver_id INT PRIMARY KEY IDENTITY(1,1),
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    phone_number NVARCHAR(20),
    vehicle_type NVARCHAR(50),
    license_number NVARCHAR(50)
);


CREATE TABLE DeliveryAssignments (
    assignment_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    driver_id INT NOT NULL,
    assigned_time DATETIME DEFAULT GETDATE(),
    delivered_time DATETIME,
    delivery_status NVARCHAR(20) CHECK (delivery_status IN ('Assigned','Picked Up','On the Way','Delivered','Failed')) DEFAULT 'Assigned',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (driver_id) REFERENCES DeliveryDrivers(driver_id)
);




ALTER TABLE Customers
ALTER COLUMN phone_number VARCHAR(50);



