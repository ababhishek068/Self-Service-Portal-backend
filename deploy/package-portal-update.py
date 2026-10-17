#!/usr/bin/env python3
"""Build a standalone Windows portal update with an optional verified BC432 hotfix, without credentials."""
import argparse
import xml.etree.ElementTree as ET
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import zipfile

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument('--include-bc432', action='store_true')
parser.add_argument('--include-profile-source', action='store_true')
args = parser.parse_args()
bc_files = []
if args.include_bc432:
    bc_root = ROOT / 'output/bc432'
    bc_files = ['Technology Associates EA Ltd_BC24_TA App_1.0.3.432.app',
                'INSTALL-BC432.ps1', 'UAT-CHECKLIST.txt', 'StoreApprovalGuard.patch',
                'VERIFICATION.json']
    for file in bc_files:
        if not (bc_root / file).is_file():
            raise SystemExit(f'Missing BC hotfix artifact: {file}')
    with zipfile.ZipFile(bc_root / bc_files[0]) as z:
        app = ET.fromstring(z.read('NavxManifest.xml')).find('{*}App')
        if app.get('Id') != '5b5c244a-59bb-4a49-a255-0757fe4470cd' or app.get('Version') != '1.0.3.432':
            raise SystemExit('Unexpected BC app identity/version')
stamp = re.search(r"PORTAL_API_BUILD = '([^']+)'", (ROOT / 'src/portalApi.ts').read_text()).group(1)
version = re.search(r'\d+\.\d+\.\d+\.\d+', stamp).group()
name = f'ABH-Portal-COMPLETE-{version}'
out = ROOT / name
if out.exists() or (ROOT / f'{name}.zip').exists():
    raise SystemExit(f'Release already exists: {name}; choose a new version or move the previous output.')

def run(*args, cwd=ROOT):
    subprocess.run(args, cwd=cwd, check=True)

run('npm', 'test')
run('npm', 'run', 'build:portal')
backend = out / 'SelfServiceSuite/SelfServiceBackend'
backend.mkdir(parents=True)
for folder in ('dist', 'public'):
    shutil.copytree(ROOT / folder, backend / folder)
(backend / 'dist/BUILD_ID.txt').write_text(stamp + '\n')
for file in ('package.json', 'package-lock.json'):
    shutil.copy2(ROOT / file, backend / file)
# Only locked production dependencies; no native dev/build binaries from this Mac.
run('npm', 'ci', '--omit=dev', '--ignore-scripts', '--offline', '--no-audit', '--no-fund', cwd=backend)
windows = out / 'deploy/windows'
windows.mkdir(parents=True)
launchers = ('START-ABH-PORTAL.bat', 'STOP-ABH-PORTAL.bat', 'VERIFY-SUITE.bat',
             'INSTALL-AUTOSTART.bat', 'INSTALL-AUTOSTART.ps1')
for file in (*launchers, 'START-ABH-PORTAL-ONBOOT.bat', 'kill-port.bat'):
    shutil.copy2(ROOT / 'deploy/windows' / file, windows / file)
for file in launchers:
    shutil.copy2(windows / file, out / file)
shutil.copy2(ROOT / 'deploy/PORTAL-UPDATE-README.txt', out / 'READ-ME-FIRST.txt')
release = {
    'version': version, 'build': stamp, 'bcAppIncluded': False,
    'bcStoreApprovalErrorResolved': False,
    'bcStoreApprovalHotfixRequired': True,
    'bcHotfixBaselineVersion': '1.0.3.410',
    'fixes': ['BC non-annual leave balances', 'Borrowing PDF pagination',
              'Store concurrent submission protection', 'Strict Store approval confirmation',
              'Refresh after failed actions'],
    'knownLimitations': ['BC pending-approval modification error requires a separate compatible BC hotfix.',
                         'Windows runtime and end-to-end BC approval require UAT validation.'],
    'annualLeaveCalculationChanged': False,
}
if args.include_bc432:
    bc_dest = out / 'deploy/businesscentral'
    bc_dest.mkdir(parents=True)
    for file in bc_files:
        shutil.copy2(bc_root / file, bc_dest / file)
    release.update(bcAppIncluded=True, bcAppVersion='1.0.3.432',
                   bcHotfixBaselineVersion='1.0.3.431',
                   bcStoreApprovalFixIncluded=True,
                   bcStoreApprovalErrorResolved=None,
                   bcStoreApprovalRuntimeVerified=False,
                   knownLimitations=['BC runtime regression tests and full workflow require UAT validation.',
                                     'Windows launchers require validation on the target server.'])
    release['fixes'].append('BC Store pending approval guard uses persisted state')
if args.include_profile_source:
    profile_source = ROOT / 'output/profile/al-source'
    if not (profile_source / 'EmployeeProfile.patch').is_file():
        raise SystemExit('Missing AL profile source handoff')
    shutil.copytree(profile_source, out / 'deploy/businesscentral/profile-source')
    release.update(bcProfileSourceIncluded=True, bcProfileSourcePublished=False,
                   bcProfileRuntimeVerified=False, bcHotfixBaselineVersion=None)
    release['fixes'].extend(['Allowlisted employee profile from BC', 'Hide absent profile fields and empty sections',
                            'BC option captions and complete contact/contract details', 'Visible partial source failures'])
    release['knownLimitations'] = [
        'Expanded profile data requires Nitish to build and publish the included AL source patch on the latest BC app.',
        'Until that publish, existing BC endpoints provide partial data and unavailable sections show a retry notice.',
        'Store approval still requires the previously supplied AL guard fix and end-to-end UAT verification.',
        'Windows launchers and expanded profile require validation on the target BC server.'
    ]
(out / 'RELEASE.json').write_text(json.dumps(release, indent=2) + '\n')
files = sorted(p for p in out.rglob('*') if p.is_file())
for file in files:
    if file.name in ('.env', '.npmrc', '.DS_Store') or file.suffix in ('.log', '.node') or (file.suffix == '.app' and (not args.include_bc432 or file.name != bc_files[0])):
        raise SystemExit(f'Unexpected runtime/private file in package: {file.relative_to(out)}')
checksums = '\n'.join(f'{hashlib.sha256(p.read_bytes()).hexdigest()}  {p.relative_to(out).as_posix()}' for p in files)
(out / 'SHA256SUMS.txt').write_text(checksums + '\n')
archive = ROOT / f'{name}.zip'
with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
    for file in sorted(out.rglob('*')):
        if file.is_file():
            z.write(file, file.relative_to(ROOT).as_posix())
digest = hashlib.sha256(archive.read_bytes()).hexdigest()
(ROOT / f'{name}.sha256.txt').write_text(f'{digest}  {archive.name}\n')
print(f'Created {archive} ({archive.stat().st_size:,} bytes)')
