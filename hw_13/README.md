**Домашнее задание №13: Создаем отчетную выборку**

- для магазина к предыдущему списку продуктов добавить максимальную и минимальную цену и кол-во предложений

```
SELECT
    r.id as product_id,
    MAX(r.price) as max_price,
    MIN(r.price) as min_price,
    COUNT(r.id) as product_cnt
(SELECT 
	p1.id, 
	p2.price
FROM products p1
INNER JOIN price p2
ON p1.price_id = p2.id) r
GROUP BY r.id WITH ROLLUP;
```

- сделать выборку показывающую самый дорогой и самый дешевый товар в каждой категории

```
WITH result AS (
SELECT 
	p1.id as product_id, 
	p2.price,
	c.id as category_id
FROM products p1
INNER JOIN price p2
ON p1.price_id = p2.id
LEFT JOIN
categories c
ON p1.category_id = c.id)

SELECT 
	category_id,
	product_id,
	price
FROM
(SELECT 
	*, 
	ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price) r
FROM result ) rs
WHERE r = 1
ORDER BY category_id
```

- сделать rollup с количеством товаров по категориям

```
-- создадим CTE result как во втором задании, код здесь опущу

SELECT
    category_id
    COUNT(product_id) as product_cnt
FROM result
GROUP BY category_id WITH ROLLUP;
```