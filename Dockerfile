FROM debian:jessie
MAINTAINER Prescrypto

# Install python build dependencies
# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            node-less \
            python-gevent \
            python-pip \
            python-renderpm \
            python-support \
            python-watchdog \
            python-dev \
            libpq-dev \
            build-essential \
            libxml2-dev \
            libxslt-dev \
            libevent-dev \
            libsasl2-dev \
            libldap2-dev \
            libjpeg-dev \
            libz-dev \
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb \
        && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb \
        && pip install psycogreen==1.0

# Add group
RUN groupadd odoo

# Add user
RUN useradd --no-create-home --shell /bin/bash --gid odoo odoo

# Set password
RUN echo 'odoo:odoo' | chpasswd

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./odoo.conf /etc/odoo/
COPY ./requirements.txt /
RUN chown odoo /etc/odoo/odoo.conf

# Add python dependencies
RUN pip install -r requirements.txt

# Mount /mnt/prescrypto-odoo for our fork and /mnt/custom-addons for Prescrypto addons
RUN mkdir -p /mnt/prescrypto-odoo \
        && chown -R odoo /mnt/prescrypto-odoo
RUN mkdir -p /mnt/custom-addons \
        && chown -R odoo /mnt/custom-addons

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN mkdir -p /mnt/extra-addons \
        && chown -R odoo /mnt/extra-addons

VOLUME ["/var/lib/odoo", "/mnt/prescrypto-odoo", "/mnt/extra-addons", "/mnt/custom-addons"]

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
