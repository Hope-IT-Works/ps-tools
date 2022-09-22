param([switch]$KeepDownload)

function Check-IsElevated {
    $a = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $b = New-Object System.Security.Principal.WindowsPrincipal($a)
    if ($b.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $c = $true
    } else {
        $c = $false
    }
    return $c
}

if(-not(Check-IsElevated)){
    return "Error: The script was not invoked as administrator"
}

if([System.Environment]::Is64BitOperatingSystem){
    $PS_DL_ARCH = "x64"
} else {
    $PS_DL_ARCH = "x86"
}

$PS_DL_VERSION = "7.2.3"
$PS_DL_URL     = "https://github.com/PowerShell/PowerShell/releases/download/v"+$PS_DL_VERSION+"/PowerShell-"+$PS_DL_VERSION+"-win-"+$PS_DL_ARCH+".msi"
$PS_DL_NAME    = Split-Path $PS_DL_URL -Leaf
$PS_DL_PATH    = Join-Path $env:TEMP $PS_DL_NAME

$PS_SEC_URL    = 'https://github.com/PowerShell/PowerShell/releases/tag/v' + $PS_DL_VERSION
$PS_SEC_PARSER = '(?s)(?<=' + $PS_DL_NAME + ')[^\da-f]*?(?<FileHash>[\da-f]+)[^\da-f]*?(?=PowerShell)'

try {
    Write-Host -ForegroundColor Yellow ("Downloading "+$PS_DL_NAME)
    Invoke-WebRequest -UseBasicParsing -Uri $PS_DL_URL -OutFile $PS_DL_PATH
    Write-Host -ForegroundColor Yellow ("Downloaded "+$PS_DL_NAME)
    Write-Host -ForegroundColor Yellow ("Validating "+$PS_DL_NAME)
    $res = Invoke-WebRequest -UseBasicParsing -Uri $PS_SEC_URL
    if($res.Content -match $PS_SEC_PARSER) {
        $ExpectedHash = $Matches.FileHash
        $ReceivedHash = (Get-FileHash -Path $PS_DL_PATH -Algorithm SHA256).Hash
        if($ReceivedHash -ne $ExpectedHash) {
            throw 'Fail: File download validation check.'
        }
        Write-Host -ForegroundColor Yellow ("Validated "+$PS_DL_NAME)
    } else {
        Write-Warning 'Build verification not found'
    }
    Write-Host -ForegroundColor Yellow ("Installing "+$PS_DL_NAME+" with msiexec")
    msiexec /i $PS_DL_PATH /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=0 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=0 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1
    Write-Host -ForegroundColor Yellow ("Installed "+$PS_DL_NAME)
} catch {
    Write-Host -ForegroundColor Red "Error: Download or Installation failed."
}
if(!$KeepDownload) {
    Remove-Item -Path $PS_DL_NAME -ErrorAction SilentlyContiue
}
