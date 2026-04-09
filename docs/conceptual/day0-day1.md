# Day 0 / Day 1 (IT Operations Concepts)

In IT/DevOps, "Day 0" and "Day 1" describe phases of a system's lifecycle.
You'll also hear "Day 2" (ongoing operations), but this doc focuses on Day 0 and Day 1.

## Definitions

- **Day 0**: design + initial provisioning foundations (getting ready to run)
- **Day 1**: initial configuration + first deployment (getting it running correctly)

Rule of thumb:

- Day 0 answers **"What are we building, where, and with what guardrails?"**
- Day 1 answers **"How do we configure and deploy it so it's usable?"**

## Day 0 (design / foundation / provisioning)

Typical Day 0 outcomes:

- **Architecture**: components, dependencies, data flows, failure domains
- **Environment setup**: accounts/subscriptions/projects, VPC/VNet, subnets, DNS, routing
- **Identity & access**: IAM roles/groups, least privilege, SSO integration
- **Security baseline**: network segmentation, encryption defaults, secrets strategy
- **Standards**: naming conventions, tagging/labels, resource organization
- **Provisioning automation**: IaC modules, reusable templates, CI pipeline scaffolding
- **Observability baseline**: log destinations, metrics, alerts destinations (even if minimal)
- **Backups / DR posture**: RPO/RTO assumptions, backup locations, restore plan outline

Examples:

- Building the VPC/VNet, subnets, route tables, and security groups
- Creating Kubernetes cluster / node pools and configuring baseline policies
- Defining Terraform state backend and remote locking
- Setting up container registry, artifact repo, and CI/CD credentials

Common risks if Day 0 is rushed:

- Inconsistent environments (dev/prod drift from day one)
- Security gaps (over-permissive IAM, open networks, unmanaged secrets)
- Hard-to-operate systems (no logs/metrics path, no ownership, no naming/tagging)

## Day 1 (configuration / deployment / go-live)

Typical Day 1 outcomes:

- **Configuration management**: OS packages, users, services, app configs
- **Application deployment**: first release deployed, smoke-tested, and documented
- **Data initialization**: DB schema migrations, seed data, initial integrations
- **Operational readiness**: runbooks, on-call/ownership, dashboards, basic alerting
- **Access for users/operators**: least-privilege access, break-glass procedure
- **Validation**: health checks, rollback plan tested (even if manual), SLO expectations set

Examples:

- Installing and configuring NGINX + TLS + systemd units
- Deploying the first Helm release into a new namespace
- Configuring logging agents and forwarding to the central log system
- Running the first backup and performing a restore test of a small sample

Common risks if Day 1 is rushed:

- "It works on my machine" deployments
- No clear rollback path
- Missing operational docs/runbooks (tribal knowledge)

## Day 0 vs Day 1 (quick comparison)

| Area | Day 0 focus | Day 1 focus |
|---|---|---|
| Infra | Create the environment | Configure it for workloads |
| Security | Guardrails + defaults | App/service-specific policies |
| Automation | Frameworks/modules | Repeatable deployments |
| Observability | Plumbing exists | Dashboards + alerts wired |
| Docs | Architecture + standards | Runbooks + operational usage |

## Practical checklist (copy/paste)

Day 0 checklist:

- [ ] Ownership defined (team, escalation path)
- [ ] Environments and naming/tagging conventions agreed
- [ ] Network baseline (subnets, routing, firewall rules) created
- [ ] IAM baseline (roles, least privilege, SSO) created
- [ ] Secrets strategy chosen (vault/KMS, rotation expectations)
- [ ] IaC state backend and CI credentials configured
- [ ] Minimal logging/metrics path exists

Day 1 checklist:

- [ ] First deployment done (and repeatable)
- [ ] Health checks + smoke tests documented
- [ ] Rollback procedure documented (and tried once)
- [ ] Basic alerts/dashboards exist (even if coarse)
- [ ] Access controls validated (operators vs users)
- [ ] Backups executed; restore test scheduled or completed

## Related terms you may see

- **Day 2**: ongoing operations (patching, scaling, incident response, optimization)
- **"Shift left"**: pushing ops/security concerns earlier (into Day 0/Day 1)
- **"Operational readiness review"**: a gate before go-live (often at end of Day 1)

