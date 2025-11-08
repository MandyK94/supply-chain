# WildTrace Monorepo Skeleton

Monorepo for a supply-chain traceability system for wild harvests.

## Modules
- `gateway/` — Spring Cloud Gateway
- `identity-service/` — Auth, users, roles, JWT
- `registry-service/` — Actors, locations, products
- `lot-service/` — Lot lifecycle, QC, certificates
- `transfer-service/` — Chain-of-custody transfers
- `audit-service/` — Event log and hash chain
- `consumer-api/` — Public QR trace API
- `legacy-adapter/` — SOAP interop demo
- `analytics-service/` — Read models / summaries
- `frontend/` — React 18 + TS (Vite)

## Quickstart (local)
```bash
# Build all services
./mvnw -q -DskipTests package

# Start stack (Postgres, Kafka, Prometheus, Grafana, services, frontend)
docker compose -f deploy/docker-compose.yaml up --build
```
