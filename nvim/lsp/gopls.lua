# go install golang.org/x/tools/gopls@latest
return {

	cmd = { "gopls" },
	filetypes = { 'go' },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
}
