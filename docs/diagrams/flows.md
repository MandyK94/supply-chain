# Wyldtrace Supply Chain Diagrams

## Context Diagram
```mermaid
flowchart LR
  subgraph Harvest
    H1[Harvester or FPO] -->|Harvest Data| GW[Gateway Service]
  end

  subgraph Processing
    P1[Processor or Warehouse] -->|Batch Update| GW
  end

  subgraph Trade
    E1[Exporter or Brand] -->|Shipment Update| GW
  end

  subgraph RegistryLayer
    GW --> RS[Registry Service]
    RS --> BC[Hyperledger Network]
    RS --> DB[PostgreSQL Offchain DB]
  end

  subgraph Identity
    U[User or Admin] --> IS[Identity Service]
    IS --> RS
  end

  subgraph Consumer
    QR[Consumer QR Scan] --> CA[Consumer API]
    CA --> RS
  end

  RS --> AN[Analytics Service]
  AN --> GF[Grafana Monitoring]

  style BC fill:#c2e0ff,stroke:#0077cc,stroke-width:2px
  style RS fill:#ffefa0,stroke:#b59f00
  style GW fill:#ffe0b3,stroke:#b57900
  style CA fill:#d2ffcc,stroke:#009933

```

```mermaid
sequenceDiagram
  participant Staff as Staff UI
  participant Gateway
  participant Registry as registry-service
  participant Lot as lot-service
  participant Transfer as transfer-service
  participant Audit as audit-service
  participant Consumer as consumer-api

  Staff->>Gateway: POST /lot/lots (create)
  Gateway->>Lot: create lot
  Lot-->>Audit: LotCreated event (Kafka)
  Staff->>Gateway: POST /transfer/transfers (create)
  Gateway->>Transfer: create transfer
  Transfer-->>Audit: TransferCreated
  Staff->>Gateway: POST /transfer/{id}/ship
  Transfer-->>Audit: TransferShipped
  Staff->>Gateway: POST /transfer/{id}/receive
  Transfer-->>Audit: TransferReceived
  Consumer->>Gateway: GET /consumer/trace/{qrId}
  Gateway->>Consumer: resolve denormalized trace
```

```mermaid
sequenceDiagram
  participant Transfer
  participant Registry
  participant Lot
  Transfer->>Lot: validate lot status AVAILABLE
  Transfer->>Registry: validate toActor type ∈ {PROCESSOR,WAREHOUSE,EXPORTER,RETAILER}
  Transfer->>Transfer: check qtyReceived ≤ qtyShipped
  Transfer-->>Lot: set lot.status=AVAILABLE, adjust quantities
```