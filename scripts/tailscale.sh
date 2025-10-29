if ! tailscale status --json 2>/dev/null | yq -e '.BackendState == "Running"' >/dev/null; then
	XDG_RUNTIME_DIR=/run/user/$(id -u)  notify-send --urgency=critical Tailscale "Tailscale is down"
fi

