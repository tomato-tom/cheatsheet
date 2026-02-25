# nftables Cheat Sheet

nftables is the modern packet filtering framework for Linux, designed to replace iptables and
its variants with a single, unified tool.

## Core Concepts

* Ruleset: The complete nftables configuration.
* Table: Top-level container for chains, sets, etc. Common families: ip, ip6, inet.
* Chain: Container for rules, processing packets based on a hook (e.g., input, output,
 forward).
* Rule: Defines actions for packets matching specific conditions.
* Set: A collection of values (e.g., IP addresses) used for efficient matching.

## General Commands

```
# View ruleset:
nft list ruleset

# Add table:
# nft add table <family> <table_name>
nft add table ip filter

Delete table:
nft delete table ip filter

# Add chain:
# nft add chain <family> <table_name> <chain_name> '{
#    type <type> hook <hook> priority <priority>; policy <policy>;
# }'
nft add chain inet filter input '{ type filter hook input priority 0; policy drop; }'

#   * type: filter, nat, route
#   * hook: prerouting, input, forward, output, postrouting
#   * priority: Integer (e.g., 0, -150, 100)
#   * policy: accept or drop

# Delete chain:
nft delete chain inet filter input

# Add rule:
# nft add rule <family> <table_name> <chain_name> <match_expression> <statement>
nft add rule inet filter input tcp dport 22 accept

# Flush (clear) rules:
nft flush ruleset                                   # Clear all rules
nft flush table <family> <table_name>               # Clear all rules in a table
nft flush chain <family> <table_name> <chain_name>  # Clear all rules in a chain
```

> root privileges required

## nftables Families

* ip: IPv4
* ip6: IPv6
* inet: IPv4 and IPv6
* arp: ARP
* bridge: Bridging
* netdev: For base chains on network interfaces

## Chain Priorities

Chain priorities determine the execution order of chains within the same hook.<br>
**Lower values execute first.**

### Common Priorities
*   **-150 (Mangle)**: Modifies packets before filtering decisions.
*   **0 (Filter)**: Default. Makes accept/drop decisions.
*   **100 (SNAT)**: Performs source NAT after filtering.

Set priority during chain creation:
```bash
nft add chain inet filter input { type filter hook input priority 0\; }
```

## Common Rule Syntax & Examples

```
# Allow loopback:
nft add rule inet filter input iif lo accept

# Allow established/related connections:
nft add rule inet filter input ct state established,related accept

# Allow TCP port 22 (SSH):
nft add rule inet filter input tcp dport 22 accept

# Allow UDP port 53 (DNS):
nft add rule inet filter input udp dport 53 accept

# Masquerade (NAT):
nft add table ip nat
nft add chain ip nat postrouting '{ type nat hook postrouting; priority 100; }'
# Replace "eth0" with your outgoing interface
nft add rule ip nat postrouting oif "eth0" masquerade

# Block IP address:
nft add rule inet filter input ip saddr 192.168.1.100 drop

# Drop invalid packets:
nft add rule inet filter input ct state invalid drop
```

## To make rules persistent

```
# Export rules:
nft list ruleset | tee /etc/nftables.conf

# Enable and start service:
systemctl enable nftables
systemctl start nftables
# Service name and config path may vary by distribution

# Manually loading a ruleset file
nft flush ruleset
nft -f /etc/nftables.conf
```

## Set

```bash
# Define a Set
nft add set inet filter blocklist { type ipv4_addr\; }

# Use in Rule
# Reference sets with `@`.
nft add rule inet filter input ip saddr @blocklist drop

# Manage Elements
# Add element
nft add element inet filter blocklist { 192.168.1.5 }

# Delete element
nft delete element inet filter blocklist { 192.168.1.5 }

# List Sets
nft list sets
```

## Log

```bash
# Controls syslog severity (emerg, alert, crit, err, warn, notice, info, debug).
nft add rule inet filter forward log level warn prefix "FWD DROP "

# Sends logs to userspace (e.g., `nft-log`) via netlink.
nft add rule inet filter forward log group 1 prefix "FWD "

# Adds specific packet details.
# Log IP options
nft add rule inet filter forward log flags ip options prefix "FWD "

# Log all available data
nft add rule inet filter forward log flags all prefix "FWD "

# Combined Example
nft add rule inet filter forward log level error group 2 flags all prefix "ERR "
```

## Counter

*Output shows `packets X bytes Y`.*
```bash
# Anonymous Counter (Inline)
# Automatically created per rule.
nft add rule inet filter input counter accept

# Named Counter (Object)
# Define
nft add counter inet filter http_traffic    # Define once, reuse across rules.

# Use
nft add rule inet filter input tcp dport 80 counter name http_traffic accept

# List all counters
nft list counters

# List rules with counters
nft list chain inet filter input
```

### Reset Counters
```bash
# Reset named counter
nft reset counter inet filter http_traffic

# Reset all counters in table
nft reset table inet filter
```
