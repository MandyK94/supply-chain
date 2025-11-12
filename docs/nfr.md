* SLOs: p95 latency ≤ 250ms for registry/lot/transfer; 99.9% availability; consumer API cache TTL 5m.
* Throughput: baseline 100 RPS; Kafka retention 7d; DLQ monitored.
* Security: JWT RS256, 15m access, 7d refresh, RBAC enforced at controller and method.
* Observability: Micrometer Prometheus default, logs JSON, correlationId propagated.
* Data: referential integrity at DB, Flyway migrations, UTC timestamps.