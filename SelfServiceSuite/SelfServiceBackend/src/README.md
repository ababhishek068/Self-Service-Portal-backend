# Self Service Backend — `src/` layout

Layered architecture aligned with the React portal. Each folder has a single
responsibility; route files stay thin and delegate to domain/services code.

```
src/
├── app/                    # Application bootstrap
│   ├── server.ts           # Express app wiring
│   └── errorHandler.ts     # Global error middleware
├── config/                 # Typed environment configuration
├── domain/                 # Business rules & BC mappings (no HTTP)
│   ├── approval/
│   └── erp/
├── infrastructure/         # External systems & cross-cutting I/O
│   ├── bc/                 # OData / SOAP client
│   └── logging/
├── middleware/             # Express middleware (auth, JWT)
├── services/               # Use-case logic (no HTTP)
│   └── leave/              # Leave date & half-day BC formatting
├── routes/                 # HTTP adapters — map requests to services
│   ├── auth.routes.ts
│   ├── staff.routes.ts     # Legacy ESS session routes (leave, attendance)
│   ├── modules.routes.ts   # Per-module /api/staff/:module routes
│   ├── portal.routes.ts    # JWT JSON API for the React SPA
│   └── erp.routes.ts       # Diagnostic ERP proxy routes
└── shared/                 # Framework-agnostic helpers
    ├── asyncHandler.ts
    ├── odataHelpers.ts
    ├── portalError.ts
    └── sessionUser.ts
```

## SOLID conventions

- **Single responsibility** — routes handle HTTP; `domain/` holds BC table IDs and
  ERP field mappings; `infrastructure/bc` owns transport to Business Central.
- **Open/closed** — new request modules extend `MODULE_SPECS` in
  `routes/modules.routes.ts` without changing the generic router builder.
- **Dependency inversion** — routes depend on `domain` and `infrastructure`
  abstractions, not raw curl details.

## Run

```bash
npm run dev    # watches src/app/server.ts
```
