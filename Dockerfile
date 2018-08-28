# Use an official ubuntu
FROM ubuntu

# Set the working directory to /app
WORKDIR /app

# Define environment variable
ENV DEBIAN_FRONTEND noninteractive

# Prerequisite
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y locales tzdata && \
    apt-get install -y less vim && \
    apt-get install -y postfix mailutils rsyslog

# Locale
RUN sed -i -e 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:en
ENV LC_ALL ja_JP.UTF-8

# Timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Postfix
RUN cp /etc/postfix/main.cf /etc/postfix/main.cf.org
RUN cp /etc/postfix/master.cf /etc/postfix/master.cf.org

## Postfix Configuration
RUN postconf -e compatibility_level=2
RUN postconf -e relayhost=[smtp.gmail.com]:587
RUN postconf -e mynetworks="127.0.0.0/8 172.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128"

### SMTP Auth
RUN postconf -e smtp_sasl_auth_enable=yes
RUN postconf -e smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd
RUN postconf -e smtp_sasl_security_options=noanonymous
RUN postconf -e smtp_sasl_mechanism_filter=plain,login

### TLS
RUN postconf -e smtp_use_tls=yes
RUN postconf -e smtp_tls_security_level=encrypt
RUN postconf -e tls_random_source=dev:/dev/urandom

# Entry
ADD entrypoint.sh /app/entrypoint.sh
RUN chmod 500 /app/entrypoint.sh
CMD /app/entrypoint.sh
