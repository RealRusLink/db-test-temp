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
