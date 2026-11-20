/**
 * ESSP password policy (client Pending issues, 20 Nov 2026). Every new password set through the portal
 * (reset with an e-mailed code, or Change Password) must meet it. Example: Abcd@123.
 */
export const PASSWORD_POLICY_STATEMENT =
  'Passwords must be at least 8 characters long and include uppercase letters, lowercase letters, numbers, and special characters.'

export const PASSWORD_MIN_LENGTH = 8

const RULES: Array<{ test: (password: string) => boolean; message: string }> = [
  { test: (password) => password.length >= PASSWORD_MIN_LENGTH, message: `at least ${PASSWORD_MIN_LENGTH} characters` },
  { test: (password) => /[A-Z]/.test(password), message: 'an uppercase letter (A–Z)' },
  { test: (password) => /[a-z]/.test(password), message: 'a lowercase letter (a–z)' },
  { test: (password) => /[0-9]/.test(password), message: 'a number (0–9)' },
  { test: (password) => /[^A-Za-z0-9\s]/.test(password), message: 'a special character (e.g. @, #, $, %)' },
]

/** Why the password does not meet the policy, or null when it does. */
export function passwordPolicyProblem(password: string): string | null {
  const missing = RULES.filter((rule) => !rule.test(password)).map((rule) => rule.message)
  if (!missing.length) return null
  return `The new password needs ${missing.join(', ')}. ${PASSWORD_POLICY_STATEMENT}`
}
