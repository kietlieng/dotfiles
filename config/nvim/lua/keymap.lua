local F = {}

function F.setup()

  -- repetitive remaps
  local G_NO_REMAP        = { silent = false, remap = false }
  local G_SILENT_NO_REMAP = { silent = true, remap  = false }
  local map               = vim.keymap.set

  -- core remaps

  vim.g.mapleader = " "

  map("n", " ", "", G_SILENT_NO_REMAP ) -- set leader to space
  map("n", "Q", "", G_SILENT_NO_REMAP ) -- disable Q to avoid mode

  -- find files

  map("n", "<LEADER>/", "<cmd>lua require('tele').dirDepthJump(-1)<CR>", G_SILENT_NO_REMAP )   -- search from git root
  map("n", "<LEADER>?", "<cmd>lua require('tele').dirDepthJump(0)<CR>", G_SILENT_NO_REMAP )    -- search from current
  map("n", "<LEADER>1/", "<cmd>lua require('tele').dirDepthJump(1)<CR>", G_SILENT_NO_REMAP )   -- search from 1 up
  map("n", "<LEADER>2/", "<cmd>lua require('tele').dirDepthJump(2)<CR>", G_SILENT_NO_REMAP )   -- search from 2 up
  map("n", "<LEADER>3/", "<cmd>lua require('tele').dirDepthJump(-2)<CR>", G_SILENT_NO_REMAP )  -- search from cwd

  -- grep string in file
  --map("n", "<LEADERrr", ":Rg<CR>", G_NO_REMAP ) -- ripgrep current directory

  map("n", "<LEADER>R", "<cmd>lua require('ripgrepper').grepLevel(-1)<CR>", G_NO_REMAP )   -- grep from git root
  map("n", "<LEADER>r", "<cmd>lua require('ripgrepper').grepLevel(0)<CR>", G_NO_REMAP )    -- grep from current
  map("n", "<LEADER>1r", "<cmd>lua require('ripgrepper').grepLevel(1)<CR>", G_NO_REMAP )   -- grep from 1 parent up
  map("n", "<LEADER>2r", "<cmd>lua require('ripgrepper').grepLevel(2)<CR>", G_NO_REMAP )   -- grep from 2 parent up
  map("n", "<LEADER>3r", "<cmd>lua require('ripgrepper').grepLevel(-2)<CR>", G_NO_REMAP )  -- grep from cwd

  -- copy word / WORD

  map("n", "<LEADER>V", 'viw"*yy<ESC>', G_SILENT_NO_REMAP ) -- copy word
  map("n", "<LEADER>v", 'viW"*yy<ESC>', G_SILENT_NO_REMAP ) -- copy WORD

  -- save and quit override
  --map("n", "QQ", "<cmd>lua require('buffer').CloseBufferOrVim(0)<CR>", G_SILENT_NO_REMAP ) -- Quit without saving. Buffer aware. Will close 1 buffer at a time.

  map("n", "QQ", ":call CloseBufferOrVim(0)<CR>", G_SILENT_NO_REMAP )  -- Quit without saving. Buffer aware. Will close 1 buffer at a time.
  map("n", "ZZ", ":call CloseBufferOrVim(1)<CR>", G_SILENT_NO_REMAP )  -- Save and close
  map("n", "qQ", ":silent! q!<CR>", G_SILENT_NO_REMAP )                -- Quit regardless of buffers
  map("n", "zZ", ":wq!<CR>", G_SILENT_NO_REMAP )                       -- save and quit

  -- clipboard copy

  map("n", "<LEADER>**", ":lua require('reg').toClipboard('/')<CR>", G_SILENT_NO_REMAP )  -- yank to clipboard register
  map("n", "<LEADER>y", 'mcggVG"*yy<CR>`c', G_SILENT_NO_REMAP )                           -- copy everything
  map("v", "<LEADER>y", '"*yy', G_SILENT_NO_REMAP )                                       -- copy everything in visual

  map("n", "<LEADER>ba", "vip<C-v>$A", G_SILENT_NO_REMAP )         -- block insert end
  map("n", "<LEADER>bb", "vip<C-v>^", G_SILENT_NO_REMAP )          -- block insert begin
  map("n", "<LEADER>bi", "Vip<C-v>I", G_SILENT_NO_REMAP )          -- block insert end
  map("n", "<LEADER>bp", "vi{<C-v>^", G_SILENT_NO_REMAP )          -- select { block begin
  map("n", "<LEADER>bs", "vip:'<,'>sort<CR>", G_SILENT_NO_REMAP )  -- block sort
  map("n", "<LEADER>bt", "vip:'<,'>Tabularize/=", G_NO_REMAP )     -- tab
  map("v", "<LEADER>bt", ":Tabularize/=", G_NO_REMAP )             -- tab visual

  -- search and replace

  map("n", "<LEADER>sc", ":%s///gn<CR>", G_NO_REMAP ) -- search count

  -- buffer
  --map("n", "<LEADER>bd", ":bufdo %s//<C-r>./gc<CR>", G_NO_REMAP ) -- repeat replace

  -- https://github.com/kaddkaka/vim_examples/blob/main/README.md#repeat-last-change-in-all-of-file-global-repeat-similar-to-g

  map("n", "<LEADER>sG", ":%s//<C-r>./gc<CR>", G_NO_REMAP )  -- repeat replace
  map("n", "<LEADER>sg", ":%s//<C-r>./g<CR>", G_NO_REMAP )   -- repeat replace

  map("n", "<LEADER>sR", ":%s///gc<LEFT><LEFT><LEFT>", G_NO_REMAP )  -- search and replace with prompt
  map("n", "<LEADER>sr", ":%s///g<LEFT><LEFT>", G_NO_REMAP )         -- search and replace all
  map("v", "<LEADER>sR", ":s///gc<LEFT><LEFT><LEFT>", G_NO_REMAP )   -- tab visual
  map("v", "<LEADER>sr", ":s///g<LEFT><LEFT>", G_NO_REMAP )          -- tab visual

  -- terminal runs

  map("n", "<C-t>", ":!callterminal '%:p:h' ", G_NO_REMAP )

  -- G KEYS: git commands

  map("n", "<LEADER>gB", ":!callterminal '%:p:h' g ", G_NO_REMAP )                    -- create branch
  map("n", "<LEADER>ga", ":Git add %<CR>", G_NO_REMAP )                               -- add current file
  map("n", "<LEADER>gb", ":!callterminal '%:p:h' g $(pbpaste) ", G_NO_REMAP )         -- create new branch
  map("n", "<LEADER>gc", ":Git commit<CR>", G_NO_REMAP )                              -- commit
  map("n", "<LEADER>gd", ":Git diff<CR>", G_NO_REMAP )                                -- diff
  map("n", "<LEADER>gl", ":silent !callterminal '%:p:h' glink<CR>", G_NO_REMAP )      -- link
  map("n", "<LEADER>gL", ":!callterminalless '%:p:h' glog<CR>", G_NO_REMAP )          -- link
  map("n", "<LEADER>gm", ":!callterminal '%:p:h' g master<CR>", G_NO_REMAP )          -- checkout master
  map("n", "<LEADER>go", ":!callterminal '%:p:h' gco", G_NO_REMAP )                   -- checkout a specific branch
  map("n", "<LEADER>gP", ":!callterminal '%:p:h' gp<CR>", G_NO_REMAP )                -- pull
  map("n", "<LEADER>gp", ":!callterminal '%:p:h' gpush -p '%:p:h'<CR>", G_NO_REMAP )  -- push
  map("n", "<LEADER>greset", ":!callterminal '%:p:h' greset<CR>", G_NO_REMAP )        -- reset
  map("n", "<LEADER>gs", ":!callterminal '%:p:h' g<CR>", G_NO_REMAP )                 -- status

  -- U KEYS: Utility keys that are infrequently used
  map("n", "<LEADER>usource", ":source ~/.config/nvim/init.lua<CR>", G_SILENT_NO_REMAP ) -- source file not working as expecting

  --map("n", "<C-c>", ":call ToggleList(\"Quickfix List\", 'c')<CR>", G_SILENT_NO_REMAP )
  --map("n", "<C-c>", ":copen<CR>", G_SILENT_NO_REMAP )
  map("n", "<LEADER>uc", ":call ToggleList(\"Quickfix List\", 'c')<CR>", G_SILENT_NO_REMAP )

  map("n", "<LEADER>ulz", ":Lazy<CR>", G_NO_REMAP ) -- open Lazy

  -- Lspinfo
  map("n", "<LEADER>uhealth", ":CheckHealth<CR>", G_NO_REMAP )
  map("n", "<LEADER>uli", ":LspInfo<CR>", G_NO_REMAP )
  map("n", "<LEADER>ull", ":LspLog<CR>", G_NO_REMAP )
  map("n", "<LEADER>uln", ":LspInstall<CR>", G_NO_REMAP )
  map("n", "<LEADER>ulp", ":LspStop bufnr()<CR>", G_NO_REMAP )
  map("n", "<LEADER>uml", ":MasonLog<CR>", G_NO_REMAP )
  map("n", "<LEADER>umn", ":MasonInstall<space>", G_NO_REMAP )
  map("n", "<LEADER>umu", ":MasonUpdate<CR>", G_NO_REMAP )

  -- buffer navigation
  map("n", "<C-n>", ":bn<CR>", G_SILENT_NO_REMAP )
  map("n", "<C-p>", ":bp<CR>", G_SILENT_NO_REMAP )
  map("n", "<LEADER>bl", ":ls<CR>", G_SILENT_NO_REMAP )
  map("n", "<LEADER>==", "gg=G<CR>", G_SILENT_NO_REMAP ) -- format
  map("n", "<LEADER>bd", ":bd<CR>", G_SILENT_NO_REMAP )
  map("n", "<LEADER>sort", "mcggVG:sort<CR>`ck<CR>", G_SILENT_NO_REMAP )
  map("n", "<LEADER>ujson", ":%!/opt/homebrew/bin/python3 -m json.tool<CR>", G_SILENT_NO_REMAP )
  map("v", "<LEADER>sort", ":sort<CR>", G_SILENT_NO_REMAP )

  -- uploads
  map("n", "<LEADER>uupcert", ":!callterminal '%:p:h' upcert<CR>", G_NO_REMAP )

  -- visual move
  map("v", "J", ":m '>+1<CR>gv=gv", G_NO_REMAP )
  map("v", "K", ":m '<-2<CR>gv=gv", G_NO_REMAP )

  map("n", "<LEADER>pp", ":PrettierAsync<CR>", G_SILENT_NO_REMAP ) -- prettier

  -- move windows
  -- nmap <LEADER>win :silent !callwin md<CR>
  map("n", "<LEADER>sx", ":call StripTrailingWhitespaces()<CR>", G_SILENT_NO_REMAP )

  -- marks
  map({"n", "v"}, "<LEADER>mv", "dd`tp``", G_SILENT_NO_REMAP ) -- paste to mark t and jump back to last location
  map("n", "<LEADER>ml", ":marks<CR>", G_SILENT_NO_REMAP ) -- list marks


  -- markdown visual
  --map("n", "<LEADER>mc", ":CocCommand markmap.create<CR>", G_SILENT_NO_REMAP ) -- never use
  map("n", "<LEADER>md", ":MarkdownPreviewToggle<CR>", G_SILENT_NO_REMAP )
  map("n", "<LEADER>mm", ":CocCommand markmap.watch<CR>", G_SILENT_NO_REMAP )
  map("n", "<LEADER>mp", ":silent !callpx<SPACE>-v<SPACE>%:p:h<SPACE>%:r<SPACE>", G_NO_REMAP ) -- get screenshot

  ---- wrapped text needs to be seen
  --map("n", "j", "gj", G_SILENT_NO_REMAP )
  --map("n", "k", "gk", G_SILENT_NO_REMAP )

  -- oil. directory edits in vim
  map("n", "<LEADER>-", ":Oil --float<CR>", { desc = "open up" })
  map("n", "<LEADER>olab", ":Oil --float ~/lab<CR>", { desc = "lab" })
  map("n", "<LEADER>olua", ":Oil --float ~/.config/nvim/lua<CR>", { desc = "lab" })
  map("n", "<LEADER>orepo", ":Oil --float ~/lab/repos<CR>", { desc = "repos" })
  map("n", "<LEADER>oscript", ":Oil --float ~/lab/scripts<CR>", { desc = "Scripts" })

  ---- See `:help vim.diagnostic.*` for documentation on any of the below functions
  --map('n', '<space>e', vim.diagnostic.open_float)
  --map('n', '<space>q', vim.diagnostic.setloclist)
  --map('n', '[d', vim.diagnostic.goto_prev)
  --map('n', ']d', vim.diagnostic.goto_next)

  ---- tmux navigation covered by tmux setting
  --map("n", "<C-h>", ":wincmd h<CR>", G_SILENT_NO_REMAP )
  --map("n", "<C-j>", ":wincmd j<CR>", G_SILENT_NO_REMAP )
  --map("n", "<C-k>", ":wincmd k<CR>", G_SILENT_NO_REMAP )
  --map("n", "<C-l>", ":wincmd l<CR>", G_SILENT_NO_REMAP )

  -- harpoon shortcuts

  map("n", "<C-h>", ':lua require("harpoon.ui").nav_next()<CR>', G_SILENT_NO_REMAP )                -- next
  map("n", "<C-l>", ':lua require("harpoon.ui").nav_prev()<CR>', G_SILENT_NO_REMAP )                -- prev
  map("n", "<LEADER>ha", ':lua require("harpoon.mark").add_file()<CR>', G_SILENT_NO_REMAP )         -- harpoon add
  map("n", "<LEADER>hm", ':lua require("harpoon.ui").toggle_quick_menu()<CR>', G_SILENT_NO_REMAP )  -- harpoon menu

  -- telescope to move around

  map("n", "<LEADER>jbig", ":lua require('tele').dirJump('bigip')<CR>", G_SILENT_NO_REMAP )
  map("n", "<LEADER>jcert", ":lua require('tele').dirJump('cert')<CR>", G_SILENT_NO_REMAP ) -- forgot why it's important
  map("n", "<LEADER>jlu", ":lua require('tele').dirJump('lua')<CR>", G_SILENT_NO_REMAP )
  map("n", "<LEADER>jscript", ":lua require('tele').dirJump('script')<CR>", G_SILENT_NO_REMAP )
  map("n", "<LEADER>jtm", ":lua require('tele').dirJump('tmuxp')<CR>", G_SILENT_NO_REMAP )
  map("n", "<LEADER>jirule", ":lua require('tele').dirJump('irules')<CR>", G_SILENT_NO_REMAP )

  -- edits using :next instead of :e to open multiple files

  map("n", "<LEADER>vidd", ":next ~/lab/repos/edge/dns-internal-dev/zones/paciolan.info.yaml <CR>", G_SILENT_NO_REMAP )                                                                                      -- dns dev
  map("n", "<LEADER>virule", ":next ~/lab/repos/irules-engine/modules/download_irule.py <CR>", G_SILENT_NO_REMAP )                                                                                           -- dns dev
  map("n", "<LEADER>vidp", ":next ~/lab/repos/nameserver/roles/nsupdate/templates/fwd/db.oc2.evenue.net.j2.zone.fwd ~/lab/repos/edge/dns-internal-prod/zones/oc2.evenue.net.yaml <CR>", G_SILENT_NO_REMAP )  -- dns prod
  map("n", "<LEADER>vir", ":next ~/.config/nvim/init.lua ~/.config/nvim/lua/keymap.lua <CR>", G_SILENT_NO_REMAP )                                                                                            -- edit init file
  map("n", "<LEADER>vipd", ":next ~/lab/repos/edge/public-dns-repo/zones/evenue.net.yaml <CR>", G_SILENT_NO_REMAP )                                                                                          -- dns public

end

return F
