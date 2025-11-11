Bounded contexts<br>
* Identity: users, roles, JWT, actor linkage.
* Registry: actors, locations, products.
* Lot: lot lifecycle, QC, certificates.
* Transfer: chain-of-custody, shipments, receipts.
* Audit: immutable event log + hash chaining.
* Consumer: public trace read model.
* Legacy: SOAP bridge.
* Analytics: read models/KPIs.

Context map
* Identity authenticates all staff services.
* Registry is upstream for IDs referenced by Lot and Transfer.
* Lot and Transfer publish events to Kafka.
* Audit consumes all domain events.
* Consumer subscribes to Audit or denormalized projections.
