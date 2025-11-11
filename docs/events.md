Commands
* CreateActor, CreateProduct, CreateLot, RecordQC, AttachCertificate,
* ShipTransfer, ReceiveTransfer, CancelTransfer, ConsumeLot.

Events
* ActorCreated, ProductCreated,
* LotCreated, LotUpdated, QCRecorded, CertificateAttached, LotConsumed,
* TransferShipped, TransferReceived, TransferCancelled.

Topics
* lot.events, transfer.events, registry.events. DLQ per service.

Idempotency
* Use x-request-id header. De-dup table keyed on (service, requestId).