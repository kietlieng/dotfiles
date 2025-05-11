require('settings')
require('keymap').setup()                           -- key mapping

local set = vim.opt

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end

set.rtp:prepend(lazypath)


---@type LazySpec
local plugins = 'plugins'

-- lazystart
require('lazy').setup(plugins, {

   ui = { border = 'rounded' },
   dev = { path = vim.g.projects_dir },
   install = {
       -- Do not automatically install on startup.
       missing = true,
   },
   -- Don't bother me when tweaking plugins.
   change_detection = {
     notify = false
   },
   -- None of my plugins use luarocks so disable this.
   rocks = {
       enabled = false,
   },
   performance = {
       rtp = {
           -- Stuff I don't use.
           disabled_plugins = {
              'block',
              -- 'harpoon',
           },
       },
   },

})

----- LAZY END -----

-- AUTO COMMANDS BEGIN

-- vim.api.nvim_create_autocmd({'TextChanged', 'textChangedI'}, { pattern = '<buffer>', command = 'silent update' })  -- doesn't work all the time only on first buffer
vim.api.nvim_create_autocmd( { 'BufNewFile', 'BufRead' }, { pattern = '*.md', command = 'call NotePreview()', })      -- run the watch command when detecting markup
vim.api.nvim_create_autocmd( { 'VimEnter' }, { pattern = '*', command = ':normal zz' })

vim.api.nvim_create_autocmd( { 'BufWinEnter' }, -- disable yaml if buf path has the following
  { pattern = { '*.yaml', '*.yml' },
  callback = function()

    local bufferRepo = vim.fn.expand('%:p')

    --vim.api.nvim_out_write(bufferRepo .. "\n") -- debug

    -- if you find it shut it down
    if (string.find(bufferRepo, "dns%-internal%-dev")) or
       (string.find(bufferRepo, "public%-dns%-repo")) or
       (string.find(bufferRepo, "dns%-internal%-prod")) then

      vim.cmd(':LspStop ' .. vim.fn.bufnr('%'))

    end
  end,

  }

)

-- AUTO COMMANDS END

-- COMMAND BEGIN

vim.cmd([[

  augroup highlight_follows_focus
    autocmd!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
  augroup END

  augroup highligh_follows_vim
    autocmd!
    autocmd FocusGained * set cursorline
    autocmd FocusLost * set nocursorline
  augroup END

  ""g:fzf_vim.listproc = { list -> fzf#vim#listproc#quickfix(list) } "" currently not working

  "" Remember / Return to last edit position when opening files (You want this!)
  autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

  let g:loaded_perl_provider = 0  "" disable perl from checkhealth

  function! GetBufferList()
    redir =>buflist
    silent! ls!
    redir END
    return buflist
  endfunction

  function! ToggleList(bufname, pfx)
    let buflist = GetBufferList()
    for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
      if bufwinnr(bufnum) != -1
        exec(a:pfx.'close')
        return
      endif
    endfor
    if a:pfx == 'l' && len(getloclist(0)) == 0
        echohl ErrorMsg
        echo "Location List is Empty."
        return
    endif
    let winnr = winnr()
    exec(a:pfx.'open')
    if winnr() != winnr
      wincmd p
    endif
  endfunction

  " reposition the windows correctly
  function! NotePreview()
      let l:filename=tolower(expand('%:r'))
      let l:filePath=tolower(expand('%:p:h'))
      let l:previewing=0

      "" not in meetings / notes / not a license or have a '-no'
      if (stridx(l:filePath, 'lab/meetings') == -1) && (stridx(l:filePath, 'lab/notes') == -1)
          if stridx(l:filename, 'readme') > -1 || stridx(l:filename, 'license') > -1 || stridx(l:filename, '-no') > -1
              "":echo "Do nothing"
          elseif stridx(l:filename, '-mm') > -1
              "" preview mind map
              let l:previewing=1
              :CocCommand markmap.watch
              :AsyncRun callkittyfocus.sh
          else " preview markdown
              let l:previewing=1
              :MarkdownPreview
              :AsyncRun callkittyfocus.sh
          endif
      endif

      ":silent !callwin.sh md " reposition windows to reading
      ":silent !callopenbook.sh '%:r' " find the book and open it
      " :) I love this! Runs in the background with no hesitations whatsoever
      " requires asyncrun plugin
      if (l:previewing)
          :AsyncRun callopenbook.sh '%:r'
      endif

  endfunction

  function! StripTrailingWhitespaces()
      let l = line(".")
      let c = col(".")
      %s/\s\+$//e
      call cursor(l, c)
  endfunction

  function! CloseBufferOrVim(saveFirst)

    "" if more than 1 buffer close the current buffer only. Otherwise close vim
    if (len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1)
      if a:saveFirst == 1
        "" to avoid git commit window issue
        :w
        :bw
      else
        :bd!
      endif
    else
      if a:saveFirst == 1
        :wq!
      else
        :q!
      endif
    endif

  endfunction

  function! NumberToggle()

    if(&relativenumber == 1 && &number == 1)
      set number
      set norelativenumber
    elseif (&number == 1 && &relativenumber == 0)
      set number
      set relativenumber
    endif

  endfunc


  autocmd BufNewFile,BufRead * if &syntax == '' | set syntax=yaml | endif "" make syntax yaml if no syntax is found

  ""nnoremap <LEADER>R :Ack!<SPACE> -- don't actually like this command does not work properly
  ""autocmd BufWritePre * call StripTrailingWhitespaces() "" doesn't work with oil remap manually
  ""autocmd BufWritePre * call SaveIt() "" doesn't work with oil remap manually

]])
-- COMMAND END

--require('autosave-unnamed').setup()                  -- setup snippet engine
require('snippet-luasnip').setup()                  -- setup snippet engine
require("luasnip.loaders.from_vscode").lazy_load()  -- lead friendly-snippets support into luasnip
require('mason-setup').setup()                      -- setup syntax for treesitter
require('lsp-setup').setup()                        -- setup all lsp
require('keymap').setup()                           -- key mapping
--require('fun').setup()                            -- useless but fun

-- theme setup

--require('theme-darkvoid').setup()                 -- needs to be last
--require('theme-onedarkpro').setup()               -- needs to be last
--require('theme-mellow').setup()                   -- needs to be last
--require('theme-everforest').setup()                   -- needs to be last
require('theme-gruvbox').setup()                  -- needs to be last

