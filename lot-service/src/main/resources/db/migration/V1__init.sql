create table lot (
    id uuid primary key,
    product_id uuid not null,
    source_actor_id uuid not null,
    harvested_at timestamptz not null,
    quantity numeric not null check (quantity>=0),
    unit varchar(10) not null check (unit in ('KG', 'G', 'L')),
    status varchar(20) not null check (status in ('CREATED', 'AVAILABLE', 'IN_TRANSFER', 'CONSUMED'))
);
create index ids_lot_product on lot(product_id);
create index idx_lot_source on lot(source_actor_id);

create table qc_inspection(
    id uuid primary key,
    lot_id uuid not null references lot(id),
    inspected_at timestamptz not null,
    result varchar(10) not null check (result in ('PASS', 'FAIL')),
    notes text 
);

create table certificate (
    id uuid primary key,
    lot_id uuid not null references lot(id),
    scheme varchar(100) not null,
    number varchar(100) not null,
    valid_from date not nul,
    valid_to date not_null,
    check (valid_from<=valid_to)
);