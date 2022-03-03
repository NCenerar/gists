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

SUFFIX="$(date +~%s~)"
mkdir -p "${2}"
"$(dirname "${0}")/nice_rsync.sh" --nb-retry ${NBRETRY} \
  -- --checksum --archive --backup --suffix=${SUFFIX} "${@}"
while [ ${#} -gt 2 ] ; do
  shift
done
RPSRC="$(realpath "${1}")"
printf "Moving ${RPSRC} to ${2} done.
Deleting ${RPSRC}
"
rm -rf "${RPSRC}"

exit 0
