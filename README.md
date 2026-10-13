# whatomate-helm

A community Helm chart for [Whatomate](https://github.com/shridarpatil/whatomate), the self-hosted
WhatsApp Business platform.

This chart is **unofficial**. It is not maintained by the Whatomate project, which keeps deployment
tooling out of its own repository. Problems with the application belong in
[shridarpatil/whatomate](https://github.com/shridarpatil/whatomate/issues). Problems with this chart
belong here.

## Install

```bash
kubectl create namespace whatomate
kubectl -n whatomate create secret generic whatomate \
  --from-literal=db-password='...' \
  --from-literal=jwt-secret="$(openssl rand -hex 32)" \
  --from-literal=encryption-key="$(openssl rand -hex 32)"

helm install whatomate oci://ghcr.io/ankit373/charts/whatomate \
  --version 0.1.0 -n whatomate -f my-values.yaml
```

PostgreSQL and Redis are not bundled. See [the chart README](charts/whatomate/README.md) for the
values, the secret mapping, and a complete `my-values.yaml`.

## Which chart version runs which Whatomate version

Each chart version targets exactly one Whatomate release, set as `appVersion`, and the image tag
defaults to it. The chart never defaults to `latest`.

| Chart | Whatomate | Checked |
| --- | --- | --- |
| 0.1.0 | 0.1.1-beta-0.17 | On kind with PostgreSQL 17 and Redis 7: install, migrations and `/health` on every CI run; uninstall keeping the volume and reinstall by hand |

Whatomate is pre-1.0 and every release so far is marked pre-release. It has renamed settings between
releases: after the switch to the double-underscore separator in
[#478](https://github.com/shridarpatil/whatomate/pull/478), a deployment on `:latest` restarted onto
the new image and ignored every environment variable. That is why the chart pins the application
version and why the table above exists. Treat an `appVersion` bump as something to read the upstream
release notes for.

## How releases work

- **Chart versions** follow SemVer. A patch is a chart fix, a minor is a new Whatomate version or new
  values, and a major is a change that needs edits to existing values files.
- **Tracking Whatomate.** A daily job looks for a new Whatomate release. When there is one, it opens a
  pull request that bumps `appVersion` and the chart version and runs CI against the new image.
  Nothing is merged or published until a person has read the release notes and filled in the table
  above.
- **Publishing.** Every merge to `main` that carries a chart version with no release yet is packaged,
  pushed to `oci://ghcr.io/ankit373/charts/whatomate`, and attached to a GitHub release.
- **CI** lints the chart, checks that a production install without allowed origins fails to render, and
  installs the chart on a kind cluster against throwaway PostgreSQL and Redis. A pod that ignores its
  environment variables never becomes ready, so a renamed setting fails there.

The maintainer steps are in [RELEASING.md](RELEASING.md).

## Support

Only the Whatomate release in the latest chart version is tested. To stay on an older Whatomate, use
the older chart version that targets it.

## License

The chart is licensed under [Apache-2.0](LICENSE). Whatomate itself is licensed separately, under
AGPL-3.0, and is not distributed here. The chart only deploys the published image.
