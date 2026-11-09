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
set re.price = re.price / 2
where
(select first_show_time from first_shows where first_shows.estate_id = re.id)
>
(select avg(first_show_time) from first_shows)
