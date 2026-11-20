import { CheckCircle2, Circle } from 'lucide-react'
import { PASSWORD_POLICY_RULES, PASSWORD_POLICY_STATEMENT } from '@/utils/passwordPolicy'

/** Live password policy checklist under a New Password field (client password policy, 20 Nov 2026). */
export function PasswordPolicyChecklist({ password, id }: { password: string; id?: string }) {
  return (
    <div id={id} className="rounded-lg border border-slate-200 bg-slate-50 px-3 py-2 text-xs text-slate-700" aria-live="polite">
      <p className="font-semibold text-slate-900">Password policy</p>
      <ul className="mt-1 grid gap-1 sm:grid-cols-2">
        {PASSWORD_POLICY_RULES.map((rule) => {
          const met = rule.test(password)
          return (
            <li key={rule.id} className={`flex items-center gap-1.5 ${met ? 'text-emerald-700' : ''}`}>
              {met ? <CheckCircle2 className="h-3.5 w-3.5 shrink-0" aria-hidden /> : <Circle className="h-3.5 w-3.5 shrink-0 text-slate-400" aria-hidden />}
              <span>
                {rule.label}
                <span className="sr-only">{met ? ' (met)' : ' (not met yet)'}</span>
              </span>
            </li>
          )
        })}
      </ul>
      <p className="mt-1.5 text-slate-600">{PASSWORD_POLICY_STATEMENT} Example: Abcd@123</p>
    </div>
  )
}
