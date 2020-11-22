#!/bin/bash

# Failing commands cause the script to exit immediately
set -e
# Errors on undefined variables
set -u
# Don't hide errors in pipes
set -o pipefail

debug_mode=0
_debug() {
    # _debug "${FUNCNAME[0]}" ""
    if (( "${debug_mode}" == 0 )); then
        printf "[DEBUG]\t $(date +%T) %s - %s\n" "${1}" "${2}"
    fi
}

_info() {
    # _info "${FUNCNAME[0]}" ""
    printf "[INFO]\t $(date +%T) %s - %s\n" "${1}" "${2}"
}

_error() {
    # _error "${FUNCNAME[0]}" ""
    printf "[ERROR]\t $(date +%T) %s - %s\n" "${1}" "${2}"
}

_getopts() {

    # Uncomment if the script should not be run without any parameters
    # set +u
    # if [[ -z "${1}" ]]; then
    #     _help
    # fi
    # set -u

    # The leading colon turns on silent error reporting
    # The trailing colon checks for a parameter
    # while getopts ":d:vh" opt; do
    while getopts "vh" opt; do
        case "${opt}" in
            # d)
            #     backup_dir="${OPTARG}"
            #     _debug "${FUNCNAME[0]}" "Backup dir set to: ${backup_dir}"
            #     ;;
            v)
                debug_mode=0
                _debug "${FUNCNAME[0]}" "Debug mode turned on"
                ;;
            h)
                _help
                exit 0
                ;;
            \?)
                _error "${FUNCNAME[0]}" "Invalid option: -${OPTARG}"
                _usage
                exit 1
                ;;
            :)
                printf "Option -%s requires an argument.\n" "${OPTARG}"
                _error "${FUNCNAME[0]}" "Option -${OPTARG} requires an argument."
                _usage
                exit 1
                ;;
            *)
                _help
                exit 1
                ;;
        esac
    done
    shift $((OPTIND -1))
}

_usage() {
    printf "%s\n" "Usage: $0 [-v] [-h]" 1>&2
}

_help() {
    _usage
    printf "%s\t-\t%s\n" "-v" "Enable verbose logging."
    printf "%s\t-\t%s\n" "-h" "This help."
}

install_or_update() {
    bash "${HOMEDIR}/steamcmd/steamcmd.sh" +login anonymous \
        +force_install_dir "${STEAM_APP_DIR}" \
        +app_update "${STEAM_APP_ID}" \
        +quit
}

get_build_id() {
    curl -s -X GET "https://api.steamcmd.net/v1/info/${STEAM_APP_ID}" | jq -r '.data[].depots.branches.public.buildid'
}

main() {
    get_build_id > /tmp/buildid &
    build_id_pid="${!}"

    # _info "${FUNCNAME[0]}" "Displaying debug.log if it exists"
    # cat < $(find . -type f -name "debug.log") || true

    if [[ ! -d "${STEAM_APP_DIR}" ]]; then
        _info "${FUNCNAME[0]}" "Creating Steam app dir: ${STEAM_APP_DIR}"
        mkdir -p "${STEAM_APP_DIR}"
    fi

    if [[ ! "$(find "${STEAM_APP_DIR}" -mindepth 1 -print -quit 2>/dev/null)" ]]; then
        _info "${FUNCNAME[0]}" "Installing ${STEAM_APP^^} server files into ${STEAM_APP_DIR}"
        install_or_update

        # Are we in a metamod container?
        if [ ! -z "$METAMOD_VERSION" ]; then
            _info "${FUNCNAME[0]}" "Installing metamod version ${METAMOD_VERSION}"
            LATESTMM=$(wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/mmsource-latest-linux)
            wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/"${LATESTMM}" | tar xvzf - -C "${STEAM_APP_DIR}/${STEAM_APP}"	
        fi

        # Are we in a sourcemod container?
        if [ ! -z "$SOURCEMOD_VERSION" ]; then
            _info "${FUNCNAME[0]}" "Installing sourcemod version ${SOURCEMOD_VERSION}"
            LATESTSM=$(wget -qO- https://sm.alliedmods.net/smdrop/"${SOURCEMOD_VERSION}"/sourcemod-latest-linux)
            wget -qO- https://sm.alliedmods.net/smdrop/"${SOURCEMOD_VERSION}"/"${LATESTSM}" | tar xvzf - -C "${STEAM_APP_DIR}/${STEAM_APP}"
        fi

        wait "${build_id_pid}"
        cat /tmp/buildid > "${STEAM_APP_DIR}"/buildid
    else

        _debug "${FUNCNAME[0]}" "${STEAM_APP^^} server has already been initialised, checking if it needs an update."
        wait "${build_id_pid}"

        curr_buildid=$(cat /tmp/buildid)
        _debug "${FUNCNAME[0]}" "Current build: ${curr_buildid}"

        if [[ -f "${STEAM_APP_DIR}"/buildid ]]; then
            old_buildid=$(cat "${STEAM_APP_DIR}"/buildid)
        else
            old_buildid=0
        fi
        _debug "${FUNCNAME[0]}" "Old build: ${old_buildid}"

        if (( "${curr_buildid}" > "${old_buildid}" )); then
            _info "${FUNCNAME[0]}" "Updating ${STEAM_APP^^} server files"
            install_or_update
            cat /tmp/buildid > "${STEAM_APP_DIR}"/buildid
        else
            _debug "${FUNCNAME[0]}" "${STEAM_APP^^} already up to date."
        fi
    fi

    # Change hostname on launch
    _debug "${FUNCNAME[0]}" "Changing server hostname to ${SRCDS_HOSTNAME}"
    sed -i -e 's/{{SERVER_HOSTNAME}}/'"${SRCDS_HOSTNAME}"'/g' "${STEAM_APP_DIR}/${STEAM_APP}/cfg/server.cfg"

    # # Believe it or not, if you don't do this srcds_run shits itself
    # cd "${STEAM_APP_DIR}"
    # bash "${STEAM_APP_DIR}/srcds_run" -game "${STEAM_APP}" -console -debug \
    #                         -usercon \
    #                         +fps_max "${SRCDS_FPSMAX}" \
    #                         -tickrate "${SRCDS_TICKRATE}" \
    #                         -port "${SRCDS_PORT}" \
    #                         +tv_port "${SRCDS_TV_PORT}" \
    #                         +clientport "${SRCDS_CLIENT_PORT}" \
    #                         +maxplayers "${SRCDS_MAXPLAYERS}" \
    #                         +map "${SRCDS_STARTMAP}" \
    #                         +sv_setsteamaccount "${SRCDS_TOKEN}" \
    #                         +rcon_password "${SRCDS_RCONPW}" \
    #                         +sv_password "${SRCDS_PW}" \
    #                         +sv_region "${SRCDS_REGION}" \
    #                         +net_public_adr "${SRCDS_NET_PUBLIC_ADDRESS}" \
    #                         -ip "${SRCDS_IP}" \
    #                         +host_workshop_collection "${SRCDS_HOST_WORKSHOP_COLLECTION}" \
    #                         +workshop_start_map "${SRCDS_WORKSHOP_START_MAP}" \
    #                         -authkey "${SRCDS_WORKSHOP_AUTHKEY}"

    _info "${FUNCNAME[0]}" "Creating copy of ${STEAM_APP^^} server files."
    time cp -r "${STEAM_APP_DIR}"/ "${HOMEDIR}"/server/

    _info "${FUNCNAME[0]}" "Starting up the ${STEAM_APP} server"

    cd "${HOMEDIR}"/server
    bash "${HOMEDIR}/server/srcds_run" -game "${STEAM_APP}" -console -debug \
                            -usercon \
                            +fps_max "${SRCDS_FPSMAX}" \
                            -tickrate "${SRCDS_TICKRATE}" \
                            -port "${SRCDS_PORT}" \
                            +tv_port "${SRCDS_TV_PORT}" \
                            +clientport "${SRCDS_CLIENT_PORT}" \
                            +maxplayers "${SRCDS_MAXPLAYERS}" \
                            +map "${SRCDS_STARTMAP}" \
                            +sv_setsteamaccount "${SRCDS_TOKEN}" \
                            +rcon_password "${SRCDS_RCONPW}" \
                            +sv_password "${SRCDS_PW}" \
                            +sv_region "${SRCDS_REGION}" \
                            +net_public_adr "${SRCDS_NET_PUBLIC_ADDRESS}" \
                            -ip "${SRCDS_IP}" \
                            +host_workshop_collection "${SRCDS_HOST_WORKSHOP_COLLECTION}" \
                            +workshop_start_map "${SRCDS_WORKSHOP_START_MAP}" \
                            -authkey "${SRCDS_WORKSHOP_AUTHKEY}"
}

main "${@}"
