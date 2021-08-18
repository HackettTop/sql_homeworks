--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

������� 1: ������� name, class �� ��������, ���������� ����� 1920
SELECT name, class
FROM ships
WHERE launched > 1920

������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942
SELECT name, class
FROM ships
WHERE launched > 1920
and launched < 1942

������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class
select count(name), class
from ships s 
group by class

������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)
select class, country
from classes c 
where bore >= 16

������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.
select ship
from outcomes o 
where battle = 'North Atlantic'

������� 6: ������� �������� (ship) ���������� ������������ �������

select   ship 
from  battles b 
join  outcomes o2
on b."name" = o2.battle 
where result = 'sunk' and date = (select max(date) from battles b join outcomes o2 on b."name" = o2.battle )

������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������

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

������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class

select ship, s2."class"
from outcomes o 
join ships s2 
on o.ship = s2."name" 
where "result" = 'sunk' and ship in (select ship from ships s join classes c on s."class" = c."class" where c.bore >= 16)


������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class
select class 
from classes c 
where country = 'USA'

������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class
select s."name" , s."class"
from ships s 
join classes c 
on s."class" = c."class" 
where s."class" in (select class  from classes c where country = 'USA')