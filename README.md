# Get-IssueFormData

Reads the body of an issue and parses it into a JSON object.

Bases itself on the definitions of GitHub Issue Forms:

- [Syntax for issue forms | GitHub Docs](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms)
- [Syntax for GitHub's form schema](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema)

## Usage

### Inputs

### Secrets

### Outputs

The data structure that is returned is a JSON object that contains the following properties:

```json
{
    "<header1>": "<value1>",                           // input
    "<header2>": "<value2>",                           // dropdown
    "<header3>": "<value3.1>\n<value3.2>\n<value3.3>", // textarea
    "<header4>": {                                     // checkbox
        "<valuename>": true,
        "<valuename>": false
    }
}
```

### Example

```yaml
Example here
```

## Inspiration

- [zentered/issue-forms-body-parser](https://github.com/zentered/issue-forms-body-parser)
