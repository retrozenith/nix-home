# Makefile for NixOS Homelab

# Host definitions
LOCAL_HOST := h610
REMOTE_HOST := andromeda
REMOTE_IP := 192.168.0.26
REMOTE_USER := cvictor

# NixOS Commands
NIXOS_REBUILD := nixos-rebuild
FLAKE := .

.PHONY: all dry-run switch deploy edit-secret check update

all: dry-run

# Run a dry-run build for the local host
dry-run:
	$(NIXOS_REBUILD) dry-run --flake $(FLAKE)#$(LOCAL_HOST)

# Switch configuration on the local host (requires sudo)
switch:
	sudo $(NIXOS_REBUILD) switch --flake $(FLAKE)#$(LOCAL_HOST)

# Deploy configuration to remote host (andromeda)
deploy:
	sudo $(NIXOS_REBUILD) switch --flake $(FLAKE)#$(REMOTE_HOST) \
		--target-host $(REMOTE_USER)@$(REMOTE_IP) \
		--use-remote-sudo

# Edit a secret file (usage: make edit-secret [FILE=secret-name])
edit-secret:
	@if [ -n "$(FILE)" ]; then \
		name=$$(basename "$(FILE)" .age); \
		bash ./scripts/manage-secrets edit "$$name"; \
	else \
		echo "Select a secret to edit:"; \
		cd secrets && files=(*.age) && \
		for i in "$${!files[@]}"; do \
			echo "$$((i+1))) $${files[$$i]}"; \
		done; \
		echo "c) Create new secret"; \
		echo -n "Enter selection: "; \
		read input; \
		if [ "$$input" = "c" ]; then \
			echo -n "Enter new secret name (e.g. my-secret): "; \
			read name; \
			if [ -z "$$name" ]; then echo "Name cannot be empty"; exit 1; fi; \
			name=$$(basename "$$name" .age); \
			cd ..; bash ./scripts/manage-secrets edit "$$name"; \
		elif [ -n "$$input" ] && [ "$$input" -eq "$$input" ] 2>/dev/null; then \
			idx=$$((input-1)); \
			if [ $$idx -ge 0 ] && [ $$idx -lt $${#files[@]} ]; then \
				name=$$(basename "$${files[$$idx]}" .age); \
				cd ..; bash ./scripts/manage-secrets edit "$$name"; \
			else \
				echo "Invalid selection"; \
				exit 1; \
			fi \
		else \
			echo "Invalid input"; \
			exit 1; \
		fi \
	fi

# Check flake integrity
check:
	nix flake check

# Update flake inputs
update:
	nix flake update
