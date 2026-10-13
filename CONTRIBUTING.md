# Contributing

This repository only holds the Helm chart. Changes to Whatomate itself belong in
[shridarpatil/whatomate](https://github.com/shridarpatil/whatomate).

- Open an issue first for a new value, a new template, or anything that changes defaults.
- Fixes and documentation corrections need no discussion.
- Run `helm lint charts/whatomate -f ci/values-kind.yaml` before you open a pull request. The smoke
  test in `ci/smoke.sh` runs on a kind cluster and refuses to run against any other context.
- A change to `charts/` needs a bumped `version` in `Chart.yaml` and a matching row in the
  compatibility table in the README.
- Sign off your commits with `git commit -s`.
