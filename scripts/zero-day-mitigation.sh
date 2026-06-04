cat << EOF > etc/sysctl.d/ptrace-restrict.conf
# CVE-2026-46333
kernel.yama.ptrace_scope=2
EOF

cat << EOF > /etc/modprobe.d/disable-algif_aead.conf
# Disable algif_aead module due to CVE-2026-31431 (AKA copy.fail)
# This will likely be re-enabled in a subsequent update once an updated
# kernel has been deployed.
# Blacklisting the module isn't sufficient, we need to do as below:
install algif_aead /bin/false
EOF


cat << EOF /etc/modprobe.d/dirtyfrag.conf
install esp4 /bin/false
install esp6 /bin/false
install rxrpc /bin/false
EOF




