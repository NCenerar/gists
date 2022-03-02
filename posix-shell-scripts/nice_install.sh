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

printf "Installing ${BRANCH} NiCe commands into ${HOME}/bin
"
_update nice_runner.sh    # only from url
_update nice_rsync.sh     # only from url
_update nice_install.sh   # only from url
grep -vF '# only from url' "${HOME}/bin/nice_install.sh" > "${HOME}/bin/nice_install2.sh" # only from url
rm -f "${HOME}/bin/nice_install.sh" # only from url
chmod +x "${HOME}/bin/nice_install2.sh" # only from url
mv -f "${HOME}/bin/nice_install2.sh" "${HOME}/bin/nice_installer.sh" # only from url
exit 0                    # only from url

printf "Fetching ${BRANCH} NiCe commands last update
"
curl -fsSL "${URL}/${BRANCH}/posix-shell-scripts/nice_install.sh" | sh -s - --branch "${BRANCH}"
exit 0
