#!/usr/bin/env bash
# Installs the chart on the current cluster against throwaway PostgreSQL and Redis, then checks /health.
# A pod that ignores its env vars cannot reach the database and never becomes ready, which is how a
# renamed config variable shows up here.
set -euo pipefail
cd "$(dirname "$0")/.."

ctx=$(kubectl config current-context)
case "$ctx" in kind-*) ;; *) echo "refusing to run against context '$ctx': this installs and deletes things, use a kind cluster" >&2; exit 2 ;; esac

NS=${NS:-whatomate-smoke}
kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f -
kubectl -n "$NS" apply -f ci/deps.yaml
kubectl -n "$NS" rollout status deploy/postgres --timeout=180s
kubectl -n "$NS" rollout status deploy/redis --timeout=180s

helm upgrade --install whatomate charts/whatomate -n "$NS" -f ci/values-kind.yaml --wait --timeout 300s \
  || { kubectl -n "$NS" get pods; kubectl -n "$NS" logs deploy/whatomate --tail=80 || true; exit 1; }

kubectl -n "$NS" port-forward svc/whatomate 18080:8080 >/dev/null 2>&1 &
PF=$!
trap 'kill $PF 2>/dev/null || true' EXIT
for _ in $(seq 1 20); do
  if curl -fsS http://127.0.0.1:18080/health; then echo; echo "smoke ok"; exit 0; fi
  sleep 2
done
echo "health check failed" >&2
kubectl -n "$NS" logs deploy/whatomate --tail=80 || true
exit 1
