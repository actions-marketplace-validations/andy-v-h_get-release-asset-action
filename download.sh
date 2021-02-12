#!/bin/sh

set -e

curl -sL --fail \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: Bearer ${GITHUB_PAT}" \
    "https://api.github.com/repos/${REPO}/releases/${RELEASE}" \
    | jq -r ".assets | .[] | select(.name | test(\"${MATCH}\")) | .url" \
    | tee asset.url

curl -sL --fail \
    -H "Accept: application/octet-stream" \
    -H "Authorization: Bearer ${GITHUB_PAT}" \
    -o "${RENAME}" \
    "$(cat asset.url)"

tag=$(curl -sL --fail \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: Bearer ${GITHUB_PAT}" \
    "https://api.github.com/repos/${REPO}/releases/${RELEASE}" \
    | jq -r ".tag_name")
    
echo "::set-output name=release::$tag"
