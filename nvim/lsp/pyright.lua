return {
	cmd = { "pyright-langserver", "--stdio" },
	root_markers = { "pyproject.toml" },
	filetypes = { 'python' },
	settings = {
		pyright = {
			disableLanguageServices = false,
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				autoImportCompletions = true,

				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				typeCheckingMode = "strict",
			},
		},
	},
}
