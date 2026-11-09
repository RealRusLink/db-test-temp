-- середня заявлена ціна об'єкту нерухомості кожного типу
select avg(price) from RealEstate
group by type_id


-- агенти з найбільшою кількістю продажів за останній рік
select * from (
select count(*) as sells, ag.id as agent_id from
Agent ag inner join Management ma
on ag.id = ma.agent_id
inner join Showing sh
on sh.management_id = ma.id
inner join Sell s
on s.showing_is = sh.id
where (CURRENT_TIMESTAMP - s.time) <= interval '1y'
group by ag.id
)
order by sells
limit 10 -- тут кількість агентів з найбільшою кількістю продаж

-- об'єкти нерухомості з найбільшою кількістю оглядів, але без продажу
with badly_selling as (select re.id as estate_id, count(*) as showings from
RealEstate re inner join Management ma
on re.id = ma.estate_id
inner join Showing sh
on ma.id = sh.management_id
left join Sell s
on sh.id = s.showing_id
where s.id IS NULL
group by re.id
order by count(*)
limit 10 -- тут кількість об'єктів нерухомості з найбільшою кількостю оглядів та без продажу(можна прибрати)
)

-- середній час на ринку до продажу
select avg(CURRENT_TIMESTAMP - s.time) from
RealEstate re inner join Management ma
on re.id = ma.estate_id
inner join Showing sh
on ma.id = sh.management_id
inner join Sell s
on sh.id = s.showing_id
