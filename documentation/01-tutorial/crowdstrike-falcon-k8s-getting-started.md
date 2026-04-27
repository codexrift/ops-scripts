---
title: "CrowdStrike Falcon on Kubernetes tutorial: understand the pieces before deploying"
type: "tutorial"
owner: "u115478"
last_updated: "2026-04-27"
---

# CrowdStrike Falcon on Kubernetes tutorial: understand the pieces before deploying

## Summary

- **Goal:** Build a safe mental model of Falcon on Kubernetes (admission + sensor) and learn what to verify in a sandbox before any production rollout.
- **What you'll learn:**
  - What admission controllers do (and why they can be risky)
  - What a node sensor DaemonSet does (and why it can impact nodes)
  - A safe staged rollout approach (test namespace + canary node pool)
  - The verification evidence you should collect
- **Estimated time:** 45-90 minutes
- **Difficulty:** intermediate
- **Who this is for:** you

## Prerequisites

### Access and permissions

- A non-production Kubernetes cluster you can modify (sandbox)
- Ability to read cluster-wide objects (webhooks, nodes, namespaces)

### Required tools

- `kubectl`

### Inputs you must have

- Cluster context: `<context>`
- Candidate namespace for Falcon components: `<falcon_ns>`
- A test namespace: `<falcon_test_ns>`
- A canary node pool label/selector: `<canary_selector>`

## Safety and scope

### What this tutorial changes

- Read-only until you reach the end; then you may optionally create a test namespace and a simple test Pod (safe).

### Risks

- None to low for read-only steps. Do not install admission webhooks or privileged DaemonSets as part of this tutorial.

### Rollback (high-level)

- Delete the test namespace and test Pod you created.

## Before you start (sanity checks)

```bash
kubectl config current-context
kubectl config view --minify
kubectl get nodes -o wide
kubectl get ns
```

Checkpoint:

- You can see nodes and namespaces.

## Tutorial steps

### Step 1 - Identify what you are deploying (admission vs sensor)

**What you're doing:** Separate the two core components conceptually.

**Why it matters:** They have different risk profiles and rollback plans.

- Admission controller:
  - runs on API request path (create/update)
  - can validate or mutate objects
  - can block workloads if misconfigured
- Sensor DaemonSet:
  - runs on nodes
  - provides runtime visibility/detection
  - can affect node stability if resource/privileges are wrong

Checkpoint:

- You can explain which component affects which part of the system.

---

### Step 2 - Baseline the cluster risk surface

**What you're doing:** Record current admission webhooks and node pool diversity.

**Why it matters:** You need to predict interactions and where canaries should run.

```bash
kubectl get validatingwebhookconfigurations
kubectl get mutatingwebhookconfigurations
kubectl get nodes --show-labels | head
```

Checkpoint:

- You can identify:
  - existing broad-scoped webhooks
  - tainted/critical node pools
  - OS/arch mix

---

### Step 3 - Define a staged rollout plan (write it down)

**What you're doing:** Decide scope and failure behavior before touching production.

**Why it matters:** Most failures are from expanding too fast with fail-closed settings.

Plan template (fill in):

- test namespace: `<falcon_test_ns>`
- critical namespaces excluded: `kube-system`, `<platform_ns>`, `<monitoring_ns>`
- admission initial mode: `<observe>`
- admission initial failurePolicy: `<Ignore>`
- sensor canary selector: `<canary_selector>`
- expansion order: `<canary -> more pools -> all supported>`
- rollback triggers: `<list>`

Checkpoint:

- You have a written plan and rollback triggers.

---

### Step 4 - Practice verification mechanics (safe)

**What you're doing:** Practice creating a test workload and collecting evidence.

**Why it matters:** Your future rollout depends on good evidence.

```bash
kubectl get ns <falcon_test_ns> || kubectl create ns <falcon_test_ns>
kubectl -n <falcon_test_ns> run hello --image=nginx --restart=Never
kubectl -n <falcon_test_ns> get pod hello -o wide
kubectl -n <falcon_test_ns> describe pod hello
```

Checkpoint:

- You can capture pod events, status, and logs.

Cleanup:

```bash
kubectl -n <falcon_test_ns> delete pod hello
kubectl delete ns <falcon_test_ns>
```

## Cleanup (if this tutorial uses a lab)

- Delete test namespace and resources (above).

## Troubleshooting

### Symptom: You cannot create resources in the test namespace

```bash
kubectl auth can-i create pods -n <falcon_test_ns>
```

## Best Practices

- Treat admission rollout as higher risk than sensor rollout; stage accordingly.
- Always have break-glass steps for admission (ability to remove/disable webhook configs).
- Canary sensors by node pool; do not assume all nodes are identical.
- Keep secrets out of Git unless using an approved encryption workflow.

## FAQ

**Q:** Can I deploy admission and sensors at the same time?  
**A:** Prefer separate staged rollouts so you can attribute failures to one change.

## Glossary

- **Admission:** API-time validation/mutation.
- **Runtime sensor:** node agent observing runtime behavior.

## Next steps

- How-to (admission): `ops-scripts/documentation/02-how-to-guide/crowdstrike-falcon-admission-controller-implement.md`
- How-to (sensor): `ops-scripts/documentation/02-how-to-guide/crowdstrike-falcon-sensor-daemonset-deploy.md`
- Reference: `ops-scripts/documentation/03-reference/crowdstrike-falcon-k8s-reference.md`
- Explanation: `ops-scripts/documentation/04-explanation/crowdstrike-falcon-k8s-how-it-works.md`

