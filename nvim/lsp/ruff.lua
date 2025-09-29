return {
	cmd = { "ruff", "server" },
	root_markers = { "pyproject.toml" },
	filetypes = { 'py' },
	capabilities = {
		general = {
			positionEncodings = { "utf-16" }
		}
	}
}
