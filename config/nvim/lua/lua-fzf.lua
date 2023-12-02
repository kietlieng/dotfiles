local F = {}

function F.setup()

  -- do nothing for now

end

return F
--+  vim.api.nvim_create_autocmd('FileType', {
--    group = vim.g.user.event,
--    pattern = 'fzf',
--     callback = fzf_window_setup,
--;    desc = '(fzf.vim) Adjust settings on enter fzf window',
--  })
--.  vim.api.nvim_create_autocmd('ColorScheme', {
--    group = vim.g.user.event,
--    callback = function()
--5      vim.api.nvim_set_hl(0, 'fzf1', { bg = 'NONE' })
--5      vim.api.nvim_set_hl(0, 'fzf2', { bg = 'NONE' })
--5      vim.api.nvim_set_hl(0, 'fzf3', { bg = 'NONE' })
--    end,
--  })
--'  vim.api.nvim_create_autocmd('User', {
--    group = vim.g.user.event,
--    pattern = 'FzfStatusLine',
--    callback = function(args)
--R      vim.wo[vim.fn.bufwinid(args.buf)].statusline = '%#fzf1# > %#fzf2#fz%#fzf3#f'
--    end,
--)    desc = '(fzf.vim) Custom highlights',
--  })
