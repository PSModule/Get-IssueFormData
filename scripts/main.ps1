[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSReviewUnusedParameter', 'IssueBody',
    Justification = 'Variable is used in LogGroup blocks.'
)]
[CmdletBinding()]
param()

$PSStyle.OutputRendering = 'Ansi'

LogGroup 'Issue Body - Raw' {
    Write-Output $env:GITHUB_ACTION_INPUT_IssueBody
}

LogGroup 'Issue Body - Object' {
    $data = $env:GITHUB_ACTION_INPUT_IssueBody | ConvertFrom-IssueForm
    $data | Format-List | Out-String
    Set-GitHubOutput -Name 'data' -Value $data
}
