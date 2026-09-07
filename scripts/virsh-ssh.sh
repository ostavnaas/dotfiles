#!/usr/bin/env bash
#
# ssh into a libvirt domain by name, resolving its IP via the guest agent.
#
# Usage: virsh-ssh.sh <domain> [ssh args...] [-- command...]
#   virsh-ssh.sh vm1
#   virsh-ssh.sh vm1 -L 123:localhost:123
#   virsh-ssh.sh root@vm1 -L 8080:localhost:80 -- systemctl status kubelet
#
# Env: VIRSH_SSH_IFACE (default enp1s0), VIRSH_SSH_URI (libvirt connection URI)

set -euo pipefail

iface=${VIRSH_SSH_IFACE:-enp1s0}
virsh_args=()
[[ -n ${VIRSH_SSH_URI:-} ]] && virsh_args=(--connect "$VIRSH_SSH_URI")

usage() {
    sed -n '3,/^$/p' "$0" | grep '^#' | sed 's/^# \?//;s/^#$//'
    exit "${1:-0}"
}

[[ $# -eq 0 ]] && usage 1
case $1 in
    -h | --help) usage 0 ;;
    -*) echo "error: first argument must be the domain name, got '$1'" >&2; usage 1 ;;
esac

target=$1
shift

# Allow user@domain so the user part is kept when we swap in the IP.
user=""
domain=$target
if [[ $target == *@* ]]; then
    user=${target%@*}@
    domain=${target#*@}
fi

ip=$(virsh "${virsh_args[@]}" domifaddr "$domain" --source agent --interface "$iface" |
    awk '$3 == "ipv4" { split($4, a, "/"); print a[1]; exit }')

if [[ -z $ip ]]; then
    echo "error: no ipv4 address for domain '$domain' on interface '$iface'" >&2
    exit 1
fi

exec ssh "${user}${ip}" "$@"
