import type { Request } from 'express'
import { execFile } from 'node:child_process'
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import { promisify } from 'node:util'

const execFileAsync = promisify(execFile)
const registryPath = resolve(
  dirname(fileURLToPath(import.meta.url)),
  '..',
  'data',
  'attendance-mac-registry.json',
)

const MAC_PATTERN = /([0-9a-f]{2}[:-]){5}[0-9a-f]{2}/i

type MacRegistry = Record<string, string>

function readMacRegistry(): MacRegistry {
  try {
    const parsed = JSON.parse(readFileSync(registryPath, 'utf8')) as MacRegistry
    return parsed && typeof parsed === 'object' ? parsed : {}
  } catch {
    return {}
  }
}

function writeMacRegistry(registry: MacRegistry) {
  mkdirSync(dirname(registryPath), { recursive: true })
  writeFileSync(registryPath, JSON.stringify(registry, null, 2))
}

export function persistedEmployeeMac(employeeNo: string) {
  const raw = readMacRegistry()[employeeNo] ?? ''
  return normalizeMacAddress(raw) || attendanceIdentifierFromDeviceId(raw)
}

export function persistedDeviceMac(deviceId: string) {
  const key = deviceRegistryKey(deviceId)
  if (!key) return ''
  const raw = readMacRegistry()[key] ?? ''
  return normalizeMacAddress(raw) || attendanceIdentifierFromDeviceId(raw)
}

function deviceRegistryKey(deviceId: string) {
  const compact = String(deviceId ?? '').replace(/[^a-f0-9]/gi, '').toUpperCase()
  return compact ? `device:${compact}` : ''
}

export function persistEmployeeMac(employeeNo: string, macAddress: string) {
  const mac =
    normalizeMacAddress(macAddress) || attendanceIdentifierFromDeviceId(macAddress)
  if (!mac || !employeeNo) return
  const registry = readMacRegistry()
  registry[employeeNo] = mac
  writeMacRegistry(registry)
}

export function persistDeviceMac(deviceId: string, macAddress: string) {
  const key = deviceRegistryKey(deviceId)
  const mac =
    normalizeMacAddress(macAddress) || attendanceIdentifierFromDeviceId(macAddress)
  if (!key || !mac) return
  const registry = readMacRegistry()
  registry[key] = mac
  writeMacRegistry(registry)
}

function normalizeIp(value: unknown) {
  const raw = String(value ?? '').trim()
  if (!raw) return ''
  const withoutZone = raw.replace(/^::ffff:/i, '')
  if (withoutZone.includes(':') && !withoutZone.includes('.')) return ''
  return withoutZone
}

function isUsableClientIp(ip: string) {
  if (!ip) return false
  if (ip === '127.0.0.1' || ip === '::1') return false
  if (ip.startsWith('169.254.')) return false
  return true
}

export function clientIpFromRequest(req: Request) {
  const candidates: unknown[] = [
    req.headers['x-forwarded-for'],
    req.headers['x-real-ip'],
    req.headers['cf-connecting-ip'],
    req.socket.remoteAddress,
    req.ip,
  ]

  for (const candidate of candidates) {
    const values =
      typeof candidate === 'string'
        ? candidate.split(',').map((part) => part.trim())
        : [candidate]
    for (const value of values) {
      const ip = normalizeIp(value)
      if (isUsableClientIp(ip)) return ip
    }
  }
  return ''
}

export function normalizeMacAddress(value: string) {
  const match = String(value ?? '').match(MAC_PATTERN)
  if (!match) return ''
  return match[0].replace(/-/g, ':').toUpperCase()
}

/** Stable browser device id shown in the MAC Address column when hardware MAC is unavailable. */
export function attendanceIdentifierFromDeviceId(deviceId: string) {
  const supplied = normalizeMacAddress(deviceId)
  if (supplied) return supplied
  const hex = String(deviceId ?? '').replace(/[^a-f0-9]/gi, '').toUpperCase()
  if (hex.length < 12) return ''
  const pairs = hex.slice(0, 12).match(/.{2}/g)
  return pairs ? pairs.join(':') : ''
}

export function resolveAttendanceIdentifier(
  options: { bodyMac?: string; deviceId?: string } = {},
) {
  const supplied = normalizeMacAddress(String(options.bodyMac ?? '').trim())
  if (supplied) return supplied
  return attendanceIdentifierFromDeviceId(String(options.deviceId ?? '').trim())
}

function uniqueIps(...groups: Array<string | string[] | undefined>) {
  const ips = new Set<string>()
  for (const group of groups) {
    const values = Array.isArray(group) ? group : [group]
    for (const value of values) {
      const ip = normalizeIp(value)
      if (isUsableClientIp(ip)) ips.add(ip)
    }
  }
  return [...ips]
}

function extractMacFromOutput(stdout: string) {
  for (const line of stdout.split(/\r?\n/)) {
    const mac = normalizeMacAddress(line)
    if (mac) return mac
  }
  return ''
}

async function pingClient(ip: string) {
  try {
    if (process.platform === 'win32') {
      await execFileAsync('ping', ['-n', '1', '-w', '1500', ip], { windowsHide: true })
    } else {
      await execFileAsync('ping', ['-c', '1', '-W', '1', ip])
    }
  } catch {
    /* Host may block ICMP; ARP may still work */
  }
}

async function resolveMacFromPowerShellNeighbor(ip: string) {
  if (process.platform !== 'win32' || !ip) return ''
  try {
    const { stdout } = await execFileAsync(
      'powershell',
      [
        '-NoProfile',
        '-Command',
        `$n = Get-NetNeighbor -IPAddress '${ip}' -ErrorAction SilentlyContinue | Where-Object { $_.LinkLayerAddress -and $_.State -ne 'Unreachable' } | Select-Object -First 1; if ($n) { $n.LinkLayerAddress }`,
      ],
      { windowsHide: true },
    )
    return normalizeMacAddress(stdout)
  } catch {
    return ''
  }
}

async function resolveMacOnWindows(ip: string) {
  const neighborMac = await resolveMacFromPowerShellNeighbor(ip)
  if (neighborMac) return neighborMac

  try {
    const { stdout } = await execFileAsync('arp', ['-a', ip], { windowsHide: true })
    const mac = extractMacFromOutput(stdout)
    if (mac) return mac
  } catch {
    /* fall through */
  }

  try {
    const { stdout } = await execFileAsync('nbtstat', ['-A', ip], { windowsHide: true })
    const mac = extractMacFromOutput(stdout)
    if (mac) return mac
  } catch {
    /* fall through */
  }

  return ''
}

async function resolveMacOnUnix(ip: string) {
  try {
    const { stdout } = await execFileAsync('arp', ['-n', ip])
    const mac = extractMacFromOutput(stdout)
    if (mac) return mac
  } catch {
    /* fall through */
  }

  try {
    const { stdout } = await execFileAsync('ip', ['neigh', 'show', ip])
    const mac = extractMacFromOutput(stdout)
    if (mac) return mac
  } catch {
    /* fall through */
  }

  return ''
}

async function resolveMacFromArpTable(ip: string) {
  try {
    const { stdout } = await execFileAsync('arp', ['-a'], {
      ...(process.platform === 'win32' ? { windowsHide: true } : {}),
    })
    for (const line of stdout.split(/\r?\n/)) {
      if (!line.includes(ip)) continue
      const mac = normalizeMacAddress(line)
      if (mac) return mac
    }
  } catch {
    /* ARP lookup is best-effort on the app server */
  }
  return ''
}

export async function resolveMacFromArp(ip: string) {
  if (!isUsableClientIp(ip)) return ''

  await pingClient(ip)

  const platformMac =
    process.platform === 'win32'
      ? await resolveMacOnWindows(ip)
      : await resolveMacOnUnix(ip)
  if (platformMac) return platformMac

  return resolveMacFromArpTable(ip)
}

export async function resolveMacFromCandidateIps(ips: string[]) {
  for (const ip of uniqueIps(ips)) {
    const mac = await resolveMacFromArp(ip)
    if (mac) return mac
  }
  return ''
}

export async function resolveAttendanceMacAddress(
  req: Request,
  options: { bodyMac?: string; clientIps?: string[]; employeeNo?: string } = {},
) {
  const supplied = normalizeMacAddress(String(options.bodyMac ?? '').trim())
  if (supplied) return supplied

  if (options.employeeNo) {
    const persisted = persistedEmployeeMac(options.employeeNo)
    if (persisted) return persisted
  }

  const requestIp = clientIpFromRequest(req)
  const mac = await resolveMacFromCandidateIps([...(options.clientIps ?? []), requestIp])
  return mac
}

export function formatAttendanceMacLabel(mac: string) {
  return normalizeMacAddress(mac) || attendanceIdentifierFromDeviceId(mac)
}

export function macFromAttendanceLocation(value: string) {
  const raw = String(value ?? '').trim()
  if (!raw) return ''
  if (raw.toLowerCase() === 'mac unavailable') return ''
  if (/latitude/i.test(raw) && /longitude/i.test(raw)) return ''
  if (raw.toUpperCase().startsWith('MAC:')) return normalizeMacAddress(raw.slice(4)) || raw.slice(4).trim()
  return normalizeMacAddress(raw)
}
