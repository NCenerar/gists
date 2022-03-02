#!/bin/sh -u
set -e

NBRETRY=9
while [ ${#} -gt 0 ] ; do
  case "${1}" in
    --nb-retry) NBRETRY=${2} ; shift 2 ;;
    --) shift ; break ;;
    *)          break ;;
  esac
done

if [ ${#} -lt 2 ] ; then
  printf "${0} [--nb-retry n] [--] [rsync options] SRC DST
    --nb-retry  n   Number of retry in case of failure. (default to 9)

  rsync options are system specific.
  Usefull rsync commands:
    -r              recursive
    -a              archive
    -aHAX           archive and keep attributes
"
  exit 1
fi 1>&2

SUCCESS=1
while [ ${SUCCESS} -ne 0 ] && [ ${NBRETRY} -ge 0 ] ; do
  (   rsync    -vh --progress "${@}" \
  &&  rsync -c -vh --progress "${@}" \
  &&  SUCCESS=0 ) || NBRETRY=$(( ${NBRETRY} - 1 ))
done

exit ${SUCCESS}
