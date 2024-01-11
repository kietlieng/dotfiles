local F = {}

function F.setup()

--  local null_ls = require("null-ls")
--
--  null_ls.setup({
--    debug = true,
--    sources = {
--      --null_ls.builtins.formatting.prettier.with({
--      --  filetypes = { "html", "json", "yaml", "markdown" },
--      --}),
--      null_ls.builtins.formatting.stylua,
--      null_ls.builtins.diagnostics.eslint,
--      null_ls.builtins.completion.spell,
--    },
--  })

  --vim.keymap.set('n', '<LEADER>gf', vim.lsp.buf.format, {}) -- have no idea what this does right now
end

return F
