[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSReviewUnusedParameter', 'IssueBody',
    Justification = 'Variable is used in LogGroup blocks.'
)]
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
    $data | Format-List
    Set-GitHubOutput -Name 'data' -Value $data
}
