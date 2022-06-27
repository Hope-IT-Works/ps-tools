function Remove-DuplicateFiles ($Path) {
    Get-ChildItem -Path $Path -Recurse | Get-FileHash | Group-Object -Property Hash | Where-Object -FilterScript { $_.Count -gt 1 } | ForEach-Object { $_.Group | Select-Object -Skip 1 } | Remove-Item
}
