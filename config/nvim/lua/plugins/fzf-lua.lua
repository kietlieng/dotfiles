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

        ['--multi']    = '',
        ['--layout']   = false,
        ["--highlight-line"] = true,
        -- ['--with-nth'] = '2..',

      },
      buffers = {

         file_icons    = false,
         show_unloaded = false,
         -- sort_lastused = false,

      },
      files = {

         -- prompt     = 'Files >',
         dir_opts   = [[]],
         cwd_prompt = false,
         git_icons  = false,
         file_icons = false,

      },
      actions = {
        files = {
          -- Default action when selecting multiple files

          ['default'] = function(selected, opts)

            if not selected or #selected == 0 then return end

            -- io.output(assert(io.open("output.txt", "w")))

            local result = ''
            local cwd    = opts.cwd or vim.loop.cwd()

            -- Open each selected file in a new buffer
            for _, filepath in pairs(selected) do
              -- Open each file using :edit (replaces buffer)
              -- Or use :tabedit/:split/:vsplit if preferred

              -- remove icons from the front of the name
              -- result, _ = filepath:gsub("^[^a-zA-Z0-9%.%-_]+", "")
              result = filepath

              -- io.write(cwd .. "/" .. result)
              -- io.write("\n")

              vim.cmd('edit ' .. vim.fn.fnameescape(cwd .. "/" .. result))

            end
          end,
        },
      },
    })
  end
}
