# Local dry-test on Mac (matches server package)

Same two-app layout as `deploy/windows/start-suite.bat` on the Windows server:

| App | Folder | Port | Login |
| --- | --- | --- | --- |
| **SelfServiceBackend** | `../SelfServiceBackend` | **4000** | **BC365 User** (HIJRA) |
| **Application server** | `server` | **4001** | Application User (MySQL) |

HIJRA UAT only needs **port 4000**.

## Quick start (BC365 — HIJRA)

```bash
cd SelfServiceSuite/SelfServicePortal
npm run dry-run
```

Open **http://localhost:4000** → **BC365 User** → employee **E0083**.

## First-time setup

1. Copy BC env:

```bash
cp deploy/local-bc.env.example ../SelfServiceBackend/.env
```

Edit `BC_NAV_PASSWORD` in `../SelfServiceBackend/.env`.

2. VPN/network to BC `10.30.7.14`.

3. Run:

```bash
npm run dry-run
```

## Dev mode (hot reload)

**Terminal 1:**

```bash
cd SelfServiceSuite/SelfServicePortal
npm run dry-run:dev
```

**Terminal 2:**

```bash
cd SelfServiceSuite/SelfServicePortal/self-service-portal
npm run dev
```

Open **http://localhost:5173**.

## What the scripts do

| Script | Purpose |
| --- | --- |
| `deploy/sync-backend-from-repo.sh` | Copies latest `src/` from repo root into suite `SelfServiceBackend` |
| `deploy/run-local-suite.sh` | Build portal + backend, run on port 4000 |
| `deploy/local-bc.env.example` | HIJRA `.env` template for suite backend |

## Application User (port 4001)

The `server/` folder in this package is a **deploy stub** (no `src/` in git).
Application User login needs the full server build from the deployment ZIP or MySQL setup on Windows.

For HIJRA dry-test, use **BC365 User** on port **4000** only.

## Match Windows server

Windows: `SelfServicePortal\deploy\windows\start-suite.bat`
Mac: `SelfServicePortal\deploy\run-local-suite.sh`
