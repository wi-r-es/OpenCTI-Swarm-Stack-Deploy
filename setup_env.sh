#!/usr/bin/env bash
set -euo pipefail

#########
# Usage #
#########
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <secret_key>"
  echo ""
  echo "  secret_key   The secret to base64-encode for OPENCTI_ENCRYPTION_KEY"
  exit 1
fi

SECRET_KEY="$1"
ENV_FILE=".env.sample"
cp .env.sample .env
############ 
# Validate #
############
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: .env file not found in the current directory."
  exit 1
fi

##################################
# Generate base64 encryption key #
##################################
BASE64_KEY=$(printf '%s' "$SECRET_KEY" | base64 -w 0)

############################
# Replace <base64_enc_key> #
############################
sed -i "s|<base64_enc_key>|${BASE64_KEY}|g" "$ENV_FILE"
echo "Replaced <base64_enc_key> with base64-encoded secret."

#############################################
# Replace every <UUIDv4> with a unique UUID #
#############################################
count=0
while grep -q '<UUIDv4>' "$ENV_FILE"; do
  uuid=$(cat /proc/sys/kernel/random/uuid)
  sed -i "0,/<UUIDv4>/{s/<UUIDv4>/${uuid}/}" "$ENV_FILE"
  ((count++))
done

echo "Generated and replaced ${count} UUIDv4 value(s)."
echo ""
echo "Done. Review your file:"
echo "  cat .env"
