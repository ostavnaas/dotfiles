return {
	cmd = { "ruff", "server" },
	root_markers = { "pyproject.toml" },
	filetypes = { 'python' },
	capabilities = {
		general = {
			positionEncodings = { "utf-16" }
		}
	}
}
