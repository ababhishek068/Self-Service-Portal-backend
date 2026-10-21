/** Item Borrowing Form with the BC layout and continuation pages for every item. */

export type BorrowingFormLine = {
  itemNo: string
  description: string
  unitOfMeasure: string
  quantityRequested: string
  quantityIssued: string
}

export type BorrowingFormInput = {
  requestNo: string
  storeIssueNo: string
  requisitionType: string
  requestDate: string
  requiredDate: string
  issueDate: string
  requesterName: string
  employeeNo: string
  division: string
  functionName: string
  department: string
  issuingStore: string
  purpose: string
  lines: BorrowingFormLine[]
  /** requisition = the approved request document. borrowing = the form after receipt. */
  documentKind?: 'requisition' | 'borrowing'
}

function pdfText(value: string) {
  return value.replace(/\\/g, '\\\\').replace(/\(/g, '\\(').replace(/\)/g, '\\)').replace(/[^\x20-\x7E]/g, ' ')
}

function row(label: string, value: string) {
  return `${label}: ${value || '-'}`
}

export function buildStoreBorrowingFormPdf(input: BorrowingFormInput) {
  const pages: string[][] = [[]]
  let commands = pages[0]
  let y = 800
  const text = (size: number, line: string, x = 48) => {
    commands.push('BT')
    commands.push(`/F1 ${size} Tf`)
    commands.push(`${x} ${y} Td`)
    commands.push(`(${pdfText(line)}) Tj`)
    commands.push('ET')
  }
  const rule = () => {
    commands.push(`${48} ${y} m ${547} ${y} l S`)
  }

  // Standard Helvetica advance widths (ASCII 32-126), in thousandths of an em.
  const widths = [278, 278, 355, 556, 556, 889, 667, 191, 333, 333, 389, 584, 278, 333, 278, 278, 556, 556, 556, 556, 556, 556, 556, 556, 556, 556, 278, 278, 584, 584, 584, 556, 1015, 667, 667, 722, 722, 667, 611, 778, 722, 278, 500, 667, 556, 833, 722, 778, 667, 778, 722, 667, 611, 722, 667, 944, 667, 667, 611, 278, 278, 278, 469, 556, 333, 556, 556, 500, 556, 556, 278, 556, 556, 222, 222, 500, 222, 833, 556, 556, 556, 556, 333, 500, 278, 556, 500, 722, 500, 500, 500, 334, 260, 334, 584]
  const wrap = (value: string, width: number, size: number) => {
    const result: string[] = []
    for (const paragraph of value.split(/\r?\n/)) {
      let rest = paragraph
      while (rest) {
        let end = 0
        let measured = 0
        while (end < rest.length) {
          const advance = (widths[rest.charCodeAt(end) - 32] ?? 556) * size / 1000
          if (end > 0 && measured + advance > width) break
          measured += advance
          end++
        }
        if (end < rest.length) {
          const space = rest.lastIndexOf(' ', end)
          if (space > 0) end = space
        }
        result.push(rest.slice(0, end))
        rest = rest.slice(end).replace(/^ +/, '')
      }
      if (!paragraph) result.push('')
    }
    return result
  }
  const requisition = input.documentKind === 'requisition'
  const continuation = (table: boolean) => {
    commands = []
    pages.push(commands)
    y = 800
    text(16, 'ABH PARTNERS')
    y -= 22
    text(12, requisition ? 'STORE REQUISITION (continued)' : 'Item Borrowing Form (continued)')
    y -= 18
    text(10, `Requisition No.: ${input.requestNo}`)
    y -= 20
    if (table) tableHeader()
  }
  const tableHeader = () => {
    rule()
    y -= 16
    for (const [label, x] of [['No.', 48], ['Item Code', 72], ['Description', 160], ['UOM', 365], ['Requested', 407], ['Issued', 490]] as const) {
      text(10, label, x)
    }
    y -= 8
    rule()
    y -= 16
  }
  const storeName = input.issuingStore || 'Store'
  text(16, 'ABH PARTNERS')
  y -= 22
  text(12, requisition ? 'STORE REQUISITION' : `ABH ${storeName} Item Borrowing Form`)
  y -= 16
  text(9, requisition ? 'Approved store requisition.' : 'Loan ID is the store issue number, or the requisition number before it is issued.')
  y -= 10
  rule()
  y -= 18

  const facts = [
    row('Loan ID', input.storeIssueNo || input.requestNo),
    row('Requisition No.', input.requestNo),
    row('Borrower Name', input.requesterName),
    row('Requisition Type', input.requisitionType),
    row('Request Date', input.requestDate),
    row('Required Date', input.requiredDate),
    row('Issue Date', input.issueDate),
    row('Requested By', input.requesterName),
    row('Employee No.', input.employeeNo),
    row('Division', input.division),
    row('Function', input.functionName),
    row('Department', input.department),
    row('Issuing Store', input.issuingStore),
    row('Purpose', input.purpose),
  ]
  for (const fact of facts) {
    for (const part of wrap(fact, 499, 10)) {
      if (y < 70) continuation(false)
      text(10, part)
      y -= 14
    }
  }
  y -= 8
  if (y < 200) continuation(false)
  tableHeader()
  input.lines.forEach((line, index) => {
    const cells = [
      wrap(String(index + 1), 22, 9),
      wrap(line.itemNo, 84, 9),
      wrap(line.description, 199, 9),
      wrap(line.unitOfMeasure, 38, 9),
      wrap(line.quantityRequested, 79, 9),
      wrap(line.quantityIssued, 57, 9),
    ]
    const positions = [48, 72, 160, 365, 407, 490]
    const height = Math.max(...cells.map((cell) => cell.length))
    // Keep normal rows together; exceptionally tall rows can continue across pages.
    if (y - height * 14 < 160 && height * 14 < 550) continuation(true)
    for (let rowIndex = 0; rowIndex < height; rowIndex++) {
      if (y < 160) continuation(true)
      cells.forEach((cell, column) => {
        if (cell[rowIndex] !== undefined) text(9, cell[rowIndex], positions[column])
      })
      y -= 14
    }
  })
  if (!input.lines.length) {
    text(9, 'No issued lines.')
    y -= 14
  }
  y -= 18
  rule()
  y -= 28
  text(10, 'Requester signature: ____________________    Date: ______________')
  y -= 22
  text(10, 'Storekeeper: ____________________________    Store manager: ________________')
  y -= 22
  text(
    9,
    requisition
      ? 'This is the portal copy of the Business Central Store Requisition voucher.'
      : 'This form is the portal copy of the Business Central Item Borrowing Form.',
  )

  if (pages.length > 1) {
    pages.forEach((page, index) => {
      page.push(`BT /F1 9 Tf 48 40 Td (Page ${index + 1} of ${pages.length}) Tj ET`)
    })
  }
  const objects = [
    '1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj',
    `2 0 obj << /Type /Pages /Count ${pages.length} /Kids [${pages.map((_, i) => `${4 + i * 2} 0 R`).join(' ')}] >> endobj`,
    '3 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >> endobj',
  ]
  pages.forEach((page, index) => {
    const pageId = 4 + index * 2
    const streamId = pageId + 1
    const stream = page.join('\n')
    objects.push(
      `${pageId} 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Contents ${streamId} 0 R /Resources << /Font << /F1 3 0 R >> >> >> endobj`,
      `${streamId} 0 obj << /Length ${Buffer.byteLength(stream)} >> stream\n${stream}\nendstream endobj`,
    )
  })
  let pdf = '%PDF-1.4\n'
  const offsets = [0]
  for (const object of objects) {
    offsets.push(Buffer.byteLength(pdf))
    pdf += `${object}\n`
  }
  const xref = Buffer.byteLength(pdf)
  pdf += `xref\n0 ${objects.length + 1}\n`
  pdf += '0000000000 65535 f \n'
  for (const offset of offsets.slice(1)) {
    pdf += `${String(offset).padStart(10, '0')} 00000 n \n`
  }
  pdf += `trailer << /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n${xref}\n%%EOF`
  return Buffer.from(pdf)
}
