#FROM debian:jessie
# FROM multiarch/debian-debootstrap:arm64-jessie
# MAINTAINER Prescrypto
FROM ubuntu:18.04

# Set environment variables to non-interactive
ENV DEBIAN_FRONTEND=noninteractive
# Update repository URLs to point to archive.debian.org
# RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list \
#  && sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list \
#  && apt-get update

# Add the new GPG key
# RUN apt-get update -o Acquire::Check-Valid-Until=false && \
#     apt-get install -y --no-install-recommends \
#     gnupg dirmngr && \
#     apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7638D0442B90D010 8B48AD6246925553

# RUN rm /etc/apt/sources.list

# RUN echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list.d/jessie.list

# RUN echo "deb http://archive.debian.org/debian jessie main" >> /etc/apt/sources.list.d/jessie.list
    
# Add the Debian Jessie archive keys
# RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7638D0442B90D010 8B48AD6246925553

# RUN rm /etc/apt/sources.list

# RUN echo "deb [trusted=yes] http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list.d/jessie.list

# RUN echo "deb [trusted=yes] http://archive.debian.org/debian jessie main" >> /etc/apt/sources.list.d/jessie.list

# Install python build dependencies
# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
                gnupg \
                dirmngr \
                curl \
                vim \
                git \
                sudo \
            ca-certificates \
            node-less \
            python-gevent \
            python-pip \
            python-renderpm \
            python-setuptools \
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
            mc \
            unzip \
            python3-pip \
            python3-setuptools \
            python3-dev \
            libpq-dev \
            wget \
            postgresql-client \
        && curl -o wkhtmltox.deb -SL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_arm64.deb \
        # && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb 
        # \
        # && pip install psycogreen==1.0



# Add group
RUN groupadd odoo

# Add user
RUN useradd --no-create-home --shell /bin/bash --gid odoo odoo

# Set password
RUN echo 'odoo:odoo' | chpasswd && adduser odoo sudo

# Allow sudo without password for the new user
RUN echo 'odoo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy Odoo configuration file and python deps
COPY ./odoo.conf /etc/odoo/
COPY ./requirements.txt /

# Copy upgrade requirmemnts
# COPY ./requirements_upgrade.txt /


COPY ./test_psycopg2.py /

RUN chown odoo /etc/odoo/odoo.conf

# Add python dependencies
RUN pip install -r requirements.txt # Mount /mnt/prescrypto-odoo for our fork and /mnt/custom-addons for Prescrypto addons

# install Requirments upgrade
# RUN pip install -r requirements_upgrade.txt

RUN mkdir -p /mnt/prescrypto-odoo \
        && chown -R odoo /mnt/prescrypto-odoo
RUN mkdir -p /mnt/custom-addons \
        && chown -R odoo /mnt/custom-addons

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN mkdir -p /mnt/extra-addons \
        && chown -R odoo /mnt/extra-addons

RUN mkdir -p /mnt/OpenUpgrade \
        && chown -R odoo /mnt/OpenUpgrade      

# 
# COPY ./OpenUpgrade /mnt/OpenUpgrade

# RUN unzip /mnt/OpenUpgrade/OpenUpgrade-11.0.zip
# RUN cd /mnt/OpenUpgrade/OpenUpgrade-11.0/

# install Requirments upgrade
# RUN pip install -r requirements.txt
# RUN python ./setup.py install


VOLUME ["/var/lib/odoo", "/mnt/prescrypto-odoo", "/mnt/extra-addons", "/mnt/custom-addons", "/mnt/OpenUpgrade"]

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

# Set default user when running the container
USER odoo

ENTRYPOINT ["/bin/bash"]
