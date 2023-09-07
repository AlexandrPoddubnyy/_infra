[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Environment='DATABASE_URL=${ip_address_db}'
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/reddit
ExecStart=/bin/bash -lc 'puma'
Restart=always

[Install]
WantedBy=multi-user.target
