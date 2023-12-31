-- https://dev.to/rishavmngo/how-to-setup-lsp-in-neovim-nh1
-- https://github-wiki-see.page/m/neovim/nvim-lspconfig/wiki/Snippets

local F = {}

function F.setup()

  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local cmp = require("cmp")
  local ls  = require("luasnip")

  local choice   = ls.choice_node
  local dynamicn = ls.dynamic_node
  local func     = ls.function_node
  local insert   = ls.insert_node
  local node     = ls.snippet_node
  local snip     = ls.snippet
  local text     = ls.text_node

  local date = function() return {os.date('%Y-%m-%d')} end

  cmp.setup({

    mapping = cmp.mapping.preset.insert({

      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

    }),

    snippet = {
      expand = function(args)

        if not ls then
          return
        end

        ls.lsp_expand(args.body)

      end,
    },

    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    sources = cmp.config.sources({
      --{ name = "nvim_lsp" },
      --{ name = "nvim_lsp_signature_help" },
      --{ name = "nvim_lua" },
      { name = "luasnip", option = { show_autosnippets = true } },
      --{ name = "path" },
    },
    {
      { name = "buffer", keyword_length = 3 },
    }),

  })

  ls.add_snippets(nil, {
    all = {

      snip(
      {

        trig = "date",
        namr = "Date",
        dscr = "Date in the form of YYYY-MM-DD",

      },
      {

        func(date, {}),

      }),
    },
  })


  vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, { silent = true })

  vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true })

  vim.keymap.set("i", "<C-l>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end)

end

return F
