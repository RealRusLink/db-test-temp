create table RealEstate(
    id UUID PRIMARY KEY,
    type_id UUID NOT NULL,
    owner_id UUID NOT NULL,
    address varchar(256) NOT NULL,
    price decimal NOT NULL,
    rooms uint NOT NULL,
    registration timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT rooms_limit CHECK(rooms > 0 AND rooms < 1000),
    CONSTRAINT price_limit CHECK(price > 0),
    CONSTRAINT type_FK FOREIGN KEY(type_id) REFERENCES EstateType(id),
    CONSTRAINT owner_FK FOREIGN KEY(owner_id) REFERENCES Client(id)
);

create table Client(
    id UUID PRIMARY KEY,
    contact varchar(256)
);

create table Agent(
    id UUID PRIMARY KEY,
    type_id UUID NOT NULL,
    CONSTRAINT type_FK FOREIGN KEY(type_id) REFERENCES EstateType(id)
);

create table EstateType(
    id UUID PRIMARY KEY,
    type varchar(256) NOT NULL UNIQUE
);

create table Management(
    id UUID PRIMARY KEY,
    estate_id UUID NOT NULL,
    agent_id UUID,
    CONSTRAINT estate_FK FOREIGN KEY(estate_id) REFERENCES RealEstate,
    CONSTRAINT agent_FK FOREIGN KEY(agent_id) REFERENCES Agent,
    CONSTRAINT pair_KEY UNIQUE(estate_id, agent_id)
);

create table Showing(
    id UUID PRIMARY KEY,
    management_id UUID NOT NULL,
    buyer_id UUID NOT NULL,
    time TIMESTAMP NOT NULL
);

create table Sell(
    id UUID PRIMARY KEY,
    management_id UUID NOT NULL,
    time timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    price decimal NOT NULL,
    CONSTRAINT management_FK FOREIGN KEY(management_id) REFERENCES Management,
    CONSTRAINT price_limit CHECK(price > 0)
);
