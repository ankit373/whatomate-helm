# Releasing

## A new Whatomate release

1. The `Track Whatomate releases` workflow opens `bump/whatomate-<version>` when upstream publishes a
   release whose image exists on Docker Hub. It bumps `appVersion`, bumps the chart minor version, adds a
   row marked `Not yet verified` to the compatibility table, and runs CI on the branch.
2. Read the upstream release notes for renamed or removed settings. Check them against
   `values.yaml` and `config.example.toml` at that tag. Update the values and the chart README for
   anything that changed. A change that breaks existing values files is a major chart version.
3. Make sure CI is green on the branch, including the smoke test against the new image.
4. Replace `Not yet verified` with what was actually checked, then merge.

Merging publishes. CI on `main` packages the chart, pushes it to
`oci://ghcr.io/ankit373/charts/whatomate`, and creates the GitHub release `v<chart version>`.

## A chart-only change

Bump `version` in `charts/whatomate/Chart.yaml` (patch for a fix, minor for new values), add a row to
the compatibility table, and merge. The `lint` job fails when the table has no row for the current
version.

## First publish

After the first release, check that an anonymous pull works, for example
`helm show chart oci://ghcr.io/ankit373/charts/whatomate --version <version>` from a machine without
GHCR credentials. If it is denied, make the package public in the GHCR package settings.

## If a release is wrong

Do not delete or move a published version. Publish a higher patch with the fix and say so in its
release notes.
