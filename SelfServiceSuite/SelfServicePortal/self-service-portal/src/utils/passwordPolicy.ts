/**
 * ESSP password policy (client Pending issues, 20 Nov 2026); the backend enforces the same rules.
 * Example: Abcd@123.
 */
export const PASSWORD_POLICY_STATEMENT =
  'Passwords must be at least 8 characters long and include uppercase letters, lowercase letters, numbers, and special characters.'

export const PASSWORD_POLICY_RULES: ReadonlyArray<{ id: string; label: string; test: (password: string) => boolean }> = [
  { id: 'length', label: 'At least 8 characters', test: (password) => password.length >= 8 },
  { id: 'upper', label: 'One uppercase letter (A–Z)', test: (password) => /[A-Z]/.test(password) },
  { id: 'lower', label: 'One lowercase letter (a–z)', test: (password) => /[a-z]/.test(password) },
  { id: 'number', label: 'One number (0–9)', test: (password) => /[0-9]/.test(password) },
  { id: 'special', label: 'One special character (e.g. @, #, $, %)', test: (password) => /[^A-Za-z0-9\s]/.test(password) },
]

export function passwordMeetsPolicy(password: string) {
  return PASSWORD_POLICY_RULES.every((rule) => rule.test(password))
}

/** Error text for a password that does not meet the policy, or null. */
export function passwordPolicyError(password: string): string | null {
  return passwordMeetsPolicy(password) ? null : `The new password does not meet the password policy. ${PASSWORD_POLICY_STATEMENT}`
}
