# PRD: Neovim Version Check Enhancement

## 1. Introduction / Overview

The `install.sh` script for Neovim currently installs Neovim without checking whether a newer stable version is available. This enhancement adds a version-check step that queries the GitHub Releases API for the latest stable Neovim release, compares it to the currently installed version (if any), and interactively offers the user an upgrade before proceeding.

The goal is to keep Neovim up-to-date by surfacing available upgrades automatically, while leaving the final decision to the user.

---

## 2. Goals

1. Detect the latest stable Neovim version available on GitHub before any install or upgrade action.
2. Compare it against the currently installed version (if Neovim is already installed).
3. If a newer version is available, prompt the user to confirm the upgrade (yes/no).
4. If Neovim is not installed, install the latest stable version from GitHub.
5. Use the same visual conventions (`print_info`, `print_warning`, `print_success`, `print_error`) as the rest of the script.
6. Fail loudly (exit non-zero with `print_error`) if the GitHub API is unreachable.

---

## 3. User Stories

- **As a user running the script for the first time**, I want the latest stable Neovim version to be installed automatically, so I don't start with an outdated release.
- **As a user who already has Neovim installed**, I want to be told if a newer stable version exists and asked whether to upgrade, so I stay in control of when updates happen.
- **As a user building from source**, I still want to be informed if a newer stable version exists on GitHub before the build begins, so I know whether my manual build will produce an up-to-date binary.

---

## 4. Functional Requirements

### 4.1 Determine the latest stable GitHub version

1. The script **must** query the GitHub Releases API (`https://api.github.com/repos/neovim/neovim/releases`) to identify the latest stable version.
2. The "latest stable" version **must** be determined as follows:
   - **Primary:** Find the release tagged as "Latest Release" (i.e., `prerelease: false` and `draft: false` with the highest semantic version tag such as `v0.10.4`).
   - **Fallback:** If no such release is found, identify the most recent `release-x.y` branch and treat its tip as the stable reference.
3. The version string **must** be normalized to a comparable form (e.g., `0.10.4`) by stripping the leading `v`.

### 4.2 Network failure handling

4. If the GitHub API call fails (no network, rate-limited, HTTP error), the script **must** call `print_error` with a descriptive message and **exit with a non-zero status code** immediately.

### 4.3 Compare installed vs. available version

5. If Neovim is already installed (`nvim --version` succeeds), the script **must** extract the current version string and compare it to the latest stable version obtained in §4.1.
6. Version comparison **must** use semantic versioning logic (major.minor.patch).

### 4.4 Upgrade prompt when a newer version is available

7. If the installed version is **older** than the latest stable, the script **must**:
   - Print an info message: `"Neovim <current> is installed. Neovim <latest> is available."`
   - Prompt the user interactively: `"Would you like to upgrade? [y/N]"`
   - If the user answers **yes**, proceed with the installation flow (package manager or source build).
   - If the user answers **no** (or presses Enter), print a message and exit 0 without making any changes.

### 4.5 First-time install (Neovim not installed)

8. If Neovim is **not** installed, the script **must** proceed directly to install the latest stable version without any version-check prompt.
9. The version printed during the install flow should reflect the latest stable version identified in §4.1.

### 4.6 Already up-to-date

10. If the installed version **matches** the latest stable, the script **must** print a success message (e.g., `"Neovim <version> is already the latest stable version."`) and exit 0.

### 4.7 `BUILD_FROM_SOURCE` mode

11. When `BUILD_FROM_SOURCE=true`, the version check **must still run** (requirements 4.1–4.3).
12. If a newer version is available, the script **must** print a warning before the build begins (e.g., `"A newer stable version <latest> is available. Proceeding with source build anyway..."`).
13. The build-from-source path is **not** interrupted by the version check; it always continues after the informational warning.

### 4.8 Output format

14. All user-facing messages **must** use the existing helper functions: `print_info`, `print_warning`, `print_success`, `print_error` — consistent with the rest of `install.sh`.

---

## 5. Non-Goals (Out of Scope)

- Checking Fedora/DNF repositories for available versions (GitHub is the sole version source).
- Automatic (unattended) upgrades without user confirmation.
- Downgrading to an older version.
- Checking or upgrading Neovim plugins or plugin managers.
- Caching the GitHub API response between runs.

---

## 6. Technical Considerations

- Use `curl` (already a declared build dependency) to call the GitHub Releases API endpoint:
  `https://api.github.com/repos/neovim/neovim/releases`
- Use `jq` to parse JSON if available, otherwise fall back to `grep`/`sed` for minimal dependencies.
- The GitHub API returns paginated results; the first page (30 releases by default) is sufficient for finding the latest stable.
- The existing `pkg_is_installed` and `print_*` helpers (from `lib/utils.sh`) should be reused where possible.
- A new helper function `get_latest_stable_github_version` should encapsulate the API call and version extraction logic, keeping `main()` readable.
- `nvim --version` outputs a line like `NVIM v0.10.4` — parse with `grep`/`awk` to extract the version number.

---

## 7. Success Metrics

- Running `install.sh` when Neovim is already at the latest stable version prints a clear "already up-to-date" message and exits 0.
- Running `install.sh` when a newer version is available prompts the user and respects the yes/no answer.
- Running `install.sh` with no network connectivity exits non-zero with a clear error message.
- All output uses `print_*` helpers (no raw `echo` for user-facing messages).

---

## 8. Open Questions

- Should the script support a `--check-only` flag in the future (print available version, no install)? Not in scope now but worth noting.
- Is `jq` guaranteed to be available in all target environments, or should the parser always use `grep`/`sed` for portability?
