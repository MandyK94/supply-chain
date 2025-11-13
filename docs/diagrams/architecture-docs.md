# Wyldtrace Architecture Documentation

---

## 1. Context Diagram
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
## 2. Container Diagram
```mermaid
flowchart TD
  user[Web / Mobile User]
  browser[React Frontend]
  gateway[Spring Boot Gateway]
  identity[Identity Service]
  registry[Registry Service]
  lot[Lot Service]
  transfer[Transfer Service]
  audit[Audit Service]
  blockchain[(Hyperledger Node)]
  db[(PostgreSQL)]
  analytics[Analytics + Grafana]

  user --> browser --> gateway
  gateway --> identity
  gateway --> lot
  gateway --> transfer
  gateway --> registry
  registry --> blockchain
  registry --> db
  audit --> db
  audit --> analytics
```

## 3. Event Flow Map
```mermaid
flowchart LR
  subgraph KafkaTopics
    T1((lot.created))
    T2((transfer.created))
    T3((transfer.shipped))
    T4((transfer.received))
  end

  LotService -->|publish| T1
  TransferService -->|publish| T2
  TransferService -->|publish| T3
  TransferService -->|publish| T4

  AuditService -->|consume| T1
  AuditService -->|consume| T2
  AuditService -->|consume| T3
  AuditService -->|consume| T4

  AnalyticsService -->|consume| T1
  AnalyticsService -->|consume| T4
```

## 4. Event Flow Map
```mermaid
stateDiagram-v2
  [*] --> CREATED
  CREATED --> SHIPPED : Transfer created
  SHIPPED --> RECEIVED : Transfer received
  RECEIVED --> VERIFIED : QA check passed
  VERIFIED --> CLOSED : Lot consumed/exported
  CLOSED --> [*]
```


## 5. CI/CD Pipeline Flow
```mermaid
flowchart LR
  dev[Developer Push]
  gh[GitHub Actions CI]
  mvn[Build + Test + Package]
  docker[Docker Build + Tag]
  registry[(Docker Registry)]
  deploy[AWS ECS / EC2 Deploy]
  monitor[Grafana + Alerts]

  dev --> gh
  gh --> mvn --> docker --> registry
  registry --> deploy --> monitor
```

---

## 6. Data Model (ER Diagram)
```mermaid
erDiagram
    ACTOR {
        string actor_id
        string name
        string type  
        string org_id
    }
    %% Mermaid comment
    %% type allowed values: FPO, PROCESSOR, EXPORTER, RETAILER

    ORGANIZATION {
        string org_id
        string name
        string region
        string certification
    }

    LOT {
        string lot_id
        string species
        float weight_kg
        string status  
        string actor_id
        datetime created_at
    }
    %% Mermaid comment
    %% status allowed values: CREATED, SHIPPED, RECEIVED, VERIFIED, CLOSED

    TRANSFER {
        string transfer_id
        string from_actor
        string to_actor
        string lot_id
        float qty_shipped
        float qty_received
        datetime shipped_at
        datetime received_at
    }

    AUDIT_EVENT {
        string event_id
        string type
        string ref_id
        string tx_hash
        datetime timestamp
    }

    LOT ||--o{ TRANSFER : has
    ACTOR ||--o{ LOT : owns
    ORGANIZATION ||--o{ ACTOR : includes
    TRANSFER ||--o{ AUDIT_EVENT : triggers
```

## 7. Deployment Topology (AWS Infrastructure)
```mermaid
flowchart TB
  subgraph AWS
    subgraph VPC
      subgraph PublicSubnet
        LB[Load Balancer]
      end

      subgraph PrivateSubnet
        GW[Gateway Service]
        ID[Identity Service]
        REG[Registry Service]
        LOT[Lot Service]
        TR[Transfer Service]
        AUD[Audit Service]
        AN[Analytics Service]
        DB[(RDS PostgreSQL)]
        HL[Hyperledger Peer Node]
      end
    end

    subgraph Monitoring
        GF[Grafana]
        PR[Prometheus]
    end
  end

  User[Frontend / Browser] --> LB --> GW
  GW --> ID & REG & LOT & TR & AUD
  REG --> HL
  REG --> DB
  AUD --> DB
  AN --> GF
  PR --> GF
```

## 8. Registry Service — Internal Component Diagram (C4 L3)
```mermaid
flowchart LR
  subgraph Registry-Service
    C[REST controllers]
    V[Validators]
    S[Application services]
    R[Repositories]
    O[Outbox publisher]
    L[Event listeners]
  end

  DB[(PostgreSQL)]
  KIn((kafka: cmd.registry.*))
  KEv((kafka: evt.registry.*))

  C --> V --> S --> R --> DB
  S --> O --> KEv
  L --> S
  KIn --> L
```


---

## 9. Login Sequence — OIDC Authorization Code (Recommended)
```mermaid
sequenceDiagram
  participant U as User-Browser
  participant FE as Frontend
  participant GW as Gateway
  participant KC as Keycloak
  participant ID as Identity-Service

  U->>FE: Open app
  FE->>GW: GET /app
  alt no-valid-token
    FE->>KC: Redirect to /authorize
    KC-->>U: Login form
    U->>KC: Credentials
    KC-->>FE: Redirect with code
    FE->>KC: POST /token (code)
    KC-->>FE: access_token + id_token
  end

  FE->>GW: GET /api/me (Authorization: Bearer token)
  GW->>ID: /me (propagate JWT)
  ID-->>GW: actor-profile
  GW-->>FE: actor-profile
```