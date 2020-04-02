#!/usr/bin/env bash

export VAULT_ADDR='http://127.0.0.1:8200'
./vault status >/dev/null 2>&1 || exit 1

APPROLE="approle"
MYSQL_USER="vault"
MYSQL_PASSWORD="supersecret"
MYSQL_HOST="10.0.0.120"
MYSQL_DB="database"


./vault auth enable approle > /dev/null 2>&1

./vault write auth/approle/role/${APPROLE} \
	secret_id_ttl=10m \
	token_ttl=20m \
	token_max_ttl=30m > /dev/null 2>&1

cat << EOL > mysql-${APPROLE}.hcl
path "database/creds/${APPROLE}" {
  capabilities = [ "read" ]
}
path "auth/approle/role/${APPROLE}/role-id" {
  capabilities = [ "read" ]
}
EOL

./vault policy write mysql-${APPROLE} mysql-${APPROLE}.hcl > /dev/null 2>&1
rm mysql-${APPROLE}.hcl
./vault write auth/approle/role/${APPROLE} token_policies="mysql-${APPROLE}" > /dev/null 2>&1

SECRET_ID=$(./vault write -f auth/approle/role/${APPROLE}/secret-id  --format=json | jq -r '.data.secret_id') > /dev/null 2>&1
ROLE_ID=$(./vault read auth/approle/role/${APPROLE}/role-id --format=json | jq -r '.data.role_id') > /dev/null 2>&1
V_TOKEN=$(./vault write auth/approle/login role_id="${ROLE_ID}" secret_id="${SECRET_ID}" --format=json | jq -r '.auth.client_token') > /dev/null 2>&1
echo "export VAULT_ADDR='http://127.0.0.1:8200"
echo "VAULT_TOKEN=${V_TOKEN} ./vault read database/creds/${APPROLE}"



./vault secrets enable database > /dev/null 2>&1

./vault write database/config/${APPROLE}-mysql-user \
	plugin_name=mysql-database-plugin \
        connection_url="{{username}}:{{password}}@tcp(${MYSQL_HOST}:3306)/" \
	allowed_roles="${APPROLE}" \
	username="${MYSQL_USER}" \
	password="${MYSQL_PASSWORD}" > /dev/null 2>&1

./vault write database/roles/${APPROLE} \
	db_name=${APPROLE}-mysql-user \
	creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON ${MYSQL_DB}.* TO '{{name}}'@'%';" \
	default_ttl="10m" \
	max_ttl="24h" > /dev/null 2>&1


