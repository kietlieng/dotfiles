return {
  'jremmen/vim-ripgrep',
  event = "VeryLazy",
  config = function()

      vim.cmd([[

      let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'
      let g:rg_highlight = 'true'
      let @r = expand('%:p:h') "" need to register r to be set first

      "" command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, { "options": '--delimiter : --nth 4..' }, <bang>0) "" original bang command "" command just searches only current working directory
      "" command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>) . " " . @r, 1, { "options": '--delimiter : --nth 4..' }, <bang>0) "" new bang command that searches the current file directory or register r.  This allows for us to change the register value to whatever we want

      command! -bang -nargs=* Rg call fzf#vim#grep("rg --column -i --context 4 --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>) . " " . @r, 1, { "options": '--delimiter : --nth 4..' }, <bang>0) "" new bang command that searches the current file directory or register r.  This allows for us to change the register value to whatever we want
      ]])

  end
}

