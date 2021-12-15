FROM python:3-alpine

# Based on the work of Jonathan Boeckel <jonathanboeckel1996@gmail.com>
# https://gitlab.com/Joniator/docker-maloja
# https://github.com/Joniator

WORKDIR /usr/src/app

# Copy project into dir
COPY . .

RUN apk add --no-cache --virtual .build-deps \
    gcc \
    libxml2-dev \
    libxslt-dev \
    libc-dev \
    # install pip3
    py3-pip \
    linux-headers && \
    pip3 install psutil && \
    # use pip to install maloja project requirements
    pip3 install --no-cache-dir -r requirements.txt && \
    # use pip to install maloja as local project
    pip3 install /usr/src/app && \
    apk del .build-deps

RUN apk add --no-cache tzdata

# expected behavior for a default setup is for maloja to "just work"
ENV MALOJA_SKIP_SETUP=yes

EXPOSE 42010
# use exec form for better signal handling https://docs.docker.com/engine/reference/builder/#entrypoint
ENTRYPOINT ["maloja", "run"]