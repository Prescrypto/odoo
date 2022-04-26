#FROM debian:jessie
#FROM scratch
#ADD ubuntu-bionic-oci-amd64-root.tar.gz /
FROM ubuntu:18.04
MAINTAINER Prescrypto

# Install python build dependencies
# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            bash \
            openssh-server \
            iproute2 \
            ca-certificates \
            curl \
            node-less \
            python-gevent \
            python-pip \
            python-renderpm \
            python-watchdog \
            python-dev \
            python-setuptools \
            libpq-dev \
            build-essential \
            libxml2-dev \
            libxslt-dev \
            libevent-dev \
            libsasl2-dev \
            libldap2-dev \
            libjpeg-dev \
            libz-dev \
            wget \
            fontconfig \
            fontconfig-config \
            fonts-dejavu-core \
            libfontconfig1 \
            libfontenc1 \
            libjpeg-turbo8 \
            libxrender1 \
            x11-common \
            xfonts-75dpi \
            xfonts-base \
            xfonts-encodings \
            xfonts-utils \
            libxext6 \
            nano \
        && wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb \
        && dpkg -i wkhtmltox_0.12.6-1.bionic_amd64.deb \
        && apt --fix-broken install \
        && apt-get -y install -f --no-install-recommends \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && pip install psycogreen==1.0

# Add group
RUN groupadd odoo

# Add user
RUN useradd --no-create-home --shell /bin/bash --gid odoo odoo

# Set password
RUN echo 'odoo:odoo' | chpasswd

# Copy Odoo configuration file and python deps
COPY ./odoo.conf /etc/odoo/
COPY ./requirements.txt /
RUN chown odoo /etc/odoo/odoo.conf

# Copy entrypoint script
COPY ./entrypoint.sh /
RUN chown odoo entrypoint.sh
COPY wait-for-psql.py /usr/local/bin/wait-for-psql.py
RUN chown odoo /usr/local/bin/wait-for-psql.py

# Add python dependencies
RUN pip install -r requirements.txt # Mount /mnt/prescrypto-odoo for our fork and /mnt/custom-addons for Prescrypto addons
RUN mkdir -p /mnt/prescrypto-odoo \
        && chown -R odoo /mnt/prescrypto-odoo
RUN mkdir -p /mnt/custom-addons \
        && chown -R odoo /mnt/custom-addons

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN mkdir -p /mnt/extra-addons \
        && chown -R odoo /mnt/extra-addons

RUN mkdir /odoo \
        && chown -R odoo /odoo
#COPY . /odoo

VOLUME ["/var/lib/odoo", "/mnt/prescrypto-odoo", "/mnt/extra-addons", "/mnt/custom-addons", "/odoo"]

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

# Set default user when running the container
USER odoo

ADD ./.profile.d /app/.profile.d
#RUN rm /bin/sh && ln -s /bin/bash /bin/sh
#RUN rm /bin/sh \
#        && ln -s /bin/bash /bin/sh

#ENTRYPOINT ["/entrypoint.sh"]
#ENTRYPOINT ["/bin/sh"]
#CMD ["odoo"]

