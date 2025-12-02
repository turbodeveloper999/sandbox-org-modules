#!/usr/bin/env sh
set -euo pipefail

# Read JSON input from Terraform
eval "$(jq -r '@sh "URL=\(.url)"')"

# Download the script
wget -qO /tmp/install.sh "$URL"

# Make it executable (optional)
chmod +x /tmp/install.sh

# Execute with sh
OUTPUT=$(sh /tmp/install.sh 2>&1)

# Return JSON back to Terraform
jq -n --arg output "$OUTPUT" '{"output":$output}'

