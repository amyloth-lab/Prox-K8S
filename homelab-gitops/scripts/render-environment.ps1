param(
    [Parameter(Mandatory = $true)]
    [string]$EnvironmentFile
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $EnvironmentFile)) {
    throw "Environment file not found: $EnvironmentFile"
}

$values = @{}
Get-Content $EnvironmentFile | Where-Object {
    $_ -match '^[A-Z][A-Z0-9_]*=' -and $_ -notmatch '^\s*$'
} | ForEach-Object {
    $name, $value = $_ -split '=', 2
    $values[$name] = $value
}

$required = @(
    'GITOPS_REPO_SSH',
    'GITOPS_BASE_DOMAIN',
    'KUBERNETES_API_VIP',
    'KUBERNETES_POD_CIDR',
    'CILIUM_L2_START',
    'CILIUM_L2_END',
    'GATEWAY_ADDRESS',
    'LONGHORN_BACKUP_TARGET',
    'SOPS_AGE_PUBLIC_RECIPIENT'
)

foreach ($name in $required) {
    if (-not $values.ContainsKey($name) -or [string]::IsNullOrWhiteSpace($values[$name])) {
        throw "Missing required variable: $name"
    }
}

$replacements = @{
    'git@github.com:example-org/homelab-gitops.git' = $values['GITOPS_REPO_SSH']
    'example.com' = $values['GITOPS_BASE_DOMAIN']
    '192.0.2.150' = $values['KUBERNETES_API_VIP']
    '10.244.0.0/16' = $values['KUBERNETES_POD_CIDR']
    'start: "192.0.2.151"' = "start: `"$($values['CILIUM_L2_START'])`""
    'stop: "192.0.2.159"' = "stop: `"$($values['CILIUM_L2_END'])`""
    '192.0.2.151' = $values['GATEWAY_ADDRESS']
    'nfs://nfs.example.internal:/srv/nfs/k8s-backups' = $values['LONGHORN_BACKUP_TARGET']
    'AGE_PUBLIC_RECIPIENT' = $values['SOPS_AGE_PUBLIC_RECIPIENT']
}

$paths = @(
    (Join-Path $PSScriptRoot '..\bootstrap'),
    (Join-Path $PSScriptRoot '..\infrastructure'),
    (Join-Path $PSScriptRoot '..\apps')
)

foreach ($path in $paths) {
    Get-ChildItem -LiteralPath $path -Recurse -File -Include '*.yaml','*.yml' |
        ForEach-Object {
            $content = Get-Content -LiteralPath $_.FullName -Raw
            foreach ($oldValue in $replacements.Keys) {
                $content = $content.Replace($oldValue, $replacements[$oldValue])
            }
            Set-Content -LiteralPath $_.FullName -Value $content -NoNewline
        }
}

Write-Host "Rendered repository environment values from $EnvironmentFile"
