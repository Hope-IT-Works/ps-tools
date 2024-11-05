# Returns true or false
function Get-BooleanFromUser {
    param(
        [string]$Title = '',
        [Parameter(ValueFromPipeline=$true)][string]$Question = ''
    )
    return $Host.UI.PromptForChoice($Title, $Question, @('&Yes', '&No'), 1) -eq 0
}

<#
    USAGE
    $Result = Get-BooleanFromUser -Title "Confirm" -Question "Are you sure?"
#>
