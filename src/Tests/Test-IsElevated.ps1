# Returns true, when the current PowerShell environment is elevated, returns false when not.
function Test-IsElevated {
    $a = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $a = New-Object System.Security.Principal.WindowsPrincipal($a)
    if ($a.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $b = $true
    } else {
        $b = $false
    }
    return $b
}
