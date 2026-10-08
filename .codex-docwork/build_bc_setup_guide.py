from pathlib import Path

from docx import Document
from docx.enum.section import WD_SECTION
from docx.enum.style import WD_STYLE_TYPE
from docx.enum.table import WD_ALIGN_VERTICAL, WD_CELL_VERTICAL_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_BREAK, WD_LINE_SPACING
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Inches, Pt, RGBColor


OUT_DIR = Path("/Users/abhishekbehera/SelfServiceBackend-ABH/deliverables")
OUT_DIR.mkdir(parents=True, exist_ok=True)
OUT_PATH = OUT_DIR / "ABH_Business_Central_ERP_Full_Setup_Guide.docx"
OUT_PATH_ERP = Path("/Users/abhishekbehera/ABH_UAT_LIVE_V2/docs/ABH_Business_Central_ERP_Full_Setup_Guide.docx")

# compact_reference_guide preset tokens
PAGE_WIDTH_DXA = 12240
PAGE_HEIGHT_DXA = 15840
CONTENT_WIDTH_DXA = 9360
TABLE_INDENT_DXA = 120
CELL_TOP_BOTTOM_DXA = 80
CELL_START_END_DXA = 120
LIST_LEFT_DXA = 540
LIST_HANGING_DXA = 271

NAVY = "17365D"
BLUE = "2E74B5"
DARK_BLUE = "1F4D78"
TEAL = "008C95"
LIGHT_BLUE = "E8EEF5"
LIGHT_TEAL = "E8F6F6"
LIGHT_GRAY = "F2F4F7"
MID_GRAY = "667085"
DARK = "1F2937"
WHITE = "FFFFFF"
GOLD = "A36A00"
LIGHT_GOLD = "FFF4D6"
RED = "9B1C1C"
LIGHT_RED = "FDECEC"
GREEN = "1F6D4D"
LIGHT_GREEN = "EAF6EF"


def set_cell_shading(cell, fill):
    tc_pr = cell._tc.get_or_add_tcPr()
    shd = tc_pr.find(qn("w:shd"))
    if shd is None:
        shd = OxmlElement("w:shd")
        tc_pr.append(shd)
    shd.set(qn("w:fill"), fill)


def set_cell_margins(cell, top=CELL_TOP_BOTTOM_DXA, start=CELL_START_END_DXA,
                     bottom=CELL_TOP_BOTTOM_DXA, end=CELL_START_END_DXA):
    tc_pr = cell._tc.get_or_add_tcPr()
    tc_mar = tc_pr.find(qn("w:tcMar"))
    if tc_mar is None:
        tc_mar = OxmlElement("w:tcMar")
        tc_pr.append(tc_mar)
    for edge, value in (("top", top), ("start", start), ("bottom", bottom), ("end", end)):
        tag = tc_mar.find(qn(f"w:{edge}"))
        if tag is None:
            tag = OxmlElement(f"w:{edge}")
            tc_mar.append(tag)
        tag.set(qn("w:w"), str(value))
        tag.set(qn("w:type"), "dxa")


def set_table_borders(table, color="B8C4D2", size="4"):
    tbl_pr = table._tbl.tblPr
    borders = tbl_pr.find(qn("w:tblBorders"))
    if borders is None:
        borders = OxmlElement("w:tblBorders")
        tbl_pr.append(borders)
    for edge in ("top", "left", "bottom", "right", "insideH", "insideV"):
        node = borders.find(qn(f"w:{edge}"))
        if node is None:
            node = OxmlElement(f"w:{edge}")
            borders.append(node)
        node.set(qn("w:val"), "single")
        node.set(qn("w:sz"), size)
        node.set(qn("w:space"), "0")
        node.set(qn("w:color"), color)


def set_table_geometry(table, widths_dxa):
    assert sum(widths_dxa) == CONTENT_WIDTH_DXA
    table.autofit = False
    tbl_pr = table._tbl.tblPr
    tbl_w = tbl_pr.find(qn("w:tblW"))
    if tbl_w is None:
        tbl_w = OxmlElement("w:tblW")
        tbl_pr.append(tbl_w)
    tbl_w.set(qn("w:w"), str(CONTENT_WIDTH_DXA))
    tbl_w.set(qn("w:type"), "dxa")
    tbl_ind = tbl_pr.find(qn("w:tblInd"))
    if tbl_ind is None:
        tbl_ind = OxmlElement("w:tblInd")
        tbl_pr.append(tbl_ind)
    tbl_ind.set(qn("w:w"), str(TABLE_INDENT_DXA))
    tbl_ind.set(qn("w:type"), "dxa")
    layout = tbl_pr.find(qn("w:tblLayout"))
    if layout is None:
        layout = OxmlElement("w:tblLayout")
        tbl_pr.append(layout)
    layout.set(qn("w:type"), "fixed")

    grid = table._tbl.tblGrid
    for child in list(grid):
        grid.remove(child)
    for width in widths_dxa:
        col = OxmlElement("w:gridCol")
        col.set(qn("w:w"), str(width))
        grid.append(col)

    for row in table.rows:
        for idx, cell in enumerate(row.cells):
            tc_pr = cell._tc.get_or_add_tcPr()
            tc_w = tc_pr.find(qn("w:tcW"))
            if tc_w is None:
                tc_w = OxmlElement("w:tcW")
                tc_pr.append(tc_w)
            tc_w.set(qn("w:w"), str(widths_dxa[idx]))
            tc_w.set(qn("w:type"), "dxa")
            cell.width = Inches(widths_dxa[idx] / 1440)
            cell.vertical_alignment = WD_CELL_VERTICAL_ALIGNMENT.CENTER
            set_cell_margins(cell)
    set_table_borders(table)


def set_repeat_table_header(row):
    tr_pr = row._tr.get_or_add_trPr()
    tbl_header = OxmlElement("w:tblHeader")
    tbl_header.set(qn("w:val"), "true")
    tr_pr.append(tbl_header)


def set_run_font(run, name="Calibri", size=11, color=DARK, bold=False, italic=False):
    run.font.name = name
    run._element.get_or_add_rPr().rFonts.set(qn("w:ascii"), name)
    run._element.get_or_add_rPr().rFonts.set(qn("w:hAnsi"), name)
    run.font.size = Pt(size)
    run.font.color.rgb = RGBColor.from_string(color)
    run.bold = bold
    run.italic = italic


def set_paragraph_spacing(paragraph, before=0, after=6, line=1.25):
    pf = paragraph.paragraph_format
    pf.space_before = Pt(before)
    pf.space_after = Pt(after)
    pf.line_spacing_rule = WD_LINE_SPACING.MULTIPLE
    pf.line_spacing = line


def add_hyperlink(paragraph, text, url, color=BLUE):
    part = paragraph.part
    rel_id = part.relate_to(
        url,
        "http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink",
        is_external=True,
    )
    hyperlink = OxmlElement("w:hyperlink")
    hyperlink.set(qn("r:id"), rel_id)
    new_run = OxmlElement("w:r")
    r_pr = OxmlElement("w:rPr")
    r_color = OxmlElement("w:color")
    r_color.set(qn("w:val"), color)
    r_pr.append(r_color)
    underline = OxmlElement("w:u")
    underline.set(qn("w:val"), "single")
    r_pr.append(underline)
    fonts = OxmlElement("w:rFonts")
    fonts.set(qn("w:ascii"), "Calibri")
    fonts.set(qn("w:hAnsi"), "Calibri")
    r_pr.append(fonts)
    size = OxmlElement("w:sz")
    size.set(qn("w:val"), "20")
    r_pr.append(size)
    new_run.append(r_pr)
    text_node = OxmlElement("w:t")
    text_node.text = text
    new_run.append(text_node)
    hyperlink.append(new_run)
    paragraph._p.append(hyperlink)


def add_page_field(paragraph):
    run = paragraph.add_run()
    fld_char1 = OxmlElement("w:fldChar")
    fld_char1.set(qn("w:fldCharType"), "begin")
    instr_text = OxmlElement("w:instrText")
    instr_text.set(qn("xml:space"), "preserve")
    instr_text.text = " PAGE "
    fld_char2 = OxmlElement("w:fldChar")
    fld_char2.set(qn("w:fldCharType"), "end")
    run._r.append(fld_char1)
    run._r.append(instr_text)
    run._r.append(fld_char2)
    set_run_font(run, size=9, color=MID_GRAY)


def add_paragraph_border(paragraph, color=TEAL, size="16", space="4"):
    p_pr = paragraph._p.get_or_add_pPr()
    p_bdr = p_pr.find(qn("w:pBdr"))
    if p_bdr is None:
        p_bdr = OxmlElement("w:pBdr")
        p_pr.append(p_bdr)
    bottom = OxmlElement("w:bottom")
    bottom.set(qn("w:val"), "single")
    bottom.set(qn("w:sz"), size)
    bottom.set(qn("w:space"), space)
    bottom.set(qn("w:color"), color)
    p_bdr.append(bottom)


def add_para(doc, text="", *, style=None, size=None, bold=False, italic=False,
             color=DARK, align=None, before=0, after=6, line=1.25,
             keep_with_next=False):
    p = doc.add_paragraph(style=style)
    if text:
        run = p.add_run(text)
        set_run_font(run, size=size or 11, color=color, bold=bold, italic=italic)
    set_paragraph_spacing(p, before=before, after=after, line=line)
    if align is not None:
        p.alignment = align
    p.paragraph_format.keep_with_next = keep_with_next
    return p


def add_callout(doc, title, body, kind="info"):
    palettes = {
        "info": (LIGHT_TEAL, TEAL),
        "warning": (LIGHT_GOLD, GOLD),
        "risk": (LIGHT_RED, RED),
        "success": (LIGHT_GREEN, GREEN),
    }
    fill, accent = palettes[kind]
    p = doc.add_paragraph()
    p.style = doc.styles["Callout"]
    p_pr = p._p.get_or_add_pPr()
    shd = OxmlElement("w:shd")
    shd.set(qn("w:fill"), fill)
    p_pr.append(shd)
    borders = OxmlElement("w:pBdr")
    left = OxmlElement("w:left")
    left.set(qn("w:val"), "single")
    left.set(qn("w:sz"), "28")
    left.set(qn("w:space"), "8")
    left.set(qn("w:color"), accent)
    borders.append(left)
    p_pr.append(borders)
    title_run = p.add_run(title.upper() + "  ")
    set_run_font(title_run, size=10.5, color=accent, bold=True)
    body_run = p.add_run(body)
    set_run_font(body_run, size=10.5, color=DARK)
    return p


def add_code_block(doc, lines):
    p = doc.add_paragraph(style="Code Block")
    for idx, line in enumerate(lines):
        if idx:
            p.add_run().add_break()
        run = p.add_run(line)
        set_run_font(run, name="Consolas", size=8.5, color="263238")
    p_pr = p._p.get_or_add_pPr()
    shd = OxmlElement("w:shd")
    shd.set(qn("w:fill"), "F5F7FA")
    p_pr.append(shd)
    borders = OxmlElement("w:pBdr")
    for edge in ("top", "left", "bottom", "right"):
        node = OxmlElement(f"w:{edge}")
        node.set(qn("w:val"), "single")
        node.set(qn("w:sz"), "4")
        node.set(qn("w:space"), "3")
        node.set(qn("w:color"), "CFD8E3")
        borders.append(node)
    p_pr.append(borders)
    return p


def add_table(doc, headers, rows, widths_dxa, *, compact=False):
    table = doc.add_table(rows=1, cols=len(headers))
    table.style = "Table Grid"
    hdr = table.rows[0]
    set_repeat_table_header(hdr)
    for idx, header in enumerate(headers):
        cell = hdr.cells[idx]
        set_cell_shading(cell, LIGHT_BLUE)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.LEFT
        set_paragraph_spacing(p, after=0, line=1.0)
        run = p.add_run(header)
        set_run_font(run, size=9.5 if compact else 10, color=NAVY, bold=True)
    for row_idx, values in enumerate(rows):
        cells = table.add_row().cells
        for col_idx, value in enumerate(values):
            if row_idx % 2 == 1:
                set_cell_shading(cells[col_idx], "FAFBFC")
            p = cells[col_idx].paragraphs[0]
            set_paragraph_spacing(p, after=0, line=1.05)
            run = p.add_run(str(value))
            set_run_font(run, size=9 if compact else 9.5, color=DARK)
    set_table_geometry(table, widths_dxa)
    spacer = doc.add_paragraph()
    spacer.paragraph_format.space_after = Pt(2)
    return table


def add_heading(doc, text, level=1):
    p = doc.add_paragraph(style=f"Heading {level}")
    run = p.add_run(text)
    sizes = {1: 16, 2: 13, 3: 12}
    colors = {1: BLUE, 2: BLUE, 3: DARK_BLUE}
    set_run_font(run, size=sizes[level], color=colors[level], bold=True)
    return p


def add_bullet(doc, text, level=0):
    p = doc.add_paragraph()
    p.style = doc.styles["Normal"]
    p.paragraph_format.left_indent = Inches(LIST_LEFT_DXA / 1440)
    p.paragraph_format.first_line_indent = Inches(-LIST_HANGING_DXA / 1440)
    p.paragraph_format.space_after = Pt(4)
    p.paragraph_format.line_spacing_rule = WD_LINE_SPACING.MULTIPLE
    p.paragraph_format.line_spacing = 1.25
    num_pr = OxmlElement("w:numPr")
    ilvl = OxmlElement("w:ilvl")
    ilvl.set(qn("w:val"), str(level))
    num_id = OxmlElement("w:numId")
    num_id.set(qn("w:val"), str(BULLET_NUM_ID))
    num_pr.append(ilvl)
    num_pr.append(num_id)
    p._p.get_or_add_pPr().append(num_pr)
    run = p.add_run(text)
    set_run_font(run)
    return p


def add_numbered(doc, text, level=0):
    p = doc.add_paragraph()
    p.style = doc.styles["Normal"]
    p.paragraph_format.left_indent = Inches(LIST_LEFT_DXA / 1440)
    p.paragraph_format.first_line_indent = Inches(-LIST_HANGING_DXA / 1440)
    p.paragraph_format.space_after = Pt(4)
    p.paragraph_format.line_spacing_rule = WD_LINE_SPACING.MULTIPLE
    p.paragraph_format.line_spacing = 1.25
    num_pr = OxmlElement("w:numPr")
    ilvl = OxmlElement("w:ilvl")
    ilvl.set(qn("w:val"), str(level))
    num_id = OxmlElement("w:numId")
    num_id.set(qn("w:val"), str(NUMBER_NUM_ID))
    num_pr.append(ilvl)
    num_pr.append(num_id)
    p._p.get_or_add_pPr().append(num_pr)
    run = p.add_run(text)
    set_run_font(run)
    return p


def create_numbering(doc, fmt, text, font=None):
    numbering = doc.part.numbering_part.element
    abstract_ids = [int(x.get(qn("w:abstractNumId"))) for x in numbering.findall(qn("w:abstractNum"))]
    num_ids = [int(x.get(qn("w:numId"))) for x in numbering.findall(qn("w:num"))]
    abstract_id = max(abstract_ids, default=0) + 1
    num_id = max(num_ids, default=0) + 1
    abstract = OxmlElement("w:abstractNum")
    abstract.set(qn("w:abstractNumId"), str(abstract_id))
    multi = OxmlElement("w:multiLevelType")
    multi.set(qn("w:val"), "singleLevel")
    abstract.append(multi)
    lvl = OxmlElement("w:lvl")
    lvl.set(qn("w:ilvl"), "0")
    start = OxmlElement("w:start")
    start.set(qn("w:val"), "1")
    lvl.append(start)
    num_fmt = OxmlElement("w:numFmt")
    num_fmt.set(qn("w:val"), fmt)
    lvl.append(num_fmt)
    lvl_text = OxmlElement("w:lvlText")
    lvl_text.set(qn("w:val"), text)
    lvl.append(lvl_text)
    lvl_jc = OxmlElement("w:lvlJc")
    lvl_jc.set(qn("w:val"), "left")
    lvl.append(lvl_jc)
    p_pr = OxmlElement("w:pPr")
    tabs = OxmlElement("w:tabs")
    tab = OxmlElement("w:tab")
    tab.set(qn("w:val"), "num")
    tab.set(qn("w:pos"), str(LIST_LEFT_DXA))
    tabs.append(tab)
    p_pr.append(tabs)
    ind = OxmlElement("w:ind")
    ind.set(qn("w:left"), str(LIST_LEFT_DXA))
    ind.set(qn("w:hanging"), str(LIST_HANGING_DXA))
    p_pr.append(ind)
    lvl.append(p_pr)
    if font:
        r_pr = OxmlElement("w:rPr")
        r_fonts = OxmlElement("w:rFonts")
        r_fonts.set(qn("w:ascii"), font)
        r_fonts.set(qn("w:hAnsi"), font)
        r_pr.append(r_fonts)
        lvl.append(r_pr)
    abstract.append(lvl)
    numbering.append(abstract)
    num = OxmlElement("w:num")
    num.set(qn("w:numId"), str(num_id))
    abs_id = OxmlElement("w:abstractNumId")
    abs_id.set(qn("w:val"), str(abstract_id))
    num.append(abs_id)
    numbering.append(num)
    return num_id


def set_keep_lines(paragraph):
    paragraph.paragraph_format.keep_together = True


doc = Document()
section = doc.sections[0]
section.page_width = Inches(8.5)
section.page_height = Inches(11)
section.top_margin = Inches(1)
section.right_margin = Inches(1)
section.bottom_margin = Inches(1)
section.left_margin = Inches(1)
section.header_distance = Inches(0.492)
section.footer_distance = Inches(0.492)

# Explicit style sheet
normal = doc.styles["Normal"]
normal.font.name = "Calibri"
normal._element.rPr.rFonts.set(qn("w:ascii"), "Calibri")
normal._element.rPr.rFonts.set(qn("w:hAnsi"), "Calibri")
normal.font.size = Pt(11)
normal.font.color.rgb = RGBColor.from_string(DARK)
normal.paragraph_format.space_before = Pt(0)
normal.paragraph_format.space_after = Pt(6)
normal.paragraph_format.line_spacing_rule = WD_LINE_SPACING.MULTIPLE
normal.paragraph_format.line_spacing = 1.25

heading_tokens = {
    1: (16, BLUE, 18, 10),
    2: (13, BLUE, 14, 7),
    3: (12, DARK_BLUE, 10, 5),
}
for level, (size, color, before, after) in heading_tokens.items():
    style = doc.styles[f"Heading {level}"]
    style.font.name = "Calibri"
    style._element.rPr.rFonts.set(qn("w:ascii"), "Calibri")
    style._element.rPr.rFonts.set(qn("w:hAnsi"), "Calibri")
    style.font.size = Pt(size)
    style.font.bold = True
    style.font.color.rgb = RGBColor.from_string(color)
    style.paragraph_format.space_before = Pt(before)
    style.paragraph_format.space_after = Pt(after)
    style.paragraph_format.line_spacing_rule = WD_LINE_SPACING.MULTIPLE
    style.paragraph_format.line_spacing = 1.0
    style.paragraph_format.keep_with_next = True

for style_name in ("Callout", "Code Block"):
    if style_name not in [s.name for s in doc.styles]:
        style = doc.styles.add_style(style_name, WD_STYLE_TYPE.PARAGRAPH)
    else:
        style = doc.styles[style_name]
    style.font.name = "Calibri" if style_name == "Callout" else "Consolas"
    style.font.size = Pt(10.5 if style_name == "Callout" else 8.5)
    style.paragraph_format.space_before = Pt(5)
    style.paragraph_format.space_after = Pt(8)
    style.paragraph_format.left_indent = Inches(0.12)
    style.paragraph_format.right_indent = Inches(0.12)
    style.paragraph_format.line_spacing_rule = WD_LINE_SPACING.MULTIPLE
    style.paragraph_format.line_spacing = 1.12
    style.paragraph_format.keep_together = True

BULLET_NUM_ID = create_numbering(doc, "bullet", "•", "Calibri")
NUMBER_NUM_ID = create_numbering(doc, "decimal", "%1.")

# Running header/footer
header = section.header
hp = header.paragraphs[0]
hp.alignment = WD_ALIGN_PARAGRAPH.RIGHT
set_paragraph_spacing(hp, after=0, line=1.0)
hr = hp.add_run("ABH PARTNERS  |  ERP IMPLEMENTATION GUIDE")
set_run_font(hr, size=8.5, color=MID_GRAY, bold=True)

footer = section.footer
fp = footer.paragraphs[0]
fp.alignment = WD_ALIGN_PARAGRAPH.RIGHT
set_paragraph_spacing(fp, after=0, line=1.0)
fr = fp.add_run("INTERNAL  •  VERSION 1.0  •  PAGE ")
set_run_font(fr, size=8.5, color=MID_GRAY)
add_page_field(fp)

# Cover: editorial_cover pattern
add_para(doc, "ABH PARTNERS", size=11, bold=True, color=TEAL,
         align=WD_ALIGN_PARAGRAPH.CENTER, before=95, after=16, line=1.0)
cover_title = add_para(
    doc,
    "Microsoft Dynamics 365\nBusiness Central ERP",
    size=29,
    bold=True,
    color=NAVY,
    align=WD_ALIGN_PARAGRAPH.CENTER,
    after=9,
    line=1.05,
)
add_para(doc, "Fresh On-Premises Deployment and Configuration Guide",
         size=15, color=DARK_BLUE, align=WD_ALIGN_PARAGRAPH.CENTER,
         after=20, line=1.05)
rule = add_para(doc, "", after=18)
add_paragraph_border(rule, color=TEAL, size="18", space="5")
add_para(doc, "Management approval • Infrastructure • Installation • Security • ERP configuration • Integration • UAT • Go-live",
         size=10.5, color=MID_GRAY, align=WD_ALIGN_PARAGRAPH.CENTER,
         after=70, line=1.25)
add_para(doc, "Prepared for", size=9, bold=True, color=MID_GRAY,
         align=WD_ALIGN_PARAGRAPH.CENTER, after=2, line=1.0)
add_para(doc, "Management, IT, Finance, HR, Procurement and Stores",
         size=11, bold=True, color=NAVY, align=WD_ALIGN_PARAGRAPH.CENTER,
         after=16, line=1.0)
add_para(doc, "Document version 1.0  |  3 September 2026  |  Internal use",
         size=9.5, color=MID_GRAY, align=WD_ALIGN_PARAGRAPH.CENTER,
         after=8, line=1.0)
add_para(doc, "Licensed stack: Microsoft Dynamics 365 Business Central on-premises  •  Custom app BC24_TA App  •  Company ABH PARTNERS PLC  •  Currency ETB",
         size=9, color=MID_GRAY, align=WD_ALIGN_PARAGRAPH.CENTER,
         after=0, line=1.15)
doc.add_page_break()

add_heading(doc, "Document control and intended use", 1)
add_para(doc, "This is an implementation control document for establishing a new, production-grade Microsoft Dynamics 365 Business Central ERP environment. It is written for management approval and for execution by the internal IT team together with the Microsoft partner. It does not replace Microsoft licensing terms, a solution design, or country-specific accounting and tax advice.")
add_table(
    doc,
    ["Control", "Value"],
    [
        ("Owner", "ERP Implementation Sponsor / IT Manager"),
        ("Technical owner", "Business Central Administrator / Microsoft Partner"),
        ("Legal entity", "ABH PARTNERS PLC (not ABH SERVICES PLC unless management confirms a change)"),
        ("Target deployment", "New on-premises production environment using the existing ABH license"),
        ("Reference environment", "ABH UAT (BC240, tenant default, custom app BC24_TA App, self-service portal)"),
        ("Status", "Draft for management, IT, Finance, HR, Procurement and process-owner approval"),
        ("Change rule", "No production change without backup, change record, tested rollback and authorized window"),
    ],
    [1800, 7560],
)

add_callout(
    doc,
    "Release decision required",
    "Business Central 24 reached end of servicing on 8 October 2025. Do not use BC24 as the target for a new 2026 production deployment. The recommended target is BC28; BC27 is the fallback if partner, license, localization or custom-extension compatibility requires it. The chosen version must be confirmed before hardware sizing or installation.",
    "risk",
)

add_heading(doc, "Management decisions required before work starts", 2)
add_table(
    doc,
    ["Decision", "Recommended position", "Approval"],
    [
        ("Product release", "BC28, latest supported cumulative update; BC27 only as approved fallback", "[ ]"),
        ("Hosting model", "Two-tier core: application/web server plus separate SQL server; separate portal host if internet-facing", "[ ]"),
        ("Identity", "Microsoft Entra ID/OpenID Connect with MFA; Windows authentication only for approved internal-only use", "[ ]"),
        ("Recovery objectives", "Business owner to approve RPO and RTO before backup design is finalized", "[ ]"),
        ("Go-live authority", "Joint sign-off by Management, Finance, IT and functional owners", "[ ]"),
    ],
    [2200, 6200, 960],
    compact=True,
)

add_heading(doc, "Guide at a glance", 2)
for item in [
    "Phase 0 — confirm scope, license entitlement, release and ownership",
    "Phase 1 — prepare servers, SQL, DNS, certificates, accounts and firewall rules",
    "Phase 2 — install and validate the Business Central platform",
    "Phase 3 — import the license and establish the production company",
    "Phase 4 — configure identity, users, permissions and audit controls",
    "Phase 5 — configure Finance, Purchase, Stores, HR/Leave and other business areas",
    "Phase 6 — deploy the ABH custom app and connect the self-service portal",
    "Phase 7 — configure email, notifications, approval workflows and job queues",
    "Phase 8 — migrate and reconcile data",
    "Phase 9 — execute UAT, security, performance and recovery tests",
    "Phase 10 — cut over, verify, sign off and operate",
]:
    add_bullet(doc, item)

add_heading(doc, "1. Executive recommendation", 1)
add_para(doc, "ABH should treat the new environment as a controlled ERP implementation, not as a server-copy exercise. The production platform, database, custom extension, portal, user mappings, approval workflows, email and migrated balances must be tested together as one system.")
add_callout(
    doc,
    "Recommended target state",
    "Deploy a supported Business Central release on supported Windows Server and SQL Server, expose only HTTPS to users, keep SQL private, use least-privilege accounts, maintain separate UAT and Production environments, and require a tested backup/restore plus signed UAT before go-live.",
    "success",
)

add_heading(doc, "1.1 Proposed production architecture", 2)
arch = add_para(doc, "Users and Self-Service Portal  — HTTPS 443 —>  IIS / BC Web / Portal Gateway\n"
                "                                                         |\n"
                "                                                         v\n"
                "                                               Business Central Server\n"
                "                                                         |\n"
                "                                                         v\n"
                "                                                  SQL Server Database",
                size=9, color=NAVY, align=WD_ALIGN_PARAGRAPH.CENTER,
                before=4, after=8, line=1.05)
arch.style = doc.styles["Code Block"]
add_para(doc, "Core recommendation: install the Business Central Web Server components and Business Central Server together on the application server, and place SQL Server on a separate database server. If the portal is internet-facing, place it on a separate host or reverse-proxy tier. Never expose SQL Server, administration services or developer services directly to the internet.")

add_heading(doc, "1.2 Environment separation", 2)
add_table(
    doc,
    ["Environment", "Purpose", "Data rule"],
    [
        ("Development", "AL development, automated tests and developer publishing", "Synthetic or masked data only"),
        ("UAT", "Business-process testing, training and deployment rehearsal", "Masked production-like data; no live integrations without approval"),
        ("Production", "Live accounting, purchasing, stores, HR and approvals", "Controlled access; auditable changes only"),
    ],
    [1700, 4160, 3500],
)

add_heading(doc, "2. Governance, scope and responsibilities", 1)
add_heading(doc, "2.1 Minimum project roles", 2)
add_table(
    doc,
    ["Role", "Accountability"],
    [
        ("Executive sponsor", "Approves scope, budget, release choice, downtime and final go-live."),
        ("Project manager", "Maintains plan, risks, decisions, dependencies and sign-offs."),
        ("Business Central partner", "Confirms licensing, localization, supported release, installation and extension compatibility."),
        ("IT infrastructure", "Builds servers, network, DNS, certificates, monitoring, backups and disaster recovery."),
        ("BC administrator", "Configures instance, company, users, permissions, workflows, email and job queues."),
        ("Functional owners", "Finance, Procurement, Stores, HR and Payroll approve setup and test results."),
        ("Security owner", "Reviews identities, privileged access, firewall rules, service accounts and audit evidence."),
        ("Data owners", "Clean, map, approve and reconcile migrated data and opening balances."),
    ],
    [2350, 7010],
)

add_heading(doc, "2.2 Scope to confirm", 2)
for item in [
    "Legal entities/companies, branches, currencies, fiscal calendar, localization and reporting obligations.",
    "Modules in scope: General Ledger, Receivables, Payables, Cash/Bank, Fixed Assets, Purchasing, Inventory/Stores, HR/Leave, Payroll and portal approvals.",
    "User count, license type per user, concurrent usage, branches, remote access and expected transaction volume.",
    "Interfaces: email, self-service portal, banking, payroll, tax, Power BI, document storage or other systems.",
    "Historical data depth, opening-balance date, cutover blackout and record-retention requirements.",
]:
    add_bullet(doc, item)

add_heading(doc, "3. Phase 0 — licensing and release readiness", 1)
add_numbered(doc, "Ask the Microsoft partner to confirm that ABH's license and active enhancement/maintenance entitlement allow download and use of the selected on-premises release.")
add_numbered(doc, "Obtain the production .bclicense file through the authorized channel. Store it in a restricted administrator location; do not place it in source control or shared chat.")
add_numbered(doc, "Select BC28 latest cumulative update as the target unless the partner documents a reason to use BC27.")
add_numbered(doc, "Rebuild the ABH custom extension against symbols from the target version. The existing BC24 package must not be assumed compatible merely because it compiles for runtime 13.")
add_numbered(doc, "Complete a compatibility test covering schema synchronization, install/upgrade code, reports, APIs, workflows, email and portal operations.")
add_numbered(doc, "Record the exact platform version, application version, localization, cumulative update, custom-app version and compiler version in the release register.")

add_callout(doc, "Gate 0 exit criteria", "Release, license entitlement, localization and extension compatibility are documented and approved. If any item is unknown, infrastructure build may continue only as non-production preparation.", "warning")

add_heading(doc, "4. Phase 1 — infrastructure preparation", 1)
add_heading(doc, "4.1 Production sizing baseline", 2)
add_para(doc, "Final sizing must be based on users, transactions, report load, job queues, portal traffic and database growth. The following is a practical starting point, not a substitute for capacity testing.")
add_table(
    doc,
    ["Component", "Starting baseline", "Production notes"],
    [
        ("BC application/web server", "Windows Server 2022 or 2025; 8 vCPU; 32 GB RAM; 150 GB OS/app disk", "Use 32–64 GB if publishing a large extension; monitor CPU, memory and request queues."),
        ("SQL Server", "Supported SQL Server; 8–16 vCPU; 32–64 GB RAM; separate data, log and backup storage", "Size from database and growth; enable Full-Text Search; use latest supported SQL CU."),
        ("Portal server", "4–8 vCPU; 16 GB RAM; separate host when internet-facing", "Run as a managed service behind HTTPS reverse proxy; restrict BC/API access."),
        ("Backup repository", "Encrypted off-server storage with retention and immutable/offline copy", "Capacity must cover full, differential and log backups plus restore testing."),
    ],
    [2350, 3000, 4010],
    compact=True,
)

add_heading(doc, "4.2 Required prerequisites", 2)
for item in [
    "Supported 64-bit Windows Server, fully patched, domain joined where applicable, with accurate time synchronization.",
    "Supported SQL Server edition and cumulative update; Full-Text and Semantic Extractions for Search installed.",
    "For BC28: .NET 8, .NET Framework 4.8 for report rendering and Administration Shell, IIS 10, and Report Builder components as required by Microsoft Setup.",
    "Dedicated DNS name such as erp.company.example and a trusted TLS certificate matching the public/internal name.",
    "Dedicated service accounts, for example DOMAIN\\svc-bc-prod and DOMAIN\\svc-portal-prod, with denied interactive logon and least privilege.",
    "Separate administrator accounts for server/SQL administration; normal user accounts must not hold server administrator rights.",
    "Static IP addressing, documented firewall flows, monitoring agent, anti-malware exclusions approved for BC/SQL paths, and backup agent.",
]:
    add_bullet(doc, item)

add_heading(doc, "4.3 Network and port plan", 2)
add_table(
    doc,
    ["Flow", "Port", "Rule"],
    [
        ("Users / portal to HTTPS endpoint", "TCP 443", "Only user-facing inbound port; trusted certificate required."),
        ("Application server to SQL Server", "TCP 1433 or approved fixed SQL port", "Internal only; never internet-exposed."),
        ("BC management service", "TCP 7045 default", "Administrator subnet only."),
        ("BC client service", "TCP 7085 default for current releases", "Internal app/web flow only; confirm selected release."),
        ("SOAP services", "TCP 7047 default", "Enable only if required by the portal/integration; restrict source."),
        ("OData services", "TCP 7048 default", "Enable only if required; TLS and least-privilege authentication."),
        ("Developer service", "TCP 7049 default", "UAT/administrator subnet only; block public access."),
    ],
    [3430, 1820, 4110],
    compact=True,
)
add_para(doc, "Microsoft Setup allows ports to be changed. Confirm that every selected port is unused, documented and permitted only between the required hosts.", italic=True, color=MID_GRAY, size=9.5)

add_heading(doc, "4.4 Security baseline before installation", 2)
for item in [
    "Use HTTPS from first production access; do not accept a 'Not secure' browser warning as production-ready.",
    "Prefer Microsoft Entra ID/OpenID Connect and MFA. Windows authentication is acceptable for an approved internal-only design. Microsoft advises against NavUserPassword where stronger options are available.",
    "Do not store service-account passwords, email secrets, database credentials or license files in Git, scripts, portal source files or screenshots.",
    "Restrict RDP/WinRM to the administrator network and record privileged sessions under the organization's access policy.",
    "Keep Production and UAT databases, instances, URLs, certificates and integration credentials separate.",
]:
    add_bullet(doc, item)

add_heading(doc, "5. Phase 2 — install Business Central", 1)
add_heading(doc, "5.1 Prepare SQL Server", 2)
add_numbered(doc, "Install the supported SQL Server release and latest approved cumulative update. Include Full-Text Search.")
add_numbered(doc, "Configure dedicated data, log, tempdb and backup locations. Set SQL maximum server memory so the operating system and backup/monitoring agents retain capacity.")
add_numbered(doc, "Create or identify the BC database instance and grant the BC service account only the permissions required by Microsoft installation and runtime guidance.")
add_numbered(doc, "Configure full, differential and transaction-log backup jobs according to the approved RPO. Run and document a test restore before go-live.")
add_numbered(doc, "For BC28, use supported database compatibility level 160 or 170 as confirmed in the Microsoft system requirements.")

add_heading(doc, "5.2 Install the application and web components", 2)
add_numbered(doc, "Download installation media and the selected cumulative update only from Microsoft or the authorized partner. Record the source and checksum.")
add_numbered(doc, "Sign in to the application server with an installation administrator account and run setup.exe as Administrator.")
add_numbered(doc, "Choose Advanced installation options, then Custom. Install Business Central Server, Web Server Components and Administration Shell. Install development components only on approved administrator/development hosts.")
add_numbered(doc, "Set a clear server instance name, for example BC280_PROD. Enter the production SQL server and database details. Use the dedicated BC service account.")
add_numbered(doc, "Configure the web instance and HTTPS hostname. Do not expose the initial HTTP endpoint to users.")
add_numbered(doc, "Complete Setup, review the installation log, confirm the Business Central Server Windows service is running and open the web client from an administrator workstation.")

add_heading(doc, "5.3 Record the installation", 2)
add_table(
    doc,
    ["Setting", "Production value"],
    [
        ("BC release and cumulative update", "[[ENTER]]"),
        ("Server instance", "[[ENTER, e.g., BC280_PROD]]"),
        ("SQL server / instance", "[[ENTER]]"),
        ("Database name", "[[ENTER]]"),
        ("Web URL", "[[ENTER HTTPS URL]]"),
        ("Authentication type", "[[ENTRA ID / WINDOWS — APPROVED VALUE]]"),
        ("Service account", "[[ENTER ACCOUNT NAME; NEVER PASSWORD]]"),
        ("Certificate subject / expiry", "[[ENTER]]"),
    ],
    [3000, 6360],
)

add_heading(doc, "6. Phase 3 — license and base service validation", 1)
add_para(doc, "Open Business Central Administration Shell as Administrator on the application server. Replace the example values before execution.")
add_code_block(doc, [
    '$ServerInstance = "BC280_PROD"',
    '$LicenseFile = "C:\\BCSetup\\Licenses\\fin.bclicense"',
    'Import-NAVServerLicense -ServerInstance $ServerInstance -LicenseFile $LicenseFile',
    'Restart-NAVServerInstance -ServerInstance $ServerInstance',
    'Get-NAVServerInstance -ServerInstance $ServerInstance',
])
add_numbered(doc, "Sign in to the web client using the emergency implementation administrator.")
add_numbered(doc, "Open Help & Support and record platform and application version numbers.")
add_numbered(doc, "Open License Information and confirm the customer name, expiry/entitlement information and required granules.")
add_numbered(doc, "Verify the database connection, company list, event log and server telemetry. Resolve every startup or license error before configuration begins.")
add_callout(doc, "Security", "After the implementation team has created role-based administrators, restrict the emergency account and store its credential under the approved break-glass procedure.", "warning")

add_heading(doc, "7. Phase 4 — identity, users and permissions", 1)
add_heading(doc, "7.1 Identity design", 2)
add_para(doc, "Use one authoritative identity per person. The Business Central User ID, Employee User ID, Approval User Setup ID and portal identity must map consistently. Duplicate or shared mappings can show one person's approval under another user's name and are a production blocker.")
for item in [
    "Create named accounts for all human users. Shared accounts are prohibited except approved technical integration identities.",
    "Require MFA for remote and privileged access when Entra ID is used.",
    "Use dedicated, non-interactive service accounts for BC Server, portal integration and scheduled tasks.",
    "Maintain an approved User-to-Employee mapping register and test every approver identity.",
]:
    add_bullet(doc, item)

add_heading(doc, "7.2 Permission model", 2)
add_numbered(doc, "Create role-based permission sets for Finance, Procurement, Stores, HR, Payroll, Manager/Approver, Requester, Auditor and IT Administration.")
add_numbered(doc, "Assign the minimum base sign-in permissions required by the selected release, then add business permissions by job role.")
add_numbered(doc, "Limit SUPER to the smallest possible administrator group. Do not use SUPER to bypass a missing functional permission during UAT.")
add_numbered(doc, "Apply company-level access filters when a user must see only specific legal entities.")
add_numbered(doc, "Test segregation of duties: vendor creation vs payment, requester vs approver, store request vs issue, payroll preparation vs approval, and administrator vs auditor.")
add_numbered(doc, "Export the final user/permission assignment as go-live evidence and schedule quarterly access reviews.")

add_heading(doc, "8. Phase 5 — establish and configure the company", 1)
add_heading(doc, "8.1 Create the production company", 2)
add_numbered(doc, "Open Companies and choose New. Use Production — Setup Data Only or a controlled approved company template. Do not use an evaluation company with sample transactions for production.")
add_numbered(doc, "Enter Company Information: registered name, address, contacts, bank details, tax identifiers, logo and local reporting information.")
add_numbered(doc, "Set regional formats, language, time zone and work date policy. Confirm date display across BC and the portal.")
add_numbered(doc, "Create Base Calendars for weekends and public holidays. Apply them to the company and relevant processes so leave and operational dates do not count non-working days incorrectly.")

add_heading(doc, "8.2 Finance foundation", 2)
for item in [
    "Chart of Accounts, account categories, posting controls and blocked accounts.",
    "General Ledger Setup, accounting periods, retained earnings and allowed posting-date windows.",
    "General, customer, vendor, inventory, VAT/tax and bank posting groups.",
    "Dimensions, dimension combinations and default dimensions by account/vendor/customer/item.",
    "Currencies and exchange-rate process; bank accounts, payment methods and reconciliation.",
    "Number series for all master records, journals and documents; prevent collisions with migrated identifiers.",
    "Fixed-asset books, depreciation methods, classes, locations and posting groups where in scope.",
]:
    add_bullet(doc, item)

add_heading(doc, "8.3 Procurement and purchase controls", 2)
for item in [
    "Vendor master, addresses, bank/payment data, tax status and duplicate-prevention controls.",
    "Purchase requisition and purchase request numbering, mandatory justification, attachment rules and budget checks.",
    "Approval thresholds by amount, department/division and responsibility center; substitute approvers and escalation.",
    "Request-for-quotation rules, quotation comparison, purchase order release, receipt, invoice matching and payment authorization.",
    "Test cancellation, rejection remarks, resubmission, delegation and changes after approval.",
]:
    add_bullet(doc, item)

add_heading(doc, "8.4 Inventory and Stores", 2)
for item in [
    "Item cards, categories, base units of measure, alternate UOMs, costing method and reorder policy.",
    "Locations/stores, bins if used, inventory posting groups, responsible storekeepers and issue permissions.",
    "For requester usability, do not require the requester to know the issuing store when stock location is unknown. Route or assign the store during approval/fulfilment according to the approved process design.",
    "Define the process for non-stock or unavailable items: convert to purchase request, notify Procurement and retain linkage to the originating requisition.",
    "Store approval workflow event and response must be registered by the custom extension, configured in BC and tested before enabling the portal button.",
]:
    add_bullet(doc, item)

add_heading(doc, "8.5 HR, Leave and Payroll", 2)
for item in [
    "Employee numbers, employment status, department/division, manager, BC User ID and Company E-Mail.",
    "Leave types, entitlement, carry-forward rules, accrual, half-day handling, base calendar, holidays and weekend exclusion.",
    "Approver hierarchy, reliever requirement, rejection remarks, cancellation rules and final balance update.",
    "Payroll periods, earnings/deductions, statutory/localization rules, bank details and maker/checker controls. Obtain Finance/HR sign-off before live calculation.",
    "The portal and BC must show the same document number, status, approver, timestamp, comment and balance after each workflow action.",
]:
    add_bullet(doc, item)

add_heading(doc, "8.6 ABH licensed ERP profile", 2)
add_para(doc, "The following describes the ERP ABH already licenses and operates in UAT. A new production company must be configured to this profile, not as a generic Microsoft evaluation company.")
add_table(
    doc,
    ["Item", "ABH licensed / UAT value"],
    [
        ("Product", "Microsoft Dynamics 365 Business Central on-premises"),
        ("Current UAT release", "Business Central 24, server instance BC240, tenant default"),
        ("Recommended new production release", "BC28 latest CU (BC24 end of servicing: 8 October 2025). Use BC27 only if the partner documents incompatibility."),
        ("Custom extension", "BC24_TA App, publisher Technology Associates EA Ltd"),
        ("UAT app naming", "Technology Associates EA Ltd_BC24_TA App_<version>.app"),
        ("Company name", "ABH PARTNERS PLC"),
        ("Country / currency", "Ethiopia (ET) / Ethiopian Birr (ETB)"),
        ("Tax PIN / TIN", "0004168579"),
        ("VAT in use", "Yes — standard rate 15%"),
        ("Financial year", "July start. Custom Ethiopian Calendar periods (e.g. 2019 EC) also maintained."),
        ("Global dimension 1", "DIVISION"),
        ("Global dimension 2", "DEPARTMENT"),
        ("UAT host (reference only)", "ABH-ERP-M1 — keep ADMIN and Windows administrator accounts for IT; do not rename them into staff names"),
        ("Payroll templates folder", "C:\\ProgramData\\ABH\\PayrollTemplates\\"),
        ("Self-service portal", "ABH Smart ESSP Enterprise Hub, paired with the same TA App version"),
    ],
    [2800, 6560],
    compact=True,
)

add_heading(doc, "8.7 Company Information and Control Information", 2)
add_para(doc, "Search Company Information and Control-Information. Complete both; payroll and official documents read company name, TIN, logo and payslip message from these pages.")
add_table(
    doc,
    ["Field", "What to enter"],
    [
        ("Name", "ABH PARTNERS PLC"),
        ("Country/Region Code", "ET"),
        ("VAT Registration No. / TIN", "0004168579"),
        ("Picture / logo", "Approved ABH logo used on payroll Excel layouts and official reports"),
        ("Bank Name / Account", "Production operating accounts only — no UAT test banks as default"),
        ("Vision / Mission / Motto", "Approved corporate text (Company Information extension fields)"),
        ("Control-Information PIN, NSSF, NHIF", "Statutory registration numbers as provided by Finance/HR"),
        ("Payslip Message", "Approved period message from HR/Finance"),
    ],
    [3200, 6160],
    compact=True,
)

add_heading(doc, "8.8 Chart of accounts, periods and posting control", 2)
for item in [
    "Load the approved ABH chart of accounts once (UAT reference: about 294 accounts). Do not reload over a live company.",
    "Create accounting periods for the July financial year. Also create Custom Financial Periods for the Ethiopian Calendar year in use.",
    "Leave Allow Posting From / To empty on General Ledger Setup and User Setup unless Finance issues a closed-period instruction.",
    "VAT in Use = Yes. Do not use G/L 1104-03 as VAT payable. UAT payable account is 2100-14; receivable is 1104-02.",
    "Petty cash G/L 1101-03. Process rule: maximum Br. 500 unless Finance issues a new limit.",
    "Do not post opening balances, invoices, receipts, payment vouchers or petty-cash vouchers until Finance signs the trial balance file.",
]:
    add_bullet(doc, item)

add_heading(doc, "8.9 Tax codes — Tariff Codes UP", 2)
add_para(doc, "These are the ABH UAT tax codes approved with Finance. Recreate them in a new company. Leave PAYROLLTAX and DIVIDENDTAXT as-is. Do not create a 50% WHT code.")
add_table(
    doc,
    ["Code", "Use", "G/L"],
    [
        ("VAT_15%", "VAT 15% sales and purchases", "Payable 2100-14. Receivable 1104-02."),
        ("WTX_3%", "Local WHT 3% (licence + TIN)", "2100-16"),
        ("WTX30%", "Local WHT 30% (no TIN)", "2100-16"),
        ("WTX_15%", "Foreign / USD WHT 15%", "2100-20"),
    ],
    [1600, 4560, 3200],
)

add_heading(doc, "8.10 Dimensions", 2)
add_para(doc, "Create dimensions DIVISION (Global 1) and DEPARTMENT (Global 2). Load short codes only. EXEC must stay unblocked. Do not use WORKSTATION as Project unless Finance confirms every payment requires a Project code.")
add_para(doc, "DIVISION — unblocked codes: EXEC, FAD, BD, AAD, AWS, ACD, AMS.", bold=True, size=10.5)
add_para(doc, "DEPARTMENT — unblocked codes: LEGAL, AUDIT, FIN, OPS, HR, IT, BDR, MKT, CPD, STT, ACAD, HRO, TM, JOB, RES, DATA, REV-R, PM, QO, CONS, REV-C, SSE, SM, TND, REG.", bold=True, size=10.5)
add_para(doc, "On DEPARTMENT values, set the custom Division field to the parent division. Set Staff No. on each department value to the actual HOD employee so the portal can grant HOD access.")

add_heading(doc, "8.11 Banks, customers, vendors and journals", 2)
add_table(
    doc,
    ["Item", "New-company rule"],
    [
        ("Bank accounts", "Create production banks. Leave default paying / receipts / petty-cash bank blank unless Finance names one default."),
        ("Vendors", "Load approved supplier list. Finance must complete TIN and bank details. Assign WHT 3%, 30% or 15% per vendor."),
        ("Customers", "Load approved customer list. Do not post opening balances until the signed TB is received."),
        ("Journal templates", "Create CASH RECE and PAYMENTS. Do not change Bal. Account on the templates."),
        ("Payment methods", "CASH, CHEQUE, BANK. Leave Bal. Account empty. Do not use leftover demo methods such as PAYPAL."),
        ("Payment terms", "30D (30 days) as standard. Payment vouchers use Pay Mode on the document (Cash, Cheque, EFT)."),
    ],
    [2200, 7160],
    compact=True,
)

add_heading(doc, "8.12 Receipt types and payment types", 2)
add_table(
    doc,
    ["Code", "Account type", "VAT / WHT", "Meaning"],
    [
        ("CUSTREC", "Customer", "No / No", "Customer collection. VAT stays on the sales invoice."),
        ("SUPPLIER", "Vendor", "No / No", "Plain supplier payment. Keep. Do not delete."),
        ("VEND3", "Vendor", "VAT_15% / WTX_3%", "Local vendor with TIN."),
        ("VEND30", "Vendor", "VAT_15% / WTX30%", "Local vendor, no TIN."),
        ("VEND15", "Vendor", "VAT_15% / WTX_15%", "Foreign / USD vendor."),
    ],
    [1400, 1800, 2200, 3960],
    compact=True,
)
add_para(doc, "Do not invent extra expense types (rent, fuel, and similar) until Finance sends Code + Name + G/L.", italic=True, color=MID_GRAY, size=10)

add_heading(doc, "8.13 Cash Office Setup and number series", 2)
add_para(doc, "Search Cash Office Setup UP. Assign a unique number series to every document type. Purchase Requests and Store Requisitions must use different prefixes (for example PR and SR) because portal history is keyed by the Business Central request number.")
add_table(
    doc,
    ["Series / setup", "Purpose"],
    [
        ("PV", "Payment vouchers"),
        ("PCV", "Petty cash vouchers"),
        ("IMP / SUR", "Imprest request and imprest surrender"),
        ("REC", "Receipts"),
        ("Staff Claim / Other Advance / Advance Surrender", "Staff claims and advances"),
        ("Stores Requisition / Quotation Request / Tender / Contract", "Procurement documents"),
        ("InterBank Transfer / Bank Deposit / Payment Schedule", "Treasury documents"),
        ("CASH RECE / PAYMENTS journal templates and per-user batches", "Each cashier needs a unique receipt batch. Two people cannot share CASH RECE / DEFAULT."),
        ("Payroll Template / Payroll Batch / Payroll Control A/C", "Payroll posting into the general ledger"),
        ("PV Template / PV Batch / Surrender Template / Surrender Batch", "Funds posting journals"),
        ("Current Budget + start/end dates", "Leave empty until Finance sends the budget file and Warn vs Block rule"),
    ],
    [4300, 5060],
    compact=True,
)

add_heading(doc, "8.14 User Setup, cashiers and role centers", 2)
add_para(doc, "Search Users, User Setup and Cash Office User Template. Proposed login format: FIRSTNAME_LASTNAME (example CHERNET_GETU). Keep ADMIN and the Windows administrator for IT.")
for item in [
    "User Setup: Employee No., E-Mail, Approval Title, Imprest Account, posting-date window, and document-creation flags (G/L, Customer, Vendor, Asset, Bank, Item).",
    "Approval limits: PV Amount, Petty Cash, Imprest, Store Requisition, Imprest Surrender, Interbank. Unlimited flags only for authorized officers.",
    "View Payroll, Post JVs, Can Post Bank Recon., Assign Role Center — grant only to the named role holders.",
    "Cash Office User Template: Receipt Journal Template/Batch, Payment Journal Template/Batch, Imprest/Claim templates, default banks. One unique receipt batch per cashier.",
    "Assign Role Centers by job: Funds Management, Finance/Accountant, Supply Chain, HR, Fleet, Grants/Projects, Security, Legal, Corporate, CEO/DG, IT Manager, Default (common requisitions).",
]:
    add_bullet(doc, item)

add_heading(doc, "8.15 ABH module setup checklist", 2)
add_para(doc, "Complete each module only after the process owner supplies masters and numbering. Do not invent leave types, stores, projects, approval limits or budget rules.")
add_table(
    doc,
    ["Module", "BC search / setup page", "Owner must confirm"],
    [
        ("Finance / Funds", "General Ledger Setup, Cash Office Setup UP, Budgetary Control Setup", "COA, banks, tax, dimensions, number series, PV approver and ETB limit"),
        ("Procurement", "Purchases & Payables Setup, Tender Setup, Minutes Setup", "PR/RFQ/tender/contract/disposal number series, committees, portal path"),
        ("Stores / Inventory", "Locations, Items, Item Journal Template/Batch", "Issuing stores, costing method, storekeepers, PR vs SR prefixes"),
        ("Fixed Assets", "FA Setup, Asset Movement Nos", "FA classes, books, locations, movement series"),
        ("HR", "HR Setup, Leave Types, Base Calendar, Jobs", "Employee nos, leave types, calendars, HOD/Staff No. on departments"),
        ("Payroll", "PR Vital Setup Info, PR Transaction Codes, Employee Posting Groups, ABH Payroll Report Setup", "PAYE/pension/relief rates, posting G/Ls, bank transfer layout, logo"),
        ("Medical claims", "PR Medical Setup, Employee Card medical balances", "SELF/DEPENDANT ledger and current HR calendar"),
        ("Fleet", "FLT-Fleet Mgt Setup, Fuel Card Setup", "Transport, fuel, maintenance, safari notice series"),
        ("Grants / Projects", "Jobs-Setup", "Job, proposal, donor, closeout number series"),
        ("Hospital / clinic", "HMS Setup", "Patient, lab, pharmacy, admission series and billing flags"),
        ("Academic (if in scope)", "General Set-Up, Academic Central Setup, Exams Setup", "Student/receipt series, default year/semester/intake"),
        ("Self-service portal", "Web Services, Approval User Setup, Workflows, Portal Employee Transfer Setup", "Paired app + portal version, SOAP account, workflows"),
    ],
    [2000, 3600, 3760],
    compact=True,
)

add_heading(doc, "8.16 HR Setup, payroll and medical balances", 2)
for item in [
    "HR Setup: Employee Nos., Leave Application Nos., Recruitment, Disciplinary, Applicants, Training, Job ID, Base Calendar, payroll journal template/batch and payroll control account.",
    "PR Vital Setup Info (PR Rates & Ceilings): tax relief, insurance relief, pension employee/employer, NHIF based-on, overtime, house/fuel/acting allowance codes, medical claim recovery and minimum take-home.",
    "PR Employee Posting Groups: salary expense, PAYE/income tax, pension, NSSF/SSF, net salary payable and related G/Ls.",
    "ABH Payroll Report Setup: template folder C:\\ProgramData\\ABH\\PayrollTemplates\\ and branded Payment Sheet, Bank Transfer List and Summary templates. Company name on layouts is ABH PARTNERS PLC.",
    "Payroll signatories on branded reports: Accountant; Finance Manager; HR Manager; Adm & Fin Director; MD/MPH/CEO.",
    "Medical Claim Balance - Self / Dependant are FlowFields from PR Medical Ledger Entry for the employee's Current HR Calendar. Do not type balances on Staff Claims.",
    "Staff Claim and sick/medical leave require at least one Document Attachment before Request Approval.",
]:
    add_bullet(doc, item)

add_heading(doc, "8.17 Purchases & Payables Setup (procurement numbering)", 2)
for item in [
    "Set number series for Requisition, Quotation Request, Tender Bid, Contract, Contract Addendum, Inspection, Minutes, Disposal Plan, Disposal, Vendor Buffer and Shipment Notification.",
    "Set Portal Path to the production HTTPS portal URL after the portal is live.",
    "Do not create a separate Foreign Purchase Request. Currency is not a requester-facing field on the portal Purchase Request.",
]:
    add_bullet(doc, item)

add_heading(doc, "8.18 What Finance, HR and IT must send before a new company is built", 2)
add_table(
    doc,
    ["#", "Owner", "Required input"],
    [
        ("1", "IT / Partner", "Confirmed BC release (BC28 preferred), .bclicense file location, server names, HTTPS URL"),
        ("2", "Finance", "User IDs (FIRSTNAME_LASTNAME), finance UAT/prod staff list, shared password policy"),
        ("3", "Finance", "PV approver and ETB approval limit"),
        ("4", "Finance", "Opening trial balance, bank openings, customer openings"),
        ("5", "Finance", "Vendor TIN, bank details and WHT rate (3% / 30% / 15%)"),
        ("6", "Finance", "VAT-exempt services (academy / medical vs consulting)"),
        ("7", "Finance", "Whether Project is mandatory on every payment voucher, and the Project codes"),
        ("8", "Finance", "Budget file and Warn vs Block rule — do not load Budgetary Control until this arrives"),
        ("9", "HR", "Employee list with department, supervisor, BC User ID, Company E-Mail, leave types and opening leave balances"),
        ("10", "HR / Finance", "Payroll rates, posting groups, bank file format and medical scheme rules"),
        ("11", "Procurement / Stores", "Locations, items, storekeepers, PR/SR prefixes and approval sequence"),
        ("12", "Management", "Go-live date, freeze window, and confirmation that the legal name stays ABH PARTNERS PLC"),
    ],
    [700, 1800, 6860],
    compact=True,
)

add_heading(doc, "9. Phase 6 — custom extension and portal deployment", 1)
add_heading(doc, "9.1 Custom extension release controls", 2)
add_numbered(doc, "Recompile the custom app against the selected production release. Update dependencies and resolve all compiler errors; do not deploy a package built for another major release without validation.")
add_numbered(doc, "Use a unique, incremented app version and immutable build artifact. Record source commit, build time and SHA-256 checksum.")
add_numbered(doc, "Code-sign the production extension. Microsoft documentation notes that unsigned extensions are not recommended for production.")
add_numbered(doc, "Test installation and upgrade in UAT using a restored production-like database and the exact production commands.")

add_heading(doc, "9.2 Fresh extension installation", 2)
add_code_block(doc, [
    '$ServerInstance = "BC280_PROD"',
    '$Tenant = "default"',
    '$AppPath = "C:\\BCSetup\\Apps\\Technology Associates EA Ltd_BC_TA App_X.Y.Z.W.app"',
    'Publish-NAVApp -ServerInstance $ServerInstance -Path $AppPath',
    'Sync-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -Name "BC_TA App" -Publisher "Technology Associates EA Ltd" -Version "X.Y.Z.W"',
    'Install-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -Name "BC_TA App" -Publisher "Technology Associates EA Ltd" -Version "X.Y.Z.W"',
    'Get-NAVAppInfo -ServerInstance $ServerInstance -Tenant $Tenant -TenantSpecificProperties | Where-Object Name -eq "BC_TA App"',
])
add_para(doc, "If the package is not code-signed, -SkipVerification may be required for testing, but that should be treated as a documented exception and corrected before production.", italic=True, color=RED, size=9.5)

add_heading(doc, "9.3 Portal deployment", 2)
add_para(doc, "Keep the Business Central app and portal as a generated pair. Example from the current suite: portal 1.0.3.345 expects BC app 1.0.3.273. Do not mix versions.")
for item in [
    "Create a production portal configuration file or secret store; include no credentials in source control.",
    "Point the portal only to the production BC instance and production company. Confirm company names, API/SOAP/OData endpoints and time zone (Windows server local time must be Ethiopia).",
    "Use a least-privilege integration account and HTTPS for every portal-to-BC call. Do not use SUPER in production.",
    "Run the portal as a managed service with automatic restart, health check, structured logs, log rotation and monitoring. Install the autostart helper after UAT.",
    "Publish the portal through HTTPS and a controlled DNS name. Remove direct public access to development ports such as 4000 unless it is behind an approved reverse proxy/firewall.",
    "Set Link Portal URL in HR Setup to the final HTTPS URL and enable emails only after the email account test succeeds.",
    "Attendance policy in the paired app: arrival 08:30 (grace to 08:50), departure 17:30 (grace from 17:20), open sessions closed at 19:00.",
    "Do not enable HOD_GRANT_ALL_AUTHENTICATED in production. HOD_OVERRIDE_EMPNOS only for a formally authorized exception.",
]:
    add_bullet(doc, item)

add_heading(doc, "9.4 Web Services that must be published", 2)
add_table(
    doc,
    ["Object", "Service name", "Required for"],
    [
        ("Codeunit Staff Portal Codeunit", "StaffPortal", "Leave, claims, imprest, purchase/store, profile"),
        ("Codeunit CuPortalEmployeeExit", "published by install", "Transfer, Resignation, Exit Form"),
        ("Page Hr Document Downloads", "PgHrDownloads", "HR Policies & Forms"),
        ("Query Document Attachments (50108)", "QyDocumentAttachments", "HR document files"),
        ("Query QyPortalPurchaseLines", "QyPortalPurchaseLines", "Portal purchase lines"),
    ],
    [3200, 2500, 3660],
    compact=True,
)
add_para(doc, "Restrict SOAP/OData to the portal server. Ordinary requesters must not receive the service-account credential. Confirm StaffPortal remains published after every app upgrade.", italic=True, color=MID_GRAY, size=10)

add_heading(doc, "9.5 Portal workflows to import and enable", 2)
for item in [
    "Purchase-Requisition-Approval-Workflow.xml — enable PURCHASE-REQ-WF. Select the actual ABH Department/Division Head then Finance/Admin method. Do not auto-fill Approver ID from the Employee Card.",
    "Store-Requisition-Approval-Workflow.xml — enable STORE-REQ-WF against a Workflow User Group sequenced Supervisor, Department Head, Division Head, Finance/Admin. Skip the requester's own role and start at the next level.",
    "Imprest-Approval-Workflow.xml — import only if the tenant does not already have the approved imprest/surrender workflow.",
    "Portal Employee Transfer Setup: Immediate Supervisor is last-resort fallback; HR Approver User ID is the optional authoritative HR owner for Transfer and Resignation.",
    "Test approve, reject, cancel and final release with real named approvers. A workflow button is not proof the event/response is registered.",
]:
    add_bullet(doc, item)

add_heading(doc, "10. Phase 7 — email and notifications", 1)
add_heading(doc, "10.1 Configure the email account", 2)
add_numbered(doc, "Assign EMAIL - ADMIN to the administrator performing setup.")
add_numbered(doc, "For Business Central on-premises, create the required Microsoft Entra application registration and connect it through Email Microsoft Entra Application Registration or the assisted setup.")
add_numbered(doc, "Open Email Accounts and add Microsoft 365/shared mailbox or the approved SMTP OAuth connector. Prefer modern authentication; do not use basic authentication.")
add_numbered(doc, "Set one account as Default. Assign email scenarios only where a separate sender is required.")
add_numbered(doc, "Send a Test Email to an external and internal test mailbox. Record successful delivery and sender identity.")

add_heading(doc, "10.2 Configure leave and approval recipients", 2)
for item in [
    "HR Setup: Enable Emails = Yes; Link Portal URL = final production HTTPS portal URL.",
    "Employee Card: Company E-Mail is valid; User ID exactly matches the user's Business Central identity.",
    "User Setup: each approver has the correct User ID and E-Mail; no duplicate Employee/User mapping exists.",
    "Approval User Setup: Notification Type = Approval, Notification Method = Email and schedule = Instantly for real-time approval notifications.",
    "Confirm requester, each approval step and reliever have working mailboxes before workflow testing.",
]:
    add_bullet(doc, item)

add_heading(doc, "10.3 Notification acceptance test", 2)
add_table(
    doc,
    ["Event", "Expected recipient and evidence"],
    [
        ("Requester submits leave", "First approver receives approval-required email; portal and BC show Pending Approval."),
        ("First approver approves", "Next approver receives email; first step is Approved and next is Pending/Open."),
        ("Approver rejects with remark", "Requester receives rejection email containing the remark; portal/BC both show Rejected."),
        ("Final approver approves", "Requester receives final approval email; reliever receives leave-cover notification; balance updates once."),
        ("Requester cancels", "Requester receives cancellation confirmation; approval entries are cancelled and document returns to allowed status."),
    ],
    [2900, 6460],
)
add_para(doc, "Troubleshoot in this order: Sent Emails, Email Outbox, Email Error Entries, HR Setup Enable Emails, Employee/User Setup email, Approval Entry Approver ID and notification schedule.", bold=True, color=DARK_BLUE, size=10)

add_heading(doc, "11. Phase 7 — approval workflow configuration", 1)
add_para(doc, "Workflow setup must be completed separately for standard purchase documents and custom Purchase Request, Store Requisition and Leave document types. A workflow button is not proof that the required event and response are registered.")
add_numbered(doc, "Create and verify users on Approval User Setup. Assign Approver ID, approval limits, substitute and approval administrator as required.")
add_numbered(doc, "Create Workflow User Groups where sequence-based multi-level approval is required. One person must not be requester and approver at the same level.")
add_numbered(doc, "Open Workflows and create the workflow from a Microsoft template for standard purchase documents, or from the registered custom events/responses for custom documents.")
add_numbered(doc, "Define event conditions such as company, document type, department, amount or responsibility center.")
add_numbered(doc, "Configure responses: create approval requests, restrict record use, notify approver, release on final approval, reopen/cancel on rejection or cancellation.")
add_numbered(doc, "Enable the workflow only after the Workflow Steps page shows no missing event/response error.")
add_numbered(doc, "Test submit, approve, reject with mandatory remark, next approver, final approval, cancel, resubmit, substitute and unauthorized-user denial.")

add_callout(doc, "Production blocker", "If Business Central says a workflow response 'does not exist' or is 'not configured for this document type', stop testing and correct the extension registration plus BC workflow configuration. Do not bypass approval in the portal.", "risk")

add_heading(doc, "12. Phase 7 — job queues and background processing", 1)
for item in [
    "Open Job Queue Entries and inventory all required background jobs, including email dispatch, workflow notifications, integrations, payroll tasks and cleanup jobs.",
    "Run jobs under an approved licensed service user with only the required permission sets.",
    "Set recurrence, earliest start, timeout and retry policy. Prevent heavy reports, backups and imports from competing during business hours.",
    "Test every job manually, then set Status = Ready and confirm at least one scheduled execution completes.",
    "Monitor Job Queue Log Entries and email error pages daily during hypercare; alert on repeated failure.",
]:
    add_bullet(doc, item)

add_heading(doc, "13. Phase 8 — data migration and reconciliation", 1)
add_heading(doc, "13.1 Migration sequence", 2)
for item in [
    "Freeze and cleanse source master data; assign data owners and duplicate rules.",
    "Build mapping files for dimensions, posting groups, number series, payment terms, tax/VAT, UOMs, locations and employee identities.",
    "Load setup/reference data first, then master data, then open documents and opening balances.",
    "Use Configuration Packages/RapidStart only for initial company setup and controlled loads. Microsoft advises against using them for large ongoing imports into an active production company.",
    "Validate package data before applying. Correct errors in the source file and repeat in UAT rather than editing unexplained differences directly in production.",
    "Post opening balances through controlled journals and reconcile to signed source-system trial balance and subledgers.",
]:
    add_numbered(doc, item)

add_heading(doc, "13.2 Mandatory reconciliation", 2)
add_table(
    doc,
    ["Area", "Reconciliation evidence"],
    [
        ("General Ledger", "Trial balance by account and dimension equals the signed source balance."),
        ("Customers", "Total receivables and open invoice count match; aging is reviewed."),
        ("Vendors", "Total payables and open invoice count match; bank details independently checked."),
        ("Bank", "Opening bank ledger balances agree to statements and reconciliation."),
        ("Inventory", "Quantity and value by item/location reconcile; negative or zero-cost anomalies approved."),
        ("Fixed Assets", "Acquisition cost, accumulated depreciation and net book value reconcile."),
        ("Leave / Payroll", "Employee mapping, leave balances and payroll opening figures reconcile to HR-approved records."),
    ],
    [2300, 7060],
)

add_heading(doc, "14. Phase 9 — UAT and production-readiness audit", 1)
add_heading(doc, "14.1 End-to-end UAT matrix", 2)
add_table(
    doc,
    ["Test stream", "Minimum scenarios", "Owner"],
    [
        ("Finance", "Journal posting, period controls, dimensions, VAT/tax, bank reconciliation, reports", "Finance"),
        ("Purchase", "Request, approval levels, RFQ, PO, receipt, invoice matching, cancellation, rejection", "Procurement/Finance"),
        ("Stores", "Known/unknown store, stock available/unavailable, approval, issue, receipt confirmation", "Stores/Procurement"),
        ("Leave", "Working-day calculation, half day, balances, reliever, sequential approvals, reject remark, cancel", "HR"),
        ("Payroll", "Sample payroll, maker/checker, statutory values, payslip, bank and GL output", "HR/Finance"),
        ("Portal sync", "Same document/status/approver/date/comment in portal and BC; refresh/retry is idempotent", "IT/Owners"),
        ("Notifications", "Submit, next approver, reject remark, final approval, reliever, cancellation", "IT/HR"),
        ("Security", "Least privilege, segregation, unauthorized denial, audit trail, session controls", "Security/IT"),
        ("Recovery", "Restore SQL backup, reconnect BC, validate extension and portal", "IT"),
        ("Performance", "Peak users, large reports, approvals, portal calls and job queues", "IT/Partner"),
    ],
    [1650, 6230, 1480],
    compact=True,
)

add_heading(doc, "14.2 Go-live quality gates", 2)
for item in [
    "No unresolved Severity 1 or Severity 2 defects; lower defects have owner, workaround and approved target date.",
    "All workflows create the correct current approval entries, with no duplicate historical timeline mixing.",
    "Approval decisions remain saved even if email delivery fails; email failure is visible in the outbox/error pages.",
    "Portal retries do not create duplicate documents or duplicate approval entries.",
    "One full backup has been restored to an isolated environment and verified by IT plus a functional owner.",
    "Security, license, data reconciliation, performance, monitoring and operations handover are signed.",
]:
    add_bullet(doc, item)

add_heading(doc, "15. Phase 10 — cutover and go-live", 1)
add_heading(doc, "15.1 Cutover sequence", 2)
for item in [
    "Approve final cutover plan, owners, timestamps, communication tree, stop/go criteria and rollback deadline.",
    "Stop legacy postings and portal submissions at the agreed freeze time. Take and verify final source backups/exports.",
    "Take a full SQL backup of the target environment before final migration and keep a copy outside the server.",
    "Load final master-data changes, open transactions and opening balances using the rehearsed scripts/packages.",
    "Run reconciliation and obtain Finance/HR/Stores/Procurement sign-off.",
    "Deploy the signed production extension and portal build; verify versions and checksums.",
    "Enable workflows, email, integrations and job queues in the agreed order.",
    "Run smoke tests with named users: sign-in, one controlled finance transaction, purchase request, store request, leave submit/approve/reject and notification.",
    "Management makes the go/no-go decision. Communicate production URL, support contacts and known limitations.",
]:
    add_numbered(doc, item)

add_heading(doc, "15.2 Rollback criteria", 2)
add_para(doc, "Rollback must be initiated before irreversible business processing exceeds the agreed cutoff if any of the following occurs:")
for item in [
    "Database integrity, posting or opening-balance reconciliation fails.",
    "Users cannot authenticate securely or privileged access is uncontrolled.",
    "Core purchase, store, leave or finance approval workflow fails or assigns the wrong user.",
    "Portal creates duplicate/incorrect documents or does not synchronize status with BC.",
    "Backup cannot be restored or critical monitoring is unavailable.",
]:
    add_bullet(doc, item)
add_callout(doc, "Rollback rule", "Do not uninstall extensions or manually reverse database changes during an incident unless that exact rollback was rehearsed. Prefer restoring the pre-cutover database and reverting application/portal artifacts under the approved plan.", "risk")

add_heading(doc, "16. Production operations after go-live", 1)
add_table(
    doc,
    ["Frequency", "Operational control"],
    [
        ("Daily", "Check server/service health, SQL backups, Job Queue errors, Email Outbox/Error Entries, portal errors and disk space."),
        ("Weekly", "Review failed integrations, slow reports, certificate/secret alerts, privileged changes and unresolved support tickets."),
        ("Monthly", "Patch OS/SQL/BC in UAT first; review database growth, performance, backup retention and user-license assignments."),
        ("Quarterly", "Access and segregation-of-duties review; restore test; workflow/approver review; disaster-recovery exercise or evidence review."),
        ("Annually", "Capacity plan, license/entitlement review, penetration/security assessment, retention policy and full business-continuity test."),
    ],
    [1500, 7860],
)

add_heading(doc, "16.1 Controlled extension upgrade", 2)
add_code_block(doc, [
    '$ServerInstance = "BC280_PROD"',
    '$Tenant = "default"',
    '$Version = "X.Y.Z.W"',
    'Publish-NAVApp -ServerInstance $ServerInstance -Path "C:\\BCSetup\\Apps\\NewVersion.app"',
    'Sync-NAVApp -ServerInstance $ServerInstance -Tenant $Tenant -Name "BC_TA App" -Publisher "Technology Associates EA Ltd" -Version $Version',
    'Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Tenant $Tenant -Name "BC_TA App" -Publisher "Technology Associates EA Ltd" -Version $Version',
    'Restart-NAVServerInstance -ServerInstance $ServerInstance',
])
add_para(doc, "Before every upgrade: approved change, recent verified backup, tested package, version-specific release notes, maintenance window and rollback plan. Validate installed app state after the command completes.", bold=True, color=DARK_BLUE, size=10)

add_heading(doc, "17. Troubleshooting quick reference", 1)
add_table(
    doc,
    ["Symptom", "First checks"],
    [
        ("Cannot sign in", "BC service, HTTPS certificate, authentication type, user state, permission set, time synchronization and event logs."),
        ("License error", "Correct .bclicense, import scope/database, service restart and licensed granules."),
        ("Extension will not publish", "Target symbols/runtime, dependencies, code signing, license/developer rights and server event log."),
        ("Workflow response does not exist", "Custom event/response registration, installed app version, workflow step configuration and service restart."),
        ("Approval shows wrong person", "Approval Entry Approver ID, User Setup, Employee User ID, duplicate mappings and portal session/cache."),
        ("Old approvals appear in timeline", "Portal/API must filter the current record/workflow cohort, not only reused document number."),
        ("Email not received", "Default Email Account, Test Email, recipient email, notification schedule, Sent Emails, Outbox and Error Entries."),
        ("Portal says error but BC changed", "Check BC postcondition/status, transaction boundary and idempotency; never ask the user to click repeatedly without verification."),
        ("Dates count weekends", "Company/employee Base Calendar, holidays and custom leave-duration logic."),
        ("Job Queue stopped", "Entry status, user license/permissions, earliest start, category concurrency and Job Queue Log Entries."),
    ],
    [2800, 6560],
    compact=True,
)

add_heading(doc, "18. Final sign-off", 1)
add_table(
    doc,
    ["Approval area", "Name", "Decision / date"],
    [
        ("Executive sponsor", "[[ENTER]]", "[[APPROVE / HOLD]]"),
        ("Finance", "[[ENTER]]", "[[APPROVE / HOLD]]"),
        ("HR / Payroll", "[[ENTER]]", "[[APPROVE / HOLD]]"),
        ("Procurement / Stores", "[[ENTER]]", "[[APPROVE / HOLD]]"),
        ("IT / Security", "[[ENTER]]", "[[APPROVE / HOLD]]"),
        ("Business Central partner", "[[ENTER]]", "[[READY / NOT READY]]"),
    ],
    [2600, 3000, 3760],
)
add_callout(doc, "Go-live authorization", "Production may open only when all mandatory gates are passed, the final backup is verified, rollback remains available, and the executive sponsor records an explicit GO decision.", "success")

add_heading(doc, "Appendix A — production setup worksheet", 1)
add_table(
    doc,
    ["Item", "Approved value / owner"],
    [
        ("Target BC release / CU", "[[ENTER]]"),
        ("License entitlement confirmed by", "[[ENTER]]"),
        ("Production company name", "[[ENTER]]"),
        ("BC instance / tenant", "[[ENTER]]"),
        ("Application and SQL hosts", "[[ENTER]]"),
        ("Production HTTPS URLs", "[[ENTER]]"),
        ("Certificate expiry / renewal owner", "[[ENTER]]"),
        ("Authentication / MFA design", "[[ENTER]]"),
        ("Custom app version / checksum", "[[ENTER]]"),
        ("Portal build / checksum", "[[ENTER]]"),
        ("RPO / RTO", "[[ENTER]]"),
        ("Cutover and rollback times", "[[ENTER]]"),
        ("Support escalation contacts", "[[ENTER]]"),
    ],
    [3300, 6060],
)

add_heading(doc, "Appendix B — official Microsoft references", 1)
sources = [
    ("S1", "Business Central on-premises lifecycle", "https://learn.microsoft.com/en-us/lifecycle/products/dynamics-365-business-central-onpremises-modern-policy"),
    ("S2", "BC28 system requirements", "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/deployment/system-requirements-business-central-v28"),
    ("S3", "Business Central component and system topology", "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/deployment/product-and-architecture-overview"),
    ("S4", "Install Business Central using Setup", "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/deployment/install-using-setup"),
    ("S5", "Upload the Business Central on-premises license", "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/cside/cside-upload-license-file"),
    ("S6", "Security overview", "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/security/security-and-protection"),
    ("S7", "Set up email", "https://learn.microsoft.com/en-us/dynamics365/business-central/admin-how-setup-email"),
    ("S8", "Set up approval workflows", "https://learn.microsoft.com/en-us/dynamics365/business-central/across-set-up-workflows"),
    ("S9", "Specify approval notification delivery", "https://learn.microsoft.com/en-us/dynamics365/business-central/across-how-to-specify-when-and-how-to-receive-notifications"),
    ("S10", "Use job queues to schedule tasks", "https://learn.microsoft.com/en-us/dynamics365/business-central/admin-job-queues-schedule-tasks"),
    ("S11", "Apply company configuration packages", "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/apply-company-configuration-packages"),
    ("S12", "Upgrade Business Central extensions", "https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-upgrading-extensions"),
]
for code, title, url in sources:
    p = doc.add_paragraph()
    set_paragraph_spacing(p, after=5, line=1.12)
    r = p.add_run(f"{code}  ")
    set_run_font(r, size=10, color=NAVY, bold=True)
    add_hyperlink(p, title, url)

add_para(doc, "References were checked on 3 September 2026. Microsoft documentation and lifecycle information change over time; the implementation team must re-check the selected release's system requirements and update guidance immediately before installation.", italic=True, color=MID_GRAY, size=9.5, before=8, after=8)

add_heading(doc, "Appendix C — ABH UAT reference (do not copy blindly to production)", 1)
add_para(doc, "These values are already in the ABH UAT company. Use them as the configuration blueprint for a new licensed production company. Do not copy UAT test documents, test receipts or UAT passwords into production.")
add_table(
    doc,
    ["UAT item", "Value / status"],
    [
        ("Company", "ABH PARTNERS PLC. Country ET. Currency ETB. TIN 0004168579."),
        ("Chart of Accounts", "Loaded (~294 accounts). Do not reload."),
        ("Accounting periods", "Financial year from July. Custom Financial Periods 2019 EC also set."),
        ("VAT", "Yes. Codes VAT_15%, WTX_3%, WTX30%, WTX_15%."),
        ("Allow Posting From / To", "Empty on GL Setup and User Setup."),
        ("Dimensions", "Dim 1 = DIVISION. Dim 2 = DEPARTMENT. EXEC unblocked."),
        ("Banks", "Cards exist. No single default paying/receipts/petty-cash bank."),
        ("Vendors / Customers", "About 25 vendors (TIN/bank still for Finance). About 311 customers. Openings not posted."),
        ("Number series", "PV, PCV, IMP, SUR, REC on Cash Office Setup UP."),
        ("Journals", "Templates CASH RECE and PAYMENTS exist. Do not change Bal. Account."),
        ("Test documents", "PV-000001 and PCV-00002 exist in UAT. Do not post. Do not recreate in production."),
        ("IT accounts", "Keep ADMIN and ABH-ERP-M1\\ADMINISTRATOR. Do not rename into staff names."),
        ("Finance UAT users pending confirmation", "Azeb Matewos, Chernet Getu, Hamere Gulilat, Liya G/Egziabher, Rediet Birhanu, Tesfaye Abebe, Zinash Tegene"),
        ("Budgetary Control", "Not loaded until Finance sends a file and Warn vs Block rule."),
        ("Custom app (UAT publish scripts)", "Publish-NAVApp / Sync-NAVApp / Start-NAVAppDataUpgrade / Restart-NAVServerInstance on BC240"),
    ],
    [2800, 6560],
    compact=True,
)
add_callout(
    doc,
    "UAT pause (25 August 2026)",
    "Finance setup in UAT was paused on an unposted test receipt: ADMIN still needed Cash Office User Template (CASH RECE / ADMIN). Resume from cashier setup — do not start finance setup from zero and do not change AL for cashier/receipt.",
    "warning",
)

# Core properties
doc.core_properties.title = "ABH Business Central ERP Full Setup Guide"
doc.core_properties.subject = "Fresh on-premises Business Central ERP deployment and configuration"
doc.core_properties.author = "ABH ERP Implementation Team"
doc.core_properties.keywords = "Business Central, ERP, on-premises, setup, deployment, UAT, go-live"
doc.core_properties.comments = "Manager-ready implementation control guide"

# Avoid orphaned body blocks and set explicit table paragraph font where inherited values vary.
for p in doc.paragraphs:
    if p.style.name.startswith("Heading"):
        p.paragraph_format.keep_with_next = True
        p.paragraph_format.keep_together = True

doc.save(OUT_PATH)
OUT_PATH_ERP.parent.mkdir(parents=True, exist_ok=True)
doc.save(OUT_PATH_ERP)
print(OUT_PATH)
print(OUT_PATH_ERP)
