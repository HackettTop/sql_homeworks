--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--�������: ��� ������� ������ ���������� ����� �������� ����� ������, ����������� � ���������.
-- �������: ����� � ����� ����������� ��������.

select class, count(result)
from (select *
from outcomes o 
join ships s 
on o.ship = s."name"
where o.result = 'sunk') a
group by class


--task2
--�������: ��� ������� ������ ���������� ���, ����� ��� ������ �� ���� ������ ������� ����� ������. 
--���� ��� ������ �� ���� ��������� ������� ����������, ���������� ����������� ��� ������ �� ���� �������� ����� ������.
-- �������: �����, ���.
select "class", min(launched)
from ships s 
group by "class" 

--task3
--�������: ��� �������, ������� ������ � ���� ����������� �������� � �� ����� 3 �������� � ���� ������, 
--������� ��� ������ � ����� ����������� ��������.
select *
from (select class, count(result)
from (select *
from outcomes o 
join ships s 
on o.ship = s."name"
where o.result = 'sunk') a
group by class) b
where count >= 3 



--task4
--�������: ������� �������� ��������, ������� ���������� ����� ������ ����� ���� �������� ������ �� ������������� 
--(������ ������� �� ������� Outcomes).

SELECT name
FROM (SELECT O.ship AS name, numGuns, displacement
FROM Outcomes O 
join Classes C 
ON O.ship = C.class AND
O.ship NOT IN (SELECT name
FROM Ships
)
UNION
SELECT S.name AS name, numGuns, displacement
FROM Ships S 
join Classes C 
ON S.class = C.class
) OS 
join (SELECT MAX(numGuns) AS MaxNumGuns, displacement
FROM Outcomes O
join Classes C
ON O.ship = C.class AND
O.ship NOT IN (SELECT name
FROM Ships
)
GROUP BY displacement
UNION
SELECT MAX(numGuns) AS MaxNumGuns, displacement
FROM Ships S 
join Classes C 
ON S.class = C.class
GROUP BY displacement
) GD ON OS.numGuns = GD.MaxNumGuns AND
OS.displacement = GD.displacement
                       
--task5
--������������ �����: ������� �������������� ���������, ������� ���������� �� � ���������� ������� RAM � � ����� ������� ����������� 
--����� ���� ��, ������� ���������� ����� RAM. �������: Maker

select maker
from product p
join printer p2 
on p.model = p2.model 
where maker in (select maker from product p3
				join pc p4
				on p3.model = p4.model
				where speed = (select max(speed) from (select * from pc p6
													join product p5 
													on p6.model = p5.model 
													where ram = (select min(ram) from pc)) a ))

--task17
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.
select battle 
from outcomes o 
where ship  in (select ships."name" from ships where ships."class" = 'Kongo')

