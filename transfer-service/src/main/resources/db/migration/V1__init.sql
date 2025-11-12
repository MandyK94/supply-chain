create table transfer (
  id uuid primary key,
  lot_id uuid not null,
  from_actor_id uuid not null,
  to_actor_id uuid not null,
  shipped_at timestamptz,
  received_at timestamptz,
  status varchar(20) not null check (status in ('CREATED','SHIPPED','RECEIVED','CANCELLED')),
  quantity_shipped numeric not null check (quantity_shipped >= 0),
  quantity_received numeric check (quantity_received >= 0)
);
create index idx_transfer_lot on transfer(lot_id);
create index idx_transfer_to_status on transfer(to_actor_id, status);
