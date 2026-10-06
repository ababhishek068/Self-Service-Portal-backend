/** One-page Item Borrowing Form, matching the posted store requisition print in Business Central. */

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
  const commands: string[] = []
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

  const requisition = input.documentKind === 'requisition'
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
    text(10, fact.slice(0, 110))
    y -= 14
  }
  y -= 8
  rule()
  y -= 16
  text(10, 'No.   Item Code          Description                          UOM    Requested    Issued', 48)
  y -= 8
  rule()
  y -= 16
  const body = input.lines.length ? input.lines : []
  body.slice(0, 18).forEach((line, index) => {
    const item = line.itemNo.padEnd(16, ' ').slice(0, 16)
    const description = line.description.padEnd(32, ' ').slice(0, 32)
    const uom = line.unitOfMeasure.padEnd(6, ' ').slice(0, 6)
    const requested = line.quantityRequested.padStart(6, ' ')
    const issued = line.quantityIssued.padStart(8, ' ')
    text(9, `${String(index + 1).padStart(2, ' ')}   ${item} ${description} ${uom} ${requested} ${issued}`)
    y -= 14
  })
  if (!body.length) {
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

  const stream = commands.join('\n')
  const objects = [
    '1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj',
    '2 0 obj << /Type /Pages /Count 1 /Kids [3 0 R] >> endobj',
    '3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >> endobj',
    `4 0 obj << /Length ${Buffer.byteLength(stream)} >> stream\n${stream}\nendstream endobj`,
    '5 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >> endobj',
  ]
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
