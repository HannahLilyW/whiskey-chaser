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
chown -R nginx:nginx /usr/share/nginx/$hostName/html

echo "Writing to /etc/nginx/conf.d/$hostName.conf..."
cat > /etc/nginx/conf.d/$hostName.conf << EOF
server {
    listen 80;

    root /usr/share/nginx/$hostName/html;
    index index.html index.htm index.nginx-debian.html;

    server_name $hostName www.$hostName;

    location /whiskey_api/ {
        proxy_pass https://127.0.0.1:8443/;
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





