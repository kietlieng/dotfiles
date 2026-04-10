return {
  'neovim/nvim-lspconfig',
  -- event = "VeryLazy",
  config = function ()

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    vim.lsp.config('lua_ls', {
      capabilites = capabilities,
      setup = {
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  }
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  -- library = vim.api.nvim_get_runtime_file("", true)
                }
              }
            })

            --client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
          return true
        end,
      }
    })

    vim.lsp.config('ansiblels', { capabilites = capabilities })
    vim.lsp.config('awk_ls', { capabilites = capabilities })
    vim.lsp.config('bashls', { capabilites = capabilities })
    vim.lsp.config('cssls', { capabilites = capabilities })
    vim.lsp.config('docker_compose_language_service', { capabilites = capabilities })
    vim.lsp.config('dockerls', { capabilites = capabilities })
    vim.lsp.config('eslint', { capabilites = capabilities })
    vim.lsp.config('html', { capabilites = capabilities })
    vim.lsp.config('jqls', { capabilites = capabilities })
    vim.lsp.config('jsonls', { capabilites = capabilities })
    -- vim.lsp.config('lua_ls', { capabilites = capabilities })
    vim.lsp.config('marksman', { capabilites = capabilities })
    vim.lsp.config('pyright', { capabilites = capabilities })
    vim.lsp.config('terraformls', { capabilites = capabilities })
    vim.lsp.config('tclsp', { capabilites = capabilities })
    vim.lsp.config('ts_ls', { capabilites = capabilities })
		vim.lsp.config('yamlls', { capabilites = capabilities })
    vim.lsp.config('zls', { capabilites = capabilities })

		vim.lsp.enable('ansiblels')
    vim.lsp.enable('awk_ls')
    vim.lsp.enable('bashls')
    vim.lsp.enable('cssls')
    vim.lsp.enable('docker_compose_language_service')
    vim.lsp.enable('dockerls')
    vim.lsp.enable('eslint')
    vim.lsp.enable('html')
    vim.lsp.enable('jqls')
    vim.lsp.enable('jsonls')
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('marksman')
    vim.lsp.enable('pyright')
    vim.lsp.enable('terraformls')
    vim.lsp.enable('tclsp')
    vim.lsp.enable('ts_ls')
		-- vim.lsp.enable('yamlls')
    vim.lsp.enable('zls')

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        --vim.keymap.set('n', '<space>wl', function()
        --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        --end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        --vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({'n', 'v'}, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
        -- look for next
        -- vim.keymap.set("n", "<leader>n", vim.diagnostic.goto_next)
        -- vim.keymap.set("n", "<leader>p", vim.diagnostic.goto_prev)
      end,
    })

  end

}
