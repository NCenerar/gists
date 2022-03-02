#!/bin/sh -u
set -e

BRANCH="main"
FOLDER="posix-shell-scripts"
SCRIPT="nice_install.sh"
while [ ${#} -gt 0 ] ; do
  case "${1}" in
    --branch) BRANCH="${2}" ; shift 2 ;;
    --folder) FOLDER="${2}" ; shift 2 ;;
    --script) SCRIPT="${2}" ; shift 2 ;;
    --) shift ; break ;;
    *)          break ;;
  esac
done

if [ ${#} -gt 0 ] ; then
  printf "${0} [--branch name] [--folder name] [--script name] [--]
  --branch  name  Name of the branch to use. (default to main)
  --folder  name  Name of the folder to use. (default to posix-shell-scripts)
  --script  name  Name of the script to use. (default to nice_install.sh)
"
  exit 1
fi 1>&2

printf "Running ${BRANCH}/${FOLDER}/${SCRIPT}
"

curl -fsSL https://raw.githubusercontent.com/NCenerar/gists/${BRANCH}/${FOLDER}/${SCRIPT} | sh -

exit 0
