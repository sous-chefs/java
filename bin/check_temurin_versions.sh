#!/bin/bash

# # Fetch latest Temurin versions from endoflife.date API
# curl --request GET \
#   --url https://endoflife.date/api/eclipse-temurin.json \
#   --header 'Accept: application/json' | jq '.'

# Filter for LTS versions only
echo "LTS Versions:"
curl -s --request GET \
  --url https://endoflife.date/api/eclipse-temurin.json \
  --header 'Accept: application/json' | \
  jq -r '.[] | select(.lts == true) | "Java \(.cycle) (LTS) - Latest: \(.latest), EOL: \(.eol)"'
