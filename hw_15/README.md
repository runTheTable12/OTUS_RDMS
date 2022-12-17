**Домашнее задание №15: Добавляем в базу хранимые процедуры и триггеры**

- Создать пользователей client, manager.

```
CREATE USER client IDENTIFIED WITH caching_sha2_password BY 'client';
CREATE USER manager IDENTIFIED WITH caching_sha2_password BY 'manager';
```

- Создать процедуру выборки товаров с использованием различных фильтров: категория, цена, производитель, различные дополнительные параметры.Также в качестве параметров передавать по какому полю сортировать выборку, и параметры постраничной выдачи

Создадим процедуру, которая находит по указанной цене, категории товара, или названию поставщика.
```
CREATE procedure product_fillter(IN category_name varchar(250), 
                                 IN provider_name varchar(250), 
                                 IN price float,
                                 IN sort_col varchar(250),
                                 IN res_lim int , 
                                 IN res_ofs int)
BEGIN
    select p1.name as product, p2.name as provider, c.name as category, p3.price as price
    from products_providers pp
         LEFT JOIN products p1
         ON pp.product_id = p1.id
         LEFT JOIN providers p2
         ON pp.product_id = p2.id
         LEFT JOIN prices p3
         ON p1.price_id = p3.id
         LEFT JOIN categories c
         ON p1.category_id = c.id
         WHERE (p3.price = price OR price is null) 
           AND (p2.name  = provider_name OR provider_name is null) 
           AND (c.name = category_name OR category_name is null) 
         order by sort_col 
         limit res_lim
         offset res_ofs; 
END
```

- дать права на запуск процедуры пользователю client

```
GRANT EXECUTE ON PROCEDURE otus_hw.product_fillter TO 'client'@'%';
```

- Создать процедуру get_orders - которая позволяет просматривать отчет по продажам за определенный период (час, день, неделя) с различными уровнями группировки (по товару, по категории, по производителю)

```
CREATE PROCEDURE get_orders(date_from TIMESTAMP, date_to TIMESTAMP, group_col varchar(250))

BEGIN
    SELECT o.id, o.order_date 
    FROM orders o 
    LEFT JOIN products_orders po
    ON o.order_id = po.order_id
    LEFT JOIN products p
    ON po.product_id  = p.id
    LEFT JOIN categories c
    ON p.category_id = c.id
    LEFT JOIN products_providers pp
    ON p.id = pp.product_id
    LEFT JOIN providers p2
    ON pp.provider_id = p2.id
    where s.date between date_from AND date_to
    group by group_col;
END
```

- Права дать пользователю manager

```
GRANT EXECUTE ON PROCEDURE otus_hw.get_orders TO 'manager'@'%';
```