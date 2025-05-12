return {
  {

    "akinsho/bufferline.nvim",
    -- event = 'VeryLazy',
    opts = {
      options = {}
    },
    config = function()
      require("bufferline").setup{}
    end

  },
}
