-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "markdown_oxide", "jsonls", "marksman", "ts_ls", "bashls", "marksman", "taplo", "powershell_es" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end


-- PowerShell Editor Services
lspconfig.powershell_es.setup ({
  filetypes = { "ps1", "psm1", "psd1" },
  -- bundle_path = "C:/Users/cjasa/nvim-lspStuff/PowerShellEditorServices",
  bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services",
  settings = { powershell = { codeFormatting = { Preset = "OTBS" } } },
})
