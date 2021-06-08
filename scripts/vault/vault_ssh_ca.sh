#!/usr/bin/env bash
TARGET_IP="192.168.122.13"

kill $(pidof vault)
export VAULT_ADDR='http://0.0.0.0:8200'
vault server -dev -dev-listen-address=0.0.0.0:8200 -log-level="info" &
sleep 1

vault audit enable file file_path=/home/ubuntu/vault_audit.log
vault secrets enable -path=ssh-client-signer ssh

#vault write ssh-client-signer/config/ca generate_signing_key=true
ssh-keygen -q -t ecdsa -f ca-keys -N "" -y
vault write ssh-client-signer/config/ca private_key=@ca-keys public_key=@ca-keys.pub


vault read -field=public_key ssh-client-signer/config/ca | tee trusted-user-ca-keys.pem
scp trusted-user-ca-keys.pem root@${TARGET_IP}:/etc/ssh/
ssh root@${TARGET_IP} chmod 600 /etc/ssh/trusted-user-ca-keys.pem
ssh root@${TARGET_IP} systemctl restart sshd



vault write ssh-client-signer/roles/admin -<<"EOH"
{
  "allow_user_certificates": true,
  "allow_user_key_ids": "true",
  "allowed_users": "*",
  "allowed_extensions": "permit-pty",
  "default_extensions": [
    {
      "permit-pty": ""
    }
  ],
  "key_type": "ca",
  "default_user": "ubuntu",
  "valid_principals": "ubuntu",
  "ttl": "0m5s"
}
EOH


vault policy write admin -<<"EOL"
path "sys/mounts" {
  capabilities = ["list", "read"]
}

path "ssh-client-signer/sign/admin" {
  capabilities = ["create", "update"]
}

path "ssh-client-signer/config/ca" {
  capabilities = ["read"]
}

path "ssh-host-signer/config/ca" {
  capabilities = ["read"]
}
EOL

vault read ssh-client-signer/roles/admin
vault write ssh-client-signer/sign/admin public_key=@$HOME/.ssh/id_rsa.pub
vault write -field=signed_key ssh-client-signer/sign/admin public_key=@$HOME/.ssh/id_rsa.pub > signed-cert.pub


ssh-keygen -L -f signed-cert.pub

vault auth enable userpass
vault write auth/userpass/users/o.stavnaas password=test policies=admin

echo "ssh -i signed-cert.pub -i ~/.ssh/id_rsa ubuntu@${TARGET_IP}"
