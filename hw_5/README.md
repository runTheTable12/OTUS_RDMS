**Домашнее задание №5: DML в PostgreSQL**

- Напишите запрос по своей базе с регулярным выражением, добавьте пояснение, что вы хотите найти.

Найдём всех клиентов, чьё имя начинается на *Ал*

```
select id, first_name, last_name from store.customers where first_name like 'Ал%'
```

- Напишите запрос по своей базе с использованием LEFT JOIN и INNER JOIN, как порядок соединений в FROM влияет на результат? Почему?

```
select c.first_name, c.last_name, o.order_date
from store.customers c
INNER JOIN store.orders o
ON c.id = o.client_id 

select p.product_name, c.category_name
from store.products p
LEFT JOIN store.categories c
ON p.category_id = c.id
```
INNER JOIN делает соединение только по значениям полей, которые есть в обоих таблицах. LEFT JOIN оставляет все значения из таблицы слева и делает соедение с правой таблицей, если в правой таблице нет совпадений по значению, то будет NULL. Например, если в базе есть продукты, не принадлежащие в какой-то категории, то при INNER JOIN их бы не было в ответе, в LEFT JOIN они бы попали в ответ, а значение категории было бы NULL.

- Напишите запрос на добавление данных с выводом информации о добавленных строках.

```
insert into store.producers values ('Молочный комбинат') returning id, name;
insert into store.producers values ('Мясной комбинат') returning id, name;
insert into store.producers values ('Пивоварня') returning id, name;
```

- Напишите запрос с обновлением данные используя UPDATE FROM.

```
update p set p.name = p.name || ' Россия' from store.producers p where p.name = 'Пивоварня'
```

- Напишите запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью using.

```
DELETE FROM
store.products p1
USING store.products p2
WHERE
p1.id < p2.id
AND p1.name = p2.name;
```

- Приведите пример использования утилиты COPY (по желанию)

Экспорт результата запроса в файл

```
COPY (SELECT * FROM store.customers WHERE first_name LIKE 'A%') TO '/database/data/query_data.copy
```