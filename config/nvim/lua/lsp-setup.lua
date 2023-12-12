-- https://github-wiki-see.page/m/neovim/nvim-lspconfig/wiki/Snippets

local F = {}

function F.setup()

  local lspconfig = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  --local capabilities = vim.lsp.protocol.make_client_capabilities()
  --capabilities.textDocument.completion.completionItem.snippetSupport = true

  local ensure_installed = {

    "ansiblels",
    "awk_ls",
    "bashls",
    "cssls",
    "docker_compose_language_service",
    "dockerls",
    "html",
    "jqls",
    "jsonls",
    "marksman",
    "pyright",
    "terraformls",
    "tsserver",
    --"lua_ls",
    --"yamlls",

  }


  for _, lsp in ipairs(ensure_installed) do
    lspconfig[lsp].setup {
      capabilities = capabilities,
    }
  end

  lspconfig.lua_ls.setup {
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
    capabilities = capabilities,
  }

  local currentRepo = vim.fn.expand('%:p:h')
  if (string.find(currentRepo, "dns%-internal%-dev") == nil) and
     (string.find(currentRepo, "public%-dns%-repo") == nil) and
     (string.find(currentRepo, "dns%-internal%-%prod") == nil) then

     -- do not setup yaml if any of these are true
    lspconfig.yamlls.setup {
      --... -- other configuration for setup {}
      settings = {
        yaml = {
          --... -- other settings. note this overrides the lspconfig defaults.
          --schemas = {
          --  ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          --  ["../path/relative/to/file.yml"] = "/.github/workflows/*",
          --  ["/path/from/root/of/project"] = "/.github/workflows/*",
          --},
        },
      },
      capabilities = capabilities,
    }
  end

  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
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
      vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format { async = true }
      end, opts)
    end,
  })

end
return F
