# Single-IP Windows Deployment Without IIS

This deployment runs one Node process on the host PC:

```text
http://HOST-IP:4000/       React portal
http://HOST-IP:4000/api/*  Backend API
```

Other PCs do not run a script. They open the host URL in a browser.

## 1. Select the host PC

The host must:

- remain powered on;
- have sleep disabled;
- be connected to the client LAN;
- have a static IP or DHCP reservation;
- resolve `erp-app-uat`;
- reach TCP ports `2447` and `2448`.

Ask the client's IT team to reserve an address such as `192.168.1.50`.

## 2. Verify Business Central from the host

Run in PowerShell:

```powershell
Resolve-DnsName erp-app-uat
Test-NetConnection erp-app-uat -Port 2447
Test-NetConnection erp-app-uat -Port 2448
curl.exe --version
```

Do not continue until DNS and both port tests succeed.

## 3. Install Node.js on the host

Install a supported Node.js LTS x64 release. If the host has no internet,
download the Windows MSI elsewhere and transfer it by approved removable media
or the internal network.

Verify:

```powershell
node --version
npm --version
```

## 4. Create an offline application bundle

Perform this step on a Windows preparation PC with internet access.

Keep the repositories in this layout:

```text
C:\Build\SelfServiceBackend
C:\Build\SelfServicePortal\self-service-portal
```

Open PowerShell in `C:\Build\SelfServiceBackend` and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy\windows\create-offline-bundle.ps1
```

This installs dependencies, builds the backend, creates the on-prem React
build, installs Windows production dependencies, and creates:

```text
SelfServicePortal-Windows.zip
```

Do not copy `node_modules` from macOS to Windows.

## 5. Copy the bundle to the host

Extract the ZIP on the host to:

```text
C:\SelfServicePortal
```

The directory must contain:

```text
dist\server.js
public\index.html
node_modules\
deploy\windows\
package.json
```

## 6. Create the host configuration

From `C:\SelfServicePortal`:

```powershell
Copy-Item .\deploy\windows\host.env.example .\.env
notepad .\.env
```

Set:

```env
HOST=0.0.0.0
PORT=4000
CORS_ORIGIN=http://192.168.1.50:4000
```

Also set the real BC domain, user and password. Replace both application
secrets with different long random values.

The current integrated backend stores portal data in Business Central. It does
not require a separate MySQL or PostgreSQL database.

## 7. Open the Windows firewall

Open PowerShell as Administrator:

```powershell
Set-Location C:\SelfServicePortal
powershell -ExecutionPolicy Bypass -File .\deploy\windows\open-firewall.ps1
```

Only TCP port `4000` is exposed to the local subnet. BC credentials and
database ports are not exposed.

## 8. Start manually

Run:

```powershell
Set-Location C:\SelfServicePortal
.\deploy\windows\start-self-service.bat
```

Check locally on the host:

```text
http://localhost:4000
http://localhost:4000/api/health
```

Watch BC integration logs:

```powershell
Get-Content C:\SelfServicePortal\bc-integration.log -Wait
```

## 9. Test from another PC

The second PC must be on the same LAN or a routed client network.

Run:

```powershell
Test-NetConnection 192.168.1.50 -Port 4000
```

Then open:

```text
http://192.168.1.50:4000
```

Sign in with a valid BC portal staff account. The host log should show:

```text
[api-in]
[bc-request]
[bc-response] status=200
[api-out] status=200
```

## 10. Start automatically after reboot

After manual testing succeeds, open Administrator PowerShell:

```powershell
Set-Location C:\SelfServicePortal
powershell -ExecutionPolicy Bypass -File .\deploy\windows\install-startup-task.ps1
```

Restart the host and verify the portal from another PC.

## 11. Operational checks

- Prevent the host from sleeping.
- Back up `.env` securely.
- Rotate any credentials exposed in recordings or source files.
- Review `bc-integration.log` and `logs\server-console.log`.
- Do not expose port `4000` to the public internet.
- Use an internal DNS name and HTTPS before handling production credentials
  across untrusted or shared networks.
