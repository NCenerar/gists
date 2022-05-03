#!/bin/sh -u
set -e

URL="https://raw.githubusercontent.com/NCenerar/gists"

BRANCH="main"
while [ ${#} -gt 0 ] ; do
  case "${1}" in
    --branch) BRANCH="${2}" ; shift 2 ;;
    --) shift ; break ;;
    *)          break ;;
  esac
done

if [ ${#} -gt 0 ] ; then
  printf "${0} [--branch name] [--]
  --branch  name  Name of the branch to use. (default to main)
"
  exit 1
fi 1>&2

_update() {
  SRC="${URL}/${BRANCH}/posix-shell-scripts/${1}"
  DST="${HOME}/bin/${1}"
  printf "  Downloading ${SRC} into ${DST}
"
  curl -fsSL "${SRC}" --create-dirs -o "${DST}"
  printf "    Marking ${DST} as executable
"
  chmod +x "${DST}"
}

_import() {
  DST="${HOME}/bin/${1}"
  if [ -e "${DST}" ] ; then
    printf "${DST} already exists.
" 1>&2
  else
    _update "${@}"
  fi
}

UPDATE=0
UPDATE=1
if [ ${UPDATE} -eq 1 ] ; then
  printf "Updating ${BRANCH} NiCe commands
  "
  curl -fsSL "${URL}/${BRANCH}/posix-shell-scripts/nice_install.sh" \
  | grep -vF 'UPDATE=1' | sh -s - --branch "${BRANCH}"
  exit 0
fi

printf "Installing ${BRANCH} NiCe commands into ${HOME}/bin
"
_update nice_install.sh
_update nice_runner.sh
_update nice_rsync.sh
_update nice_move.sh
_update nice_git_credentials.sh

exit 0
