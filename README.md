# Get-IssueFormData

Reads the body of an issue and parses it into a JSON object.

Bases itself on the definitions of GitHub Issue Forms:

- [Syntax for issue forms | GitHub Docs](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms)
- [Syntax for GitHub's form schema](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema)

## Usage

### Inputs

### Secrets

### Outputs

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

this action returns the following JSON object:

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
        uses: PSModule/Get-IssueFormData@v0

```

## Inspiration

- [zentered/issue-forms-body-parser](https://github.com/zentered/issue-forms-body-parser)
