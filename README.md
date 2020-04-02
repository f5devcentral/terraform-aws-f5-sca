# F5 Terraform AWS Secure Cloud Architecture (SCA)

## Contents

- [CHANGELOG](CHANGELOG.md)
- [What is SCA](#what-is-sca)
- [Prerequisites](#prerequisites)
- [Requirements Mapping](#requirements-mapping)
- [Deploying Custom Configuration to the BIG-IP VE](#deploying-custom-configuration-to-the-big-ip-ve)
- [Post-Deployment Configuration](#post-deployment-configuration)
- [Creating Virtual Servers on the BIG-IP VE](#creating-virtual-servers-on-the-big-ip-ve)
- [Filing issues](#filing-issues)
- [Contributing](#contributing)

## What is SCA

SCA is a location & cloud agnostic flexible and repeatable conceptual deployment pattern that can adapt for all customers challenges in the cloud.

## Prerequisites

- [Amazon Subscription](https://console.aws.amazon.com)
- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

## Requirements Mapping

| Category | Title | Description | Mapping Notes | Controls |
|----------|-------|-------------|---------------|----------|
| Security | Traffic Segregation | The Security Stack shall maintain virtual separation of all management, user, and data traffic.
Components shall provide logically separate network interfaces for access from the management network infrastructure that is logically separate from production.
The Security Stack shall provide secure connectivity to Application management systems that is logically separate from application traffic.
Components shall provide for management traffic segmentation from user and data plane traffic.
  | LTM / AFM / CORE | SCCA 2.1.2.1, 2.3.2.6, 2.3.2.9, 2.2.3.3 |
| Security | Traffic Encryption | The Security Stack shall allow the use of encryption for segmentation of management traffic. | LTM / Core | SCCA 2.1.2.2 |
| Security | Reverse Proxy | The Security Stack shall provide a reverse proxy capability to handle access requests from client systems. | LTM / Core | SCCA 2.1.2.3 |
| Security | Traffic Filtering | The Security Stack shall provide a capability to inspect and filter application layer conversations based on a predefined set of rules (including HTTP) to identify and block malicious content. | AFM / ASM / PS | SCCA 2.1.2.4 |
| Security | Block Unauthorized | The Security Stack shall provide a capability that can distinguish and block unauthorized application layer traffic. | ASM / AFM| SCCA 2.1.2.5 |
| Security | Traffic Monitor | The Security Stack shall provide a capability that monitors network and system activities to detect and report malicious activities for traffic entering and exiting Application virtual private networks/enclaves. | ASM / AFM / PS| SCCA 2.1.2.6 |
| Security | Block Malicious | The Security Stack shall provide a capability that monitors network and system activities to stop or block detected malicious activity. | ASM / AFM / PS | SCCA 2.1.2.7|
| Security | East / West Inspection | The Security Stack shall inspect and filter traffic traversing between application virtual private networks/enclaves.| AFM | SCCA 2.1.2.8 |
| Security | Break and Inspect Traffic | The Security Stack shall perform break and inspection of SSL/TLS communication traffic supporting single and dual authentication for traffic destined to systems hosted within the Cloud Service Provider.| LTM | SCCA 2.1.2.9 |
| Security | Management Access & Control | The Security Stack shall provide an interface to conduct ports, protocols, and service management activities in order to provide control for operators. | Core / AFM / ASM| 2.1.2.10|
| Security | Logging | The Security Stack shall provide a monitoring capability that captures log files and event data for cybersecurity analysis. | Core | SCCA 2.1.2.11|
| Security | SIEM Integration | The Security Stack shall provide or feed security information and event data to an allocated archiving system for common collection, storage, and access to event logs by privileged users. | Core | SCCA 2.1.2.12|
| Security | FIPS 140-2 | The Security Stack shall provide a FIPS-140-2 compliant encryption key management system for storage of generated and assigned server private encryption key credentials for access and use by the Web Application Firewall (WAF) in the execution of SSL/TLS break and inspection of encrypted communication sessions. | Core | SCCA 2.1.2.13|
| Security | Prevent Session Hijacking | The Security Stack shall provide the capability to detect and identify application session hijacking. | APM / ASM | SCCA 2.1.2.14|
| Security | Provide DMZ | The Security Stack shall provide a DMZ Extension to support Internet Facing Applications. | Core | SCCA 2.1.2.15 |
| Security | Full Packet Capture | The Security Stack shall provide full packet capture or cloud service equivalent capability for recording and interpreting traversing communications. | Core | SCCA 2.1.2.16 |
| Security | Provide Flow Metrics | The Security Stack shall provide network packet flow metrics and statistics for all traversing communications. | Core / AVR | SCCA 2.1.2.17|
| Security | North-South Traffic Inspection | The Security Stack shall provide for the inspection of traffic entering and exiting each Application virtual private network. | AFM | SCCA 2.1.2.18 |
| Security | Management Access | The Security Stack hall allow Priviledged User access to Application management interfaces. | APM / PUA | SCCA 2.2.3.2|
| Scale | Rapid Scale| The Security Stack shall be designed to rapidly scale virtual elements up and down in capacity to achieve negotiated (between components provider and Mission Owner) SLA objectives while minimizing metered billing costs. | Core / AWS | SCCA 2.6.2.1 |
| Scale | Scaling Increments | The Security Stack shall support scalability in increments of 1 Gigabit/second throughput at all points within the design without costly modification. | Core / AWS| SCCA 2.6.2.2 |
| Performance | Throughput | The Security Stack shall start with 1 Gigabit/second throughput and have ability to scale up to 10G.| Core | SCCA 2.4.1.2 |
| Performance | Redundancy | The Security Stack shall meet backbone availability of 99.5%. | Core / AWS | SCCA 2.4.1.5 |
| Performance | Latency | The Security Stack processing latency shall be no greater than 35 milliseconds. | Core / AWS | SCCA 2.4.2.1 |
| Performance | QoS| The Security Stack shall support IP packet forwarding in accordance with tagged QOS prioritization| LTM | SCCA 2.4.2.5 |

## Deploying Custom Configuration to the BIG-IP VE

## Post-Deployment Configuration

### Creating Virtual Servers on the BIG-IP VE

## Filing issues

If you find an issue, we would love to hear about it. You have a choice when it comes to filing issues:

- Use the [Issues link](https://github.com/f5devcentral/terraform-aws-f5-sca/issues) on the GitHub menu bar in this repository for items such as enhancement or feature requests and non-urgent bug fixes. Tell us as much as you can about what you found and how you found it.

## Contributing

Individuals or business entities who contribute to this project must have completed and submitted the F5 Contributor License Agreement.
