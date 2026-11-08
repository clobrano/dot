# Jellyfin as a rootless Podman Quadlet service
# Override any variable on the command line, e.g.:
#   make setup MEDIA_DIR=/srv/videos

NAME        ?= jellyfin
IMAGE       ?= docker.io/jellyfin/jellyfin:latest
PORT        ?= 8096
MEDIA_DIR   ?= $(HOME)/Media
CONFIG_DIR  ?= $(HOME)/.local/share/jellyfin/config
CACHE_DIR   ?= $(HOME)/.local/share/jellyfin/cache
QUADLET_DIR ?= $(HOME)/.config/containers/systemd
UNIT_FILE    = $(QUADLET_DIR)/$(NAME).container

TAILSCALE_DOMAIN ?= $(shell tailscale status --json 2>/dev/null | jq -r '.Self.DNSName' | sed 's/$$//')
YTDLP_PATH      ?= $(HOME)/.local/bin/yt-dlp-standalone

define UNIT_CONTENT
[Unit]
Description=Jellyfin media server

[Container]
Image=$(IMAGE)
ContainerName=$(NAME)
PublishPort=$(PORT):8096
Volume=$(CONFIG_DIR):/config:Z
Volume=$(CACHE_DIR):/cache:Z
Volume=$(MEDIA_DIR):/media:z
Volume=$(YTDLP_PATH):/usr/local/bin/yt-dlp:ro,z

[Service]
Restart=on-failure
TimeoutStartSec=300

[Install]
WantedBy=default.target
endef
export UNIT_CONTENT

.PHONY: setup start stop status logs cleanup firewall-open firewall-close tailscale-serve tailscale-unserve

# Succeeds only if firewalld is installed and running
FIREWALLD_UP = command -v firewall-cmd >/dev/null && sudo firewall-cmd --state >/dev/null 2>&1

setup: firewall-open
	@test -d "$(MEDIA_DIR)" || { echo "MEDIA_DIR '$(MEDIA_DIR)' not found (set MEDIA_DIR=...)"; exit 1; }
	mkdir -p "$(CONFIG_DIR)" "$(CACHE_DIR)" "$(QUADLET_DIR)"
	podman pull $(IMAGE)
	@printf '%s\n' "$$UNIT_CONTENT" > "$(UNIT_FILE)"
	@echo "Wrote $(UNIT_FILE)"
	systemctl --user daemon-reload
	loginctl enable-linger $(USER)
	@echo "Done. Run 'make start' (or 'systemctl --user restart $(NAME)' if it was already running)."

start:
	systemctl --user start $(NAME)
	@echo "Jellyfin running at http://$$(hostname -I | awk '{print $$1}'):$(PORT)"

stop:
	systemctl --user stop $(NAME)

status:
	systemctl --user status $(NAME)
	@echo "Jellyfin local port: $(PORT)"
	@test -n "$(TAILSCALE_DOMAIN)" && echo "Jellyfin HTTPS: https://$(TAILSCALE_DOMAIN)" || true

logs:
	journalctl --user -u $(NAME) -f

firewall-open:
	@if $(FIREWALLD_UP); then \
		if sudo firewall-cmd --permanent --query-port=$(PORT)/tcp >/dev/null; then \
			echo "Port $(PORT)/tcp already open"; \
		else \
			sudo firewall-cmd --permanent --add-port=$(PORT)/tcp && sudo firewall-cmd --reload; \
		fi; \
	else \
		echo "firewalld not running, skipping firewall setup"; \
	fi

firewall-close:
	@if $(FIREWALLD_UP); then \
		if sudo firewall-cmd --permanent --query-port=$(PORT)/tcp >/dev/null; then \
			sudo firewall-cmd --permanent --remove-port=$(PORT)/tcp && sudo firewall-cmd --reload; \
		else \
			echo "Port $(PORT)/tcp not open, nothing to remove"; \
		fi; \
	else \
		echo "firewalld not running, skipping firewall cleanup"; \
	fi

tailscale-serve:
	@test -n "$(TAILSCALE_DOMAIN)" || { echo "Could not detect Tailscale domain (is tailscaled running?)"; exit 1; }
	tailscale serve --bg $(PORT)
	@echo "Jellyfin HTTPS URL: https://$(TAILSCALE_DOMAIN)"
	@echo "Set this in Jellyfin → Dashboard → Networking → Published server URL"

tailscale-unserve:
	tailscale serve off

cleanup: firewall-close
	-systemctl --user stop $(NAME)
	rm -f "$(UNIT_FILE)"
	systemctl --user daemon-reload
	-podman rmi $(IMAGE)
	@if [ "$(PURGE)" = "1" ]; then \
		rm -rf "$(CONFIG_DIR)" "$(CACHE_DIR)" && echo "Removed $(CONFIG_DIR) and $(CACHE_DIR)"; \
	else \
		echo "Kept $(CONFIG_DIR) and $(CACHE_DIR) (config, metadata, users). Use 'make cleanup PURGE=1' to delete them."; \
	fi
