---@type vim.lsp.Config
--- https://github.com/LuaLS/lua-language-server
--- Delete Maeson folder
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc" },
	settings = {
		Lua = {
			hint = { enable = true },
			telemetry = { enable = false },
			diagnostics = { globals = { "vim" } },
			workspace = { checkThirdParty = false },
		},
	},
}
