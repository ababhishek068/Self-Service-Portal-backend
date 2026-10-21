import type { PortalRequest } from '@/types/erp.types'

/** A Store Offer line: the real item the store keeper will issue. */
export type OfferLine = {
  lineNo: string
  itemNo: string
  itemName: string
  specification: string
  brandModel: string
  unitOfMeasure: string
  quantity: number
}

/** The employee's own line, as they wrote it. */
export type RequestedLine = {
  key: string
  itemName: string
  details: string
  brand: string
  unitOfMeasure: string
  quantity: number
}

export function text(value: unknown) {
  return String(value ?? '').trim()
}

export function quantityLabel(value: number) {
  return value.toLocaleString(undefined, { maximumFractionDigits: 2 })
}

function isOfferLine(line: Record<string, unknown>) {
  return /offer/i.test(text(line.lineRole))
}

/** Splits the store requisition lines into the employee's request and the store offer. */
export function storeOfferLines(request: PortalRequest) {
  const lines = Array.isArray(request.payload?.lines) ? (request.payload.lines as Array<Record<string, unknown>>) : []
  const offers: OfferLine[] = lines.filter(isOfferLine).map((line) => ({
    lineNo: text(line.lineNo),
    itemNo: text(line.itemNo),
    itemName: text(line.itemName) || text(line.description),
    specification: text(line.description) === text(line.itemName) ? '' : text(line.description),
    brandModel: text(line.preferredBrandModel),
    unitOfMeasure: text(line.unitOfMeasure),
    quantity: Number(line.quantityRequested ?? line.quantity ?? 0),
  }))
  const requestedLines: RequestedLine[] = lines
    .filter((line) => !isOfferLine(line))
    .map((line, index) => {
      const itemName = text(line.itemName) || text(line.description)
      return {
        key: text(line.lineNo) || String(index),
        itemName,
        details: text(line.description) === itemName ? '' : text(line.description),
        brand: text(line.preferredBrandModel),
        unitOfMeasure: text(line.unitOfMeasure),
        quantity: Number(line.quantityRequested ?? line.quantity ?? 0),
      }
    })
  const requested = requestedLines.reduce((total, line) => total + line.quantity, 0)
  return { offers, requestedLines, requested }
}
