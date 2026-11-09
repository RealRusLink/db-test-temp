-- ==================== INSERT ====================
-- коментарі зайві
insert into Client (email, phone_number) values ('some email', 'some number');

insert into EstateType (type) values ('Private house');


-- ==================== UPDATE ====================
-- оновлює назву типу
update EstateType
set type = 'Private'
where type = 'Private house';



-- знижує ціну вдвічі для усіх об'єктів нерухомості
-- для яких перший показ відбувся пізніше за середній на ринку
-- не чіпає нерухомість без показів
with first_shows as (
    select re.id as estate_id, min(sh.time) as first_show_time from
    RealEstate re inner join Management ma
    on re.id = ma.estate_id
    inner join Showing sh
    on ma.id = sh.management_id
    group by re.id)

update RealEstate re
set price = price / 2
from first_shows fs
where re.id = fs.estate_id
  and fs.first_show_time > (
      select to_timestamp(avg(extract(epoch from first_show_time)))
      from first_shows
  );


-- ==================== DELETE ====================
-- видаляє агентів без продажів
delete from Agent ag
where not exists (select 1 from
    Management m inner join Showing sh
    on m.id = sh.management_id
    inner join Sell s
    on s.showing_id = sh.id
    where ag.id = m.agent_id
    );

-- видаляє усю нерухомість з ціною менше десяти
delete from RealEstate
where price < 10


-- ==================== SELECT ====================
-- уся нерухомість яку веде конкретний агент
select re.* from
Management m inner join RealEstate re
on m.estate_id = re.id
where m.agent_id = 'some agent id';

-- усі покази конкретної нерухомості
select sh.* from
RealEstate re inner join Management m
on re.id = m.estate_id
inner join Showing sh
on sh.management_id = m.id
where re.id = 'some estate id'


-- ==================== OLAP ====================
-- середня ціна продажу об'єкту нерухомості кожного типу
select avg(s.price) from
RealEstate re inner join Management ma
on re.id = ma.estate_id
inner join Showing sh
on ma.id = sh.management_id
inner join Sell s
on sh.id = s.showing_id
group by re.type_id;


-- агенти з найбільшою кількістю продажів за останній рік
select * from (
select count(*) as sells, ag.id as agent_id from
Agent ag inner join Management ma
on ag.id = ma.agent_id
inner join Showing sh
on sh.management_id = ma.id
inner join Sell s
on s.showing_id = sh.id
where (CURRENT_TIMESTAMP - s.time) <= interval '1 year'
group by ag.id
) agent_sells
order by agent_sells.sells desc
limit 10; -- тут кількість агентів з найбільшою кількістю продаж

-- об'єкти нерухомості з найбільшою кількістю оглядів, але без продажу
with badly_selling as (
select re.id as estate_id, count(*) as showings from
RealEstate re inner join Management ma
on re.id = ma.estate_id
inner join Showing sh
on ma.id = sh.management_id
left join Sell s
on sh.id = s.showing_id
group by re.id
having count(s.id) = 0
order by count(sh.id) desc
limit 10 -- тут кількість об'єктів нерухомості з найбільшою кількостю оглядів та без продажу(можна прибрати)
)

select * from badly_selling;

-- середній час на ринку до продажу
select avg(re.registration - s.time) from
RealEstate re inner join Management ma
on re.id = ma.estate_id
inner join Showing sh
on ma.id = sh.management_id
inner join Sell s
on sh.id = s.showing_id;
