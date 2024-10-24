local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { { "prettierd", "prettier" } },
    html = { { "prettierd", "prettier" } },
    javascript = { { "prettierd", "prettier" } },
    json = { "jq" },
    yaml = { "jq" },
    xml = { "jq" },
    toml = { "jq" },
    csv = { "jq" },
    markdown = { "markdownlint" },
    ["*"] = { "codespell" },
    ["_"] = { "trim_whitespace" },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
