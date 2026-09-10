# Branching & Pull Requests

## Workflow

- `main` is always releasable — every commit on it should build, pass CI,
  and be tag-able.
- All work happens on a short-lived feature branch off `main`:
  `git checkout -b feature/short-description` (or `fix/…`, `chore/…`).
- Open a PR into `main` instead of pushing directly. Merge once CI is green.
- Prefer squash-merge so `main` history stays one commit per change.
- Tag releases from `main` per `docs/standards/versioning.md`.

## Branch protection (configure once, in GitHub repo settings)

This can't be set from the repository itself — it's a GitHub setting under
**Settings → Branches → Branch protection rules** for `main`:

- Require a pull request before merging.
- Require status checks to pass before merging — select the `CI / Import &
  Test` check from `ci.yml`.
- Require branches to be up to date before merging.
- Optionally: require at least 1 approval once more than one person works
  on the repo (not needed solo, but the rule can be added without a
  reviewer available — GitHub allows self-merge once checks pass unless
  "Require approval" is also on).

## Commit messages

No enforced format yet. Keep the subject line short and imperative
("Fix X", "Add Y"); put reasoning in the body when the "why" isn't obvious
from the diff — see existing history for the established tone.
