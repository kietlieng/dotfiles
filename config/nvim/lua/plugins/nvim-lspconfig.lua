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
    vim.lsp.config('awk_ls', { capabilities = capabilities } )
    vim.lsp.config('cssls', { capabilities = capabilities } )
    vim.lsp.config('docker_compose_language_service', { capabilities = capabilities } )
    vim.lsp.config('dockerls', { capabilities = capabilities } )
    vim.lsp.config('html', { capabilities = capabilities } )
    vim.lsp.config('jqls', { capabilities = capabilities } )
    vim.lsp.config('jsonls', { capabilities = capabilities } )
    vim.lsp.config('marksman', { capabilities = capabilities } )
    vim.lsp.config('pyright', { capabilities = capabilities } )
    vim.lsp.config('terraformls', { capabilities = capabilities } )
    vim.lsp.config('ts_ls', { capabilities = capabilities } )
    vim.lsp.config('lua_ls', { capabilities = capabilities } )
    vim.lsp.config('zls', { capabilities = capabilities } )

    -- vim.lsp.config('bashls',{ capabilities = capabilities } )
    -- vim.lsp.config('tsserver',{ capabilities = capabilities } )
    -- vim.lsp.config('yamlls',{ capabilities = capabilities } )

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
        vim.keymap.set("n", "<leader>n", vim.diagnostic.goto_next)
        vim.keymap.set("n", "<leader>p", vim.diagnostic.goto_prev)
      end,
    })

    vim.lsp.enable('lua_ls')
    vim.lsp.enable('ansiblels')
    vim.lsp.enable('awk_ls')
    vim.lsp.enable('cssls')
    vim.lsp.enable('docker_compose_language_service')
    vim.lsp.enable('dockerls')
    vim.lsp.enable('html')
    vim.lsp.enable('jqls')
    vim.lsp.enable('jsonls')
    vim.lsp.enable('marksman')
    vim.lsp.enable('pyright')
    vim.lsp.enable('terraformls')
    vim.lsp.enable('ts_ls')
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('zls')

  end

}
