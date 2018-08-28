#!/bin/bash

# SMTP認証 SASLのDBは起動時に生成する

if [ -f /app/etc/postfix/sasl_passwd ];
then

  postmap hash:/app/etc/postfix/sasl_passwd
  cp /app/etc/postfix/sasl_passwd.db /etc/postfix/sasl_passwd.db
  chmod 400 /etc/postfix/sasl_passwd.db

else

  echo "/app/etc/postfix/sasl_passwd not found in a container."
  echo "Please mount a directory which has sasl_passwd file to /app/etc when you docker-run."
  exit 1

fi

service rsyslog start
service postfix start

sleep 1

tail -f /var/log/mail.log
