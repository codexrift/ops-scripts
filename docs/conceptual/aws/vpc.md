# AWS VPC (Cheat Sheet)

Virtual Private Cloud: your isolated network boundary in AWS.

## Core concepts

- **VPC CIDR**: IP range for your network
- **Subnet**: AZ-scoped slice of a VPC (public/private)
- **Route table**: where subnets send traffic (0.0.0.0/0 -> IGW/NAT)
- **IGW**: internet gateway for public subnets
- **NAT GW**: outbound internet for private subnets
- **Security Group**: stateful instance/service firewall
- **NACL**: stateless subnet firewall (rarely needed for most apps)

## Design basics

- Use at least 2 AZs for HA
- Keep most workloads in private subnets
- Centralize egress and inspection where possible

## Common operational gotchas

- Overlapping CIDRs break peering/VPN integrations
- “Public subnet” requires IGW route, not just a name
- NAT Gateway cost can dominate small environments

