#!/usr/bin/env bash
# Test suite for Neovim version-check functions in install.sh
# Usage: bash tasks/test-neovim-version-check.sh  (from repo root or tasks/)

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_SH="$REPO_ROOT/.config/cconf/environments/neovim/install.sh"
LIB_DIR="$REPO_ROOT/.config/cconf/lib"

PASS=0; FAIL=0

ok()  { echo "  [PASS] $1"; ((PASS++)) || true; }
nok() { echo "  [FAIL] $1"; echo "         expected='$2'  got='$3'"; ((FAIL++)) || true; }
eq()  { [ "$2" = "$3" ] && ok "$1" || nok "$1" "$2" "$3"; }

check_exit() {
    local desc="$1" want="$2"
    shift 2
    local got=0
    ( "$@" ) >/dev/null 2>&1 || got=$?
    eq "$desc" "$want" "$got"
}

# ── Mock JSON payloads ────────────────────────────────────────────────────────
LATEST_RELEASE_JSON='{"tag_name":"v0.10.4","name":"NVIM v0.10.4","prerelease":false,"draft":false}'
EMPTY_TAG_JSON='{"tag_name":"","name":""}'
BRANCHES_JSON='[{"name":"master"},{"name":"release-0.9"},{"name":"release-0.10"},{"name":"release-0.11"}]'

# ── Tests: get_latest_stable_github_version ───────────────────────────────────
echo ""
echo "=== get_latest_stable_github_version ==="

# T1.1a: curl returns non-zero → exit 1
check_exit "T1.1a: curl failure → exit 1" 1 \
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        curl() { return 6; }
        get_latest_stable_github_version
    "

# T1.1b: curl returns empty body → exit 1
check_exit "T1.1b: empty curl response → exit 1" 1 \
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        curl() { echo ''; return 0; }
        get_latest_stable_github_version
    "

# T1.2/T1.4: valid latest-release JSON → normalized version (no leading v)
result=$(
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        curl() { echo '$LATEST_RELEASE_JSON'; return 0; }
        get_latest_stable_github_version
    " 2>/dev/null
)
eq "T1.2/1.4: valid JSON → 0.10.4" "0.10.4" "$result"

# T1.3: tag_name empty → falls back to branches, picks highest release-x.y → x.y.0
result=$(
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        curl() {
            if [[ \"\$*\" == *branches* ]]; then echo '$BRANCHES_JSON'; else echo '$EMPTY_TAG_JSON'; fi
            return 0
        }
        get_latest_stable_github_version
    " 2>/dev/null
)
eq "T1.3: fallback to branches → 0.11.0" "0.11.0" "$result"

# T1.3b: branches API fails → exit 1
check_exit "T1.3b: branches API also fails → exit 1" 1 \
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        curl() {
            if [[ \"\$*\" == *branches* ]]; then return 6; else echo '$EMPTY_TAG_JSON'; fi
        }
        get_latest_stable_github_version
    "

# ── Tests: get_installed_nvim_version ─────────────────────────────────────────
echo ""
echo "=== get_installed_nvim_version ==="

# T2.1: nvim not in PATH → empty string, exit 0
result=$(
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        export PATH='/no_such_dir_$$'
        get_installed_nvim_version
    " 2>/dev/null
)
eq "T2.1: nvim absent → empty string" "" "$result"

# T2.2/T2.3: nvim present → normalized version string
result=$(
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        nvim() { echo 'NVIM v0.10.2'; }
        get_installed_nvim_version
    " 2>/dev/null
)
eq "T2.2/2.3: nvim present → 0.10.2" "0.10.2" "$result"

# T2.2b: strips build metadata / pre-release suffix if present
result=$(
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        nvim() { echo 'NVIM v0.10.2-dev+g1234abc'; }
        get_installed_nvim_version
    " 2>/dev/null
)
eq "T2.2b: strips build suffix → 0.10.2" "0.10.2" "$result"

# ── Tests: check_nvim_version_and_prompt ──────────────────────────────────────
echo ""
echo "=== check_nvim_version_and_prompt ==="

# T3.3: nvim not installed → return 0 (proceed to install)
check_exit "T3.3: not installed → exit 0 (proceed)" 0 \
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        curl() { echo '$LATEST_RELEASE_JSON'; return 0; }
        get_installed_nvim_version() { echo ''; }
        check_nvim_version_and_prompt
    "

# T3.4: already up-to-date → exit 0
check_exit "T3.4: already up-to-date → exit 0" 0 \
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        curl() { echo '$LATEST_RELEASE_JSON'; return 0; }
        get_installed_nvim_version() { echo '0.10.4'; }
        check_nvim_version_and_prompt
    "

# T3.5/3.6: newer available, user answers y → return 0 (proceed with upgrade)
check_exit "T3.5/3.6: newer + user y → exit 0" 0 \
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        curl() { echo '$LATEST_RELEASE_JSON'; return 0; }
        get_installed_nvim_version() { echo '0.9.5'; }
        echo 'y' | check_nvim_version_and_prompt
    "

# T3.7: newer available, user answers n → exit 0 (skip)
check_exit "T3.7: newer + user n → exit 0 (skip)" 0 \
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        curl() { echo '$LATEST_RELEASE_JSON'; return 0; }
        get_installed_nvim_version() { echo '0.9.5'; }
        echo 'n' | check_nvim_version_and_prompt
    "

# T3.7b: newer available, user presses Enter (blank) → exit 0 (skip)
check_exit "T3.7b: newer + blank Enter → exit 0 (skip)" 0 \
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        curl() { echo '$LATEST_RELEASE_JSON'; return 0; }
        get_installed_nvim_version() { echo '0.9.5'; }
        echo '' | check_nvim_version_and_prompt
    "

# T3.8: BUILD_FROM_SOURCE=true, newer available → return 0 (no prompt, build continues)
check_exit "T3.8: BUILD_FROM_SOURCE + newer → exit 0 (no prompt)" 0 \
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        export BUILD_FROM_SOURCE=true
        curl() { echo '$LATEST_RELEASE_JSON'; return 0; }
        get_installed_nvim_version() { echo '0.9.5'; }
        check_nvim_version_and_prompt
    "

# T3.8b: BUILD_FROM_SOURCE=true, curl fails → exit 1
check_exit "T3.8b: BUILD_FROM_SOURCE + network fail → exit 1" 1 \
    bash -c "
        source '$LIB_DIR/utils.sh'
        source '$LIB_DIR/detect.sh'
        source '$INSTALL_SH'
        export BUILD_FROM_SOURCE=true
        curl() { return 6; }
        check_nvim_version_and_prompt
    "

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────────────"
echo "Results: $PASS passed, $FAIL failed"
echo "────────────────────────────────────────"
[ "$FAIL" -eq 0 ]
