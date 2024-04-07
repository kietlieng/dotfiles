local F = {}

function F.setup()

  local map = vim.keymap.set
  vim.g.mapleader = " "                                     -- core remaps

  local G_NO_REMAP = { silent = false, remap = false }        -- repetitive remaps
  local G_SILENT_NO_REMAP = { silent = true, remap = false }  -- repetitive remaps

  map("n", " ", "", G_SILENT_NO_REMAP)   -- set leader to space
  map("n", "Q", "", G_SILENT_NO_REMAP)   -- disable Q to avoid mode
  map("n", ";", ":", G_SILENT_NO_REMAP)  -- swap for : cause it's easier
  map("n", ":", ";", G_SILENT_NO_REMAP)  -- swap for ; cause I'm not using it often enough

  -- find files with telescope
  map("n", "<LEADER>/", "<cmd>lua require('tele').dirDepthJump(-1)<CR>", G_SILENT_NO_REMAP)   -- search from git root
  map("n", "<LEADER>?", "<cmd>lua require('tele').dirDepthJump(0)<CR>", G_SILENT_NO_REMAP)    -- search from current
  map("n", "<LEADER>1/", "<cmd>lua require('tele').dirDepthJump(1)<CR>", G_SILENT_NO_REMAP)   -- search from 1 up
  map("n", "<LEADER>2/", "<cmd>lua require('tele').dirDepthJump(2)<CR>", G_SILENT_NO_REMAP)   -- search from 2 up
  map("n", "<LEADER>4/", "<cmd>lua require('tele').dirDepthJump(-2)<CR>", G_SILENT_NO_REMAP)  -- search from cwd

  -- grep string in file
  --map( "n", "<LEADER>", ":Rg<CR>", G_NO_REMAP ) -- ripgrep current directory
  map("n", "<LEADER>R", "<cmd>lua require('ripgrepper').grepLevel(-1)<CR>", G_NO_REMAP)   -- grep from git root
  map("n", "<LEADER>r", "<cmd>lua require('ripgrepper').grepLevel(0)<CR>", G_NO_REMAP)    -- grep from current
  map("n", "<LEADER>1r", "<cmd>lua require('ripgrepper').grepLevel(1)<CR>", G_NO_REMAP)   -- grep from 1 parent up
  map("n", "<LEADER>2r", "<cmd>lua require('ripgrepper').grepLevel(2)<CR>", G_NO_REMAP)   -- grep from 2 parent up
  map("n", "<LEADER>4r", "<cmd>lua require('ripgrepper').grepLevel(-2)<CR>", G_NO_REMAP)  -- grep from cwd

  map("n", "<LEADER>V", 'viw"*y<ESC>', G_SILENT_NO_REMAP)  -- copy word
  map("n", "<LEADER>v", 'viW"*y<ESC>', G_SILENT_NO_REMAP)  -- copy WORD

  -- save and quit override
  --map( "n", "QQ", "<cmd>lua require('buffer').CloseBufferOrVim(0)<CR>", G_SILENT_NO_REMAP ) -- Quit without saving. Buffer aware. Will close 1 buffer at a time.
  map("n", "QQ", ":call CloseBufferOrVim(0)<CR>", G_SILENT_NO_REMAP)  -- Quit without saving. Buffer aware. Will close 1 buffer at a time.
  map("n", "ZZ", ":call CloseBufferOrVim(1)<CR>", G_SILENT_NO_REMAP)  -- Save and close
  map("n", "qQ", ":silent! q!<CR>", G_SILENT_NO_REMAP)                -- Quit regardless of buffers
  map("n", "zZ", ":wq!<CR>", G_SILENT_NO_REMAP)                       -- save and quit

  -- clipboard copy
  map("n", "<LEADER>**", ":lua require('reg').toClipboard('/')<CR>", G_SILENT_NO_REMAP)        -- yank to clipboard register
  map("n", "<LEADER>Y", 'mcggVG"*y<CR>`c', G_SILENT_NO_REMAP)                                  -- copy everything
  map("n", "<LEADER>y", "mlviWy:lua require('word').word()<CR>`l", G_SILENT_NO_REMAP)  -- copy WORD strip set characters from both ends
  map("v", "<LEADER>y", '"*y', G_SILENT_NO_REMAP)                                              -- copy everything in visual
  map("n", "<LEADER>d", 'V"*y<CR>dd', G_SILENT_NO_REMAP)                                       -- cut to clipboard
  map("v", "<LEADER>d", '"*ygvd', G_SILENT_NO_REMAP)                                           -- cut to clipboard

  ----- comment code
  -- function F.comments(aRegular, aNormalMode, aAll, aCommentOut, aInvert, aBuffer)
  -- map( "n", "<LEADER>fn", ":lua require('comments').next()<CR>", G_SILENT_NO_REMAP )                         -- test search function
  map("n", "<LEADER>cc", ":lua require('comments').comments(true, true, false, true, false)<CR>", G_SILENT_NO_REMAP)    -- comment out selected normal
  map("v", "<LEADER>cc", ":lua require('comments').comments(true, false, false, true, false)<CR>", G_SILENT_NO_REMAP)   -- comment out selected visual
  map("n", "<LEADER>cu", ":lua require('comments').comments(true, true, false, false, false)<CR>", G_SILENT_NO_REMAP)   -- uncomment out selected normal
  map("v", "<LEADER>cu", ":lua require('comments').comments(true, false, false, false, false)<CR>", G_SILENT_NO_REMAP)  -- uncomment out selected visual

  map("n", "<LEADER>CC", ":lua require('comments').comments(false, true, true, true, false)<CR>", G_SILENT_NO_REMAP)   -- global comment
  map("n", "<LEADER>CU", ":lua require('comments').comments(false, true, true, false, false)<CR>", G_SILENT_NO_REMAP)  -- glubal uncomment
  map("v", "<LEADER>CC", ":lua require('comments').comments(false, false, true, true, true)<CR>", G_SILENT_NO_REMAP)   -- global comment invert

  map("n", "<LEADER>bc", ":lua require('comments').comments(false, true, false, true, false)<CR>", G_SILENT_NO_REMAP)        -- block comment
  map("n", "<LEADER>bC", ":lua require('comments').comments(true, true, false, true, false, true)<CR>", G_SILENT_NO_REMAP)   -- select block, comment out invert of block
  map("n", "<LEADER>bu", ":lua require('comments').comments(false, true, false, false, false)<CR>", G_SILENT_NO_REMAP)       -- block uncomment
  map("n", "<LEADER>bU", ":lua require('comments').comments(true, true, false, false, false, true)<CR>", G_SILENT_NO_REMAP)  -- select block, uncomment invert of block
  map("v", "<LEADER>bc", ":lua require('comments').comments(false, false, false, true, true)<CR>", G_SILENT_NO_REMAP)        -- block comment invert

  -- block manipulation
  map("n", "<LEADER>ba", "vip<C-v>$A", G_SILENT_NO_REMAP)         -- block insert end
  map("n", "<LEADER>bb", "vip<C-v>^o", G_SILENT_NO_REMAP)         -- block
  map("n", "<LEADER>bi", "Vip<C-v>I", G_SILENT_NO_REMAP)          -- block insert begining
  map("n", "<LEADER>bs", "vip:'<,'>sort<CR>", G_SILENT_NO_REMAP)  -- block sort
  map("n", "<LEADER>bt", "vip:'<,'>Tabularize/=", G_NO_REMAP)     -- table
  map("v", "<LEADER>bt", ":Tabularize/=", G_NO_REMAP)             -- table visual

  -- search and replace
  --map( "n", "<LEADER>bd", ":bufdo %s//<C-r>./gc<CR>", G_NO_REMAP ) -- repeat replace
  -- https://github.com/kaddkaka/vim_examples/blob/main/README.md#repeat-last-change-in-all-of-file-global-repeat-similar-to-g
  map("n", "<LEADER>sG", ":%s//<C-r>./gc<CR>", G_NO_REMAP)          -- repeat replace from normal mode
  map("n", "<LEADER>sg", ":%s//<C-r>./g<CR>", G_NO_REMAP)           -- repeat replace from normal mode
  map("n", "<LEADER>sc", ":%s///gn<CR>", G_NO_REMAP)                -- search count
  map("n", "<LEADER>sR", ":%s///gc<LEFT><LEFT><LEFT>", G_NO_REMAP)  -- search and replace with prompt
  map("n", "<LEADER>sr", ":%s///g<LEFT><LEFT>", G_NO_REMAP)         -- search and replace all
  map("v", "<LEADER>sR", ":s///gc<LEFT><LEFT><LEFT>", G_NO_REMAP)   -- tab visual
  map("v", "<LEADER>sr", ":s///g<LEFT><LEFT>", G_NO_REMAP)          -- tab visual

  map("n", "<C-t>", ":!callterminal '%:p:h' ", G_NO_REMAP)  -- terminal runs

  -- G KEYS: git commands

  -- git
-- map("n", "<LEADER>gd", ":Git diff<CR>", G_NO_REMAP)                            -- diff

  map("n", "<LEADER>gn", ":GitGutterNextHunk<CR>", G_NO_REMAP)                        -- next githunk
  map("n", "<LEADER>gB", ":!callterminal '%:p:h' g ", G_NO_REMAP)                     -- create branch
  map("n", "<LEADER>gl", ":!callterminalless '%:p:h' glog<CR>", G_NO_REMAP)           -- link
  map("n", "<LEADER>gpull", ":!callterminal '%:p:h' gp<CR>", G_NO_REMAP)              -- pull
  map("n", "<LEADER>ga", ":Git add %<CR>", G_NO_REMAP)                                -- add current file
  map("n", "<LEADER>gb", ":!callterminal '%:p:h' g $(pbpaste) ", G_NO_REMAP)          -- create new branch
  map("n", "<LEADER>gc", ":Git commit<CR>", G_NO_REMAP)                               -- commit
  map("n", "<LEADER>gC", ":!callterminal2count '%:p:h' gcpush ''<LEFT>", G_NO_REMAP)  -- commit and push
  map("n", "<LEADER>gs", ":!callterminal2count '%:p:h' gcpushs ''<LEFT>", G_NO_REMAP) -- commit and push silent
  map("n", "<LEADER>glink", ":silent !callterminal '%:p:h' glink<CR>", G_NO_REMAP)    -- link
  map("n", "<LEADER>gm", ":!callterminal '%:p:h' g master<CR>", G_NO_REMAP)           -- checkout master
  map("n", "<LEADER>gco", ":!callterminal '%:p:h' gco", G_NO_REMAP)                   -- checkout a specific branch
  map("n", "<LEADER>gp", ":!callterminal '%:p:h' gpush -p '%:p:h'<CR>", G_NO_REMAP)   -- push
  map("n", "<LEADER>gP", ":!callterminal '%:p:h' gpushs -p '%:p:h'<CR>", G_NO_REMAP)  -- push silent
  map("n", "<LEADER>greset", ":!callterminal '%:p:h' greset<CR>", G_NO_REMAP)         -- reset
  map("n", "<LEADER>G", ":!callterminal '%:p:h' g<CR>", G_NO_REMAP)                   -- status

  map("n", "<LEADER>gA", ":G<CR>/Unstaged<CR>j", G_NO_REMAP) -- staging chunks
                                                             -- Select file then >
                                                             -- Add chunk via visual mode select
                                                             -- s to add chunk

  -- U KEYS: Utility keys that are infrequently used
  map("n", "<LEADER><SPACE>source", ":source ~/.config/nvim/init.lua<CR>", G_SILENT_NO_REMAP)  -- source file not working as expecting
  map("n", "<LEADER><SPACE>sp", ":%!cat -s<CR>", G_SILENT_NO_REMAP)                             -- trim mulitple consecutive lines to one
  map("v", "<LEADER><SPACE>sp", "'<,'>! cat -s<CR>", G_SILENT_NO_REMAP)                         -- trim multiple consecutive lines to one

  --map( "n", "<C-c>", ":call ToggleList(\"Quickfix List\", 'c')<CR>", G_SILENT_NO_REMAP )
  --map( "n", "<C-c>", ":copen<CR>", G_SILENT_NO_REMAP )
  map("n", "<LEADER>zc", ":call ToggleList(\"Quickfix List\", 'c')<CR>", G_SILENT_NO_REMAP)

  map("n", "<LEADER>zlz", ":Lazy<CR>", G_NO_REMAP) -- open Lazy

  -- Lspinfo
  map("n", "<LEADER>p", ":LspStop bufnr()<CR>", G_NO_REMAP) -- disable lsp
  map("n", "<LEADER>zhealth", ":CheckHealth<CR>", G_NO_REMAP)
  map("n", "<LEADER>zli", ":LspInfo<CR>", G_NO_REMAP)
  map("n", "<LEADER>zll", ":LspLog<CR>", G_NO_REMAP)
  map("n", "<LEADER>zln", ":LspInstall<CR>", G_NO_REMAP)
  map("n", "<LEADER>zml", ":MasonLog<CR>", G_NO_REMAP)
  map("n", "<LEADER>zmn", ":MasonInstall<SPACE>", G_NO_REMAP)
  map("n", "<LEADER>zmu", ":MasonUpdate<CR>", G_NO_REMAP)

  map("n", "<C-n>", ":bn<CR>", G_SILENT_NO_REMAP)       -- buffer next
  map("n", "<C-p>", ":bp<CR>", G_SILENT_NO_REMAP)       -- buffer previous
  map("n", "<LEADER>bd", ":bd<CR>", G_SILENT_NO_REMAP)  -- buffer delete
  map("n", "<LEADER>bl", ":ls<CR>", G_SILENT_NO_REMAP)  -- buffer list

  map("n", "<LEADER>ss", "mcggVG:sort<CR>`ck<CR>", G_SILENT_NO_REMAP)
  map("v", "<LEADER>ss", ":sort<CR>", G_SILENT_NO_REMAP)

  map("n", "<LEADER>==", "gg=G<CR>", G_SILENT_NO_REMAP) -- format
--  map("n", "<LEADER>zjson", ":%!/opt/homebrew/opt/python@3.11/libexec/bin/python3 -m json.tool<CR>", G_SILENT_NO_REMAP)
  map("n", "<LEADER><SPACE>json", ":%!jq<CR>", G_SILENT_NO_REMAP)  -- jq format
  map("v", "<LEADER><SPACE>json", ":!jq<CR>", G_NO_REMAP)             -- jq format 

  map("n", "<LEADER><SPACE>ad", ":!callterminal '%:p:h' upad21<CR>", G_NO_REMAP) -- uploads
  map("n", "<LEADER><SPACE>cert", ":!callterminal '%:p:h' upcert<CR>", G_NO_REMAP) -- uploads
  map("n", "<LEADER><SPACE>octo", ":!callterminal '%:p:h' upocto<CR>", G_NO_REMAP) -- uploads
  map("n", "<LEADER><SPACE>syncdot", ":!callterminal '%:p:h' syncdot<CR>", G_NO_REMAP) -- uploads

  map("n", "<LEADER><SPACE>alpha", ":set nrformats=bin,hex,alpha<CR>", G_NO_REMAP)  -- change incremental alpha
  map("n", "<LEADER><SPACE>number", ":set nrformats=bin,hex<CR>", G_NO_REMAP)       -- change incremental number: default

  map("v", "J", ":m '>+1<CR>gv=gv", G_NO_REMAP)                               -- visual move down
  map("v", "K", ":m '<-2<CR>gv=gv", G_NO_REMAP)                               -- visual move up


  --map( "n", "<LEADER>pp", ":PrettierAsync<CR>", G_SILENT_NO_REMAP ) -- prettier

  -- nmap <LEADER>win :silent !callwin md<CR> move windows

  map("n", "<LEADER>sx", ":call StripTrailingWhitespaces()<CR>", G_SILENT_NO_REMAP)

  -- marks
  map({ "n", "v" }, "<LEADER>mv", "dd`tp``", G_SILENT_NO_REMAP) -- paste to mark t and jump back to last location
  map("n", "<LEADER>ml", ":marks<CR>", G_SILENT_NO_REMAP)      -- list marks

  -- markdown visual
  --map( "n", "<LEADER>mc", ":CocCommand markmap.create<CR>", G_SILENT_NO_REMAP ) -- never use
  map("n", "<LEADER>md", ":MarkdownPreviewToggle<CR>", G_SILENT_NO_REMAP)                      -- regular preview
  map("n", "<LEADER>mm", ":CocCommand markmap.watch<CR>", G_SILENT_NO_REMAP)                   -- mind map
--  map("n", "<LEADER>mp", ":silent !callpx<SPACE>-v<SPACE>%:p:h<SPACE>%:r<SPACE>", G_NO_REMAP)  -- get screenshot
  map("n", "<LEADER>mp", ":silent !callterminal '%:p:h' mpx -v '%:p:h' '%:r' ", G_NO_REMAP)  -- get screenshot

  --map( "n", "j", "gj", G_SILENT_NO_REMAP ) -- wrapped text movement. Be careful the regular j needs to be expressed elsewhere
  --map( "n", "k", "gk", G_SILENT_NO_REMAP ) -- wrapped text movement. Be careful the regular k needs to be expressed elsewhere

  -- oil. directory edits in vim
  map("n", "<LEADER>o<SPACE>", ":Oil --float<CR>", { desc = "open up" })
  map("n", "<LEADER>olab", ":Oil --float ~/lab<CR>", { desc = "lab" })
  map("n", "<LEADER>olua", ":Oil --float ~/.config/nvim/lua<CR>", { desc = "lab" })
  map("n", "<LEADER>orepo", ":Oil --float ~/lab/repos<CR>", { desc = "repos" })
  map("n", "<LEADER>oscript", ":Oil --float ~/lab/scripts<CR>", { desc = "Scripts" })

  ---- See `:help vim.diagnostic.*` for documentation on any of the below functions

  --map( "n", '<SPACE>e', vim.diagnostic.open_float )
  --map( "n", '<SPACE>q', vim.diagnostic.setloclist )
  --map( "n", '[d', vim.diagnostic.goto_prev )
  --map( "n", ']d', vim.diagnostic.goto_next )

  --map( "n", "<C-h>", ":wincmd h<CR>", G_SILENT_NO_REMAP ) -- tmux navigation covered by tmux setting
  --map( "n", "<C-j>", ":wincmd j<CR>", G_SILENT_NO_REMAP ) -- tmux navigation covered by tmux setting
  --map( "n", "<C-k>", ":wincmd k<CR>", G_SILENT_NO_REMAP ) -- tmux navigation covered by tmux setting
  --map( "n", "<C-l>", ":wincmd l<CR>", G_SILENT_NO_REMAP ) -- tmux navigation covered by tmux setting

  -- harpoon shortcuts
  map("n", "<C-h>", ':lua require( "harpoon.ui").nav_next()<CR>', G_SILENT_NO_REMAP)                -- next
  map("n", "<C-l>", ':lua require( "harpoon.ui").nav_prev()<CR>', G_SILENT_NO_REMAP)                -- prev
  map("n", "<LEADER>ha", ':lua require( "harpoon.mark").add_file()<CR>', G_SILENT_NO_REMAP)         -- harpoon add
  map("n", "<LEADER>hm", ':lua require( "harpoon.ui").toggle_quick_menu()<CR>', G_SILENT_NO_REMAP)  -- harpoon menu

  -- telescope to move around
  map("n", "<LEADER>jbig", ":lua require('tele').dirJump('bigip')<CR>", G_SILENT_NO_REMAP)
  map("n", "<LEADER>jcert", ":lua require('tele').dirJump('cert')<CR>", G_SILENT_NO_REMAP) -- forgot why it's important
  map("n", "<LEADER>jlua", ":lua require('tele').dirJump('lua')<CR>", G_SILENT_NO_REMAP)
  map("n", "<LEADER>jscript", ":lua require('tele').dirJump('script')<CR>", G_SILENT_NO_REMAP)
  map("n", "<LEADER>jtm", ":lua require('tele').dirJump('tmuxp')<CR>", G_SILENT_NO_REMAP)
  map("n", "<LEADER>jrule", ":lua require('tele').dirJump('irules')<CR>", G_SILENT_NO_REMAP)

  -- edits using :next instead of :e to open multiple files
  --map( "n", "<LEADER>vidp", ":next ~/lab/repos/nameserver/roles/nsupdate/templates/fwd/db.oc2.evenue.net.j2.zone.fwd ~/lab/repos/edge/dns-internal-prod/zones/oc2.evenue.net.yaml <CR>", G_SILENT_NO_REMAP )  -- dns prod
  map( "n", "<LEADER>vidp", ":next ~/lab/repos/nameserver/roles/nsupdate/templates/fwd/db.oc2.evenue.net.j2.zone.fwd ~/lab/repos/edge/dns-internal-prod/zones/oc2.evenue.net.yaml <CR>", G_SILENT_NO_REMAP)                                                                                                               -- dns prod
  map("n", "<LEADER>vicomments", ":next ~/.config/nvim/lua/comments.lua <CR>", G_SILENT_NO_REMAP)  -- edit init file
  map("n", "<LEADER>vidd", ":next ~/lab/repos/edge/dns-internal-dev/zones/paciolan.info.yaml <CR>", G_SILENT_NO_REMAP) -- dns dev
  map("n", "<LEADER>vipd", ":next ~/lab/repos/edge/public-dns-repo/zones/evenue.net.yaml <CR>", G_SILENT_NO_REMAP) -- dns public
  map("n", "<LEADER>vir", ":next ~/.config/nvim/lua/keymap.lua ~/.config/nvim/init.lua <CR>", G_SILENT_NO_REMAP)  -- edit init file
  map("n", "<LEADER>vrule", ":next ~/lab/repos/irules-engine/modules/download_irule.py <CR>", G_SILENT_NO_REMAP) -- dns dev

  --map("n", "<LEADER>gf", vim.lsp.buf.format, {})                                                                  -- have no idea what this does right now
end

return F
