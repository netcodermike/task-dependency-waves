param([Parameter(Mandatory=$true, Position=0)][string] $InputPath)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
function Invoke-Analysis($data) {
    $tasks = $data['tasks']
    if ($tasks -isnot [System.Collections.IDictionary] -or $tasks.Count -eq 0) { throw 'Enter a nonempty task map' }
    $remaining = [System.Collections.Generic.List[string]]::new()
    foreach ($task in $tasks.Keys) {
        if ($tasks[$task] -isnot [array] -or @($tasks[$task] | Where-Object { $_ -cnotin $tasks.Keys }).Count) { throw 'A dependency is missing or invalid' }
        $remaining.Add($task)
    }
    $done = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $waves = [System.Collections.Generic.List[object]]::new()
    while ($remaining.Count) {
        $ready = @($remaining | Where-Object {
            @($tasks[$_] | Where-Object { -not $done.Contains([string]$_) }).Count -eq 0
        } | Sort-Object -CaseSensitive)
        if (!$ready.Count) { throw 'Dependencies contain a cycle' }
        $waves.Add($ready)
        foreach ($item in $ready) { $null = $remaining.Remove($item); $null = $done.Add($item) }
    }
    @{ waves = $waves.ToArray() }
}

try {
    $payload = Get-Content -LiteralPath $InputPath -Raw | ConvertFrom-Json -AsHashtable
    if ($payload -isnot [System.Collections.IDictionary]) { throw 'Input must be a JSON object' }
    Invoke-Analysis $payload | ConvertTo-Json -Depth 30 -Compress
} catch {
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 2
}
