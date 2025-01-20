# Get-IssueFormData

Reads the body of an issue and parses it into a JSON object.

Bases itself on the definitions of GitHub Issue Forms:

- [Syntax for issue forms | GitHub Docs](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms)
- [Syntax for GitHub's form schema](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema)

## Usage

Provided the following issue body:

```md
### Name

Name provided in the issue.

### Language

PowerShell

### Rationale

I need the
<!-- This is
a comment --> data parsed

### OS

- [ ] macOS
- [x] Ubuntu
- [x] Windows

```

This action returns the following JSON object:

```json
{
    "Name": "Name provided in the issue.",  // input
    "Language": "PowerShell",               // dropdown
    "Rationale": "I need the\ndata parsed", // textarea
    "OS": {                          // checkbox
        "macOS": false,
        "Ubuntu": true,
        "Windows": true
    }
}
```

### Inputs

| Name | Description | Default | Required |
| ---- | ----------- | ------- | -------- |
| IssueBody | The body of the issue | `${{ github.event.issue.body }}` | false |

### Outputs

| Name | Description |
| ---- | ----------- |
| data | The parsed JSON object |

### Example

```yaml
name: Example workflow
on:
  issues:
    types:
      - opened
      - edited

permissions:
  contents: read

jobs:
  assign:
    name: Process issue
    runs-on: ubuntu-latest
    steps:
      - name: Get-IssueFormData
        id: Get-IssueFormData
        uses: PSModule/Get-IssueFormData@v1

      - name: Print data
        shell: pwsh
        env:
          data: ${{ steps.Get-IssueFormData.outputs.data }}
        run: |
          $data = $env:data | ConvertFrom-Json
          Write-Output $data

```

## Alternatives

- [github/issue-parser](https://github.com/github/issue-parser)
- [issue-ops/parser](https://github.com/issue-ops/parser)
- [peter-murray/issue-forms-body-parser](https://github.com/peter-murray/issue-forms-body-parser)
- [peter-murray/issue-body-parser-action](https://github.com/peter-murray/issue-body-parser-action)
