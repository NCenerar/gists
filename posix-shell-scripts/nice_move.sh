#!/bin/sh -u
set -e

NBRETRY=9
SUFFIX="$(date +~%s~)"
while [ ${#} -gt 0 ] ; do
  case "${1}" in
    --nb-retry) NBRETRY=${2} ; shift 2 ;;
    --suffix)   SUFFIX=${2}  ; shift 2 ;;
    --) shift ; break ;;
    *)          break ;;
  esac
done

if [ ${#} -lt 2 ] ; then
  printf "${0} [options] [--] [rsync options] SRC DST

  SRC     Source path. (see rsync manual for details)
  DST     Destination path. (see rsync manual for details)

  Options:
    --nb-retry  n   Number of retry in case of failure. (default to 9)
    --suffix    s   Suffix for backuped files. (default to '~timestamp~')

  rsync options are system specific.
  Usefull rsync commands:
    -r              recursive
    -a              archive
    -aHAX           archive and keep attributes
"
  exit 1
fi 1>&2

(
  while [ ${#} -gt 2 ] ; do
    shift
  done
  mkdir -p "${2}"
)
echo "$(dirname "${0}")/nice_rsync.sh" --nb-retry ${NBRETRY} \
  -- --checksum --archive --backup --suffix=${SUFFIX} "${@}"
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
