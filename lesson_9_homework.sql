--task6 (lesson9)
-- Компьютерная фирма: Получить количество ПК и среднюю цену для каждой модели, средняя цена которой менее 800
select model, avg(price)
from pc 
group by model 
having avg(price) < 800;
 
--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
SELECT
   CASE WHEN G.Grade > 7 THEN S.Name ELSE 'NULL' END as Name
    , G.Grade
    , S.Marks
FROM Students S
JOIN Grades G ON S.Marks BETWEEN G.Min_Mark AND G.Max_Mark
ORDER BY G.Grade DESC, Name , S.Marks ;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

select Doctor, Professor, Singer, Actor 
from (select Name,Occupation,
      row_number() over(partition by Occupation order by Name) as rn
      from Occupations)
pivot(min(Name) for Occupation in ('Doctor' as Doctor, 'Professor' as Professor, 'Singer' as Singer, 'Actor' as Actor))
order by rn;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem
select distinct city from station
where regexp_like(city, '^[^ A, E, I, O, U, a, e, i, o, u]');
--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city 
from station
WHERE regexp_like(city, '[^ A, E, I, O, U, a, e, i, o, u]$');

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct city
from station
where regexp_like(city, '^[^ A, E, I, O, U, a, e, i, o, u]|[^ A, E, I, O, U, a, e, i, o, u]$');

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct city
from station
where regexp_like(city, '^[^ A, E, I, O, U, a, e, i, o, u].*[^ A, E, I, O, U, a, e, i, o, u]$');

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name from Employee
where salary > 2000
and months < 10
order by employee_id;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select 
    case when grade > 7 then Name
    else Null
    end Name,
    Grade, Marks from Students
JOIN Grades ON Students.Marks BETWEEN Min_Mark AND Max_Mark
order by grade desc, Name, Marks;

