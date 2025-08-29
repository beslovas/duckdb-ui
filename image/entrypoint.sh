#!/bin/bash

# Generate htpasswd if auth is enabled
if [ "$AUTH_ENABLED" = "true" ]; then
    echo "Setting up authentication..."
    htpasswd -cb /etc/nginx/.htpasswd "$AUTH_USERNAME" "$AUTH_PASSWORD"
    
    # Process nginx config with auth enabled
    sed -i 's/# AUTH_BASIC_PLACEHOLDER/auth_basic "Restricted Access";\n        auth_basic_user_file \/etc\/nginx\/.htpasswd;/' /etc/nginx/nginx.conf
else
    # Process nginx config without auth (remove the commented line)
    sed -i '/# AUTH_BASIC_PLACEHOLDER/d' /etc/nginx/nginx.conf
fi

# Wait a moment for setup
sleep 2

# Start supervisord
echo "Starting supervisord..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
