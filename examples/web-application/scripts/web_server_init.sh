#!/bin/bash

# Update system
apt-get update
apt-get upgrade -y

# Install Nginx
apt-get install -y nginx curl

# Enable and start Nginx
systemctl enable nginx
systemctl start nginx

# Create custom index page
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>${server_name} - Load Balanced Web App</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f4f4f4; }
        .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .header { color: #333; border-bottom: 2px solid #007acc; padding-bottom: 10px; }
        .info { background: #e7f3ff; padding: 15px; border-radius: 5px; margin: 20px 0; }
        .footer { text-align: center; color: #666; margin-top: 30px; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="header">🚀 ${server_name} Web Application</h1>

        <div class="info">
            <h3>Server Information:</h3>
            <p><strong>Hostname:</strong> \$(hostname)</p>
            <p><strong>Server IP:</strong> \$(hostname -I | awk '{print \$1}')</p>
            <p><strong>Timestamp:</strong> \$(date)</p>
            <p><strong>Uptime:</strong> \$(uptime | awk '{print \$3,\$4}' | sed 's/,//')</p>
        </div>

        <div class="info">
            <h3>Load Balancer Test:</h3>
            <p>This page is served by one of multiple backend servers.</p>
            <p>Refresh the page to see requests distributed across servers.</p>
        </div>

        <div class="info">
            <h3>Health Check Endpoint:</h3>
            <p>✅ Status: <span style="color: green;">Healthy</span></p>
            <p>🔗 Endpoint: <a href="/health">/health</a></p>
        </div>

        <div class="footer">
            <p>Powered by Terraform + OCI | Environment: Production Ready</p>
        </div>
    </div>
</body>
</html>
EOF

# Create health check endpoint
cat > /var/www/html/health << EOF
{
  "status": "healthy",
  "server": "\$(hostname)",
  "timestamp": "\$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "uptime": "\$(cat /proc/uptime | awk '{print \$1}')"
}
EOF

# Configure Nginx for better performance
cat > /etc/nginx/sites-available/default << EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm;

    server_name _;

    # Health check endpoint
    location /health {
        add_header Content-Type application/json;
        return 200 '{"status":"healthy","server":"\$hostname","timestamp":"\$time_iso8601"}';
    }

    # Main location
    location / {
        try_files \$uri \$uri/ =404;
        add_header X-Server-Name \$hostname;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
}
EOF

# Test configuration and reload
nginx -t && systemctl reload nginx

# Log completion
echo "Web server setup completed at \$(date)" >> /var/log/web_server_init.log