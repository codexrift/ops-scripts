# Incident Response Concepts Cheat Sheet

Incident response is the process of detecting, mitigating, and learning from outages/security events.

## Phases

- Detect: alerts/user reports
- Triage: impact, scope, severity
- Mitigate: stop the bleeding (rollback, disable feature, scale)
- Recover: restore service and data integrity
- Learn: postmortem, action items

## Practical rules

- Assign roles early: incident commander, comms lead, subject matter experts
- Prefer reversible mitigations (feature flags, rollback) over risky live edits
- Keep a timeline (what happened when)

## Postmortems

Good postmortems focus on:

- systems and processes, not blame
- concrete follow-ups with owners and due dates

