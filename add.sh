#!/usr/bin/env bash
set -euo pipefail

CHART_PATH=${1:-helm}
INDEX_PATH=${2:-"helm-charts/docs"}
HELM_RELEASE=${HELM_RELEASE:-"master"}

GOPATH=${GOPATH:-${HOME}/go}
if ! hash helm-release 2>/dev/null; then
  go install "github.com/sstarcher/helm-release@${HELM_RELEASE}"
fi

# Add GOPATH/bin to PATH so helm-release can be found
export PATH="${GOPATH}/bin:${PATH}"

helm release "${CHART_PATH}"
helm package "${CHART_PATH}/" -d "${INDEX_PATH}"
helm repo index "${INDEX_PATH}"
cd "${INDEX_PATH}"

git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"
git add *.tgz
git add index.yaml
git commit -m "add chart for ${GITHUB_REPOSITORY:-""}"
