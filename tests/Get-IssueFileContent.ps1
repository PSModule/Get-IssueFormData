LogGroup 'Get Issue File Content' {
    $issueFileContent = Get-Content -Path tests/IssueBody.md -Raw
    $issueFileContent
    Set-GitHubOutput -Name 'issueFileContent' -Value $issueFileContent
}
