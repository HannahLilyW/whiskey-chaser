if [[ ! -d "/root/whiskey-chaser" ]]
then
    echo "Directory /root/whiskey-chaser does not exist."
    echo "Please clone the project and run the install script before running this script."
    exit
fi

echo "Please enter the domain name for the server (example: example.com):"
read hostName

cd /root/whiskey-chaser/vue-project/
npm run build
rm -rf /usr/share/nginx/$hostName/html/*
cp -r dist/* /usr/share/nginx/$hostName/html/
cp -f /root/whiskey-chaser/stores-master.json /usr/share/nginx/$hostName/html/stores-master.json

cp -r /root/whiskey-chaser/whiskey /usr/lib
cd /usr/lib/whiskey/
source env/bin/activate
cd whiskey
python manage.py migrate

cp -f /root/whiskey-chaser/parse_email.sh /usr/bin/parse_email.sh
chown hannah:hannah /usr/bin/parse_email.sh
chmod +x /usr/bin/parse_email.sh

systemctl restart daphne-whiskey
systemctl restart nginx
