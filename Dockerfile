# We're using Alpine stable
FROM alpine:edge

#
# We have to uncomment Community repo for some packages
#
RUN sed -e 's;^#http\(.*\)/v3.9/community;http\1/v3.9/community;g' -i /etc/apk/repositories

# Installing Python
RUN apk add --no-cache --update \
    bash \
    build-base \
    bzip2-dev \
    curl \
    figlet \
    gcc \
    git \
    sudo \
    util-linux \
    chromium \
    chromium-chromedriver \
    jpeg-dev \
    libffi-dev \
    libpq \
    libwebp-dev \
    libxml2 \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    musl \
    neofetch \
    openssl-dev \
    php-pgsql \
    postgresql \
    postgresql-client \
    postgresql-dev \
    py-lxml \
    py-pillow \
    py-pip \
    py-psycopg2 \
    py-requests \
    py-sqlalchemy \
    py-tz \
    py3-aiohttp \
    python-dev \
    python3 \
    python3-dev \
    readline-dev \
    sqlite \
    sqlite-dev \
    sudo \
    zlib-dev

RUN pip3 install --upgrade pip setuptools

# Copy Python Requirements to /app
RUN git clone https://github.com/psycopg/psycopg2 psycopg2 \
&& cd psycopg2 \
&& python setup.py install

RUN  sed -e 's;^# \(%wheel.*NOPASSWD.*\);\1;g' -i /etc/sudoers
RUN adduser userbot --disabled-password --home /home/userbot
RUN adduser userbot wheel
USER userbot
RUN mkdir /home/userbot/userbot
RUN git clone -b sql-extended https://github.com/AvinashReddy3108/PaperplaneExtended /home/userbot/userbot
WORKDIR /home/userbot/userbot

#
# Copies session and config(if it exists)
#
COPY ./sample_config.env ./userbot.session* ./config.env* /home/userbot/userbot/

#
# Install requirements
#
RUN sudo pip3 install -U pip
RUN sudo pip3 install -r requirements.txt
RUN sudo chown -R userbot /home/userbot/userbot
RUN sudo chmod -R 777 /home/userbot/userbot
CMD ["python3","-m","userbot"]
