[CmdletBinding()]
param(
    [Parameter()]
    [string] $IssueBody = $env:GITHUB_ACTION_INPUT_IssueBody
)

LogGroup 'Issue Body - Raw' {
    Write-Output $IssueBody
}

LogGroup 'Issue Body - Object' {
    $data = $IssueBody | ConvertFrom-IssueForm
    $data | Format-Table -AutoSize
}

LogGroup 'Issue Body - JSON' {
    # $data = $data | ConvertTo-Json -Compress
    $data | Format-Table -AutoSize
    Set-GitHubOutput -Name 'data' -Value $data
}
