#!/usr/bin/env bash
set -euo pipefail

CHART_PATH=${1:-helm}
INDEX_PATH=${2:-"helm-charts/docs"}
HELM_RELEASE=${HELM_RELEASE:-"master"}

# Install helm-release plugin if not already installed
if ! helm plugin list | grep -q release; then
  helm plugin install https://github.com/sstarcher/helm-release
fi

helm release "${CHART_PATH}"
helm package "${CHART_PATH}/" -d "${INDEX_PATH}"
helm repo index "${INDEX_PATH}"
cd "${INDEX_PATH}"

git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"
git add *.tgz
git add index.yaml
git commit -m "add chart for ${GITHUB_REPOSITORY:-""}"
