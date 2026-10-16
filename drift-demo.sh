#!/usr/bin/env bash
# Local demo of drift detection. Needs terraform. Creates, then edits the file behind
# Terraform's back, then shows that `plan -detailed-exitcode` reports it.
set -u
terraform init -input=false >/dev/null
terraform apply -auto-approve -input=false >/dev/null
terraform plan -detailed-exitcode -input=false >/dev/null
echo "after apply, no drift: exit code $? (expect 0)"

echo '{"feature_flags":{"new_checkout":true}}' > out/app.json    # someone edits it by hand
terraform plan -detailed-exitcode -input=false >/dev/null
echo "after manual edit: exit code $? (expect 2 = changes found)"
