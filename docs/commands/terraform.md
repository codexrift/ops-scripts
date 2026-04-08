# Terraform Cheat Sheet

## Basics (init / fmt / validate)

```bash
# Show Terraform version
terraform version

# Initialize providers/modules and backend
terraform init

# Format .tf files
terraform fmt -recursive

# Validate configuration syntax and basic consistency
terraform validate
```

Reconfigure / upgrade providers:

```bash
# Reinitialize and ignore previous backend settings
terraform init -reconfigure

# Upgrade providers/modules within allowed constraints
terraform init -upgrade
```

## Plan / apply (common workflows)

Plan and review changes:

```bash
# Create an execution plan (preview changes)
terraform plan

# Save a plan to a file for a reviewed apply
terraform plan -out tfplan

# Render the saved plan in a readable form
terraform show -no-color tfplan
```

Apply:

```bash
# Plan and apply in one step (interactive approval)
terraform apply

# Apply a previously saved plan file
terraform apply tfplan
```

Destroy:

```bash
# Destroy all managed infrastructure in this workspace
terraform destroy

# Destroy only a target (can leave things inconsistent; use with care)
terraform destroy -target=module.foo
```

Refresh / drift checks:

```bash
# Reconcile state with real infrastructure without proposing config changes
terraform plan -refresh-only

# Apply refresh-only changes (updates state)
terraform apply -refresh-only
```

## Variables

```bash
# Set a variable inline
terraform plan -var 'env=dev'

# Load variables from a tfvars file
terraform plan -var-file=dev.tfvars

# Set a variable via environment variable (be careful with shells/history)
export TF_VAR_region=us-east-1
```

## Outputs

```bash
# Print all outputs
terraform output

# Print outputs as JSON (useful for tooling)
terraform output -json

# Print a single named output
terraform output db_endpoint
```

## State (inspect / move / remove)

List resources in state:

```bash
# List all addresses in state
terraform state list

# List only addresses matching a pattern
terraform state list 'module.vpc.*'
```

Inspect a resource:

```bash
# Show attributes for a state address
terraform state show aws_instance.web[0]
```

Move / rename (refactor without recreating):

```bash
# Move a state address (rename/refactor without recreation)
terraform state mv aws_instance.web aws_instance.app

# Move between modules (quoted to avoid shell globbing)
terraform state mv 'module.old.aws_s3_bucket.b' 'module.new.aws_s3_bucket.b'
```

Remove from state (does NOT delete in the provider):

```bash
# Remove an address from state (does NOT delete in the provider)
terraform state rm aws_instance.web
```

## Import existing resources

Import a real-world object into state (resource must exist in config):

```bash
# Import an existing object into state (resource must be in config)
terraform import aws_s3_bucket.logs my-company-logs-bucket

# Verify Terraform agrees with reality after import
terraform plan
```

## Targeting / replacing (use with care)

Target a subset (can lead to partial/inconsistent state if overused):

```bash
# Plan only a subset (can hide dependencies; use with care)
terraform plan -target=module.network

# Apply only a subset (can hide dependencies; use with care)
terraform apply -target=module.network
```

Force replacement of a resource:

```bash
# Force a resource to be replaced on next apply
terraform plan -replace=aws_instance.web

# Apply a forced replacement
terraform apply -replace=aws_instance.web
```

## Workspaces

```bash
# List workspaces
terraform workspace list

# Show current workspace
terraform workspace show

# Create a new workspace
terraform workspace new dev

# Switch to an existing workspace
terraform workspace select prod
```

## Debugging / introspection

Open the console with current values:

```bash
# Evaluate expressions against the current state/variables
terraform console
```

Show a plan/state as JSON (useful for tooling):

```bash
# Render a plan as machine-readable JSON
terraform show -json tfplan > tfplan.json
```

Logs:

```bash
# Enable INFO logs
export TF_LOG=INFO

# Write logs to a file
export TF_LOG_PATH=./terraform.log

# Run a command with logging enabled
terraform plan
```

## Useful flags

Run in a different directory:

```bash
# Run Terraform using configuration in a subdirectory
terraform -chdir=infra plan

# Apply from a subdirectory
terraform -chdir=infra apply
```

Notes:

- `terraform fmt` and `terraform validate` are fast; run them before every PR.
- Be careful with `state rm` and `-target`; they are powerful but easy to misuse.
