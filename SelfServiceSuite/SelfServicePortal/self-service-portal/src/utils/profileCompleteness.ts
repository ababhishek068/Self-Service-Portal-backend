import type { ProfileEditContext, ProfileFieldDef } from '@/api/endpoints/profileChanges'

export interface CompletenessItem {
  key: string
  label: string
  filled: boolean
}

export interface ProfileCompleteness {
  percent: number
  filled: number
  total: number
  missing: CompletenessItem[]
  message: string
}

type ProfileLike = Record<string, unknown> & {
  phoneNumber?: unknown
  dateOfBirth?: unknown
  gender?: unknown
}

const CORE_KEYS = [
  'firstName',
  'lastName',
  'phoneNumber',
  'cellPhone',
  'cellularPhone',
  'dateOfBirth',
  'gender',
  'maritalStatus',
  'citizenship',
] as const

const IDENTITY_DOC_KEYS = ['fydaId', 'idNumber', 'passportNumber'] as const

function filledValue(value: unknown) {
  if (value === null || value === undefined) return false
  const text = String(value).trim()
  if (!text) return false
  if (text === '0' || text.toLowerCase() === 'null') return false
  return true
}

function fieldValue(
  key: string,
  profile: ProfileLike,
  editFields: ProfileFieldDef[] | undefined,
  draftFields: Record<string, string> | undefined,
) {
  if (draftFields && key in draftFields) return draftFields[key]
  const fromEdit = editFields?.find((field) => field.key === key)
  if (fromEdit) return fromEdit.value
  return profile[key]
}

/**
 * Profile completeness for the employee header gauge.
 * Passport alone is not required — any one of FYDA ID / ID Number / Passport counts.
 * Optional contact extras are ignored so empty Passport does not stall at 92%.
 */
export function computeProfileCompleteness(
  profile: ProfileLike,
  editContext?: ProfileEditContext | null,
  draftFields?: Record<string, string>,
): ProfileCompleteness {
  const editFields = editContext?.fields
  const items: CompletenessItem[] = []

  const phoneFilled =
    filledValue(fieldValue('cellPhone', profile, editFields, draftFields)) ||
    filledValue(fieldValue('cellularPhone', profile, editFields, draftFields)) ||
    filledValue(fieldValue('phoneNumber', profile, editFields, draftFields)) ||
    filledValue(profile.phoneNumber)

  items.push({
    key: 'firstName',
    label: 'First Name',
    filled: filledValue(fieldValue('firstName', profile, editFields, draftFields)),
  })
  items.push({
    key: 'lastName',
    label: 'Last Name',
    filled: filledValue(fieldValue('lastName', profile, editFields, draftFields)),
  })
  items.push({
    key: 'phone',
    label: 'Phone',
    filled: phoneFilled,
  })
  items.push({
    key: 'dateOfBirth',
    label: 'Date Of Birth',
    filled: filledValue(fieldValue('dateOfBirth', profile, editFields, draftFields)) || filledValue(profile.dateOfBirth),
  })
  items.push({
    key: 'gender',
    label: 'Gender',
    filled: filledValue(fieldValue('gender', profile, editFields, draftFields)) || filledValue(profile.gender),
  })
  items.push({
    key: 'maritalStatus',
    label: 'Marital Status',
    filled: filledValue(fieldValue('maritalStatus', profile, editFields, draftFields)),
  })
  items.push({
    key: 'citizenship',
    label: 'Citizenship',
    filled: filledValue(fieldValue('citizenship', profile, editFields, draftFields)),
  })

  const identityFilled = IDENTITY_DOC_KEYS.some((key) =>
    filledValue(fieldValue(key, profile, editFields, draftFields)),
  )
  items.push({
    key: 'identityDocument',
    label: 'ID Number / FYDA ID / Passport',
    filled: identityFilled,
  })

  // Prefer edit-context required (Q) fields when present — still skip passport-only extras.
  if (editFields?.length) {
    for (const field of editFields) {
      if (!field.required) continue
      if (IDENTITY_DOC_KEYS.includes(field.key as (typeof IDENTITY_DOC_KEYS)[number])) continue
      if ((CORE_KEYS as readonly string[]).includes(field.key) || field.key === 'phoneNumber') continue
      if (items.some((item) => item.key === field.key)) continue
      items.push({
        key: field.key,
        label: field.label || field.key,
        filled: filledValue(fieldValue(field.key, profile, editFields, draftFields)),
      })
    }
  }

  const filled = items.filter((item) => item.filled).length
  const total = items.length || 1
  const percent = Math.round((filled / total) * 100)
  const missing = items.filter((item) => !item.filled)
  const message =
    percent >= 100
      ? 'Your profile is complete.'
      : percent >= 85
        ? 'Your profile is well completed!'
        : percent >= 60
          ? 'A few details are still missing.'
          : 'Please complete the missing profile details.'

  return { percent, filled, total, missing, message }
}
