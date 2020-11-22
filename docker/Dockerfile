FROM debian:buster-slim

LABEL maintainer="russellgroves@gmail.com"

ARG USER_UID=1000

ENV USER="steam"
ENV HOMEDIR="/home/${USER}"
ENV STEAMCMD_DIR="${HOMEDIR}/steamcmd"
ENV STEAM_APP_ID="232250"
ENV STEAM_APP="tf"
ENV STEAM_APP_DIR="${HOMEDIR}/${STEAM_APP}"
ENV METAMOD_VERSION="1.10"
ENV SOURCEMOD_VERSION="1.10"

RUN env

RUN useradd -u "${USER_UID}" -m "${USER}"

RUN set -x \
	&& dpkg --add-architecture i386 \
	&& apt update \
	&& apt install -y --no-install-recommends --no-install-suggests \
		gdb \
		git \
		wget \
		curl \
		jq \
		ca-certificates=20190110 \
		libsdl2-2.0-0:i386 \
		lib32stdc++6 \
		lib32z1 \
		libncurses5:i386 \
		libbz2-1.0:i386 \
		lib32gcc1 \
		libtinfo5:i386 \
		libcurl3-gnutls:i386 \
		lib32gcc1 \
		libstdc++6 \
		libstdc++6:i386 \
		libcurl4-gnutls-dev:i386 \
	&& apt clean autoclean \
	&& apt autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

RUN set -x \
    && su "${USER}" -c \
        'mkdir -p ${STEAMCMD_DIR} \
        && wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C ${STEAMCMD_DIR} \
        && ./${STEAMCMD_DIR}/steamcmd.sh +quit \
        && mkdir -p ${HOMEDIR}/.steam/sdk32 \
        && ln -s ${STEAMCMD_DIR}/linux32/steamclient.so ${HOMEDIR}/.steam/sdk32/steamclient.so \
        && ln -s ${STEAMCMD_DIR}/linux32/steamcmd ${STEAMCMD_DIR}/linux32/steam \
        && ln -s ${STEAMCMD_DIR}/steamcmd.sh ${STEAMCMD_DIR}/steam.sh' \
	&& ln -s "${STEAMCMD_DIR}/linux32/steamclient.so" "/usr/lib/i386-linux-gnu/steamclient.so" \
	&& ln -s "${STEAMCMD_DIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
    && chown -R "${USER}:${USER}" "${HOMEDIR}"

USER ${USER}
WORKDIR ${HOMEDIR}

COPY --chown=${USER}:${USER} ./entrypoint.sh ${HOMEDIR}/

ENV SRCDS_FPSMAX=300 \
	SRCDS_TICKRATE=66 \
	SRCDS_PORT=27015 \
	SRCDS_TV_PORT=27020 \
	SRCDS_CLIENT_PORT=27015 \
    SRCDS_NET_PUBLIC_ADDRESS="0" \
    SRCDS_IP="0" \
	SRCDS_MAXPLAYERS=16 \
	SRCDS_TOKEN=0 \
	SRCDS_RCONPW="changeme" \
	SRCDS_PW="changeme" \
	SRCDS_STARTMAP="cp_badlands" \
	SRCDS_REGION=7 \
    SRCDS_HOSTNAME="rsa.tf | New ${STEAM_APP} Server" \
    SRCDS_WORKSHOP_START_MAP=0 \
    SRCDS_HOST_WORKSHOP_COLLECTION=0 \
    SRCDS_WORKSHOP_AUTHKEY=""

VOLUME ${STEAMCMD_DIR} ${STEAM_APP_DIR}

CMD ["bash", "entrypoint.sh"]

EXPOSE 27015/tcp \
	27015/udp \
	27020/udp
