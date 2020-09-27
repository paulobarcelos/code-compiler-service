#!/bin/bash

# Download certbot
wget https://dl.eff.org/certbot-auto
mv certbot-auto /usr/local/bin/certbot-auto
chown root /usr/local/bin/certbot-auto
chmod 0755 /usr/local/bin/certbot-auto

# Generate certificates
certbot_command="/usr/local/bin/certbot-auto certonly --webroot --webroot-path /var/www/html --debug --non-interactive --email ${LETSENCRYPT_EMAIL} --agree-tos --keep-until-expiring --expand"
for domain in $(echo ${LETSENCRYPT_DOMAINS} | sed "s/,/ /g")
do
  certbot_command="$certbot_command -d $domain"
done
eval $certbot_command

# Link certificates
domain="$( cut -d ',' -f 1 <<< "${LETSENCRYPT_DOMAINS}" )";
if [ -d /etc/letsencrypt/live ]; then
  domain_folder_name="$(ls /etc/letsencrypt/live | sort -n | grep $domain | head -1)";
  if [ -d /etc/letsencrypt/live/${domain_folder_name} ]; then
	ln -sfn /etc/letsencrypt/live/${domain_folder_name} /etc/letsencrypt/live/ebcert
  fi
fi
