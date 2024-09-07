#!/bin/bash
set -e

DATABASE_SRC_DIR="/root/database"
DB_CONFIG_FILE="InstallFullDB.config"
CMANGOS_SRC_DIR="/root/cmangos"

cd ${DATABASE_SRC_DIR}

# Regenerate config file
rm ${DB_CONFIG_FILE} | true
printf "\n" | ./InstallFullDB.sh >/dev/null

config_values="
    MYSQL_HOST=${DATABASE_HOST}
    MYSQL_USERNAME=${DATABASE_USER}
    MYSQL_PASSWORD=${DATABASE_PASS}
    MYSQL_USERIP=%
    CORE_PATH=${CMANGOS_SRC_DIR}
    FORCE_WAIT=YES
    AHBOT=${DATABASE_AHBOT}
    PLAYERBOTS_DB=${DATABASE_PLAYERBOTS}
"

mapfile -t INSTALLDB_CONF <<< "$config_values"
echo "Configuring InstallFullDB.config..."
for conf_line in "${INSTALLDB_CONF[@]}"; do
    conf_item=$(echo ${conf_line} | xargs)
    CONF_KEY=${conf_item%%=*}
    CONF_VALUE=\"${conf_item#*=}\"
    sed -i "s|^\(${CONF_KEY} *= *\).*$|\1${CONF_VALUE}|" ${DB_CONFIG_FILE}
done

./InstallFullDB.sh
