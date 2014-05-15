#!/bin/bash

## version
CLIB_INIT_VERSION="0.0.1"

## cwd
CWD="`pwd`"

## output buffer
BUF=""

## output file
FILE="${CWD}/package.json"

## sets optional variable from environment
opt () { eval "if [ -z "\${$1}" ]; then ${1}=${2}; fi";  }

## output usage
usage () {
  {
    echo "usage: clib-init [-hV]"
  } >&2
}

## prompt with question and store result
## in variable
prompt () {
  local var="$1"
  local q="$2"
  local value=""
  printf "%s" "${q}"

  {
    trap "exit -1" SIGINT SIGTERM
    read -r value;
    value="${value//\"/\'}";
  } > /dev/null 2>&1
  if [ ! -z "${value}" ]; then
    eval "${var}"=\"${value}\"
  fi
}

## alert user of hint
hint () {
  {
    echo
    printf "  hint: %s\n" "$@"
    echo
  } >&2
}

## output error
error () {
  {
    printf "error: %s\n" "${@}"
  } >&2
}

## append line to buffer
append () {
  appendf '%s' "${@}"
  BUF+=$'\n'
}

## append formatted string to buffer
appendf () {
  local fmt="$1"
  shift
  BUF+="`printf "${fmt}" "${@}"`"
}

## wraps each argument in quotes
wrap () {
  printf '"%s" ' "${@}";
  echo "";
}

## parse opts
{
  while true; do
    arg="$1"
    if [ "" = "${arg}" ]; then
      break;
    fi

    case "${arg}" in
      -V|--version)
        echo "${CLIB_INIT_VERSION}"
        exit 0
        ;;

      -h|--help)
        usage
        exit 0
        ;;

      *)
        error "Unknown option: \`${arg}'"
        usage
        exit 1
        ;;
    esac
    shift
  done
}

## intro
echo
echo "This will walk you through initialzing the clib \`package.json' file."
echo "It will prompt you for the bare minimum that is needed and provide"
echo "defaults."
echo
echo "See github.com/clibs/clib for more information on defining the clib"
echo "\`package.json' file."
echo
echo "You can press ^C anytime to quit this prompt. The \`package.json' file"
echo "will only be written upon completion."
echo

## options
opt NAME "$(basename `pwd`)"
opt VERSION "0.0.1"
opt REPO ""
opt DESCRIPTION ""
opt KEYWORDS ""
opt LICENSE "MIT"
opt INSTALL ""

## prompts
prompt NAME "name: (${NAME}) "
prompt VERSION "version: (${VERSION}) "
prompt REPO "repo: "
prompt DESCRIPTION "description: "
prompt KEYWORDS "keywords: "
prompt LICENSE "license: (${LICENSE}) "
prompt INSTALL "install: "

## handle required fields
if [ -z "${NAME}" ]; then
  error "Missing \`name' property"
fi

## convert keywords to quoted csv
if [ ! -z "${KEYWORDS}" ]; then
  {
    TMP=""
    KEYWORDS="${KEYWORDS//,/ }"
    KEYWORDS="${KEYWORDS//\"/}"
    KEYWORDS="${KEYWORDS//\'/}"
    KEYWORDS=($(wrap ${KEYWORDS}))
    let len=${#KEYWORDS[@]}
    for (( i = 0; i < len; i++ )); do
      word=${KEYWORDS[$i]}
      if (( i + 1 != len )); then
        TMP+="${word}, "
      else
        TMP+="${word}"
      fi
    done
    KEYWORDS="${TMP}"
  }
fi

append "{"
  appendf '  "name": "%s"' "${NAME}" && append ","
  appendf '  "version": "%s"' "${VERSION}" &&  append ","

  if [ ! -z "${REPO}" ]; then
    appendf '  "repo": "%s"' "${REPO}" && append ","
  fi

  if [ ! -z "${DESCRIPTION}" ]; then
    appendf '  "description": "%s"' "${DESCRIPTION}"
    append ","
  else
    append ","
  fi

  appendf '  "keywords": [%s]' "${KEYWORDS}" 

  if [ ! -z "${INSTALL}" ]; then
    append ","
    appendf '  "install": "%s"' "${INSTALL}"
  else
    append ""
  fi

append ""
append "}"


## validate with user
prompt ANSWER "${BUF}(yes) ? "
if [ "n" = "${ANSWER:0:1}" ]; then
  exit 1
fi

## ensure user wants to do this
if test -f "${FILE}"; then
  prompt ANSWER "A \`package.json' already exists. Would you like to replace it ? (yes): "
  if [ "n" = "${ANSWER:0:1}" ]; then
    exit 1
  else
    rm -f "${FILE}"
  fi
fi

## create
touch "${FILE}"

## write
echo "${BUF}" > "${FILE}"

## exit
exit $?
