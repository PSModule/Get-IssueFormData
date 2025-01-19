[CmdletBinding()]
param(
    [Parameter()]
    [string] $IssueBody = $env:GITHUB_ACTION_INPUT_IssueBody
)

filter Remove-MarkdownComments {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [string] $Markdown
    )
    $commentPattern = '<!--[\s\S]*?-->'
    $content = $Markdown
    $content = $Markdown -replace $commentPattern
    $content
}

filter Parse-IssueBody {
    [OutputType([PSCustomObject[]])]
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [string] $IssueBody
    )
    $content = $IssueBody | Remove-MarkdownComments
    $content = $content.Split([Environment]::NewLine).Trim() | Where-Object { $_ -ne '' }

    $results = @()
    $currentHeader = ''
    $currentParagraph = @()

    foreach ($line in $content) {
        Write-Verbose "Processing line: [$line]"

        if ($line -match '^### (.+)$') {
            # If a new header is found, store the current header and paragraph in the results
            if ($currentHeader -ne '') {
                $results += [PSCustomObject]@{
                    Header    = $currentHeader
                    Paragraph = $currentParagraph.Trim()
                }
            }

            # Update the newly detected header and reset the paragraph
            $currentHeader = $matches[1]
            $currentParagraph = @()
        } else {
            # Append the line to the current paragraph
            $currentParagraph += $line
        }
    }

    # Add the last header and paragraph to the results
    if ($currentHeader -ne '') {
        $results += [PSCustomObject]@{
            Header    = $currentHeader
            Paragraph = $currentParagraph.Trim()
        }
    }
    $results | ConvertTo-Json
}

filter Process-IssueBody {
    [OutputType([hashtable])]
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [string] $IssueBody
    )

    $content = $IssueBody | ConvertFrom-Json

    # Initialize hashtable
    $data = @{}

    # Process each entry in the JSON
    foreach ($entry in $content) {
        $header = $entry.Header
        $paragraph = $entry.Paragraph

        if ($paragraph -is [string]) {
            # Assign string value directly
            $data[$header] = $paragraph
        } elseif ($paragraph -is [array]) {
            # Check if it's a multi-line string or checkbox list
            if ($paragraph -match '^\s*- \[.\]\s') {
                # It's a checkbox list, process as key-value pairs
                $checkboxHashTable = @{}
                foreach ($line in $paragraph) {
                    if ($line -match '^\s*- \[(x| )\]\s*(.+)$') {
                        $checked = $matches[1] -eq 'x'
                        $item = $matches[2]
                        $checkboxHashTable[$item] = $checked
                    }
                }
                $data[$header] = $checkboxHashTable
            } else {
                # It's a multi-line string
                $data[$header] = $paragraph -join [System.Environment]::NewLine
            }
        }
    }
    $data
}

LogGroup 'Issue Body' {
    Write-Output $IssueBody
}

LogGroup 'Issue Body Split' {
    $data = $IssueBody | Parse-IssueBody | Process-IssueBody
    # Output the results
    $data | Format-Table -AutoSize
    $data = $data | ConvertTo-Json -Compress
    Write-Output $data
    Set-GitHubOutput -Name 'data' -Value $data
}
