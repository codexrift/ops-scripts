# AWS CloudFormation (Cheat Sheet)

Infrastructure as Code: manage AWS resources via templates and stacks.

## Core concepts

- **Template**: YAML/JSON resource declarations
- **Stack**: deployed instance of a template
- **Change set**: preview of changes before apply

## Practical notes

- Prefer change sets for safer deployments
- Use stack policies/termination protection for critical stacks

## Common operational gotchas

- “Drift” happens when manual changes occur; detect and correct it
- Failed updates can leave resources in partial states; plan rollbacks

