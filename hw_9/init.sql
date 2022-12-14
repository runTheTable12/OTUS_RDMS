create database otus_hw;
USE otus_hw;

create table providers(
id integer not null AUTO_INCREMENT PRIMARY KEY,
name varchar(250) not null
);


create table prices(
id integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
price float not null
);


create table producers(
id integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
name varchar(250) not null
);

create table categories(
id integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
name varchar(250) not null);

create table products(
id integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
name varchar(250) not null,
price_id integer,
category_id integer,
FOREIGN KEY(price_id) REFERENCES prices(id),
FOREIGN KEY(category_id) REFERENCES categories(id)
);

create table customers(
id integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name varchar(250),
last_name varchar(250),
age int,
gender char(1)
);

create table orders(
id integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
customer_id integer,
order_date timestamp,
FOREIGN KEY(customer_id) REFERENCES customers(id)
);

create table products_providers(
id integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
product_id integer,
provider_id integer,
FOREIGN KEY(product_id) REFERENCES products(id),
FOREIGN KEY(provider_id) REFERENCES providers(id)
);

create table providers_producers(
id integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
provider_id integer,
producer_id integer,
FOREIGN KEY(producer_id) REFERENCES producers(id),
FOREIGN KEY(provider_id) REFERENCES providers(id)
);

create table products_orders(
id integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
product_id integer,
order_id integer,
quantity integer,
FOREIGN KEY(product_id) REFERENCES products(id),
FOREIGN KEY(order_id) REFERENCES orders(id)
);