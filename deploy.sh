
#!/usr/bin/env bash
set -euo pipefail

# Update these two values before running
KEY="$HOME/Downloads/vpc-web-server.pem"
SERVER="ec2-user@98.86.157.113"

echo "Starting website deployment..."

# Check that the key and website file exist
test -f "$KEY" || { echo "SSH key not found: $KEY"; exit 1; }
test -f "index.html" || { echo "index.html not found"; exit 1; }

# Copy the website to a temporary location on EC2
scp -i "$KEY" index.html "$SERVER:/tmp/index.html"

# Install the file and ensure Apache is running
ssh -i "$KEY" "$SERVER" \
  'sudo install -m 644 /tmp/index.html /var/www/html/index.html &&
   sudo systemctl enable --now httpd &&
   sudo systemctl is-active --quiet httpd'

echo "Deployment successful!"
