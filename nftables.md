# nftables Cheat Sheet

nftables is the modern packet filtering framework for Linux, designed to replace iptables and
its variants with a single, unified tool.

Core Concepts

* Ruleset: The complete nftables configuration.
* Table: Top-level container for chains, sets, etc. Common families: ip, ip6, inet.
* Chain: Container for rules, processing packets based on a hook (e.g., input, output,
 forward).
* Rule: Defines actions for packets matching specific conditions.
* Set: A collection of values (e.g., IP addresses) used for efficient matching.

General Commands

```
# View ruleset:
sudo nft list ruleset

# Add table:
# nft add table <family> <table_name>
sudo nft add table ip filter

Delete table:
sudo nft delete table ip filter

# Add chain:
# nft add chain <family> <table_name> <chain_name> {
#    type <type> hook <hook> priori <priority>; policy <policy>;
#}
sudo nft add chain inet filter input { type filter hook input priority 0; policy drop; }

#   * type: filter, nat, route
#   * hook: prerouting, input, forward, output, postrouting
#   * priority: Integer (e.g., 0, -150, 100)
#   * policy: accept or drop

# Delete chain:
sudo nft delete chain inet filter input

# Add rule:
# sudo nft add rule <family> <table_name> <chain_name> <match_expression> <statement>
sudo nft add rule inet filter input tcp dport 22 accept

# Flush (clear) rules:
sudo nft flush ruleset                                   # Clear all rules
sudo nft flush table <family> <table_name>               # Clear all rules in a table
sudo nft flush chain <family> <table_name> <chain_name>  # Clear all rules in a chain
```

nftables Families

* ip: IPv4
* ip6: IPv6
* inet: IPv4 and IPv6
* arp: ARP
* bridge: Bridging
* netdev: For base chains on network interfaces

Common Rule Syntax & Examples
```
# Allow loopback:
sudo nft add rule inet filter input iif lo accept

# Allow established/related connections:
sudo nft add rule inet filter input ct state established,related accept

# Allow TCP port 22 (SSH):
sudo nft add rule inet filter input tcp dport 22 accept

# Allow UDP port 53 (DNS):
sudo nft add rule inet filter input udp dport 53 accept

# Masquerade (NAT):
sudo nft add table ip nat
sudo nft add chain ip nat postrouting { type nat hook postrouting priority 100; }
# Replace "eth0" with your outgoing interface
sudo nft add rule ip nat postrouting oif "eth0" masquerade

# Block IP address:
sudo nft add rule inet filter input ip saddr 192.168.1.100 drop

# Drop invalid packets:
sudo nft add rule inet filter input ct state invalid drop
```

To make rules persistent
```
# Export rules:
sudo nft list ruleset > /etc/nftables.conf

# Enable and start service:
sudo systemctl enable nftables
sudo systemctl start nftables
# Service name and config path may vary by distribution

# Manually loading a ruleset file
sudo nft flush ruleset
sudo nft -f /etc/nftables.conf
```

Chain Priorities

* -150: Mangle
* 0: Standard (Filter)
* 100: SNAT

