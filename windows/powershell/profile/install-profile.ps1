Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$isDotSourced = $MyInvocation.InvocationName -eq '.'

if ($args -contains '/disable' -or $args -contains 'disable' -or $args -contains '--disable') {
  $script:Disable = $true
} else {
  $script:Disable = $false
}

function Ensure-ProfileExecutionPolicy {
  $policyList = Get-ExecutionPolicy -List
  $machinePolicy = ($policyList | Where-Object Scope -eq 'MachinePolicy').ExecutionPolicy
  $userPolicy = ($policyList | Where-Object Scope -eq 'UserPolicy').ExecutionPolicy
  $currentUserPolicy = ($policyList | Where-Object Scope -eq 'CurrentUser').ExecutionPolicy

  if ($machinePolicy -notin @($null, '', 'Undefined') -or $userPolicy -notin @($null, '', 'Undefined')) {
    Write-Warning 'A Group Policy execution policy is set. Skipping CurrentUser execution policy changes.'
    return
  }

  if ($currentUserPolicy -in @($null, '', 'Undefined', 'Restricted', 'AllSigned')) {
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
  }
}

Ensure-ProfileExecutionPolicy

$sourceDir = $PSScriptRoot
$profilePaths = @(
  $PROFILE.CurrentUserAllHosts
  $PROFILE.CurrentUserCurrentHost
) | Select-Object -Unique

$profileDir = Split-Path -Parent $PROFILE.CurrentUserAllHosts
$targetDir = Join-Path $profileDir 'profile.custom'
$targetScript = Join-Path $targetDir 'cmdhelp.ps1'
$targetCmdList = Join-Path $targetDir '.cmdlist'

New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
$escapedTargetScript = $targetScript.Replace("'", "''")
$loaderLine = ". '$escapedTargetScript'"

if ($script:Disable) {
  foreach ($profilePath in $profilePaths) {
    if (-not (Test-Path -LiteralPath $profilePath)) { continue }
    $lines = Get-Content -LiteralPath $profilePath -ErrorAction SilentlyContinue
    $filtered = $lines | Where-Object { $_ -ne $loaderLine -and $_ -ne '# cmdhelp profile' }
    Set-Content -LiteralPath $profilePath -Value $filtered -Encoding utf8
  }

  Remove-Item -LiteralPath $targetScript -ErrorAction SilentlyContinue
  Remove-Item -LiteralPath $targetCmdList -ErrorAction SilentlyContinue
  try { Remove-Item -LiteralPath $targetDir -Force -ErrorAction SilentlyContinue } catch { }

  if (-not $isDotSourced) {
    Write-Host 'Disabled PowerShell cmdhelp auto-load.'
    foreach ($profilePath in $profilePaths) {
      Write-Host "Profile updated: $profilePath"
    }
  }
  return
}

New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
Copy-Item -LiteralPath (Join-Path $sourceDir 'cmdhelp.ps1') -Destination $targetScript -Force
Copy-Item -LiteralPath (Join-Path $sourceDir '.cmdlist') -Destination $targetCmdList -Force

foreach ($profilePath in $profilePaths) {
  $profileParentDir = Split-Path -Parent $profilePath
  New-Item -ItemType Directory -Force -Path $profileParentDir | Out-Null

  if (-not (Test-Path -LiteralPath $profilePath)) {
    New-Item -ItemType File -Path $profilePath | Out-Null
  }

  $profileLines = Get-Content -LiteralPath $profilePath -ErrorAction SilentlyContinue
  if (-not ($profileLines -contains $loaderLine)) {
    Add-Content -LiteralPath $profilePath -Value ''
    Add-Content -LiteralPath $profilePath -Value '# cmdhelp profile'
    Add-Content -LiteralPath $profilePath -Value $loaderLine
  }
}

. $targetScript

if (-not $isDotSourced) {
  Write-Host 'Installed PowerShell profile custom files.'
  foreach ($profilePath in $profilePaths) {
    Write-Host "Profile updated: $profilePath"
  }
  Write-Host 'Execution policy ensured: CurrentUser RemoteSigned'
  Write-Host 'Open a new PowerShell session to load cmdhelp automatically.'
}
