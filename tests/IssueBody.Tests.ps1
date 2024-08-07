BeforeAll {
    $data = $env:data | ConvertFrom-Json -AsHashtable
    Write-Verbose ($data | Out-String) -Verbose
}

Describe "IssueBody" {
    It "'Type with spaces' should contain 'Action'" {
        $data.Keys | Should -Contain 'Type with spaces'
        $data['Type with spaces'] | Should -Be 'Action'
    }

    It "'Multiline' should contain a multiline string with 3 lines" {
        $data.Keys | Should -Contain 'Multiline'
        $data['Multiline'] | Should -Be @'
test
is multi
line
'@
    }

    It "'OS' should contain a hashtable with 3 items" {
        $data.Keys | Should -Contain 'OS'
        $data['OS'] | Should -Be @{
            Windows = $true
            Linux   = $true
            macOS   = $false
        }
    }
}
