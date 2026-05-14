# Tasks: Neovim Version Check Enhancement

## Relevant Files

- `.config/cconf/environments/neovim/install.sh` — Main file modified; contains all three new version-check functions and updated `main()`.
- `.config/cconf/lib/utils.sh` — Read-only; provides `version_compare`, `version_gt`, `version_ge`, `print_*` helpers.
- `tasks/test-neovim-version-check.sh` — Bash test suite (15 tests) for the three new functions.

### Notes

- No package manager or test runner is configured for this project; logic can be manually verified by running `install.sh` with environment variable overrides (e.g., `BUILD_FROM_SOURCE=true`).
- `jq` may not be present on all systems; the JSON parsing must fall back to `grep`/`sed` when `jq` is unavailable.
- `version_compare`, `version_gt`, `version_ge` in `lib/utils.sh` are already correct for semver — reuse them directly, do not reimplement.

---

## Tasks

- [x] 1.0 Add `get_latest_stable_github_version` helper function
  - [x] 1.1 Use `curl -fsSL` to fetch GitHub releases/latest; if curl exits non-zero or returns an empty body, call `print_error` and `exit 1`.
  - [x] 1.2 If `jq` is available, use it to extract `.tag_name`; otherwise fall back to `grep`/`sed`.
  - [x] 1.3 If tag_name is empty, fall back to querying branches, pick the highest `release-x.y` branch, return `x.y.0`.
  - [x] 1.4 Strip the leading `v` from the tag name so the function outputs a plain semver string (e.g., `0.10.4`).
  - [x] 1.5 Print the resolved version with `print_info >&2` before returning.

- [x] 2.0 Add `get_installed_nvim_version` helper function
  - [x] 2.1 Check if `nvim` is in PATH using `command -v nvim`; if not, output the empty string and return 0.
  - [x] 2.2 Run `nvim --version 2>/dev/null | head -1` and extract the `x.y.z` version with `grep -o`.
  - [x] 2.3 Output the normalized version string (e.g., `0.10.2`) to stdout.

- [x] 3.0 Add `check_nvim_version_and_prompt` orchestration function
  - [x] 3.1 Call `get_latest_stable_github_version` with `|| exit 1` guard.
  - [x] 3.2 Call `get_installed_nvim_version` and store the result.
  - [x] 3.3 **Not installed path:** print info and return 0 to proceed with installation.
  - [x] 3.4 **Up-to-date path:** `print_success` and `exit 0`.
  - [x] 3.5 **Upgrade available path:** print info and prompt `[y/N]` via `read -r`.
  - [x] 3.6 `y/Y` answer → return 0 (proceed to install).
  - [x] 3.7 Any other answer → `print_info "Skipping upgrade."` and `exit 0`.
  - [x] 3.8 **`BUILD_FROM_SOURCE` mode:** `print_warning` and return 0 (no prompt).

- [x] 4.0 Integrate version check into `main()`
  - [x] 4.1 Remove the existing early-exit block (`pkg_is_installed nvim && BUILD_FROM_SOURCE != true`).
  - [x] 4.2 Call `check_nvim_version_and_prompt` as the first statement inside `main()`.
  - [x] 4.3 Verified both `BUILD_FROM_SOURCE=true` and package-manager paths work correctly after refactor.
