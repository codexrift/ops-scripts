# AWS EC2 (Cheat Sheet)

Elastic Compute Cloud: virtual machines (“instances”) in your VPC.

## Core concepts

- **AMI**: instance image (OS + packages baseline)
- **Instance type**: CPU/memory/network profile
- **EBS**: block storage volumes attached to instances
- **Security Group**: stateful L4 firewall attached to ENIs
- **Key pair / SSM**: how you get interactive access

## Networking basics

- Instances sit in a **subnet** (public/private) inside a **VPC**
- Public reachability requires: public subnet route + public IP + SG/NACL rules
- Use **private** instances + NAT for most workloads

## Common operational gotchas

- “Stop/Start” changes public IP (unless Elastic IP)
- Termination protection doesn’t stop all automation
- User data runs once by default; make it idempotent
- IMDSv2 should be enforced (metadata token)

## Cost notes

- On-Demand vs Reserved/Compute Savings Plans vs Spot
- EBS volumes and snapshots are billed separately from instances

