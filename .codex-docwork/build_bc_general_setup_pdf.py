#!/usr/bin/env python3
"""Generic Microsoft Dynamics 365 Business Central setup guide (PDF)."""

from pathlib import Path

from reportlab.lib.colors import HexColor, white
from reportlab.lib.enums import TA_CENTER, TA_JUSTIFY, TA_LEFT, TA_RIGHT
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import (
    KeepTogether,
    ListFlowable,
    ListItem,
    PageBreak,
    Paragraph,
    Preformatted,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)

OUT_PATHS = [
    Path("/Users/abhishekbehera/SelfServiceBackend-ABH/deliverables/Business_Central_Setup_Guide.pdf"),
    Path("/Users/abhishekbehera/ABH_UAT_LIVE_V2/docs/Business_Central_Setup_Guide.pdf"),
    Path("/Users/abhishekbehera/Desktop/Business_Central_Setup_Guide.pdf"),
]

NAVY = HexColor("#17365D")
BLUE = HexColor("#2E74B5")
DARK_BLUE = HexColor("#1F4D78")
TEAL = HexColor("#008C95")
LIGHT_BLUE = HexColor("#E8EEF5")
LIGHT_TEAL = HexColor("#E8F6F6")
LIGHT_GOLD = HexColor("#FFF4D6")
GOLD = HexColor("#A36A00")
LIGHT_RED = HexColor("#FDECEC")
RED = HexColor("#9B1C1C")
LIGHT_GREEN = HexColor("#EAF6EF")
GREEN = HexColor("#1F6D4D")
DARK = HexColor("#1F2937")
MID = HexColor("#667085")
ROW = HexColor("#FAFBFC")
LINE = HexColor("#B8C4D2")
CODE_BG = HexColor("#F5F7FA")

PAGE_W, PAGE_H = letter
LEFT = 0.85 * inch
RIGHT = 0.85 * inch
TOP = 0.85 * inch
BOTTOM = 0.8 * inch
CONTENT_W = PAGE_W - LEFT - RIGHT


def styles():
    base = getSampleStyleSheet()
    s = {}
    s["cover_kicker"] = ParagraphStyle(
        "cover_kicker", parent=base["Normal"], fontName="Times-Bold",
        fontSize=11, textColor=TEAL, alignment=TA_CENTER, spaceAfter=14,
        tracking=1,
    )
    s["cover_title"] = ParagraphStyle(
        "cover_title", parent=base["Normal"], fontName="Times-Bold",
        fontSize=26, leading=32, textColor=NAVY, alignment=TA_CENTER, spaceAfter=8,
    )
    s["cover_sub"] = ParagraphStyle(
        "cover_sub", parent=base["Normal"], fontName="Times-Roman",
        fontSize=14, leading=18, textColor=DARK_BLUE, alignment=TA_CENTER, spaceAfter=10,
    )
    s["cover_meta"] = ParagraphStyle(
        "cover_meta", parent=base["Normal"], fontName="Times-Roman",
        fontSize=10, leading=14, textColor=MID, alignment=TA_CENTER, spaceAfter=4,
    )
    s["h1"] = ParagraphStyle(
        "h1", parent=base["Heading1"], fontName="Times-Bold",
        fontSize=15, leading=19, textColor=BLUE, spaceBefore=16, spaceAfter=8,
    )
    s["h2"] = ParagraphStyle(
        "h2", parent=base["Heading2"], fontName="Times-Bold",
        fontSize=12.5, leading=16, textColor=BLUE, spaceBefore=12, spaceAfter=6,
    )
    s["body"] = ParagraphStyle(
        "body", parent=base["Normal"], fontName="Times-Roman",
        fontSize=10.5, leading=14.5, textColor=DARK, alignment=TA_JUSTIFY,
        spaceAfter=7,
    )
    s["body_left"] = ParagraphStyle(
        "body_left", parent=base["Normal"], fontName="Times-Roman",
        fontSize=10.5, leading=14.5, textColor=DARK, alignment=TA_LEFT, spaceAfter=7,
    )
    s["small"] = ParagraphStyle(
        "small", parent=base["Normal"], fontName="Times-Italic",
        fontSize=9, leading=12, textColor=MID, spaceAfter=6,
    )
    s["th"] = ParagraphStyle(
        "th", parent=base["Normal"], fontName="Times-Bold",
        fontSize=9, leading=12, textColor=NAVY,
    )
    s["td"] = ParagraphStyle(
        "td", parent=base["Normal"], fontName="Times-Roman",
        fontSize=8.8, leading=11.5, textColor=DARK,
    )
    s["callout"] = ParagraphStyle(
        "callout", parent=base["Normal"], fontName="Times-Roman",
        fontSize=9.8, leading=13, textColor=DARK,
    )
    s["callout_title"] = ParagraphStyle(
        "callout_title", parent=base["Normal"], fontName="Times-Bold",
        fontSize=9.5, leading=12, textColor=TEAL,
    )
    s["code"] = ParagraphStyle(
        "code", parent=base["Code"], fontName="Courier",
        fontSize=8, leading=11, textColor=HexColor("#263238"),
        backColor=CODE_BG, leftIndent=6, rightIndent=6, spaceBefore=4, spaceAfter=8,
    )
    s["footer"] = ParagraphStyle(
        "footer", parent=base["Normal"], fontName="Times-Roman",
        fontSize=8, textColor=MID, alignment=TA_RIGHT,
    )
    s["header"] = ParagraphStyle(
        "header", parent=base["Normal"], fontName="Times-Bold",
        fontSize=8, textColor=MID, alignment=TA_RIGHT,
    )
    s["bullet"] = ParagraphStyle(
        "bullet", parent=base["Normal"], fontName="Times-Roman",
        fontSize=10.5, leading=14, textColor=DARK, leftIndent=12,
    )
    s["link"] = ParagraphStyle(
        "link", parent=base["Normal"], fontName="Times-Roman",
        fontSize=9.5, leading=13, textColor=DARK, spaceAfter=3,
    )
    return s


S = styles()


def p(text, style="body"):
    return Paragraph(text, S[style])


def bullets(items):
    flow = []
    for item in items:
        flow.append(
            ListItem(Paragraph(item, S["bullet"]), leftIndent=18, bulletColor=NAVY)
        )
    return ListFlowable(flow, bulletType="bullet", start="•", leftIndent=12, spaceAfter=6)


def numbered(items):
    flow = []
    for item in items:
        flow.append(ListItem(Paragraph(item, S["bullet"]), leftIndent=18))
    return ListFlowable(flow, bulletType="1", leftIndent=12, spaceAfter=6)


def callout(title, body, kind="info"):
    palettes = {
        "info": (LIGHT_TEAL, TEAL, "#008C95"),
        "warning": (LIGHT_GOLD, GOLD, "#A36A00"),
        "risk": (LIGHT_RED, RED, "#9B1C1C"),
        "success": (LIGHT_GREEN, GREEN, "#1F6D4D"),
    }
    fill, accent, accent_hex = palettes[kind]
    inner = Paragraph(
        f'<font color="{accent_hex}"><b>{title.upper()}</b></font>  {body}',
        S["callout"],
    )
    t = Table([[inner]], colWidths=[CONTENT_W])
    t.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), fill),
                ("LEFTPADDING", (0, 0), (-1, -1), 10),
                ("RIGHTPADDING", (0, 0), (-1, -1), 10),
                ("TOPPADDING", (0, 0), (-1, -1), 8),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
                ("LINEBEFORE", (0, 0), (0, -1), 3, accent),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
            ]
        )
    )
    t.hAlign = "LEFT"
    return KeepTogether([Spacer(1, 4), t, Spacer(1, 8)])


def table(headers, rows, widths):
    assert abs(sum(widths) - CONTENT_W) < 2
    data = [[Paragraph(h, S["th"]) for h in headers]]
    for row in rows:
        data.append([Paragraph(str(c), S["td"]) for c in row])
    t = Table(data, colWidths=widths, repeatRows=1)
    cmds = [
        ("BACKGROUND", (0, 0), (-1, 0), LIGHT_BLUE),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LEFTPADDING", (0, 0), (-1, -1), 6),
        ("RIGHTPADDING", (0, 0), (-1, -1), 6),
        ("TOPPADDING", (0, 0), (-1, -1), 5),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
        ("GRID", (0, 0), (-1, -1), 0.4, LINE),
        ("FONTNAME", (0, 0), (-1, 0), "Times-Bold"),
    ]
    for i in range(1, len(data)):
        if i % 2 == 0:
            cmds.append(("BACKGROUND", (0, i), (-1, i), ROW))
    t.setStyle(TableStyle(cmds))
    t.hAlign = "LEFT"
    return KeepTogether([t, Spacer(1, 8)])


def code_block(text):
    pre = Preformatted(text.strip("\n"), S["code"])
    t = Table([[pre]], colWidths=[CONTENT_W])
    t.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), CODE_BG),
                ("BOX", (0, 0), (-1, -1), 0.4, LINE),
                ("LEFTPADDING", (0, 0), (-1, -1), 8),
                ("RIGHTPADDING", (0, 0), (-1, -1), 8),
                ("TOPPADDING", (0, 0), (-1, -1), 8),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
            ]
        )
    )
    t.hAlign = "LEFT"
    return KeepTogether([t, Spacer(1, 8)])


def header_footer(canvas, doc):
    canvas.saveState()
    canvas.setFillColor(MID)
    canvas.setFont("Times-Bold", 8)
    canvas.drawRightString(PAGE_W - RIGHT, PAGE_H - 0.5 * inch, "BUSINESS CENTRAL  |  SETUP GUIDE")
    canvas.setStrokeColor(LINE)
    canvas.setLineWidth(0.4)
    canvas.line(LEFT, PAGE_H - 0.58 * inch, PAGE_W - RIGHT, PAGE_H - 0.58 * inch)
    canvas.line(LEFT, 0.5 * inch, PAGE_W - RIGHT, 0.5 * inch)
    canvas.setFont("Times-Roman", 8)
    canvas.drawRightString(PAGE_W - RIGHT, 0.32 * inch, f"Version 1.0  •  Page {doc.page}")
    canvas.restoreState()


def cover_header_footer(canvas, doc):
    canvas.saveState()
    canvas.setFillColor(NAVY)
    canvas.rect(0, PAGE_H - 0.35 * inch, PAGE_W, 0.35 * inch, fill=1, stroke=0)
    canvas.setFillColor(TEAL)
    canvas.rect(0, 0, PAGE_W, 0.28 * inch, fill=1, stroke=0)
    canvas.restoreState()


def build_story():
    story = []
    story.append(Spacer(1, 1.6 * inch))
    story.append(p("MICROSOFT DYNAMICS 365", "cover_kicker"))
    story.append(p("Business Central", "cover_title"))
    story.append(p("ERP Setup Guide", "cover_title"))
    story.append(p("A practical handbook for a new licensed environment", "cover_sub"))
    story.append(Spacer(1, 8))
    rule = Table([[""]], colWidths=[2.4 * inch])
    rule.setStyle(TableStyle([("LINEBELOW", (0, 0), (-1, -1), 2, TEAL)]))
    rule.hAlign = "CENTER"
    story.append(rule)
    story.append(Spacer(1, 16))
    story.append(p("Cloud (SaaS) and On-premises  •  License  •  Company  •  Finance  •  Users  •  Workflows  •  Go-live", "cover_meta"))
    story.append(Spacer(1, 1.4 * inch))
    story.append(p("Prepared for management, IT, finance and process owners", "cover_meta"))
    story.append(p("Document version 1.0  |  September 2026", "cover_meta"))
    story.append(p("Generic implementation guide — not a customer-specific design", "cover_meta"))
    story.append(PageBreak())

    story.append(p("1. Purpose of this document", "h1"))
    story.append(p(
        "This guide explains how to stand up a new Microsoft Dynamics 365 Business Central environment "
        "when the organisation already holds a valid license. It covers both cloud (SaaS) and on-premises "
        "deployment, then the company, finance, users, approvals, data and go-live work that every ERP "
        "project must complete. It does not replace Microsoft licensing terms, a solution design, or "
        "local accounting and tax advice."
    ))
    story.append(table(
        ["Control", "Value"],
        [
            ["Audience", "Management, IT, Finance, and functional process owners"],
            ["Scope", "New production-grade Business Central environment from license to go-live"],
            ["Out of scope", "Customer-specific customisation, localisation legal opinion, and live data loads"],
            ["Change rule", "No production change without backup, change record, tested rollback, and an authorised window"],
        ],
        [1.7 * inch, CONTENT_W - 1.7 * inch],
    ))
    story.append(callout(
        "Start here",
        "Treat this as a controlled ERP implementation, not a server-copy exercise. The platform, database, "
        "users, posting setup, workflows, email and opening balances must be tested together as one system.",
        "info",
    ))

    story.append(p("2. Choose the deployment model", "h1"))
    story.append(p(
        "Business Central is licensed either as online (SaaS) or as on-premises. The license type determines "
        "the installation path. Confirm the entitlement with the Microsoft partner before any server is built."
    ))
    story.append(table(
        ["Model", "When to use", "What you install"],
        [
            [
                "Cloud (SaaS)",
                "Microsoft hosts the application. Fastest path for most organisations.",
                "No Windows/SQL install. Create an environment in the Business Central admin center, assign licenses, create the company.",
            ],
            [
                "On-premises",
                "Data must stay on your servers, or you already own an on-premises license file.",
                "Windows Server, SQL Server, Business Central Server, Web Server, Administration Shell, then import the .bclicense file.",
            ],
            [
                "Hybrid",
                "On-premises application with cloud services (for example Microsoft 365 email or Entra ID).",
                "On-premises install plus Entra application registration, email connector and optional Dataverse/Power Platform links.",
            ],
        ],
        [1.35 * inch, 2.55 * inch, CONTENT_W - 3.9 * inch],
    ))
    story.append(callout(
        "Release decision",
        "Install a currently supported Business Central release with the latest cumulative update. Do not "
        "start a new production environment on a version that has already reached end of servicing. Confirm "
        "the target version with the partner before hardware sizing or installation.",
        "risk",
    ))

    story.append(p("3. Phase 0 — license and readiness", "h1"))
    story.append(numbered([
        "Ask the Microsoft partner to confirm that the license and active enhancement/maintenance entitlement allow the selected release (online or on-premises).",
        "For SaaS: confirm the Microsoft 365 tenant, Business Central subscription, user license types (Essentials, Premium, Team Member, Device) and environment quota.",
        "For on-premises: obtain the production .bclicense file through the authorised channel. Store it in a restricted administrator location. Do not put it in source control or chat.",
        "Confirm localisation (country/region application), currency, fiscal calendar and any required ISV or custom extensions.",
        "If a custom extension exists, rebuild it against symbols from the target version. A package compiled for an older major release is not automatically compatible.",
        "Record the exact platform version, application version, localisation, cumulative update and custom-app version in a release register.",
    ]))
    story.append(callout(
        "Gate 0",
        "Do not begin production installation until release, license entitlement, localisation and extension compatibility are documented and approved.",
        "warning",
    ))

    story.append(p("4. Phase 1 — cloud (SaaS) environment setup", "h1"))
    story.append(p(
        "Skip this section if the license is on-premises only. For online customers this is the first technical work."
    ))
    story.append(p("4.1 Create the environments", "h2"))
    story.append(numbered([
        "Sign in to the Business Central admin center with a Global Administrator or Dynamics 365 administrator.",
        "Create at least two environments: Production and a Sandbox (UAT). Keep them separate for life.",
        "Choose the country/region localisation that matches the legal entity. This cannot be changed later without a new environment.",
        "Select the application version and apply the latest available update before users are invited.",
        "Set the environment name, type (Production/Sandbox), and whether it is enabled for production traffic.",
    ]))
    story.append(p("4.2 Assign licenses and administrators", "h2"))
    story.append(numbered([
        "In Microsoft 365 admin center, assign Business Central licenses to named users. Do not share licenses.",
        "Assign the Dynamics 365 administrator and Business Central administrator roles to the implementation team only.",
        "Invite users from Microsoft Entra ID. Require multifactor authentication for remote and privileged access.",
        "Confirm each user can open the environment URL after license assignment has replicated (often a few minutes).",
    ]))
    story.append(table(
        ["License type", "Typical use"],
        [
            ["Essentials", "Financials, sales, purchasing, inventory, projects — most business users"],
            ["Premium", "Essentials plus manufacturing and service management"],
            ["Team Member", "Read, approvals, light updates — managers and occasional users"],
            ["Device", "Shared device scenarios such as a warehouse terminal"],
        ],
        [1.8 * inch, CONTENT_W - 1.8 * inch],
    ))

    story.append(p("5. Phase 1 — on-premises infrastructure", "h1"))
    story.append(p(
        "Skip this section if the license is SaaS only. For on-premises customers, build the platform before any company setup."
    ))
    story.append(p("5.1 Sizing baseline", "h2"))
    story.append(p(
        "Final sizing depends on users, transactions, reports, job queues and database growth. The following is a starting point, not a substitute for capacity testing."
    ))
    story.append(table(
        ["Component", "Starting baseline", "Notes"],
        [
            [
                "Application / web server",
                "Windows Server 2022 or later; 8 vCPU; 32 GB RAM; 150 GB OS/app disk",
                "Increase memory for large extensions. Monitor CPU, memory and request queues.",
            ],
            [
                "SQL Server",
                "Supported SQL Server; 8–16 vCPU; 32–64 GB RAM; separate data, log and backup disks",
                "Enable Full-Text Search. Apply the latest supported SQL cumulative update.",
            ],
            [
                "Backup repository",
                "Encrypted off-server storage with retention and an offline/immutable copy",
                "Must cover full, differential and log backups plus restore testing.",
            ],
        ],
        [1.7 * inch, 2.9 * inch, CONTENT_W - 4.6 * inch],
    ))
    story.append(p("5.2 Prerequisites", "h2"))
    story.append(bullets([
        "Supported 64-bit Windows Server, fully patched, domain-joined where applicable, with accurate time synchronisation.",
        "Supported SQL Server edition and cumulative update, with Full-Text and Semantic Extractions for Search.",
        "Required .NET runtimes, .NET Framework 4.8 (report rendering and Administration Shell), IIS, and Report Builder components as listed for the chosen release.",
        "A dedicated DNS name (for example erp.company.example) and a trusted TLS certificate that matches that name.",
        "Dedicated service accounts (for example DOMAIN\\svc-bc-prod) with interactive logon denied and least privilege.",
        "Separate administrator accounts for server and SQL work. Ordinary users must not be local administrators.",
        "Static IP addressing, documented firewall flows, monitoring, approved anti-malware exclusions, and a backup agent.",
    ]))
    story.append(p("5.3 Network and ports", "h2"))
    story.append(table(
        ["Flow", "Typical port", "Rule"],
        [
            ["Users to HTTPS web client", "TCP 443", "Only user-facing inbound port. Trusted certificate required."],
            ["Application server to SQL Server", "TCP 1433 or a fixed SQL port", "Internal only. Never expose SQL to the internet."],
            ["Management service", "TCP 7045 default", "Administrator subnet only."],
            ["Client service", "Confirm for the selected release", "Internal application/web flow only."],
            ["SOAP services", "TCP 7047 default", "Enable only if an integration requires it. Restrict source."],
            ["OData services", "TCP 7048 default", "Enable only if required. Use TLS and least-privilege authentication."],
            ["Developer service", "TCP 7049 default", "UAT or administrator subnet only. Block public access."],
        ],
        [2.3 * inch, 1.7 * inch, CONTENT_W - 4.0 * inch],
    ))
    story.append(p(
        "Microsoft Setup allows ports to be changed. Confirm that every selected port is unused, documented, and permitted only between the required hosts.",
        "small",
    ))
    story.append(p("5.4 Security baseline", "h2"))
    story.append(bullets([
        "Use HTTPS from first production access. A browser “Not secure” warning is not production-ready.",
        "Prefer Microsoft Entra ID / OpenID Connect with MFA. Windows authentication is acceptable for an approved internal-only design.",
        "Do not store service-account passwords, email secrets, database credentials or license files in Git, scripts or screenshots.",
        "Restrict RDP and WinRM to the administrator network.",
        "Keep Production and UAT databases, instances, URLs, certificates and credentials separate.",
    ]))

    story.append(p("6. Phase 2 — install Business Central (on-premises)", "h1"))
    story.append(p("6.1 Prepare SQL Server", "h2"))
    story.append(numbered([
        "Install the supported SQL Server release and latest approved cumulative update. Include Full-Text Search.",
        "Configure dedicated data, log, tempdb and backup locations. Cap SQL maximum server memory so the operating system and backup agents retain capacity.",
        "Grant the Business Central service account only the permissions required by Microsoft installation and runtime guidance.",
        "Configure full, differential and transaction-log backups to the approved recovery point objective. Run and document a test restore before go-live.",
    ]))
    story.append(p("6.2 Install application and web components", "h2"))
    story.append(numbered([
        "Download installation media and the selected cumulative update only from Microsoft or the authorised partner. Record the source and checksum.",
        "Sign in to the application server with an installation administrator and run setup.exe as Administrator.",
        "Choose Advanced installation options, then Custom. Install Business Central Server, Web Server Components and Administration Shell. Install development components only on approved development hosts.",
        "Set a clear server instance name (for example BC_PROD). Enter the production SQL server and database. Use the dedicated service account.",
        "Configure the web instance and HTTPS hostname. Do not expose the initial HTTP endpoint to users.",
        "Complete Setup, review the installation log, confirm the Windows service is running, and open the web client from an administrator workstation.",
    ]))
    story.append(p("6.3 Import the license", "h2"))
    story.append(p("Open Business Central Administration Shell as Administrator. Replace the example values before execution."))
    story.append(code_block(
        '$ServerInstance = "BC_PROD"\n'
        '$LicenseFile = "C:\\BCSetup\\Licenses\\fin.bclicense"\n'
        "Import-NAVServerLicense -ServerInstance $ServerInstance -LicenseFile $LicenseFile\n"
        "Restart-NAVServerInstance -ServerInstance $ServerInstance\n"
        "Get-NAVServerInstance -ServerInstance $ServerInstance"
    ))
    story.append(numbered([
        "Sign in to the web client using the emergency implementation administrator.",
        "Open Help and Support and record platform and application version numbers.",
        "Open License Information and confirm customer name, entitlement and required granules.",
        "Resolve every startup or license error before company configuration begins.",
    ]))
    story.append(callout(
        "Break-glass account",
        "After role-based administrators exist, restrict the emergency account and store its credential under the approved break-glass procedure.",
        "warning",
    ))

    story.append(p("7. Phase 3 — identity, users and permissions", "h1"))
    story.append(p(
        "Use one identity per person. The Business Central user, employee record, approval user and any portal identity must map consistently. Shared human accounts are prohibited except approved technical integration identities."
    ))
    story.append(p("7.1 Create users", "h2"))
    story.append(numbered([
        "SaaS: users come from Microsoft Entra ID after license assignment. Confirm each person appears on the Users page.",
        "On-premises: create Windows or Entra users, then add them in Business Central Users. Map Windows security groups to permission sets where that is the approved model.",
        "Create named accounts for all human users. Use dedicated non-interactive accounts for the server, integrations and job queues.",
        "Require MFA for remote and privileged access when Entra ID is used.",
    ]))
    story.append(p("7.2 Permission model", "h2"))
    story.append(numbered([
        "Create role-based permission sets for Finance, Sales, Purchasing, Warehouse, HR, Payroll, Approver, Requester, Auditor and IT Administration — or start from Microsoft’s standard sets and tighten them.",
        "Assign the minimum base sign-in permissions, then add business permissions by job role.",
        "Limit SUPER (or equivalent full admin) to the smallest possible administrator group. Do not use SUPER to bypass a missing permission during testing.",
        "Apply company-level access when a user must see only specific legal entities.",
        "Test segregation of duties: vendor creation versus payment, requester versus approver, goods receipt versus invoice, payroll preparation versus approval, administrator versus auditor.",
        "Export the final user and permission assignment as go-live evidence and schedule quarterly access reviews.",
    ]))
    story.append(p("Search User Setup and complete posting-date windows, approver email, and any cashier or journal restrictions required by finance policy."))

    story.append(p("8. Phase 4 — create and configure the company", "h1"))
    story.append(p("8.1 Create the company", "h2"))
    story.append(numbered([
        "Open Companies and choose New. Use Setup Data Only, or an approved configuration package. Do not use an evaluation company that contains sample transactions for production.",
        "Complete Company Information: registered name, address, contacts, bank details, tax identifiers, logo and local reporting information.",
        "Set regional formats, language, time zone and work-date policy. Confirm date display for every integration.",
        "Create Base Calendars for weekends and public holidays. Apply them to the company and to processes that calculate working days.",
    ]))
    story.append(p("8.2 Assisted Setup", "h2"))
    story.append(p(
        "Open Assisted Setup (search “Assisted Setup” or “Set up company”) and complete the relevant wizards in this order. Skip only what is genuinely out of scope."
    ))
    story.append(table(
        ["Wizard / page", "What to complete"],
        [
            ["Set up company / Company Information", "Legal name, address, VAT/tax ID, bank, logo"],
            ["Set up number series", "Customers, vendors, items, invoices, orders, journals, payments"],
            ["Set up general ledger", "Local currency, posting date policy, additional reporting currency if used"],
            ["Set up dimensions", "Global dimensions and shortcut dimensions used for reporting"],
            ["Set up VAT / tax", "VAT business and product posting groups and the posting setup matrix"],
            ["Set up inventory", "Costing method, locations, inventory posting groups"],
            ["Set up users and permissions", "After identity is ready"],
            ["Set up email", "After the email account exists"],
            ["Set up approval workflows", "After users and limits exist"],
        ],
        [2.6 * inch, CONTENT_W - 2.6 * inch],
    ))

    story.append(p("8.3 Finance foundation", "h2"))
    story.append(bullets([
        "Chart of Accounts, account categories, posting controls and blocked accounts.",
        "General Ledger Setup: local currency (LCY), allowed posting-date window, additional reporting currency if required, bank reconciliation method.",
        "Accounting periods for the financial year. Close periods only under finance instruction.",
        "General, customer, vendor, inventory, VAT/tax and bank posting groups. Complete the posting setup matrices so every combination that will be used has a G/L account.",
        "Dimensions and dimension combinations. Set default dimensions on G/L accounts, customers, vendors and items where policy requires them.",
        "Currencies and the exchange-rate process. Bank accounts, payment methods, payment terms and bank reconciliation.",
        "Number series for masters, journals and documents. Prevent collisions with migrated identifiers.",
        "Fixed-asset setup if in scope: FA books, depreciation methods, classes, locations and posting groups.",
        "Cash receipt journals, payment journals and general journals: templates, batches and balancing accounts.",
    ]))
    story.append(callout(
        "Do not post yet",
        "Do not post opening balances, invoices, receipts or payments until finance has signed the trial balance file and posting groups have been tested with a controlled dummy document in UAT.",
        "warning",
    ))

    story.append(p("8.4 Sales, purchasing and inventory", "h2"))
    story.append(table(
        ["Area", "Minimum setup"],
        [
            [
                "Sales & Receivables Setup",
                "Customer number series, invoice/credit memo series, discount posting, shipment and invoice combination, credit warnings, default posting groups.",
            ],
            [
                "Purchases & Payables Setup",
                "Vendor number series, invoice/receipt series, exact-cost reversing, default posting groups, quote-to-order rules.",
            ],
            [
                "Inventory Setup",
                "Item number series, costing method (typically FIFO, Average or Standard — pick one policy and keep it), automatic cost posting/adjustment, location mandatory if multi-site.",
            ],
            [
                "Locations and bins",
                "One location per warehouse or store. Assign responsibility and posting groups. Bins only if the warehouse design requires them.",
            ],
            [
                "Items",
                "Base unit of measure, inventory posting group, VAT product posting group, costing method, reorder policy.",
            ],
            [
                "Vendors and customers",
                "Posting groups, payment terms, payment method, tax status, bank details. Prevent duplicates.",
            ],
        ],
        [2.0 * inch, CONTENT_W - 2.0 * inch],
    ))

    story.append(p("8.5 Human resources and payroll (if licensed / in scope)", "h2"))
    story.append(bullets([
        "Employee numbers, employment status, department, manager, Business Central User ID and company email.",
        "Leave types, entitlement, carry-forward, accrual, base calendar and holiday calendar.",
        "Approver hierarchy, substitute approvers and cancellation rules.",
        "If payroll is in Business Central or an add-on: periods, earnings and deductions, statutory rates, employee posting groups, bank export and maker/checker controls. Obtain finance and HR sign-off before the first live calculation.",
    ]))

    story.append(p("9. Phase 5 — email, workflows and job queues", "h1"))
    story.append(p("9.1 Email", "h2"))
    story.append(numbered([
        "Assign the EMAIL - ADMIN permission set to the administrator performing setup.",
        "On-premises: register a Microsoft Entra application and connect it through Email Microsoft Entra Application Registration or Assisted Setup.",
        "Open Email Accounts. Add Microsoft 365 or the approved SMTP OAuth connector. Prefer modern authentication. Do not use basic authentication.",
        "Set one account as Default. Assign email scenarios only where a separate sender is required.",
        "Send a Test Email to an internal and an external mailbox. Record successful delivery and the sender identity.",
    ]))
    story.append(p("9.2 Approval workflows", "h2"))
    story.append(p(
        "A workflow button on a page is not proof that the workflow is complete. Configure and test each document type separately."
    ))
    story.append(numbered([
        "Open Approval User Setup. Assign Approver ID, amount limits, substitute and approval administrator.",
        "Create Workflow User Groups where sequence-based multi-level approval is required. The requester must not approve their own document at the same level.",
        "Open Workflows. Create from a Microsoft template for standard documents (purchase invoices, purchase orders, sales quotes, and similar), or from registered custom events for custom documents.",
        "Define event conditions (company, document type, amount, department or responsibility centre).",
        "Configure responses: create approval request, restrict record use, notify approver, release on final approval, reopen or cancel on rejection.",
        "Enable the workflow only when Workflow Steps shows no missing event or response error.",
        "Test submit, approve, reject with a remark, next approver, final approval, cancel, resubmit, substitute and unauthorised-user denial.",
    ]))
    story.append(callout(
        "Production blocker",
        "If Business Central says a workflow response does not exist or is not configured for the document type, stop testing and fix the configuration. Do not bypass approval.",
        "risk",
    ))
    story.append(p("9.3 Job queues", "h2"))
    story.append(bullets([
        "Open Job Queue Entries and inventory required background jobs: email dispatch, workflow notifications, cost adjustment, integrations and cleanup.",
        "Run jobs under an approved licensed service user with only the required permission sets.",
        "Set recurrence, earliest start, timeout and retry. Keep heavy reports and imports off peak business hours.",
        "Test each job manually, set Status to Ready, and confirm at least one scheduled run completes.",
        "Monitor Job Queue Log Entries daily during hypercare.",
    ]))

    story.append(p("10. Phase 6 — extensions and integrations", "h1"))
    story.append(p(
        "Install only extensions that are licensed, supported on the chosen release, and tested in UAT. Microsoft AppSource apps, localisation apps and custom AL extensions all follow the same publish / sync / install (or data upgrade) sequence on-premises."
    ))
    story.append(p("On-premises — first install of a custom app:"))
    story.append(code_block(
        '$ServerInstance = "BC_PROD"\n'
        '$Tenant = "default"\n'
        '$AppPath = "C:\\BCSetup\\Apps\\Publisher_AppName_X.Y.Z.W.app"\n'
        "Publish-NAVApp -ServerInstance $ServerInstance -Path $AppPath\n"
        'Sync-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -Name "AppName" -Publisher "Publisher" -Version "X.Y.Z.W"\n'
        'Install-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -Name "AppName" -Publisher "Publisher" -Version "X.Y.Z.W"\n'
        "Get-NAVAppInfo -ServerInstance $ServerInstance -Tenant $Tenant -TenantSpecificProperties"
    ))
    story.append(p(
        "If the package is not code-signed, SkipVerification may be required in a lab. Treat that as a documented exception and correct it before production.",
        "small",
    ))
    story.append(p("Later upgrades use Start-NAVAppDataUpgrade instead of Install-NAVApp after Sync-NAVApp. Always take a verified backup first."))
    story.append(bullets([
        "SaaS: install AppSource apps from Extension Management. Upload per-tenant extensions only through the approved partner process.",
        "Publish only the SOAP, OData or API endpoints that integrations actually need. Restrict them by source and use a least-privilege integration account. Do not use SUPER.",
        "Record app publisher, name, version and checksum in the release register.",
    ]))

    story.append(p("11. Phase 7 — data migration", "h1"))
    story.append(p("11.1 Sequence", "h2"))
    story.append(numbered([
        "Freeze and cleanse source master data. Assign data owners and duplicate rules.",
        "Build mapping files for dimensions, posting groups, number series, payment terms, tax/VAT, units of measure, locations and employee identities.",
        "Load setup and reference data first, then master data, then open documents and opening balances.",
        "Use Configuration Packages (RapidStart) for initial company setup and controlled loads. Microsoft advises against using them for large ongoing imports into an active production company.",
        "Validate package data before applying. Correct the source file and repeat in UAT rather than editing unexplained differences in production.",
        "Post opening balances through controlled journals and reconcile to a signed source-system trial balance and subledgers.",
    ]))
    story.append(p("11.2 Mandatory reconciliation", "h2"))
    story.append(table(
        ["Area", "Evidence required"],
        [
            ["General ledger", "Trial balance by account and dimension equals the signed source balance."],
            ["Customers", "Total receivables and open invoice count match. Aging is reviewed."],
            ["Vendors", "Total payables and open invoice count match. Bank details independently checked."],
            ["Bank", "Opening bank ledger balances agree to statements."],
            ["Inventory", "Quantity and value by item and location reconcile. Negative or zero-cost anomalies are approved."],
            ["Fixed assets", "Acquisition cost, accumulated depreciation and net book value reconcile."],
            ["HR / payroll (if in scope)", "Employee mapping, leave balances and payroll openings reconcile to HR-approved records."],
        ],
        [1.7 * inch, CONTENT_W - 1.7 * inch],
    ))

    story.append(p("12. Phase 8 — UAT and production readiness", "h1"))
    story.append(table(
        ["Test stream", "Minimum scenarios", "Owner"],
        [
            ["Finance", "Journal posting, period controls, dimensions, tax/VAT, bank reconciliation, financial reports", "Finance"],
            ["Sales", "Quote, order, shipment, invoice, credit memo, customer payment", "Sales / Finance"],
            ["Purchase", "Order, receipt, invoice matching, payment, cancellation, rejection", "Procurement / Finance"],
            ["Inventory", "Receipt, issue, transfer, adjustment, costing", "Warehouse"],
            ["Approvals", "Submit, sequential approve, reject with remark, substitute, unauthorised denial", "Process owners"],
            ["Notifications", "Submit, next approver, rejection, final approval, cancellation", "IT / owners"],
            ["Security", "Least privilege, segregation, audit trail", "Security / IT"],
            ["Recovery", "Restore SQL (or SaaS backup/copy), reconnect, validate extensions", "IT"],
            ["Performance", "Peak users, large reports, job queues", "IT / partner"],
        ],
        [1.25 * inch, 4.35 * inch, CONTENT_W - 5.6 * inch],
    ))
    story.append(p("12.1 Go-live quality gates", "h2"))
    story.append(bullets([
        "No unresolved Severity 1 or Severity 2 defects. Lower defects have an owner, workaround and approved target date.",
        "Workflows create the correct current approval entries.",
        "Approval decisions remain saved even if email delivery fails. Email failure is visible in Sent Emails, Email Outbox and Email Error Entries.",
        "Integrations do not create duplicate documents when retried.",
        "One full backup has been restored (or a SaaS environment copy restored) and verified by IT plus a functional owner.",
        "Security, license, data reconciliation, performance, monitoring and operations handover are signed.",
    ]))

    story.append(p("13. Phase 9 — cutover and go-live", "h1"))
    story.append(numbered([
        "Approve the cutover plan: owners, timestamps, communication tree, stop/go criteria and rollback deadline.",
        "Stop legacy postings at the agreed freeze time. Take and verify final source backups and exports.",
        "Take a full backup of the target environment before final migration and keep a copy off the server (SaaS: create an environment backup or copy as supported).",
        "Load final master-data changes, open transactions and opening balances using the rehearsed packages.",
        "Run reconciliation and obtain Finance (and other process-owner) sign-off.",
        "Deploy the signed production extensions and integrations. Verify versions and checksums.",
        "Enable workflows, email, integrations and job queues in the agreed order.",
        "Run smoke tests with named users: sign-in, one controlled finance posting, one purchase, one sales document, one approval and one notification.",
        "Management makes the go / no-go decision. Communicate the production URL, support contacts and known limitations.",
    ]))
    story.append(p("13.1 Rollback", "h2"))
    story.append(p("Initiate rollback before irreversible processing exceeds the agreed cutoff if any of the following occurs:"))
    story.append(bullets([
        "Database integrity, posting or opening-balance reconciliation fails.",
        "Users cannot authenticate securely, or privileged access is uncontrolled.",
        "A core approval workflow fails or assigns the wrong user.",
        "An integration creates duplicate or incorrect documents.",
        "Backup cannot be restored, or critical monitoring is unavailable.",
    ]))
    story.append(callout(
        "Rollback rule",
        "Do not uninstall extensions or manually reverse database changes during an incident unless that exact rollback was rehearsed. Prefer restoring the pre-cutover database (or SaaS copy) and reverting application artifacts under the approved plan.",
        "risk",
    ))

    story.append(p("14. Production operations", "h1"))
    story.append(table(
        ["Frequency", "Operational control"],
        [
            ["Daily", "Service health, backups, job-queue errors, email outbox/errors, disk space, failed integrations."],
            ["Weekly", "Slow reports, certificate and secret expiry, privileged changes, open support tickets."],
            ["Monthly", "Patch OS/SQL/Business Central in UAT first. Review database growth, performance, backup retention and license assignments."],
            ["Quarterly", "Access and segregation-of-duties review, restore test, workflow/approver review, disaster-recovery evidence."],
            ["Annually", "Capacity plan, license review, security assessment, retention policy and a full business-continuity test."],
        ],
        [1.35 * inch, CONTENT_W - 1.35 * inch],
    ))
    story.append(p("On-premises extension upgrade (after UAT):"))
    story.append(code_block(
        '$ServerInstance = "BC_PROD"\n'
        '$Tenant = "default"\n'
        '$Version = "X.Y.Z.W"\n'
        'Publish-NAVApp -ServerInstance $ServerInstance -Path "C:\\BCSetup\\Apps\\NewVersion.app"\n'
        'Sync-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -Name "AppName" -Publisher "Publisher" -Version $Version\n'
        'Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Tenant $Tenant -Name "AppName" -Publisher "Publisher" -Version $Version\n'
        "Restart-NAVServerInstance -ServerInstance $ServerInstance"
    ))

    story.append(p("15. Troubleshooting", "h1"))
    story.append(table(
        ["Symptom", "First checks"],
        [
            ["Cannot sign in", "Service running, HTTPS certificate, authentication type, user state, permission set, time sync, event logs."],
            ["License error", "Correct .bclicense or SaaS license assignment, import/restart, licensed granules or plans."],
            ["Extension will not publish", "Target symbols/runtime, dependencies, code signing, developer rights, server event log."],
            ["Cannot post", "Posting groups, VAT setup, number series, allowed posting dates, dimension combinations, blocked accounts."],
            ["Workflow response missing", "Installed app version, workflow step configuration, service restart."],
            ["Wrong approver", "Approval User Setup, User Setup, employee User ID, duplicate mappings."],
            ["Email not received", "Default Email Account, Test Email, recipient, notification schedule, Sent Emails, Outbox, Error Entries."],
            ["Job queue stopped", "Entry status, user license and permissions, earliest start, log entries."],
        ],
        [1.9 * inch, CONTENT_W - 1.9 * inch],
    ))

    story.append(p("16. What process owners must provide", "h1"))
    story.append(table(
        ["#", "Owner", "Required input"],
        [
            ["1", "IT / partner", "Confirmed release, license, environment names or server names, HTTPS URL"],
            ["2", "Finance", "Chart of accounts, posting groups, tax codes, dimensions, number series, bank list, posting-date policy"],
            ["3", "Finance", "Opening trial balance, customer and vendor openings, bank openings"],
            ["4", "Finance", "Payment terms, payment methods, approval limits and named approvers"],
            ["5", "Sales / AR", "Customer master, credit policy, invoice and reminder rules"],
            ["6", "Procurement / AP", "Vendor master, tax status, bank details, purchase approval sequence"],
            ["7", "Warehouse", "Locations, items, units of measure, costing method, storekeepers"],
            ["8", "HR (if in scope)", "Employee list, departments, leave types, opening leave balances, company email"],
            ["9", "Management", "Go-live date, freeze window, legal entity name, and go/no-go authority"],
        ],
        [0.45 * inch, 1.45 * inch, CONTENT_W - 1.9 * inch],
    ))

    story.append(p("17. Sign-off", "h1"))
    story.append(table(
        ["Approval area", "Name", "Decision / date"],
        [
            ["Executive sponsor", "", "Approve / Hold"],
            ["Finance", "", "Approve / Hold"],
            ["Operations / Warehouse", "", "Approve / Hold"],
            ["IT / Security", "", "Approve / Hold"],
            ["Microsoft partner", "", "Ready / Not ready"],
        ],
        [2.1 * inch, 2.5 * inch, CONTENT_W - 4.6 * inch],
    ))
    story.append(callout(
        "Go-live authorisation",
        "Production may open only when the quality gates are passed, the final backup is verified, rollback remains available, and the executive sponsor records an explicit GO decision.",
        "success",
    ))

    story.append(p("Appendix A — production worksheet", "h1"))
    story.append(table(
        ["Item", "Approved value / owner"],
        [
            ["Deployment model (SaaS / on-premises)", ""],
            ["Target Business Central release / CU", ""],
            ["License entitlement confirmed by", ""],
            ["Production company name", ""],
            ["Environment or server instance / tenant", ""],
            ["SQL host / database (on-premises)", ""],
            ["Production HTTPS URL", ""],
            ["Certificate expiry / renewal owner", ""],
            ["Authentication / MFA design", ""],
            ["Custom app version / checksum", ""],
            ["RPO / RTO", ""],
            ["Cutover and rollback times", ""],
            ["Support escalation contacts", ""],
        ],
        [3.1 * inch, CONTENT_W - 3.1 * inch],
    ))

    story.append(p("Appendix B — Microsoft references", "h1"))
    refs = [
        ("S1", "Business Central on-premises lifecycle",
         "https://learn.microsoft.com/en-us/lifecycle/products/dynamics-365-business-central-onpremises-modern-policy"),
        ("S2", "System requirements (check the version you will install)",
         "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/deployment/system-requirement"),
        ("S3", "Product and architecture overview",
         "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/deployment/product-and-architecture-overview"),
        ("S4", "Install Business Central using Setup",
         "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/deployment/install-using-setup"),
        ("S5", "Upload the on-premises license",
         "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/cside/cside-upload-license-file"),
        ("S6", "Create and manage environments (SaaS admin center)",
         "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/tenant-admin-center"),
        ("S7", "Security overview",
         "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/security/security-and-protection"),
        ("S8", "Set up company information and Assisted Setup",
         "https://learn.microsoft.com/en-us/dynamics365/business-central/ui-get-ready-business"),
        ("S9", "Set up email",
         "https://learn.microsoft.com/en-us/dynamics365/business-central/admin-how-setup-email"),
        ("S10", "Set up approval workflows",
         "https://learn.microsoft.com/en-us/dynamics365/business-central/across-set-up-workflows"),
        ("S11", "Use job queues to schedule tasks",
         "https://learn.microsoft.com/en-us/dynamics365/business-central/admin-job-queues-schedule-tasks"),
        ("S12", "Apply company configuration packages",
         "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/apply-company-configuration-packages"),
        ("S13", "Upgrade extensions",
         "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-upgrading-extensions"),
        ("S14", "Business Central licensing guide",
         "https://go.microsoft.com/fwlink/?LinkId=866544"),
    ]
    for code, title, url in refs:
        story.append(Paragraph(
            f'<b>{code}</b>  <link href="{url}" color="#2E74B5"><u>{title}</u></link>',
            S["link"],
        ))
    story.append(Spacer(1, 8))
    story.append(p(
        "References should be re-checked against the selected release immediately before installation. "
        "Microsoft documentation and lifecycle dates change over time.",
        "small",
    ))
    return story


def main():
    story = build_story()
    last = None
    for path in OUT_PATHS:
        try:
            path.parent.mkdir(parents=True, exist_ok=True)
            doc = SimpleDocTemplate(
                str(path),
                pagesize=letter,
                leftMargin=LEFT,
                rightMargin=RIGHT,
                topMargin=TOP,
                bottomMargin=BOTTOM,
                title="Business Central ERP Setup Guide",
                author="ERP Implementation Team",
                subject="Generic Microsoft Dynamics 365 Business Central setup handbook",
            )
            doc.build(story, onFirstPage=cover_header_footer, onLaterPages=header_footer)
            last = path
            print(path)
        except OSError as exc:
            print(f"SKIP {path}: {exc}")
    if last is None:
        raise SystemExit("No PDF could be written")


if __name__ == "__main__":
    main()
