# HIJRA UAT Final Fix Checklist

Follow these sections in order. Use the **HIJRA BANK** company and UAT only.

## 1. Compile the AL extension

Owner: Felix / AL developer

1. Open the complete HIJRA AL project on the Windows AL machine.
2. Extract `HIJRA-AL-finance-fixes-source-1.0.2.305.zip`.
3. Merge its files into the same paths in the complete AL project.
4. Confirm `app.json` contains version `1.0.2.305`.
5. Run **AL: Download Symbols**.
6. Run **AL: Package**.
7. Confirm a new `.app` file with version `1.0.2.305` was created.

Do not upload the source ZIP to Business Central. Business Central requires the compiled `.app` file.

## 2. Update the BC extension

Owner: BC administrator

1. Open **Extension Management** in BC UAT.
2. Upload the compiled `1.0.2.305` `.app` file.
3. Select the option to deploy/update the extension.
4. Do not uninstall the current extension first.
5. Confirm the installed version is `1.0.2.305`.

Extension `1.0.2.305` provides these fixes:

- Imprest Surrender accepts long employee division/district/branch names.
- Staff Claims accepts long employee division/district/branch names.
- `QyHREmployee` exposes `Basic_Pay` for Salary Advance.
- Petty Cash Replenishment uses a branch limit first and a department limit when no branch limit exists.

After this update, do not shorten `Total Reward and Recognition`. The AL code safely copies it into the shorter transaction fields.

## 3. Correct the PETTY payment type

Owner: Finance administrator

1. Ask Finance which existing G/L account is approved for petty cash expenses.
2. In BC, press `Alt+Q`.
3. Open **Payment Types** (page 50870).
4. Find code `PETTY`.
5. Confirm `Type` is `Payment`.
6. Confirm `Account Type` is `G/L Account`.
7. Replace invalid G/L account `101006` with the approved existing account.
8. Confirm the selected account allows direct posting and satisfies budget-control requirements.
9. Confirm the `PETTY` payment type is not blocked.
10. Save.

Do not create or select a random G/L account. Finance must approve the account.

## 4. Configure the replenishment limit

Owner: Finance administrator

1. Open employee `E0083` in BC.
2. Check the **Branch** field and the **Department** field.
3. If Branch contains a code, open **Petty Cash Limits-Branches** (page 51640).
4. Add that exact Branch code and the approved positive limit.
5. If Branch is blank, open **Petty Cash Limits-Departments** (page 51641).
6. Add E0083's exact Department code and the approved positive limit.
7. Save.

The limit must cover both the requested amount and the receiving account's resulting balance.

## 5. Verify Business Central

1. Open this OData request for employee E0083:

   `http://10.30.7.14:2448/BC240/ODataV4/Company('HIJRA%20BANK')/QyHREmployee?$filter=No%20eq%20'E0083'&$top=1`

2. Confirm the response contains `"Basic_Pay":17000` or the correct current salary.
3. Create an Imprest Surrender draft for E0083.
4. Create a Staff Claim draft for E0083.
5. Confirm neither request shows the `Total Reward and Recognition` length error.

## 6. Deploy the portal suite

Owner: Portal/server administrator

1. Copy the final offline ZIP to server `10.30.4.23`.
2. Open PowerShell **as Administrator**.
3. Stop the current services with:

   `powershell -ExecutionPolicy Bypass -File C:\TA\SelfServiceSuite\SelfServicePortal\deploy\windows\stop-suite.ps1`

4. Rename `C:\TA\SelfServiceSuite` to `C:\TA\SelfServiceSuite-backup-2026-07-10`.
5. Extract the final ZIP into `C:\TA`.
6. Confirm the resulting folder is exactly `C:\TA\SelfServiceSuite`.
7. Start the services with:

   `C:\TA\SelfServiceSuite\SelfServicePortal\deploy\windows\start-suite.bat`

8. Open `http://10.30.4.23:4000/api/health`.
9. Confirm the build ID is `hijra-uat-final-finance-fixes-al305-2026-07-10`.
10. Open `http://10.30.4.23:4000` and press `Ctrl+F5`.

The stop script is under `SelfServicePortal\deploy\windows`, not `SelfServiceBackend\deploy\windows`.

## 7. Final portal tests

1. Sign in as E0083.
2. Confirm login and normal pages load without the previous broad API probing delays.
3. Open Salary Advance and confirm the line table does not show the Amount column.
4. Create an Imprest Surrender draft.
5. Create a Staff Claim draft.
6. Create a Petty Cash request and add a `PETTY` line.
7. Create a Petty Cash Replenishment request.
8. Confirm each operation completes without the previous errors.

If a test fails, capture the exact red message and the latest lines from:

- `C:\TA\SelfServiceSuite\SelfServiceBackend\logs\bc-api.log`
- `C:\TA\SelfServiceSuite\SelfServiceBackend\bc-integration.log`
