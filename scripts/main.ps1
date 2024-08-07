[CmdletBinding()]
param(
    [Parameter()]
    [string] $IssueBody = $env:GITHUB_ACTION_INPUT_IssueBody
)

function Parse-IssueBody {
    [OutputType([PSCustomObject[]])]
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $IssueBody
    )

    $content = $IssueBody.Split([Environment]::NewLine).Trim() | Where-Object { $_ -ne '' }

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
    $results
}

function Process-IssueBody {
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

$VerbosePreference = 'Continue'
Write-Host '::group::Issue Body'
$IssueBody
Write-Host '::endgroup::'

Write-Host '::group::Issue Body Split'
# Read the content of the file

$results = Parse-IssueBody -IssueBody $IssueBody | Process-IssueBody
# Output the results
$results | Format-Table -AutoSize

Write-Host '::endgroup::'
