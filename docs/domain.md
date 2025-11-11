Entities
* Actor(id, name, type, region) type ∈ {HARVESTER,FPO,PROCESSOR,WAREHOUSE,EXPORTER,RETAILER}
* Location(id, actorId, name, coords)
* Product(id, name, category, unit) unit ∈ {KG,G,L}
* Lot(id, productId, sourceActorId, harvestedAt, status, quantity, unit)
* QCInspection(id, lotId, inspectedAt, result, notes)
* Certificate(id, lotId, scheme, number, validFrom, validTo)
* Transfer(id, lotId, fromActorId, toActorId, shippedAt, receivedAt, status, quantityShipped, quantityReceived)
* ChainEvent(id, aggregateType, aggregateId, type, occurredAt, payloadJson, prevHash, hash)

Invariants
* Lot: status ∈ {CREATED,AVAILABLE,IN_TRANSFER,CONSUMED}. Quantity ≥ 0. Unit immutable.
* Transfer: cannot SHIP unless lot=AVAILABLE and quantityShipped ≤ lot.quantity. RECEIVE sets lot.status=AVAILABLE and increases toActor holdings. Partial receive allowed if quantityReceived ≤ quantityShipped.
* QC must reference existing Lot. Certificates date-ranges valid.
* Actor type gate: only PROCESSOR/WAREHOUSE/EXPORTER/RETAILER can receive transfers.

Indexes
* lot(product_id), lot(source_actor_id), transfer(lot_id), transfer(to_actor_id,status), certificate(lot_id), qinspection(lot_id), actor(type,region).