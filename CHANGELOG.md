# Changelog

## 0.1.0

- First release, targeting Whatomate 0.1.1-beta-0.17.
- Config is a nested map rendered as `WHATOMATE_<SECTION>__<KEY>` environment variables.
- Secrets come from an existing Secret mapped per config path, or from a chart-created Secret for quick starts.
- The image tag defaults to `appVersion`, not `latest`.
- `config.toml` is always mounted.
- `allowed_origins` is derived from `ingress.hosts`, and installs fail early in production without it.
- The uploads volume is kept on uninstall.
