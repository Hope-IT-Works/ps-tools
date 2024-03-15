function Invoke-SSHCommand ($ConnectionString, $RemoteCommand) {
    $SSH_Parameters = "-t "+$ConnectionString+" "+$RemoteCommand
    Write-Host -NoNewline -ForegroundColor Yellow ('['+$ConnectionString+']: ')
    Write-Host -ForegroundColor Cyan $RemoteCommand
    $SSH_ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
    $SSH_ProcessInfo.FileName = 'ssh'
    $SSH_ProcessInfo.RedirectStandardError = $true
    $SSH_ProcessInfo.StandardErrorEncoding = [System.Text.Encoding]::UTF8
    $SSH_ProcessInfo.RedirectStandardOutput = $true
    $SSH_ProcessInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
    $SSH_ProcessInfo.UseShellExecute = $false
    $SSH_ProcessInfo.CreateNoWindow = $true
    $SSH_ProcessInfo.Arguments = $SSH_Parameters
    $SSH_Process = New-Object System.Diagnostics.Process
    $SSH_Process.StartInfo = $SSH_ProcessInfo
    $SSH_Process.Start() | Out-Null
    $SSH_Process.WaitForExit()
    $SSH_Error = $SSH_Process.StandardError.ReadToEnd()
    $SSH_Output = $SSH_Process.StandardOutput.ReadToEnd()
    if($SSH_Process.ExitCode -eq 0){
        Write-Host -ForegroundColor Green '➡️ SUCCESS ✅'
        Write-Host $SSH_Output
    } else {
        Write-Host -ForegroundColor Red ('➡️ FAILED ❌: '+$SSH_Error+' | '+$SSH_Output)
    }
}

<#
    USAGE
    Invoke-SSHCommand -ConnectionString "user@host" -RemoteCommand "ls -l"
#>