return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  opts = {},
  config = function()
    require("fzf-lua").setup(
    {
      winopts = {

        height = 1.0, -- window height
        width  = 0.9, -- window width

      },
      fzf_opts = {

        ["--layout"] = false,

      },
    }
    )
  end
}
