#!/bin/bash
set -e

CMANGOS_CONFIG_PATH="/opt/cmangos/etc"
MANGOSD_CONFIG_PATH="${CMANGOS_CONFIG_PATH}/mangosd.conf"
REALMD_CONFIG_PATH="${CMANGOS_CONFIG_PATH}/realmd.conf"

DATABASE_INFO="${DATABASE_HOST};3306;${DATABASE_USER};${DATABASE_PASS}"
_get_database_info() {
    echo -n "${DATABASE_INFO};$( \
        grep -oE "^$1 *=.*$" $2 | \
        grep -o ";[^;]*\"$" | \
        grep -o "[^;].*[^\"]" \
    )"
}

echo "Setting database config for mangosd"
export Mangosd_LoginDatabaseInfo="$(_get_database_info LoginDatabaseInfo ${MANGOSD_CONFIG_PATH})"
export Mangosd_WorldDatabaseInfo="$(_get_database_info WorldDatabaseInfo ${MANGOSD_CONFIG_PATH})"
export Mangosd_CharacterDatabaseInfo="$(_get_database_info CharacterDatabaseInfo ${MANGOSD_CONFIG_PATH})"
export Mangosd_LogsDatabaseInfo="$(_get_database_info LogsDatabaseInfo ${MANGOSD_CONFIG_PATH})"

echo "Setting database config for realmd"
export Realmd_LoginDatabaseInfo="$(_get_database_info LoginDatabaseInfo ${REALMD_CONFIG_PATH})"

echo "Config setup done"

exec "$@"
