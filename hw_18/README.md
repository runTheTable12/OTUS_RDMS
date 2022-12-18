**Домашняя работа №18: Анализ и профилирование запроса**

Поскольу у меня особо данных в БД нет, то буду тренироваться на других данных.
Утащил скрипт для инициализации БД [отсюда](https://github.com/hhorak/mysql-sample-db)

Создадим следующий запрос

```
select * from (select lastName, firstName, jobTitle, reportsTo, country, phone from employees e left join offices o ON e.officeCode = o.officeCode) t where country = 'USA' and jobTitle like 'Sale%' and phone like '%8%' and country in ('USA', 'UK') and reportsTo in (select employeeNumber from employees where email like '%tt%');
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
select e.lastName, e.firstName, e.jobTitle, e.reportsTo, country, phone from employees e left join offices o ON e.officeCode = o.officeCode left join employees e2 ON e.employeeNumber = e2.reportsTo where o.country = 'USA' and e.jobTitle like 'Sale%' and phone like '%8%' and e2.email like '%tt%';
```

В итоге, запрос стал ещё дольше. Результаты можно посмотреть здесь [до](explain_before.json) и здесь [после](explain_after.json)