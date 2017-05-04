#!/bin/bash
# Script to convert a github https:// remote to a ssh remote

REMOTE_NAME=${1:-origin}
echo "Using remote: ${REMOTE_NAME}"

REMOTE_URL=`git remote get-url ${REMOTE_NAME}`

REPO_URL=`echo ${REMOTE_URL} | sed -Ene's#(https://[^[:space:]]*)#\1#p'`
if [ -z "${REPO_URL}" ]; then
  echo "-- ERROR: Could not identify repository URL"
  echo "  Is ${REMOTE_NAME} already using SSH? (${REMOTE_URL})"
  exit
fi

REPO_HOST=`echo ${REPO_URL} | sed -Ene's#https://([^/]*)/(.*).git#\1#p'`
if [ -z "${REPO_HOST}" ]; then
  echo "-- ERROR: Could not identify repo host."
  exit
fi

USER=`echo ${REPO_URL} | sed -Ene"s#https://${REPO_HOST}/([^/]*)/(.*).git#\1#p"`
if [ -z "${USER}" ]; then
  echo "-- ERROR:  Could not identify User."
  exit
fi

REPO=`echo ${REPO_URL} | sed -Ene"s#https://${REPO_HOST}/([^/]*)/(.*).git#\2#p"`
if [ -z "${REPO}" ]; then
  echo "-- ERROR:  Could not identify Repo."
  exit
fi

NEW_URL="git@${REPO_HOST}:${USER}/${REPO}.git"
echo "Changing repo url from"
echo "  '${REPO_URL}'"
echo "      to "
echo "  '${NEW_URL}'"
echo ""

CHANGE_CMD="git remote set-url ${REMOTE_NAME} ${NEW_URL}"
`${CHANGE_CMD}`

echo "Success"
