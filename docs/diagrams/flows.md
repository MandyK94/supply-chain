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



sequenceDiagram
  participant Transfer
  participant Registry
  participant Lot
  Transfer->>Lot: validate lot status AVAILABLE
  Transfer->>Registry: validate toActor type ∈ {PROCESSOR,WAREHOUSE,EXPORTER,RETAILER}
  Transfer->>Transfer: check qtyReceived ≤ qtyShipped
  Transfer-->>Lot: set lot.status=AVAILABLE, adjust quantities
