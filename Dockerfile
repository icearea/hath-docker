ARG  JRE_VERSION
FROM amazoncorretto:${JRE_VERSION}-alpine3.18-jre
LABEL MAINTAINER="icearea"

ARG HATH_VERSION 
ARG HATH_CHECKSUM

WORKDIR /opt/hath

RUN apk add --no-cache --update tzdata \
    && wget -O /tmp/hath-$HATH_VERSION.zip \
    https://repo.e-hentai.org/hath/HentaiAtHome_$HATH_VERSION.zip \
	&& echo -n "$HATH_CHECKSUM  /tmp/hath-$HATH_VERSION.zip" | sha256sum -c \
    && unzip /tmp/hath-$HATH_VERSION.zip -d /opt/hath \
    && rm /opt/hath/autostartgui.bat HentaiAtHomeGUI.jar \
    && rm /tmp/hath-$HATH_VERSION.zip \
    && addgroup -g 911 hath \
    && adduser -DH -s /sbin/nologin -u 911 hath -G hath

ADD start.sh .

HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=3 \
    CMD pgrep java|grep "1"||exit

VOLUME ["/hath/cache", "/hath/data", "/hath/download", "/hath/log", "/hath/tmp"]

ENV HATH_OPT ""

CMD ["/opt/hath/start.sh"]
