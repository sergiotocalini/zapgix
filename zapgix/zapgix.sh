#!/usr/bin/env ksh
rcode=0
PATH=/usr/local/bin:${PATH}

#################################################################################

#################################################################################
#
#  Variable Definition
# ---------------------
#
APP_NAME=$(basename $0)
APP_DIR=$(dirname $0)
APP_VER="1.0.0"
APP_WEB="http://www.sergiotocalini.com.ar/"
#
#################################################################################

#################################################################################
#
#  Load Oracle Environment
# -------------------------
#
[ -f ${APP_DIR}/zapgix.conf ] && . ${APP_DIR}/zapgix.conf

#
#################################################################################

#################################################################################
#
#  Function Definition
# ---------------------
#
usage() {
    echo "Usage: ${APP_NAME%.*} [Options]"
    echo ""
    echo "Options:"
    echo "  -a            Query arguments."
    echo "  -h            Displays this help message."
    echo "  -j            Jsonify output."
    echo "  -p            Specify the auth_pass to connect to the databases."
    echo "  -s ARG(str)   Query to PostgreSQL."
    echo "  -u            Specify the auth_user to connect to the databases (default=postgres)."
    echo "  -v            Show the script version."
    echo "  -U            Specify a unix user to execute the sentences (default=postgres)."
    echo ""
    echo "Please send any bug reports to sergiotocalini@gmail.com"
    exit 1
}

version() {
    echo "${APP_NAME%.*} ${APP_VER}"
    exit 1
}
#
#################################################################################

#################################################################################
while getopts "s::a:q:uphvj:" OPTION; do
    case ${OPTION} in
	h)
	    usage
	    ;;
	q)
	    SQL="${APP_DIR}/sql/${OPTARG}"
	    ;;
        j)
            JSON=1
	    JSON_ATTR=${OPTARG}
            ;;
	a)
	    SQL_ARGS[${#SQL_ARGS[*]}]=${OPTARG}
	    ;;
	u)
	    auth_user=${OPTARG}
	    ;;
	p)
	    auth_pass=${OPTARG}
	    ;;
	U)
	    UNIXUSER=${OPTARG}
	    ;;
	v)
	    version
	    ;;
         \?)
            exit 1
            ;;
    esac
done

[[ -z "${auth_pass}" ]] && export PGPASSWORD=${auth_pass}

for arg in ${SQL_ARGS[@]}; do
    ARGS+="-v ${arg} "
done

if [[ -f "${SQL%.sql}.sql" ]]; then
    cmd="psql -qAtX -U ${auth_user:-postgres} -f ${SQL%.sql}.sql"
    rval=`sudo su - ${UNIXUSER:-postgres} -c "${cmd} ${ARGS} 2>/dev/null"`
    rcode="${?}"
    if [[ ${JSON} -eq 1 ]]; then
       set -A rval ${rval}
       echo '{'
       echo '   "data":['
       count=1
       for i in ${rval[@]};do
          output='{ "'{#${JSON_ATTR}}'":"'${i}'" }'
          if (( ${count} < ${#rval[*]} )); then
             output="${output},"
          fi
          echo "      ${output}"
          let "count=count+1"
       done
       echo '   ]'
       echo '}'
    else
       echo ${rval:-0}
    fi
else
    echo "ZBX_NOTSUPPORTED"
    rcode="1"
fi

exit ${rcode}
