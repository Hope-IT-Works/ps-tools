# Returns true, when the given string is valid Web-Uri, otherwise returns false.
function Test-IsWebUri {
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]$Uri
    )
    return [System.Uri]::IsWellFormedUriString($Uri, 'Relative') -and ([System.Uri]$Uri).Scheme -in 'http', 'https'
}

# Test-IsWebUri "http://google.de"
