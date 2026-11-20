import assert from 'node:assert/strict'
import test from 'node:test'
import { passwordPolicyProblem } from './passwordPolicy.js'

/** The missing rules named before the policy statement. */
function needs(password: string) {
  return (passwordPolicyProblem(password) ?? '').split('. Passwords must')[0]
}

test('password policy accepts the client example', () => {
  assert.equal(passwordPolicyProblem('Abcd@123'), null)
  assert.equal(passwordPolicyProblem('Password@123'), null)
})

test('password policy names exactly the missing rules', () => {
  assert.equal(needs('Abc@12a'), 'The new password needs at least 8 characters')
  assert.equal(needs('abcd@1234'), 'The new password needs an uppercase letter (A–Z)')
  assert.equal(needs('ABCD@1234'), 'The new password needs a lowercase letter (a–z)')
  assert.equal(needs('Abcd@efgh'), 'The new password needs a number (0–9)')
  assert.equal(needs('Abcd 1234'), 'The new password needs a special character (e.g. @, #, $, %)')
  assert.match(passwordPolicyProblem('abc') ?? '', /Passwords must be at least 8 characters long/)
})
