return {
  'folke/flash.nvim',
  event = "VeryLazy",
  opts = {
    labels = "fghjklqwetyupzcvbnm",
    search = {
      -- If mode is set to the default "exact" if you mistype a word, it will
      -- exit flash, and if then you type "i" for example, you will start
      -- inserting text and fuck up your file outside
      --
      -- Search for me adds a protection layer, so if you mistype a word, it
      -- doesn't exit
      mode = "search",
    },
    modes = {
      char = {
        -- f, t, F, T motions:
        -- After typing f{char} or F{char}, you can repeat the motion with f or go to the previous match with F to undo a jump.
        -- Similarly, after typing t{char} or T{char}, you can repeat the motion with t or go to the previous match with T.
        -- You can also go to the next match with ; or previous match with ,
        -- Any highlights clear automatically when moving, changing buffers, or pressing <esc>.
        --
        -- Useful if you do `vtf` or `vff` and then keep pressing f to jump to
        -- the next `f`s
        -- enabled = true,
        -- kl CURRENTLY only use flash for remote capabilities.  we don't want to mess with the current search until later
        enabled = false,
      },
    },
  },
  keys = { -- https://www.youtube.com/watch?v=1iWONKe4kUY
    {

      "r", -- this is a killer.  Let's see what I can do with it
      -- try `yR` in normal mode then start trying to yank what you want to yank
      mode = { "o" },
      function()
        require("flash").remote()

        -- can't copy command to system clipboard due to user input
        -- print("blah " .. vim.fn.getreg('0') .. " " .. vim.fn.getreg('"'))

      end,
      desc = "Remote Flash.  This is a killer.  Let's see what I can do with it. Try `yr` in normal mode then start trying to yank what you want to yank"
    },
  },
}
