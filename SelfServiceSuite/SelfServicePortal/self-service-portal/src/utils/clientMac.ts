const DEVICE_ID_KEY = 'ssp_attendance_device_id'

/** Stable 32-char hex from device/browser signals — same PC always yields the same id. */
function hashStringToHex32(input: string) {
  let h1 = 0x811c9dc5
  let h2 = 0x01000193
  let h3 = 0
  for (let i = 0; i < input.length; i += 1) {
    const ch = input.charCodeAt(i)
    h1 = Math.imul(h1 ^ ch, 0x01000193)
    h2 = Math.imul(h2 ^ ch, 0x1000193)
    h3 = (h3 + ch) | 0
  }
  const hex = [
    (h1 >>> 0).toString(16),
    (h2 >>> 0).toString(16),
    (h3 >>> 0).toString(16),
    ((h1 ^ h2 ^ h3) >>> 0).toString(16),
  ].join('')
  return hex.replace(/[^a-f0-9]/gi, '').toUpperCase().padEnd(32, '0').slice(0, 32)
}

function buildFingerprintDeviceId() {
  const nav = typeof navigator !== 'undefined' ? navigator : undefined
  const parts = [
    nav?.userAgent ?? '',
    nav?.platform ?? '',
    String(nav?.hardwareConcurrency ?? ''),
    String((nav as Navigator & { deviceMemory?: number }).deviceMemory ?? ''),
    typeof screen !== 'undefined'
      ? `${screen.width}x${screen.height}x${screen.colorDepth}`
      : '',
    typeof Intl !== 'undefined'
      ? Intl.DateTimeFormat().resolvedOptions().timeZone
      : '',
  ]
  return hashStringToHex32(parts.join('|'))
}

/**
 * Permanent device id for this PC + browser.
 * Derived from hardware/browser fingerprint (not random) so it never changes between sessions.
 */
export function getOrCreateDeviceId(): string {
  const id = buildFingerprintDeviceId()
  try {
    localStorage.setItem(DEVICE_ID_KEY, id)
  } catch {
    // Fingerprint alone is stable even if storage is blocked.
  }
  return id
}

/** Format device id as MAC-style AA:BB:CC:DD:EE:FF for the MAC Address column. */
export function formatDeviceIdAsMacAddress(deviceId: string) {
  const hex = String(deviceId ?? '').replace(/[^a-f0-9]/gi, '').toUpperCase()
  if (hex.length < 12) return ''
  const pairs = hex.slice(0, 12).match(/.{2}/g)
  return pairs ? pairs.join(':') : ''
}

/** Optional Windows helper — real hardware MAC when installed (preferred, never changes). */
export async function fetchLocalAgentMac(): Promise<string> {
  try {
    const controller = new AbortController()
    const timer = window.setTimeout(() => controller.abort(), 600)
    const response = await fetch('http://127.0.0.1:47211/mac', { signal: controller.signal })
    window.clearTimeout(timer)
    if (!response.ok) return ''
    const data = (await response.json()) as { mac?: string }
    return String(data.mac ?? '').trim()
  } catch {
    return ''
  }
}

export async function collectAttendanceMacHints() {
  const deviceId = getOrCreateDeviceId()
  const macAddress = await fetchLocalAgentMac()
  return {
    deviceId,
    macAddress,
  }
}
