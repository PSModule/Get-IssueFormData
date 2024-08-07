BeforeAll {
    $data = $env:data | ConvertFrom-Json
}

Describe "IssueBody" {
    It "'Type with spaces' should contain 'Action'" {
        $data | Should -ContainKey 'Type with spaces'
        $data['Type with spaces'] | Should -Be 'Action'
    }

    It "'Multiline' should contain a multiline string with 3 lines" {
        $data | Should -ContainKey 'Multiline'
        $data['Multiline'] | Should -Be @'
test
is multi
line
'@
    }

    It "'OS' should contain a hashtable with 3 items" {
        $data | Should -ContainKey 'OS'
        $data['OS'] | Should -Be @{
            Windows = $true
            Linux   = $true
            macOS   = $false
        }
    }
}
