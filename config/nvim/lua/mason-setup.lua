local F = {}

function F.setup()


  require("mason").setup({
    ui = {
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
      "tsserver",
      "yamlls",

    },
  }

end

return F
