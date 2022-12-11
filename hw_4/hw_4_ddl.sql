-- создание БД
create database otus_hw;

-- создание роли
create role anatolii SUPERUSER;

-- созданием схемы
create schema if not exists store;

-- создадим в БД таблицы

create table if not exists store.providers(
id BIGSERIAL PRIMARY KEY,
name varchar(250) not null
);

create table if not exists store.prices(
id BIGSERIAL PRIMARY KEY,
price float not null
);


create table if not exists store.producers(
id BIGSERIAL PRIMARY KEY,
name varchar(250) not null
);


create table if not exists store.categories(
id BIGSERIAL PRIMARY KEY,
name varchar(250) not null
);


create table if not exists store.products(
id BIGSERIAL PRIMARY KEY,
name varchar(250) not null,
price_id BIGINT REFERENCES store.prices(id),
category_id BIGINT REFERENCES store.categories(id)
);

create table if not exists store.customers(
id BIGSERIAL PRIMARY KEY,
first_name varchar(250),
last_name varchar(250),
age int,
gender varchar(5)
);

create table if not exists store.orders(
id BIGSERIAL PRIMARY KEY,
customer_id BIGINT REFERENCES store.customers(id),
order_date timestamp
);

create table if not exists store.products_providers(
id BIGSERIAL PRIMARY KEY,
product_id BIGINT REFERENCES store.products(id) NOT NULL,
provider_id BIGINT REFERENCES store.providers(id) NOT NULL
);

create table if not exists store.providers_producers(
id BIGSERIAL PRIMARY KEY,
producer_id BIGINT REFERENCES store.producers(id) NOT NULL,
provider_id BIGINT REFERENCES store.providers(id) NOT NULL
);

create table if not exists store.products_orders(
id BIGSERIAL PRIMARY KEY,
product_id BIGINT REFERENCES store.products(id) NOT NULL,
order_id BIGINT REFERENCES store.orders(id) NOT NULL,
quantity integer
);
