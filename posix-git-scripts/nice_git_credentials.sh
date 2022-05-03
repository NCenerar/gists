#!/bin/sh -u
set -e

GIT_NAME="$(git config --local --get user.name  || true)"
GIT_MAIL="$(git config --local --get user.email || true)"

while [ ${#} -gt 0 ] ; do
  case "${1}" in
    --name)  GIT_NAME="${2}" ; shift 2 ;;
    --email) GIT_MAIL="${2}" ; shift 2 ;;
    --) shift ; break ;;
    *)          break ;;
  esac
done

git config --local --unset-all user.name  || true
git config --local --unset-all user.email || true

KO=0
if [ -n "${GIT_NAME}" ]
then git config --local --add user.name  "${GIT_NAME}"
else KO=1 && printf "Missing name\n"
fi 1>&2
if [ -n "${GIT_MAIL}" ]
then git config --local --add user.email "${GIT_MAIL}"
else KO=1 && printf "Missing email\n"
fi 1>&2

if [ ${KO} -ne 0 ] ; then
  printf "${0} [options]

  Options:
    --name   name    Your name for this repository
    --email  email   Your email for this repository
"
else
  if ! [ -f "${HOME}/.ssh/${GIT_MAIL}" ] ; then
    printf "Generating ssh key for ${GIT_MAIL}\n"
    ssh-keygen -t ed25519 -C "${GIT_MAIL}" -f "${HOME}/.ssh/${GIT_MAIL}"
  fi
  GIT_SSH_CMD="ssh -i ~/.ssh/${GIT_MAIL} -F /dev/null"
  git config --local --unset-all core.sshCommand || true
  git config --local --add core.sshCommand "${GIT_SSH_CMD}"
  printf "Your credential:
name:    ${GIT_NAME}
email:   ${GIT_MAIL}
ssh key: ${HOME}/.ssh/${GIT_MAIL}
"
fi 1>&2

exit 0
