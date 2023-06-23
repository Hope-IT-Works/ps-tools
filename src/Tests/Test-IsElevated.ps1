# Returns true, when the current PowerShell environment is elevated, returns false when not.
function Test-IsElevated {
    $a = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $b = New-Object System.Security.Principal.WindowsPrincipal($a)
    if ($b.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $c = $true
    } else {
        $c = $false
    }
    return $c
}
