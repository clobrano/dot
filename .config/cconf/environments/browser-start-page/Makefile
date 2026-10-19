SERVICE      = browser-start-page
SERVICE_FILE = $(SERVICE).service
SYSTEMD_DIR  = $(HOME)/.config/systemd/user
PORT         = 8420
ZONE        ?= home

.PHONY: install uninstall firewall status

install:
	mkdir -p $(SYSTEMD_DIR)
	ln -sf $(CURDIR)/$(SERVICE_FILE) $(SYSTEMD_DIR)/$(SERVICE_FILE)
	systemctl --user daemon-reload
	systemctl --user enable --now $(SERVICE)

firewall:
	sudo firewall-cmd --add-port=$(PORT)/tcp --zone=$(ZONE) --permanent
	sudo firewall-cmd --reload

uninstall:
	-systemctl --user disable --now $(SERVICE)
	rm -f $(SYSTEMD_DIR)/$(SERVICE_FILE)
	systemctl --user daemon-reload
	-sudo firewall-cmd --remove-port=$(PORT)/tcp --zone=$(ZONE) --permanent
	-sudo firewall-cmd --reload

status:
	systemctl --user status $(SERVICE)
