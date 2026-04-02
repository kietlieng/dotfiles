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


    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    parser_config.tcl = {
      install_info = {
        url = "https://github.com/lewis6991/tree-sitter-tcl",
        files = {"src/parser.c"},
        branch = "main",
      },
      filetype = "tcl",
    }

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
        "tclsp",
        "ts_ls",
				"yamlls",
        "zls",

      },
    }

  end
}
