# Clarifying Questions: Neovim Version Check Enhancement

Please answer inline under each question.

---

**Q1. What should happen when a newer version is found?**

a) Print a message and exit (let the user decide what to do)
b) Prompt the user interactively (yes/no) and install if confirmed
c) Always install the newer version automatically (no prompt)

**Your answer:** B

---

**Q2. What should happen when Neovim is NOT yet installed?**

a) Follow the existing install logic unchanged (no version check needed)
b) Always install the latest stable version from Fedora repos or GitHub

**Your answer:** b

---

**Q3. Version check scope — which sources should be checked, and in what order?**

a) Fedora repos only (dnf), then GitHub as fallback if package not found
b) Fedora repos first, GitHub second — pick whichever has the newest stable
c) GitHub only (always prefer upstream stable)

**Your answer:** c

---

**Q4. "Latest stable" on GitHub — how to identify it?**

a) The most recent `release-x.y` branch (e.g. `release-0.10`)
b) The tag marked "Latest Release" on GitHub Releases page
c) Both: prefer the release tag but fall back to the latest `release-x.y` branch

**Your answer:** c

---

**Q5. Should the version check also run when `BUILD_FROM_SOURCE=true`?**

a) Yes — still warn if a newer stable exists on GitHub before building
b) No — skip the check entirely when building from source

**Your answer:** a

---

**Q6. Network/offline behavior — what if the GitHub API or dnf metadata is unreachable?**

a) Silently skip the version check and proceed with normal install
b) Print a warning and skip
c) Fail loudly (exit with error)

**Your answer:** c

---

**Q7. Output format for the version suggestion?**

a) Plain text in the terminal (e.g. `INFO: Neovim 0.11 is available in Fedora repos`)
b) Same style as existing `print_info` / `print_warning` / `print_success` helpers
c) Machine-readable (e.g. JSON) — useful if other scripts consume the output

**Your answer:** b

---
