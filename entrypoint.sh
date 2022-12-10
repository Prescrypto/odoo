#!/bin/bash

set -e

if [ -v PASSWORD_FILE ]; then
    PASSWORD="$(< $PASSWORD_FILE)"
fi

# set the postgres database host, port, user and password according to the environment
# and pass them as arguments to the odoo process if not present in the config file
: ${HOST:=${DB_PORT_5432_TCP_ADDR:='db'}}
: ${DB_PORT:=${DB_PORT_5432_TCP_PORT:=5432}}
: ${USER:=${DB_ENV_POSTGRES_USER:=${POSTGRES_USER:='odoo'}}}
: ${PASSWORD:=${DB_ENV_POSTGRES_PASSWORD:=${POSTGRES_PASSWORD:='odoo'}}}
: ${DB_NAME:=${DB_ENV_DB_NAME:='postgres'}}
#: ${DB_SSLMODE:=${DB_ENV_DB_SSLMODE:='allow'}}

DB_ARGS=()
function check_config() {
    param="$1"
    value="$2"
    if grep -q -E "^\s*\b${param}\b\s*=" "$ODOO_RC" ; then       
        value=$(grep -E "^\s*\b${param}\b\s*=" "$ODOO_RC" |cut -d " " -f3|sed 's/["\n\r]//g')
    fi;
    DB_ARGS+=("--${param}")
    DB_ARGS+=("${value}")
}
check_config "db_host" "$HOST"
check_config "db_port" "$DB_PORT"
check_config "db_user" "$USER"
check_config "db_password" "$PASSWORD"
check_config "database" "$DB_NAME"
#check_config "db_sslmode" "$DB_SSLMODE"


case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec /odoo/oodoo-bin "$@"
        else
            wait-for-psql.py ${DB_ARGS[@]} --timeout=30
            #exec ./odoo/odoo-bin --database='$DB_ENV_DB_NAME' --db_user='$DB_ENV_POSTGRES_USER' --db_password='$DB_ENV_POSTGRES_PASSWORD' --db_host='$DB_PORT_5432_TCP_ADDR' --db_port='$DB_PORT_5432_TCP_ADDR'
            #exec ./odoo/odoo-bin "$@" "${DB_ARGS[@]}"
            exec /odoo/odoo-bin --database=${DB_ENV_DB_NAME} --db_user=${DB_ENV_POSTGRES_USER} --db_password=${DB_ENV_POSTGRES_PASSWORD} --db_host=${DB_PORT_5432_TCP_ADDR} --db_port=${DB_PORT_5432_TCP_PORT} --dev='all'
        fi
        ;;
    -*)
        wait-for-psql.py ${DB_ARGS[@]} --timeout=30
        exec /odoo/odoo-bin "$@" "${DB_ARGS[@]}"
        ;;
    *)
        exec "$@"
esac

exit 1