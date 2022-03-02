#!/bin/sh -u
set -e

if date --date "now" 2> /dev/null 1>&2 ; then
  __date() {
    date "${@}"
  }
elif gdate --date "now" 2> /dev/null 1>&2 ; then
  __date() {
    gdate "${@}"
  }
else
  echo "date unavailable" 1>&2
  exit 1
fi
export -f __date

__is_past() {
  DDATE="$(basename "${1}")"
  MDATE="$(__date +%FT00:00:00 -r "${1}")"
  ADATE="$( \
        __date +%s -d "${MDATE} ${DDATE}" 2> /dev/null \
    ||  __date +%s -d "${DDATE}" 2> /dev/null \
    ||  __date +%s -d "${MDATE}" 2> /dev/null \
  )"
  if [ $(( ${ADATE} - $(__date +%s -d "now") )) -gt 0 ] ; then
    return 1
  else
    return 0
  fi
}
export -f __is_past

__move() {
  rm -v -f "${1}/.DS_Store"
  find "${1}" -mindepth 1 -maxdepth 1 -exec mv -v -n "{}" "${2}" \;
}
export -f __move

find "${0}.d" -mindepth 1 -maxdepth 1 -type d \( \
  \( -exec sh -c "__is_past \"{}\"" \; \
     -exec sh -c "printf \"   Inbox:     \"; __date +%FT%X -r \"{}\" | tr -d '\n'; printf \" {}\n\";" \; \
     -exec sh -c "__move \"{}\" \"${0}.d/../\"" \; \
  \) -o -exec sh -c "printf \"   Postponed: \"; __date +%FT%X -r \"{}\" | tr -d '\n'; printf \" {}\n\";" \; \
  \) -empty -print -delete

exit 0
