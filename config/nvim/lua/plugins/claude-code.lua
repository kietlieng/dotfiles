return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup({
      window = {
        position = "float",
        float = {
          width = "90%",      -- Take up 90% of the editor width
          height = "30%",     -- Take up 90% of the editor height
          row = 70,     -- Center vertically
          col = "center",     -- Center horizontally
          relative = "editor",
          border = "single",  -- "none", "single", "double", "rounded", "solid", "shadow" borders
        },
      },
    })
  end
}
