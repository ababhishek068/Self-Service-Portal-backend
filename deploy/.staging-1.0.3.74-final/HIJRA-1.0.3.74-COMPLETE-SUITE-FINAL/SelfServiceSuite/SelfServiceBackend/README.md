# Self Service ERP Backend

Standalone Node backend for the Self Service Portal React app
(`/Users/abhishekbehera/SelfServicePortal/self-service-portal`).

It exposes the JWT/JSON API used by the React SPA and retains the legacy
session-compatible routes from Laravel ESS (`/Users/abhishekbehera/ess`).
Business Central remains the system of record.

It uses the same Business Central endpoints configured in
`/Users/abhishekbehera/ess/config/app.php`:

- OData: `http://erp-app-uat:2448/BC240/ODataV4/Company('HIJRA%20BANK')/`
- SOAP codeunit: `http://erp-app-uat:2447/BC240/WS/HIJRA%20BANK/Codeunit/CuStaffPortal`

## Run

```bash
npm install
npm run dev
```

Default API base URL:

```text
http://localhost:4000/api
```

## React-side configuration

In `/Users/abhishekbehera/SelfServicePortal/self-service-portal/.env`:

```bash
VITE_AUTH_API_URL=http://localhost:4000
VITE_APP_NAME=Self Service Portal
```

## Endpoints

### React JWT API

The React app logs in through `/api/auth/login`, stores the returned token, and
sends it as `Authorization: Bearer <token>`.

| Method | Path                                  | Description |
| ------ | ------------------------------------- | ----------- |
| POST   | `/api/auth/login`                     | BC employee login → `{ token, user }` |
| GET    | `/api/auth/me`                        | Current BC employee |
| POST   | `/api/auth/logout`                    | Client-side JWT logout acknowledgement |
| POST   | `/api/auth/change-password`           | Calls BC SOAP `UpdatePassword` |
| GET    | `/api/dashboard/summary`              | BC dashboard counts |
| GET/POST | `/api/requests`                    | List/create supported BC documents |
| GET    | `/api/requests/:id`                   | Normalized BC request |
| POST   | `/api/requests/:id/cancel`            | Cancel BC approval workflow |
| GET/POST | `/api/approvals/*`                 | BC approval queue and `DocumentApproval` |
| GET/POST | `/api/leave/*`                     | ESS leave OData/SOAP flow |
| GET/POST | `/api/attendance/*`                | ESS attendance OData/SOAP flow |
| GET    | `/api/profile/details`                | BC employee profile |
| GET    | `/api/documents`                      | BC HR document catalog |
| GET    | `/api/documents/:id/download`         | BC policy document attachment |

Supported generic React request modules are `imprest`, `imprestSurrender`,
`staffClaim`, `pettyCash`, `storeRequisition`, `purchaseRequisition`,
`fuelRequest`, `transport`, `maintenance`, and `training`.

Modules without an ESS controller or compatible BC SOAP operation return a
clear `501` response instead of writing to an unrelated BC table.

### Public and legacy session API

| Method | Path                | Description                                  |
| ------ | ------------------- | -------------------------------------------- |
| GET    | `/api/health`       | Liveness probe                               |
| GET    | `/api/config`       | Effective public config (URLs, auth mode)    |
| GET    | `/api/csrf-token`   | Returns `{ token }` for CSRF protection      |
| POST   | `/api/login`        | `{ staffNo, password }` → `{ user }`         |

### Authenticated (session + CSRF)

All routes below require a valid `connect.sid` session cookie set by
`/api/login`. Mutating routes additionally require the `X-CSRF-TOKEN` header
echoed from `/api/csrf-token` (the React `essClient.ts` does this for you).

| Method | Path                                                      | Returns                                  |
| ------ | --------------------------------------------------------- | ---------------------------------------- |
| POST   | `/api/logout`                                             | `{ message }`                            |
| GET    | `/api/me`                                                 | `{ user }`                               |
| GET    | `/api/staff/dashboard/statistics`                         | dashboard counts                         |
| GET    | `/api/staff/approvals?status=Open\|Approved\|Rejected`    | `{ rows, status }`                       |
| GET    | `/api/staff/approvals/count/{type}/{status}`              | per-module counts                        |
| GET    | `/api/staff/approvals/{docNo}`                            | `{ document, approvers }`                |
| POST   | `/api/staff/approvals/decide`                             | calls SOAP `DocumentApproval`            |
| GET    | `/api/staff/leave`                                        | year-to-date leave list                  |
| GET    | `/api/staff/leave/types`                                  | leave-type catalog (gender-filtered)     |
| GET    | `/api/staff/leave/relievers`                              | active employees                         |
| GET    | `/api/staff/leave/balance/{type}`                         | `{ balance, pendingCount, isHourly }`    |
| GET    | `/api/staff/leave/dates/{type}/{days}/{startDate}/{half}` | `{ endDate, returnDate, isWeekend }`     |
| GET    | `/api/staff/leave/{no}`                                   | `{ requisition, approvers, attachments }`|
| POST   | `/api/staff/leave`                                        | create / update leave                    |
| POST   | `/api/staff/leave/cancel`                                 | cancel leave                             |
| GET    | `/api/staff/items`                                        | `{ rows }`                               |
| GET    | `/api/staff/items/store/{store}`                          | `{ rows }`                               |
| GET    | `/api/staff/services`                                     | `{ rows }`                               |
| GET    | `/api/staff/assets`                                       | `{ rows }`                               |
| GET    | `/api/staff/items/{item}/balance/{store}`                 | `{ balance }`                            |
| GET    | `/api/staff/payroll/years`                                | `{ rows }`                               |
| GET    | `/api/staff/payroll/years/{year}/months`                  | `{ rows }`                               |

### Request modules (one set per `<module>`)

Every implemented module exposes the same RESTish surface; the frontend hits
them in place of the direct `erpConnector` OData calls. Mutating routes
require the `X-CSRF-TOKEN` header just like the leave endpoints.

| Method | Path                                          | Description                                        |
| ------ | --------------------------------------------- | -------------------------------------------------- |
| GET    | `/api/staff/<module>`                         | List the current user's requests (`{ rows }`)      |
| GET    | `/api/staff/<module>/{no}`                    | `{ requisition, lines, approvers, attachments }`   |
| POST   | `/api/staff/<module>`                         | Create header (calls module's SOAP "Save" method)  |
| POST   | `/api/staff/<module>/{no}/edit`               | Edit header                                        |
| POST   | `/api/staff/<module>/{no}/lines`              | Create / edit a line                               |
| DELETE | `/api/staff/<module>/{no}/lines/{lineNo}`     | Delete a line                                      |
| POST   | `/api/staff/<module>/{no}/submit`             | Send for approval                                  |
| POST   | `/api/staff/<module>/{no}/cancel`             | Cancel approval                                    |

The `<module>` path segment maps onto the Laravel ESS controllers as follows
(see `src/staffModules.ts` for SOAP method names and OData services):

| Module URL segment        | Laravel controller / SOAP saver                                    |
| ------------------------- | ------------------------------------------------------------------ |
| `imprest`                 | `ImprestsController` → `ImprestRequisitionHeader`                  |
| `imprest-surrender`       | `ImprestsSurrenderController` → `ImprestSurrenderHeader`           |
| `claim`                   | `ClaimsController` → `ClaimRequisitionHeader`                      |
| `petty-cash`              | `PettyCashController` → `FnPettyCashHeader`                        |
| `inter-bank-transfer`     | `InterBankTransferController` → `FnSaveInterBankTransfer`          |
| `store-requisition`       | `StoreRequisitionsController` → `StoreRequisitionHeader`           |
| `purchase-requisition`    | `PurchaseRequisitionsController` → `PurchaseRequisitionHeader`     |
| `transport`               | `TransportRequisitionsController` → `TransportRequisition`         |
| `fuel`                    | `FuelMaintenanceController` → `FnFuelRequisitionHeader`            |
| `maintenance`             | `FuelMaintenanceController` → `FnFuelRequisitionHeader`            |
| `transfer-order`          | `TransferOrderController` → `TransferOrderHeader`                  |
| `work-tickets`            | `WorkTicketsController` (read-only + line delete)                  |
| `training`                | `TrainingController` → `FnTrainingRequest`                         |

The following modules respond `501 Not Implemented` because the ESS Laravel
app does not have a controller / SOAP method for them yet:

- `gate-pass`
- `overtime`
- `travel`

### Existing ERP convenience endpoints

These routes now require authentication.

| Method | Path                                                       |
| ------ | ---------------------------------------------------------- |
| GET    | `/api/bc/odata/:serviceName`                               |
| POST   | `/api/bc/soap/:methodName`                                 |
| GET    | `/api/erp/employees`                                       |
| GET    | `/api/erp/items`                                           |
| GET    | `/api/erp/departments`                                     |
| GET    | `/api/erp/approvals`                                       |
| GET    | `/api/erp/dashboard`                                       |
| GET    | `/api/erp/requests`                                        |
| GET    | `/api/erp/requests?module=imprest`                         |
| GET    | `/api/erp/requests/:id`                                    |
| POST   | `/api/erp/approvals/document`                              |

## Test with curl

```bash
# 1. Liveness
curl http://localhost:4000/api/health

# 2. React/JWT login
TOKEN=$(curl -s \
  -H "Content-Type: application/json" \
  -d '{"staffNo":"HB-02418","password":"YOUR_PASSWORD"}' \
  http://localhost:4000/api/auth/login | jq -r .token)

# 3. Hit an authenticated endpoint
curl -i -H "Authorization: Bearer $TOKEN" \
  http://localhost:4000/api/dashboard/summary
```

If all three return 200, the React app will work end-to-end.

## Integration evidence logs

Request logging is enabled by default:

```env
LOG_API_REQUESTS=true
LOG_BC_REQUESTS=true
BC_LOG_FILE=bc-integration.log
```

Each React request receives an `x-request-id`. The same ID is printed for the
corresponding Business Central OData or SOAP call:

```text
[api-in] requestId=... method=POST path="/api/auth/login" queryKeys="-"
[bc-request] requestId=... callId=... protocol=OData method=GET operation="QyHREmployee" target="http://erp-app-uat:2448/..." auth=ntlm metadata="queryKeys=$filter,$top"
[bc-response] requestId=... callId=... status=200 durationMs=... responseBytes=...
[api-out] requestId=... method=POST path="/api/auth/login" status=200 durationMs=...
```

When BC cannot be reached, `[bc-error]` is printed instead. Passwords,
authorization headers, request bodies, SOAP parameter values, and OData filter
values are never logged.

The server automatically appends these entries to `bc-integration.log` when
started normally:

```bash
npm run dev
```

Open the React app and perform login, leave, request, or approval actions. The
resulting `bc-integration.log` can be shared internally as connectivity
evidence after reviewing it.

## Single Windows host without IIS

The backend can serve the production React build and `/api` from one address:

```text
http://HOST-IP:4000/
http://HOST-IP:4000/api/health
```

Build both projects and copy the React output into `public`:

```bash
npm run build:all
```

For an offline client site, run this on a Windows preparation PC that has
internet access and both source projects:

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy\windows\create-offline-bundle.ps1
```

Copy the generated `SelfServicePortal-Windows.zip` to the host PC and extract
it. Copy `deploy\windows\host.env.example` to `.env`, replace `HOST-IP`, set
the BC credentials and production secrets, and then run:

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy\windows\open-firewall.ps1
.\deploy\windows\start-self-service.bat
```

To start the portal automatically after a host restart:

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy\windows\install-startup-task.ps1
```

All scripts except `start-self-service.bat` that change Windows system settings
must be run from an Administrator PowerShell window.

## Notes

- BC connectivity uses NTLM via `curl --ntlm`; if you see
  `Could not resolve host: erp-app-uat`, connect to the office network or VPN
  and try again.
- Passwords stored in BC's `PortalPassword` are bcrypt hashes (matching
  Laravel's `Hash::make()` output). Both login endpoints verify them with
  `bcryptjs.compare`.
- Set a unique production `JWT_SECRET` of at least 32 characters. Do not reuse
  the NTLM password or session secret.
- For cross-origin development between the React dev server (`:5173`) and this
  backend (`:4000`), either:
  - configure a Vite proxy on the front end so `/api` is same-origin, **or**
  - set `SESSION_COOKIE_SAMESITE=none` and `SESSION_COOKIE_SECURE=true`
    behind HTTPS.
- The local `.env` is configured for the same NTLM-style Business Central auth
  used by ESS. Keep the real password in `.env` only; do not commit it.
