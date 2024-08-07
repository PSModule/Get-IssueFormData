BeforeAll {
    $data = $env:data | ConvertFrom-Json -AsHashtable
    Write-Verbose ($data | Out-String) -Verbose
}

Describe "IssueBody" {
    It "'Type with spaces' should contain 'Action'" {
        Write-Verbose ($data['Type with spaces'] | Out-String) -Verbose
        $data.Keys | Should -Contain 'Type with spaces'
        $data['Type with spaces'] | Should -Be 'Action'
    }

    It "'Multiline' should contain a multiline string with 3 lines" {
        Write-Verbose ($data['Multiline'] | Out-String) -Verbose
        $data.Keys | Should -Contain 'Multiline'
        $data['Multiline'] | Should -Be @'
test
is multi
line
'@
    }

    It "'OS' should contain a hashtable with 3 items" {
        Write-Verbose ($data['OS'] | Out-String) -Verbose
        $data.Keys | Should -Contain 'OS'
        $data['OS'].Windows | Should -BeTrue
        $data['OS'].Linux | Should -BeTrue
        $data['OS'].Mac | Should -BeFalse
    }
}
