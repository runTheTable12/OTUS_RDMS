**Домашняя работа №18: Анализ и профилирование запроса**

Поскольу у меня особо данных в БД нет, то буду тренироваться на других данных.
Утащил скрипт для инициализации БД [отсюда](https://github.com/hhorak/mysql-sample-db)

Создадим следующий запрос

```
SELECT * 
FROM
(SELECT 
  lastName, 
  firstName, 
  jobTitle, 
  reportsTo, 
  country, 
  phone 
FROM employees e 
LEFT JOIN offices o 
ON e.officeCode = o.officeCode) t 
WHERE country = 'USA' 
AND jobTitle LIKE 'Sale%' 
AND phone LIKE '%8%' 
AND country IN ('USA', 'UK') 
AND reportsTo IN (
                SELECT employeeNumber FROM employees WHERE email LIKE '%tt%');
```

На мой взгляд, подзапросы замедляют работу чтения.
Попробуем сократить их количество. Сразу видна ошибка - два раза фильтровал по полю country - достаточно только одного. Так как в UK всё равно никого нет, то оставлю условию country = 'USA'. Знаю, что на postgres движок самостоятельно оптимизирует оператор IN, превращая его в запрос вида ANY([array]). В MySQL такого вроде нет.

Поиск с оператором **LIKE** также тяжёлый. Здесь происходит поиск по тексу, попробую накинуть полнотекстовый поиск на название должности.

```
CREATE FULLTEXT INDEX emp_jobTitle_idx ON employees(jobTitle);
```

Странно, при создании этого индекса перестала делаться выборка. Видимо, придётся отказаться от этой идеи. 

Также попробую сделать вместо подзапроса self-join. 

В результате получился такой запрос. Результат выборки одинаков с первоначальным.

```
SELECT 
  e.lastName, 
  e.firstName, 
  e.jobTitle, 
  e.reportsTo, 
  country, 
  phone 
FROM employees e 
LEFT JOIN offices o 
ON e.officeCode = o.officeCode 
LEFT JOIN employees e2 
ON e.employeeNumber = e2.reportsTo 
WHERE o.country = 'USA' 
AND e.jobTitle LIKE 'Sale%' 
AND phone LIKE '%8%' 
AND e2.email like '%tt%';
```

В итоге, запрос стал ещё дольше. Результаты можно посмотреть здесь [до](explain_before.json) и здесь [после](explain_after.json) 
Также пробовал поменять LEFT JOIN на INNER JOIN, но EXPLAIN оказался таким же. 
