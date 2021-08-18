--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

Задание 1: Вывести name, class по кораблям, выпущенным после 1920
SELECT name, class
FROM ships
WHERE launched > 1920

Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
SELECT name, class
FROM ships
WHERE launched > 1920
and launched < 1942

Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
select count(name), class
from ships s 
group by class

Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
select class, country
from classes c 
where bore >= 16

Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
select ship
from outcomes o 
where battle = 'North Atlantic'

Задание 6: Вывести название (ship) последнего потопленного корабля

select   ship 
from  battles b 
join  outcomes o2
on b."name" = o2.battle 
where result = 'sunk' and date = (select max(date) from battles b join outcomes o2 on b."name" = o2.battle )

Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля

select name, classes."class" from classes
join ships
on classes."class" = ships."class" 
where name in (select ship from outcomes join battles
				on outcomes.battle = battles."name" 
				where "result" = 'sunk' 
				and date = (select max(date) from outcomes
							join battles
							on outcomes.battle = battles."name"
							where "result" = 'sunk')
							)

Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class

select ship, s2."class"
from outcomes o 
join ships s2 
on o.ship = s2."name" 
where "result" = 'sunk' and ship in (select ship from ships s join classes c on s."class" = c."class" where c.bore >= 16)


Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
select class 
from classes c 
where country = 'USA'

Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class
select s."name" , s."class"
from ships s 
join classes c 
on s."class" = c."class" 
where s."class" in (select class  from classes c where country = 'USA')