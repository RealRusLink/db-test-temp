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
