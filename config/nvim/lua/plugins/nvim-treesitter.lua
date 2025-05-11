-- setup syntax for treesitter


return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = { -- A list of parser names, or "all" (the five listed parsers should always be installed)
      ensure_installed = {
        "awk",
        "bash",
        "c",
        "cmake",
        "css",
        "dockerfile",
        "fish",
        "git_config",
        "go",
        "html",
        "java",
        "javascript",
        "jq",
        "json",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "perl",
        "php",
        "python",
        "query",
        "ruby",
        "rust",
        "terraform",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
  --      "yaml",

      },
    },
    tree_docs = {
      enable = true,
      spec_config = {
        jsdoc = {
          slots = {
            class = {custom = true, author = true}
          },
          templates = {
            class = {
              "doc-start", -- Note, these are implicit slots and can't be turned off and vary between specs.
              "custom",
              "author",
              "doc-end",
              "%content%",
            }
          }
        }
      }
    },
    build = ':TSUpdate',
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end
  }
}
