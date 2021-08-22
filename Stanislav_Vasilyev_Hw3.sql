--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� � ��������� ���� �������� (pc, printer, laptop). �������: model, maker, type

select * from product p 

--task14 (lesson3)
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"

select *,
case when printer.price > (select avg(price) from printer)
	then 1
	else 0
end flag
from printer  

--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)

select * from ships  where class is null

--task16 (lesson3)
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����.

select name
from (select *, extract (year from date :: date ) as yyyy
from battles) a
where yyyy not in (select launched from ships)

--task17 (lesson3)
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.

select battle
from ships s 
join outcomes o 
on s."name" = o.ship 
where s."class" = 'Kongo'

--task1  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_300) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ > 300.
-- �� view ��� �������: model, price, flag

create view all_products_flag_300 as
select model, price, flag
from (select model, price, case when price > 300 then 1 else 0 end flag from pc 
union all
select model, price, case when price > 300 then 1 else 0 end flag from printer 
union all
select model, price, case when price > 300 then 1 else 0 end flag from laptop) a

--task2  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_avg_price) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ c������ .
-- �� view ��� �������: model, price, flag

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
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

select p.model 
from printer p
join product p1 
on p.model = p1.model 
where maker = 'A'
and 
price > (select avg(price) from printer p3 join product p4 on p3.model = p4.model where maker = 'D' or maker = 'C')

--task4 (lesson4)
-- ������������ �����: ������� ��� ������ ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

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
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (printer & laptop & pc)

select avg(price) 
from 
(select l.model, price, maker  from laptop l join product p1 on l.model = p1.model 
union  
select  p.model, price, maker from printer p join product p1 on p.model = p1.model 
union 
select  p2.model, price, maker from pc p2 join product p1 on p2.model = p1.model ) a
where a.maker = 'A'

--task6 (lesson4)
-- ������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) �� ������� �������������. �� view: maker, count

create view count_products_by_makers as
select maker, count(*) 
from (select l.model, price, maker  from laptop l join product p1 on l.model = p1.model 
union all 
select  p.model, price, maker from printer p join product p1 on p.model = p1.model 
union all 
select  p2.model, price, maker from pc p2 join product p1 on p2.model = p1.model ) a
group by maker

--task7 (lesson4)
-- �� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)
-- � ��������
--task8 (lesson4)
-- ������������ �����: ������� ����� ������� printer (�������� printer_updated) � ������� �� ��� ��� �������� ������������� 'D'

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
-- ������������ �����: ������� �� ���� ������� (printer_updated) view � �������������� �������� ������������� (�������� printer_updated_with_makers)

create view printer_updated_with_makers as
select p.code, p.model, p.color, p.type, p.price, p2.maker 
from printer_updated p 
join product p2 
on p.model = p2.model 

select * from printer_updated_with_makers

--task10 (lesson4)
-- �������: ������� view c ����������� ����������� �������� � ������� ������� (�������� sunk_ships_by_classes). 
--�� view: count, class (���� �������� ������ ���/IS NULL, �� �������� �� 0)

create or replace view sunk_ships_by_classes1 as
select count(*),
case when class is null then '�����������' else class end as class
from (select ship, class
from outcomes o 
left join ships s 
on o.ship = s."name" 
where "result" = 'sunk') a
group by class

select * from sunk_ships_by_classes1

--task11 (lesson4)
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)

--� ��������

--task12 (lesson4)
-- �������: ������� ����� ������� classes (�������� classes_with_flag) � �������� � ��� flag: ���� ���������� ������ ������ ��� ����� 9 - �� 1, ����� 0

create table classes_with_flag as
select *,
case when numguns >= 9 then 1 else 0 end flag
from classes c 

select * from classes_with_flag

--task13 (lesson4)
-- �������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)

--� ��������

--task14 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".

SELECT *
	FROM Ships
	WHERE name like 'O%' 
	or name LIKE 'M%' ;

--task15 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.

select count(*)
from ships s 
where s."name" like '% %'

--task16 (lesson4)
-- �������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)

-- � ��������