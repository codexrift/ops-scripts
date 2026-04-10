param(
  [string[]] $Query,

  [switch] $NoColor,

  [switch] $Raw
)

$script:CmdHelpDir = $PSScriptRoot
$script:CmdHelpFile = Join-Path $script:CmdHelpDir ".cmdlist"

function cmdhelp {
  [CmdletBinding()]
  param(
    [string[]] $Query,

    [switch] $NoColor,

    [switch] $Raw
  )

  if (-not (Test-Path -LiteralPath $script:CmdHelpFile)) {
    throw "cmdhelp: missing cmdlist file: $script:CmdHelpFile"
  }

  $pattern = ($Query -join " ").Trim()
  $lines = Get-Content -LiteralPath $script:CmdHelpFile

  if ($pattern) {
    $lines =
      $lines |
      Select-String -Pattern $pattern -SimpleMatch -CaseSensitive:$false |
      ForEach-Object { $_.Line }
  }

  if ($Raw -or -not $Host.UI -or $NoColor) {
    foreach ($line in $lines) {
      if (-not $line) { continue }
      if ($line -match '^(?<cmd>\S.*)\s#\s(?<comment>\S.*)$') {
        "$($Matches['cmd']) # $($Matches['comment'])"
      }
    }
    return
  }

  foreach ($line in $lines) {
    if (-not $line) { continue }
    if ($line -notmatch '^(?<cmd>\S.*)\s#\s(?<comment>\S.*)$') { continue }

    Write-Host $Matches["cmd"] -ForegroundColor Cyan -NoNewline
    Write-Host " # " -ForegroundColor DarkGray -NoNewline
    Write-Host $Matches["comment"] -ForegroundColor DarkGray
  }
}

if ($MyInvocation.InvocationName -ne ".") {
  cmdhelp @PSBoundParameters
}
