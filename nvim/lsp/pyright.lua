return {
	cmd = { "pyright-langserver", "--stdio" , "--offset-encoding=utf-8"},
	root_markers = { "pyproject.toml" },
	filetypes = { 'py' },
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
