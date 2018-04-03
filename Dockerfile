# Envisaged - Dockerized Gource Visualizations
#
# VERSION 0.47

FROM jamesbrink/gource

ARG VCS_REF
ARG BUILD_DATE

LABEL maintainer="James Brink, brink.james@gmail.com" \
      decription="Envisaged - Dockerized Gource Visualizations." \
      version="0.1.0" \
      org.label-schema.name="Envisaged" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/jamesbrink/Envisaged" \
      org.label-schema.schema-version="1.0.0-rc1"

# Install all needed runtime dependencies.
RUN set -xe; \
    apk --update add --no-cache --virtual .runtime-deps bash lighttpd git wget imagemagick python py-pip; \
    pip install --upgrade google-api-python-client progressbar2; \
    cd /var/tmp; \
    wget https://github.com/tokland/youtube-upload/archive/master.zip; \
    unzip master.zip; \
    cd youtube-upload-master; \
    python setup.py install; \
    cd /var/tmp; \
    rm -rf youtube-upload-master; \
    mkdir -p /visualization; \
    cd /visualization; \
    mkdir -p /visualization/video; \
    mkdir -p /visualization/html; \
    cd /visualization/html; \
    wget "https://github.com/twbs/bootstrap/releases/download/v4.0.0/bootstrap-4.0.0-dist.zip"; \
    unzip bootstrap-4.0.0-dist.zip; \
    rm bootstrap-4.0.0-dist.zip; \
    wget "https://github.com/jquery/jquery/archive/3.3.1.zip"; \
    unzip 3.3.1.zip; \
    rm 3.3.1.zip; \
    mv jquery-3.3.1/dist/* /visualization/html/js/; \
    rm -rf 3.3.1;


# Copy our assets
COPY ./docker-entrypoint.sh /usr/local/bin/entrypoint.sh
COPY . /visualization/

WORKDIR /visualization

# Set our environment variables.
ENV XVFB_WHD="${XVFB_WHD:-640x480:16}" \
    DISPLAY=":99" \
    H264_PRESET="ultrafast" \
    H264_CRF="23" \
    H264_LEVEL="5.1" \
    GIT_URL="https://github.com/moby/moby" \
    LOGO_URL="https://raw.githubusercontent.com/docker/docker.github.io/master/images/logo-docker-main.png" \
    GOURCE_SECONDS_PER_DAY="0.1" \
    GOURCE_TIME_SCALE="1.5" \
    GOURCE_USER_SCALE="1.5" \
    GOURCE_AUTO_SKIP_SECONDS="0.5" \
    GOURCE_TITLE="Software Development" \
    GOURCE_BACKGROUND_COLOR="000000" \
    GOURCE_TEXT_COLOR="FFFFFF" \
    GOURCE_CAMERA_MODE="overview" \
    GOURCE_HIDE_ITEMS="usernames,mouse,date,filenames" \
    GOURCE_FONT_SIZE="48" \
    GOURCE_DIR_DEPTH="3" \
    GOURCE_FILENAME_TIME="2" \
    GOURCE_MAX_USER_SPEED="500" \
    OVERLAY_FONT_COLOR="0f5ca8"

CMD ["/usr/local/bin/entrypoint.sh"]