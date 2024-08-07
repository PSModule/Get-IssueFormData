# Template-action

A template repository for GitHub Actions

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
