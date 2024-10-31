local F = {}

function F.setup()

  require('darkvoid').setup({
    transparent = false,
    glow = false,
    show_end_of_buffer = true,

    colors = {
        fg = "#c0c0c0",
        bg = "#1c1c1c",
        cursor = "#bdfe58",
        line_nr = "#404040",
        visual = "#303030",
        comment = "#585858",
        string = "#d1d1d1",
        func = "#e1e1e1",
        kw = "#f1f1f1",
        identifier = "#b1b1b1",
        type = "#a1a1a1",
        type_builtin = "#c5c5c5", -- current
        -- type_builtin = "#8cf8f7", -- glowy blue old (was present by default before type_builtin was introduced added here for people who may like it)
        search_highlight = "#1bfd9c",
        operator = "#1bfd9c",
        bracket = "#e6e6e6",
        preprocessor = "#4b8902",
        bool = "#66b2b2",
        constant = "#b2d8d8",

        -- enable or disable specific plugin highlights
        plugins = {
            gitsigns = true,
            nvim_cmp = true,
            treesitter = true,
            nvimtree = true,
            telescope = true,
            lualine = true,
            bufferline = true,
            oil = true,
            whichkey = true,
            nvim_notify = true,
        },

        -- gitsigns colors
        added = "#baffc9",
        changed = "#ffffba",
        removed = "#ffb3ba",

        -- Pmenu colors
        pmenu_bg = "#1c1c1c",
        pmenu_sel_bg = "#1bfd9c",
        pmenu_fg = "#c0c0c0",

        -- EndOfBuffer color
        eob = "#3c3c3c",

        -- Telescope specific colors
        border = "#585858",
        title = "#bdfe58",

        -- bufferline specific colors
        bufferline_selection = "#1bfd9c",

        -- LSP diagnostics colors
        error = "#dea6a0",
        warning = "#d6efd8",
        hint = "#bedc74",
        info = "#7fa1c3",
      }
    }
  )

--  vim.cmd([[
--
--    ""let g:gruvbox_improved_strings         = 1 "" high contrast string (white text / grey background). Not great if alot of strings
--    ""let g:gruvbox_invert_indent_guides     = 1 "" don't use indent guides
--    ""let g:gruvbox_invert_signs             = 1 "" too jarring
--    let g:gruvbox_bold                       = 1
--    let g:gruvbox_contrast_dark              = 'hard'
--    let g:gruvbox_improved_warnings          = 1
--    let g:gruvbox_invert_tabline             = 1
--    let g:gruvbox_italic                     = 1
--    let g:gruvbox_italicize_strings          = 1
--
--  ]])
--
--  vim.opt.background = "dark" -- dark / light
--  vim.cmd.colorscheme "gruvbox"
--
--  vim.cmd([[
--
--    highlight Normal ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
--    highlight ColorColumn ctermfg=NONE ctermbg=NONE guibg=NONE guifg=NONE
--    highlight clear SignColumn
--    highlight TabLineFill ctermfg=NONE ctermbg=NONE guibg=NONE guifg=NONE
--    highlight TabLine ctermfg=NONE ctermbg=NONE guibg=NONE guifg=NONE
--    highlight TabLineSel ctermfg=NONE ctermbg=NONE guibg=NONE guifg=NONE
--    highlight StatusLine ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
--
--  ]])
----    highlight Search ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
----    highlight Comment ctermfg=NONE ctermbg=NONE
end


return F
