return { 
  'williamboman/mason-lspconfig.nvim',
  -- event = "VeryLazy",
  config = function()
     require("mason").setup({
        ui = {

          check_outdated_packages_on_open = true,

          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })

      require("mason-lspconfig").setup {
        ensure_installed = {

          "ansiblels",
          "awk_ls",
          "bashls",
          "cssls",
          "docker_compose_language_service",
          "dockerls",
          "eslint",
          "html",
          "jqls",
          "jsonls",
          "lua_ls",
          "marksman",
          "pyright",
          "terraformls",
    --      "tsserver",
          "ts_ls",
    --      "yamlls",
          "zls",

        },
      }

  end
}
