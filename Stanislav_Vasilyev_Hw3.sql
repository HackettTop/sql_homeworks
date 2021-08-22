--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

select * from product p 

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
case when printer.price > (select avg(price) from printer)
	then 1
	else 0
end flag
from printer  

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select * from ships  where class is null

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

select name
from (select *, extract (year from date :: date ) as yyyy
from battles) a
where yyyy not in (select launched from ships)

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select battle
from ships s 
join outcomes o 
on s."name" = o.ship 
where s."class" = 'Kongo'

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300.
-- Во view три колонки: model, price, flag

create view all_products_flag_300 as
select model, price, flag
from (select model, price, case when price > 300 then 1 else 0 end flag from pc 
union all
select model, price, case when price > 300 then 1 else 0 end flag from printer 
union all
select model, price, case when price > 300 then 1 else 0 end flag from laptop) a

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней .
-- Во view три колонки: model, price, flag

create view all_products_flag_avg_price as
select model, price,
case when price > (select avg(price) from (select model, price from pc 
union all
select model, price from printer 
union all
select model, price from laptop) b )
then 1
else 0
end flag
from (select model, price from pc 
union all
select model, price from printer 
union all
select model, price from laptop) a

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

select p.model 
from printer p
join product p1 
on p.model = p1.model 
where maker = 'A'
and 
price > (select avg(price) from printer p3 join product p4 on p3.model = p4.model where maker = 'D' or maker = 'C')

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

select a.model
from 
(select l.model, price, maker  from laptop l join product p1 on l.model = p1.model 
union all 
select  p.model, price, maker from printer p join product p1 on p.model = p1.model 
union all 
select  p2.model, price, maker from pc p2 join product p1 on p2.model = p1.model ) a
where a.maker = 'A'
and 
a.price > (select avg(price) from printer p3 join product p4 on p3.model = p4.model where maker = 'D' or maker = 'C')

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

select avg(price) 
from 
(select l.model, price, maker  from laptop l join product p1 on l.model = p1.model 
union  
select  p.model, price, maker from printer p join product p1 on p.model = p1.model 
union 
select  p2.model, price, maker from pc p2 join product p1 on p2.model = p1.model ) a
where a.maker = 'A'

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as
select maker, count(*) 
from (select l.model, price, maker  from laptop l join product p1 on l.model = p1.model 
union all 
select  p.model, price, maker from printer p join product p1 on p.model = p1.model 
union all 
select  p2.model, price, maker from pc p2 join product p1 on p2.model = p1.model ) a
group by maker

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)
-- В ноутбуке
--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated as
select * from printer

delete from printer_updated
where model in 
	(select p.model 
	from printer p 
	join product p2 
	on p.model = p2.model 
	where maker ='D' )
	
select * from printer_updated

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as
select p.code, p.model, p.color, p.type, p.price, p2.maker 
from printer_updated p 
join product p2 
on p.model = p2.model 

select * from printer_updated_with_makers

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). 
--Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

create or replace view sunk_ships_by_classes1 as
select count(*),
case when class is null then 'отсутствует' else class end as class
from (select ship, class
from outcomes o 
left join ships s 
on o.ship = s."name" 
where "result" = 'sunk') a
group by class

select * from sunk_ships_by_classes1

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

--В ноутбуке

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag as
select *,
case when numguns >= 9 then 1 else 0 end flag
from classes c 

select * from classes_with_flag

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

--в ноутбуке

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

SELECT *
	FROM Ships
	WHERE name like 'O%' 
	or name LIKE 'M%' ;

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(*)
from ships s 
where s."name" like '% %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

-- в ноутбуке