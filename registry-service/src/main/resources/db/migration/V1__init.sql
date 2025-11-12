create table actor (
  id uuid primary key,
  name varchar(200) not null,
  type varchar(20) not null check (type in ('HARVESTER','FPO','PROCESSOR','WAREHOUSE','EXPORTER','RETAILER')),
  region varchar(100)
);
create index idx_actor_type_region on actor(type, region);

create table product (
  id uuid primary key,
  name varchar(200) not null,
  category varchar(100),
  unit varchar(10) not null check (unit in ('KG','G','L'))
);

create table location (
  id uuid primary key,
  actor_id uuid not null references actor(id),
  name varchar(200) not null,
  lat double precision,
  lng double precision
);
