import { cp, mkdir, rm } from 'node:fs/promises'
import { resolve } from 'node:path'

const frontendProject = resolve(
  process.env.PORTAL_PROJECT_DIR || '../SelfServicePortal/self-service-portal',
)
const source = resolve(frontendProject, 'dist')
const destination = resolve(process.env.PORTAL_STATIC_DIR || 'public')

await rm(destination, { recursive: true, force: true })
await mkdir(destination, { recursive: true })
await cp(source, destination, { recursive: true })

console.log(`Copied React build from ${source} to ${destination}`)
