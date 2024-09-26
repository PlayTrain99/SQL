#!/bin/bash

DB_NAME="skleppiotr"

# Tworzenie bazy danych
psql -c "CREATE DATABASE $DB_NAME"

# Połączenie z bazą danych i wykonanie kodu SQL
psql -d $DB_NAME << EOF

-- Tworzenie tabeli Customers
CREATE TABLE Customers (
  customer_id TEXT NOT NULL,
  first_name TEXT NOT NULL,
  surname TEXT NOT NULL
);

-- Tworzenie tabeli Products
CREATE TABLE Products (
  product_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price FLOAT NOT NULL
);

-- Tworzenie tabeli Orders
CREATE TABLE Orders (
  order_id SERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  customer_id INTEGER NOT NULL
);

-- Tworzenie tabeli Events
CREATE TYPE EventType AS ENUM ('OrderIssue', 'CustomerAssignment', 'CustomerCancellation', 'DeliveryToCustomer');

CREATE TABLE Events (
  order_id INTEGER NOT NULL,
  event_date TIMESTAMP NOT NULL,
  event_type EventType NOT NULL,
  FOREIGN KEY (order_id) REFERENCES Orders (order_id)
);

-- Wprowadzanie danych

INSERT INTO Customers (customer_id, first_name, surname)
VALUES ('1', 'Piotr', 'Górka'), ('2', 'Ola', 'Szmyt'), ('3', 'Marcin', 'Koks');

INSERT INTO Products (name, price)
VALUES ('Gitara', 150), ('Pianino', 750), ('Flet', 30);

INSERT INTO Orders (order_id, product_id, customer_id)
VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3);

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-01', 'OrderIssue' FROM Orders WHERE order_id = 1;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-03', 'CustomerAssignment' FROM Orders WHERE order_id = 1;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-03', 'OrderIssue' FROM Orders WHERE order_id = 2;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-03', 'OrderIssue' FROM Orders WHERE order_id = 3;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-04', 'CustomerCancellation' FROM Orders WHERE order_id = 1;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-04', 'CustomerAssignment' FROM Orders WHERE order_id = 2;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-04', 'CustomerAssignment' FROM Orders WHERE order_id = 3;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-05', 'CustomerCancellation' FROM Orders WHERE order_id = 3;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-05', 'CustomerCancellation' FROM Orders WHERE order_id = 2;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-05', 'CustomerAssignment' FROM Orders WHERE order_id = 1;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-06', 'CustomerCancellation' FROM Orders WHERE order_id = 1;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-08', 'CustomerAssignment' FROM Orders WHERE order_id = 1;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-08', 'CustomerAssignment' FROM Orders WHERE order_id = 2;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-08', 'CustomerAssignment' FROM Orders WHERE order_id = 3;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-09', 'CustomerCancellation' FROM Orders WHERE order_id = 1;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-09', 'CustomerCancellation' FROM Orders WHERE order_id = 2;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-09', 'CustomerCancellation' FROM Orders WHERE order_id = 3;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-10', 'DeliveryToCustomer' FROM Orders WHERE order_id = 1;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-10', 'CustomerAssignment' FROM Orders WHERE order_id = 2;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-10', 'DeliveryToCustomer' FROM Orders WHERE order_id = 3;

INSERT INTO Events (order_id, event_date, event_type)
SELECT order_id, '2023-06-11', 'CustomerCancellation' FROM Orders WHERE order_id = 2;

-- Tworzenie tabeli KPI i wprowadzanie danych

CREATE TABLE IF NOT EXISTS DailyKPIs (
  execution_date DATE PRIMARY KEY,
  orders_finalized INTEGER NOT NULL,
  orders_in_progress INTEGER NOT NULL,
  customer_order_bank INTEGER NOT NULL
);

INSERT INTO DailyKPIs (execution_date, orders_finalized, orders_in_progress, customer_order_bank)
SELECT
  TO_DATE('$1','YYYY-MM-DD') as date,
  COUNT(CASE WHEN a.event_type = 'DeliveryToCustomer' and a.event_date='$1' THEN a.order_id END) AS orders_finalized,
  COUNT(CASE WHEN a.event_type = 'OrderIssue' AND a.event_date<='$1' AND '$1'<COALESCE(b.event_date,TO_DATE('$1','YYYY-MM-DD')+ INTERVAL '1 DAY') THEN a.order_id END) AS orders_in_progress,
  COUNT(CASE WHEN a.event_type = 'CustomerAssignment' AND a.event_date<='$1' AND '$1'<COALESCE(b.event_date,TO_DATE('$1','YYYY-MM-DD')+ INTERVAL '1 DAY') THEN a.order_id END)-COUNT(CASE WHEN a.event_type = 'CustomerCancellation' AND a.event_date<='$1' AND '$1'<COALESCE(b.event_date,TO_DATE('$1','YYYY-MM-DD')+ INTERVAL '1 DAY') THEN a.order_id END) AS customer_order_bank
FROM EVENTS a
LEFT JOIN 
(SELECT order_id, event_date FROM EVENTS WHERE event_type='DeliveryToCustomer') b
ON a.order_id=b.order_id
GROUP BY date;

EOF
