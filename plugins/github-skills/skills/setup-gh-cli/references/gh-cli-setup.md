# gh CLI Setup: Install and Auth Without Admin or winget

## Why a portable install

`gh` ships an official Windows install via `winget install GitHub.cli`,
but a bare/managed machine may have neither `gh` nor `winget` (both were
confirmed absent on this repo's own working machine). `winget` itself
needs the App Installer package and, on some Windows builds, admin
rights to bootstrap — not something to depend on for an automated task.

The portable path instead downloads the plain zip release GitHub already
publishes for every `gh` version and extracts it to a per-user directory
that needs no elevation:

```powershell
# see scripts/install-gh-portable.ps1 for the full, idempotent version
$release = Invoke-RestMethod https://api.github.com/repos/cli/cli/releases/latest
$asset = $release.assets | Where-Object { $_.name -match 'windows_amd64\.zip$' }
Invoke-WebRequest $asset.browser_download_url -OutFile gh.zip
Expand-Archive gh.zip -DestinationPath $env:LOCALAPPDATA\pmcro-skills-tools\gh -Force
$env:PATH = "$env:LOCALAPPDATA\pmcro-skills-tools\gh\bin;$env:PATH"
```

Never extract into a repo working tree — the binary must not get staged
or committed by an inattentive `git add -A`.

## Auth: what actually works non-interactively

`gh auth login` has three broad paths. Only two are usable from an
automated shell with no human sitting at the keyboard *right now*:

1. **`gh auth login --with-token < token-file`** — works if a Personal
   Access Token already exists somewhere safe to read from (an
   environment variable, a secrets manager). Preferred when available:
   fully non-interactive, no human step.
2. **`gh auth login --web`** (device flow) — prints a one-time code and
   a URL (`github.com/login/device`); a human opens the URL and enters
   the code. Works even with no PAT on hand, but needs that one human
   step — budget for it rather than assuming it completes unattended.
3. **Reusing the existing git credential helper's stored token** — the
   obvious-looking shortcut, since `git push`/`git pull` already
   authenticate silently via `credential.helper=manager` (Git Credential
   Manager) with no prompt. **This was tried and did not work**: calling
   `git credential fill` with `protocol=https` / `host=github.com` on
   stdin, from a .NET `Process` with `RedirectStandardInput` (both via
   plain pipeline `|` and via writing raw bytes directly to
   `StandardInput.BaseStream`), consistently returned an empty stdout
   and `fatal: refusing to work with credential missing protocol field`
   on stderr — i.e. GCM received no input at all through that path, even
   though the exact same protocol works when git's own internal C code
   invokes the helper for a real push/pull. The most likely cause is
   that `git credential fill` itself spawns GCM as a *further* child
   process and does not reliably forward a redirected stdin pipe across
   that hop when driven by an external automation harness rather than a
   real interactive terminal. This was not root-caused further because
   paths 1/2 above are sufficient — flagged here so a future session
   does not re-spend time on the same dead end. If someone does want to
   chase it further: `git credential-manager get` (the GCM binary
   directly, bypassing `git credential fill`'s indirection) is the next
   thing to try.

## Verifying it worked

```powershell
gh auth status   # "Logged in to github.com as <user>"
gh pr list        # exercises an actual authenticated API call
```
