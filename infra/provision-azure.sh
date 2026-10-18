#!/usr/bin/env bash
# One-time Azure provisioning. Run in a shell where `az login` is done.
# Usage: APP=vanguard-chatbot-ayman ./infra/provision-azure.sh
set -euo pipefail

APP="${APP:?set APP to a globally unique web app name}"
RG="${RG:-rg-${APP}}"
PLAN="${PLAN:-plan-${APP}}"
LOCATION="${LOCATION:-westeurope}"
SKU="${SKU:-B1}"

az group create -n "$RG" -l "$LOCATION"
az appservice plan create -g "$RG" -n "$PLAN" --is-linux --sku "$SKU"
az webapp create -g "$RG" -p "$PLAN" -n "$APP" --runtime "NODE:20-lts"

az webapp config set -g "$RG" -n "$APP" --startup-file "node server.js"
az webapp config appsettings set -g "$RG" -n "$APP" --settings \
  WEBSITES_PORT=8080 PORT=8080 HOSTNAME=0.0.0.0 \
  SCM_DO_BUILD_DURING_DEPLOYMENT=false \
  OPENAI_API_KEY="${OPENAI_API_KEY:?export OPENAI_API_KEY}" \
  NEXT_PUBLIC_SUPABASE_URL="${NEXT_PUBLIC_SUPABASE_URL:?export NEXT_PUBLIC_SUPABASE_URL}" \
  NEXT_PUBLIC_SUPABASE_ANON_KEY="${NEXT_PUBLIC_SUPABASE_ANON_KEY:?export NEXT_PUBLIC_SUPABASE_ANON_KEY}"

echo
echo "App URL: https://${APP}.azurewebsites.net"
echo "Publish profile (paste into GitHub secret AZURE_WEBAPP_PUBLISH_PROFILE):"
az webapp deployment list-publishing-profiles -g "$RG" -n "$APP" --xml
