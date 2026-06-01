# Self Service ERP Backend

Standalone Node backend for the Self Service ERP React app.

It uses the same Business Central endpoints configured in `/Users/abhishekbehera/ess/config/app.php`:

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

## Useful Endpoints

```text
GET  /api/health
GET  /api/config
GET  /api/bc/odata/:serviceName
POST /api/bc/soap/:methodName
GET  /api/erp/employees
GET  /api/erp/items
GET  /api/erp/departments
GET  /api/erp/approvals
GET  /api/erp/requests
GET  /api/erp/requests?module=imprest
POST /api/erp/approvals/document
```

`POST /api/bc/soap/:methodName` expects:

```json
{
  "params": {
    "docNo": "REQ-001"
  }
}
```

The local `.env` is configured for the same NTLM-style Business Central auth used by ESS. Keep the real password in `.env` only; do not commit it.
