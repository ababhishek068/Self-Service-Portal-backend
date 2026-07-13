import {
  cancelHrServiceLetterRequest as cancelHrServiceLetterRequestInStore,
  createHrServiceLetterRequest,
  listHrServiceLetterRequests,
  resetHrServiceLetterDemoData,
  type HrServiceLetterRequest,
} from '@/api/mock/hrServiceLettersStore'
import type { HrLetterType } from '@/data/hrServiceLetters'

export type { HrServiceLetterRequest }

export async function fetchHrServiceLetterRequests(employeeNo: string) {
  await pause()
  return listHrServiceLetterRequests(employeeNo)
}

export async function submitHrServiceLetterRequest(input: {
  letterType: HrLetterType
  employeeNo: string
  employeeName: string
  departmentName: string
  details: Record<string, string>
}) {
  await pause(450)
  return createHrServiceLetterRequest(input)
}

export async function cancelHrServiceLetterRequest(id: string) {
  await pause(250)
  cancelHrServiceLetterRequestInStore(id)
}

export async function resetHrServiceLetterMockData() {
  await pause(150)
  resetHrServiceLetterDemoData()
}

function pause(ms = 180) {
  return new Promise((resolve) => {
    window.setTimeout(resolve, ms)
  })
}
