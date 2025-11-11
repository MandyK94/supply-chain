Roles
* ADMIN, ORG_ADMIN, STAFF, READONLY, CONSUMER (public only).

JWT claims
* sub, exp, roles, actorId, tenant (if multi-tenant later).

AuthZ rules
* Registry write: ORG_ADMIN|ADMIN.
* Lot create/QC/cert: STAFF at sourceActorId.
* Transfer ship: STAFF at fromActorId.
* Transfer receive: STAFF at toActorId.
* Consumer API: no auth, rate-limited.