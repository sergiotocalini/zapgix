#!/usr/bin/env ksh
PATH=/usr/local/bin:${PATH}
IFS_DEFAULT="${IFS}"

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
[ -f ${APP_DIR}/${APP_NAME%.*}.conf ] && . ${APP_DIR}/${APP_NAME%.*}.conf

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

zabbix_not_support() {
    echo "ZBX_NOTSUPPORTED"
    exit 1
}
#
#################################################################################

#################################################################################
while getopts "s::a:sj:uphvt:" OPTION; do
    case ${OPTION} in
	h)
	    usage
	    ;;
	s)
	    SQL="${APP_DIR}/sql/${OPTARG}"
	    ;;
        j)
            JSON=1
            IFS=":" JSON_ATTR=(${OPTARG})
	    IFS="${IFS_DEFAULT}"
            ;;
	t)
	    TIMING=${OPTARG}
	    ;;
	a)
	    param=${OPTARG//p=}
	    [[ -n ${param} ]] && SQL_ARGS[${#SQL_ARGS[*]}]=${param}
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

ARGS+="-v timing=${TIMING:-off} "

count=1
for arg in ${SQL_ARGS[@]}; do
    if [[ ${arg} =~ .*::(inet|quote) ]]; then
       ARGS+="-v p${count}=\'${arg%\:\:*}\' "
    else
       ARGS+="-v p${count}=${arg} "
    fi
    let "count=count+1"
done

if [[ -f "${SQL%.sql}.sql" ]]; then
    cmd="psql -qAtX -U ${auth_user:-postgres} -f ${SQL%.sql}.sql"
    rval=`sudo su - ${UNIXUSER:-postgres} -c "${cmd} ${ARGS} 2>/dev/null"`
    rcode="${?}"
    if [[ ${rcode} == 0 && ${TIMING} =~ ^(on|ON|1|true|TRUE)$ ]]; then
	rval=`echo -e "${rval}" | tail -n 1 |cut -d' ' -f2|sed 's/,/./'`
    fi
else
    zabbix_not_support
fi

if [[ ${JSON} -eq 1 ]]; then
    echo '{'
    echo '   "data":['
    count=1
    while read line; do
       if [[ ${line} != '' ]]; then
            IFS="|" values=(${line})
            output='{ '
            for val_index in ${!values[*]}; do
               output+='"'{#${JSON_ATTR[${val_index}]:-${val_index}}}'":"'${values[${val_index}]}'"'
               if (( ${val_index}+1 < ${#values[*]} )); then
                     output="${output}, "
	       fi
            done
            output+=' }'
	    if (( ${count} < `echo ${rval}|wc -l` )); then
	       output="${output},"
            fi
            echo "      ${output}"
	fi
        let "count=count+1"
    done <<< ${rval}
    echo '   ]'
    echo '}'
else
    echo "${rval:-0}"
fi

exit ${rcode}
