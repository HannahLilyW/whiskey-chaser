import mailbox
import quopri
import re
import requests
import json
import logging
import logging.handlers
import sys
from bs4 import BeautifulSoup

log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)
syslog_handler = logging.handlers.SysLogHandler('/dev/log')
syslog_handler.setLevel(logging.DEBUG)
log.addHandler(syslog_handler)

message = ''
for line in sys.stdin:
    message += line

log.critical(message)
exit()

mbox = mailbox.mbox("/var/spool/mail/hannah")
last_message = mbox[mbox.keys()[-1]]
last_message = quopri.decodestring(last_message.as_string()).decode('utf-8')
urls = re.findall(r'https:\/\/www\.abc\.virginia\.gov\/limited\/allocated_stores_[a-zA-Z0-9_]+\.html', last_message)
if not len(urls):
    # This must not be a drop email.
    exit

stores_json = {
    'data': []
}

url = urls[-1]
response = requests.get(url)

with open('/usr/share/nginx/whiskeychaser.org/html/stores-master.json', 'r') as f:
    stores_master = json.load(f)

soup = BeautifulSoup(response.text, 'html.parser')

p_elements = soup.find_all("p")
for p in p_elements:
    if 'Drop date: ' in p.get_text():
        stores_json['dropDate'] = p.get_text().strip()[10:]
        break

stores = soup.find_all("table")[-1].find_all('td')
for store in stores:
    store_id = store.find('span').get_text()
    store_id = int(re.findall(r'[0-9]+', store_id)[-1])
    for master_store_data in stores_master['data']:
        if master_store_data['store_id'] == store_id:
            stores_json['data'].append(master_store_data)
            break

with open('/usr/share/nginx/whiskeychaser.org/html/stores.json', 'w') as f:
    json.dump(stores_json, f)

with open('/tmp/test.log', 'a') as f:
    f.write('Ran the script successfully!')
