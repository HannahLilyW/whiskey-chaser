if [[ ! -d "/root/whiskey-chaser" ]]
then
    echo "Directory /root/whiskey-chaser does not exist."
    echo "Please run cd /root && git clone https://github.com/HannahLilyW/whiskey-chaser.git before running this script."
    exit
fi

# Check if nodejs is already installed and on correct version
nodeVersion=$(node -v)
if [[ $nodeVersion = v16* ]] 
then
    echo "Node is already installed and on correct version (16)"
else
    echo "Node v16 doesn't seem to be installed. Attempting to install..."
    dnf -y module reset nodejs
    dnf -y module install nodejs:16
fi

dnf -y install python39
dnf -y install epel-release
dnf -y install certbot
dnf -y install nginx
dnf -y install python3-certbot-nginx

echo "Please enter the domain name for the server (example: example.com):"
read hostName

cd /root/whiskey-chaser/vue-project/
npm install
npm run build
mkdir -p /usr/share/nginx/$hostName/html
cp -r dist/* /usr/share/nginx/$hostName/html/
cp -f /root/whiskey-chaser/stores-master.json /usr/share/nginx/$hostName/html/stores-master.json
chown -R nginx:nginx /usr/share/nginx/$hostName/html

echo "Writing to /etc/nginx/conf.d/$hostName.conf..."
cat > /etc/nginx/conf.d/$hostName.conf << EOF
server {
    listen 80;

    root /usr/share/nginx/$hostName/html;
    index index.html index.htm index.nginx-debian.html;

    server_name $hostName www.$hostName;

    location /whiskey_api/ {
        proxy_pass https://127.0.0.1:8444/;
    }

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

cp -r /root/whiskey-chaser/whiskey /usr/lib

echo "Installing requirements for django server in python virtual environment..."
cd /usr/lib/whiskey/
python3.9 -m venv env
source env/bin/activate
pip install -r requirements.txt

# generate a secret key for the django server
djangoSecretKey=$(python -c 'import string; import secrets; alphabet = string.ascii_letters + string.digits; print("".join(secrets.choice(alphabet) for i in range(64)))')

certbot --nginx -d $hostName

useradd daphne
usermod --shell /sbin/nologin daphne

mkdir /usr/lib/whiskey/whiskey/certs
cp /etc/letsencrypt/live/$hostName/privkey.pem /usr/lib/whiskey/whiskey/certs/privkey.pem
cp /etc/letsencrypt/live/$hostName/cert.pem /usr/lib/whiskey/whiskey/certs/cert.pem
chown daphne /usr/lib/whiskey/whiskey/certs/privkey.pem
chown daphne /usr/lib/whiskey/whiskey/certs/cert.pem

echo "Writing to /usr/lib/whiskey/whiskey/config.ini..."
cat > /usr/lib/whiskey/whiskey/config.ini << EOF
[django]
secret_key = $djangoSecretKey
is_development = false
hostname = $hostName
EOF

echo "Writing to /etc/systemd/system/daphne-whiskey.service..."
cat > /etc/systemd/system/daphne-whiskey.service << EOF
[Unit]
Description=Daphne service for whiskey chaser

[Service]
User=daphne
WorkingDirectory=/usr/lib/whiskey
ExecStart=/bin/bash -c 'cd /usr/lib/whiskey && source env/bin/activate && cd whiskey && daphne -e ssl:8444:privateKey=/usr/lib/whiskey/whiskey/certs/privkey.pem:certKey=/usr/lib/whiskey/whiskey/certs/cert.pem whiskey.asgi:application'

[Install]
WantedBy=multi-user.target
EOF

echo "Running migrations..."
cd whiskey
python manage.py migrate

# change the database and config file owner to daphne
chmod 600 /usr/lib/whiskey/whiskey/db.sqlite3
chown daphne:daphne /usr/lib/whiskey/whiskey/db.sqlite3
chown daphne:daphne /usr/lib/whiskey/whiskey
chmod 600 /usr/lib/whiskey/whiskey/config.ini
chown daphne:daphne /usr/lib/whiskey/whiskey/config.ini

systemctl daemon-reload
systemctl enable daphne-whiskey
systemctl restart daphne-whiskey
systemctl enable nginx
systemctl restart nginx
