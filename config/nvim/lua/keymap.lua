local F = {}


function F.setup()

  -- repetitive remaps
  local G_SILENT_NO_REMAP = { silent = true, remap = false }
  local G_NO_REMAP = { silent = false, remap = false }

  -- core remaps
  vim.g.mapleader = " "
  vim.keymap.set("n", " ", "", G_SILENT_NO_REMAP ) -- set leader to space
  vim.keymap.set("n", "Q", "", G_SILENT_NO_REMAP ) -- disable Q to avoid mode

  -- find files
  vim.keymap.set("n", "<LEADER>/", "<cmd>lua require('tele').dirDepthJump(-1)<CR>", G_SILENT_NO_REMAP ) -- search from git root
  vim.keymap.set("n", "<LEADER>?", "<cmd>lua require('tele').dirDepthJump(0)<CR>", G_SILENT_NO_REMAP ) -- search from current
  vim.keymap.set("n", "<LEADER>1/", "<cmd>lua require('tele').dirDepthJump(1)<CR>", G_SILENT_NO_REMAP ) -- search from 1 up
  vim.keymap.set("n", "<LEADER>2/", "<cmd>lua require('tele').dirDepthJump(2)<CR>", G_SILENT_NO_REMAP ) -- search from 2 up
  vim.keymap.set("n", "<LEADER>3/", "<cmd>lua require('tele').dirDepthJump(-2)<CR>", G_SILENT_NO_REMAP ) -- search from cwd

  -- grep string in file
  --vim.keymap.set("n", "<LEADERrr", ":Rg<CR>", G_NO_REMAP ) -- ripgrep current directory
  vim.keymap.set("n", "<LEADER>R", "<cmd>lua require('ripgrepper').grepLevel(-1)<CR>", G_NO_REMAP ) -- grep from git root
  vim.keymap.set("n", "<LEADER>r", "<cmd>lua require('ripgrepper').grepLevel(0)<CR>", G_NO_REMAP ) -- grep from current
  vim.keymap.set("n", "<LEADER>1r", "<cmd>lua require('ripgrepper').grepLevel(1)<CR>", G_NO_REMAP ) -- grep from 1 parent up
  vim.keymap.set("n", "<LEADER>2r", "<cmd>lua require('ripgrepper').grepLevel(2)<CR>", G_NO_REMAP ) -- grep from 2 parent up
  vim.keymap.set("n", "<LEADER>3r", "<cmd>lua require('ripgrepper').grepLevel(-2)<CR>", G_NO_REMAP ) -- grep from cwd

  -- copy word / WORD
  vim.keymap.set("n", "<LEADER>V", 'viw"*yy<ESC>', G_SILENT_NO_REMAP ) -- copy word
  vim.keymap.set("n", "<LEADER>v", 'viW"*yy<ESC>', G_SILENT_NO_REMAP ) -- copy WORD

  -- save and quit override
  --vim.keymap.set("n", "QQ", "<cmd>lua require('buffer').CloseBufferOrVim(0)<CR>", G_SILENT_NO_REMAP ) -- Quit without saving. Buffer aware. Will close 1 buffer at a time.
  vim.keymap.set("n", "QQ", ":call CloseBufferOrVim(0)<CR>", G_SILENT_NO_REMAP ) -- Quit without saving. Buffer aware. Will close 1 buffer at a time.
  vim.keymap.set("n", "ZZ", ":call CloseBufferOrVim(1)<CR>", G_SILENT_NO_REMAP ) -- Save and close
  vim.keymap.set("n", "qQ", ":silent! q!<CR>", G_SILENT_NO_REMAP ) -- Quit regardless of buffers
  vim.keymap.set("n", "zZ", ":wq!<CR>", G_SILENT_NO_REMAP ) -- save and quit

  -- clipboard copy
  vim.keymap.set("n", "<LEADER>8y", ":lua require('reg').toClipboard('/')<CR>", G_SILENT_NO_REMAP ) -- yank to clipboard register
  vim.keymap.set("n", "<LEADER>y", 'mcggVG"*yy<CR>`c', G_SILENT_NO_REMAP ) -- copy everything
  vim.keymap.set("v", "<LEADER>y", '"*yy', G_SILENT_NO_REMAP ) -- copy everything in visual

  -- B KEYS: block manipulation
  vim.keymap.set("n", "<LEADER>ba", "vip<C-v>$A", G_SILENT_NO_REMAP ) -- block insert end
  vim.keymap.set("n", "<LEADER>bb", "vip<C-v>^", G_SILENT_NO_REMAP ) -- block insert begin
  vim.keymap.set("n", "<LEADER>bi", "Vip<C-v>I", G_SILENT_NO_REMAP ) -- block insert end
  vim.keymap.set("n", "<LEADER>bp", "vi{<C-v>^", G_SILENT_NO_REMAP ) -- select { block begin
  vim.keymap.set("n", "<LEADER>bs", "vip:'<,'>sort<CR>", G_SILENT_NO_REMAP ) -- block sort
  vim.keymap.set("n", "<LEADER>bt", "vip:'<,'>Tabularize/=", G_NO_REMAP ) -- tab
  vim.keymap.set("v", "<LEADER>bt", ":Tabularize/=", G_NO_REMAP ) -- tab visual

  -- search and replace
  vim.keymap.set("n", "<LEADER>sc", ":%s///gn<CR>", G_NO_REMAP ) -- search count

  -- buffer 
  --vim.keymap.set("n", "<LEADER>bd", ":bufdo %s//<C-r>./gc<CR>", G_NO_REMAP ) -- repeat replace

  -- https://github.com/kaddkaka/vim_examples/blob/main/README.md#repeat-last-change-in-all-of-file-global-repeat-similar-to-g
  vim.keymap.set("n", "<LEADER>sG", ":%s//<C-r>./gc<CR>", G_NO_REMAP ) -- repeat replace
  vim.keymap.set("n", "<LEADER>sg", ":%s//<C-r>./g<CR>", G_NO_REMAP ) -- repeat replace

  vim.keymap.set("n", "<LEADER>sR", ":%s///gc<LEFT><LEFT><LEFT>", G_NO_REMAP ) -- search and replace with prompt
  vim.keymap.set("n", "<LEADER>sr", ":%s///g<LEFT><LEFT>", G_NO_REMAP ) -- search and replace all
  vim.keymap.set("v", "<LEADER>sR", ":s///gc<LEFT><LEFT><LEFT>", G_NO_REMAP ) -- tab visual
  vim.keymap.set("v", "<LEADER>sr", ":s///g<LEFT><LEFT>", G_NO_REMAP ) -- tab visual

  -- terminal runs
  vim.keymap.set("n", "<C-t>", ":!callterminal.sh '%:p:h' ", G_NO_REMAP )

  -- G KEYS: git commands

  vim.keymap.set("n", "<LEADER>gB", ":!callgitbranch.sh '%:p:h' ", G_NO_REMAP )                -- create branch
  vim.keymap.set("n", "<LEADER>ga", ":Git add %<CR>", G_NO_REMAP )                             -- add current file
  vim.keymap.set("n", "<LEADER>gb", ":!callgitbranch.sh '%:p:h' $(pbpaste) ", G_NO_REMAP )     -- create new branch
  vim.keymap.set("n", "<LEADER>gc", ":Git commit<CR>", G_NO_REMAP )                            -- commit
  vim.keymap.set("n", "<LEADER>gd", ":Git diff<CR>", G_NO_REMAP )                              -- diff
  vim.keymap.set("n", "<LEADER>gl", ":silent !callterminal.sh '%:p:h' glink<CR>", G_NO_REMAP ) -- link
  vim.keymap.set("n", "<LEADER>gm", ":!callgitcheckout.sh '%:p:h' master<CR>", G_NO_REMAP )    -- checkout master
  vim.keymap.set("n", "<LEADER>go", ":!callgitcheckout.sh '%:p:h' ", G_NO_REMAP )              -- checkout a specific branch
  vim.keymap.set("n", "<LEADER>gpul", ":!callgitpull.sh '%:p:h' <CR>", G_NO_REMAP )            -- pull
  vim.keymap.set("n", "<LEADER>gpus", ":!callgitpush.sh '%:p:h' -p '%:p:h'<CR>", G_NO_REMAP )  -- push
  vim.keymap.set("n", "<LEADER>greset", ":!callterminal.sh '%:p:h' greset<CR>", G_NO_REMAP )   -- reset
  vim.keymap.set("n", "<LEADER>gs", ":!callterminal.sh '%:p:h' g<CR>", G_NO_REMAP )            -- status

  -- U KEYS: Utility keys that are infrequently used
  vim.keymap.set("n", "<LEADER>usource", ":source ~/.config/nvim/init.lua<CR>", G_SILENT_NO_REMAP ) -- source file not working as expecting

  --vim.keymap.set("n", "<C-c>", ":call ToggleList(\"Quickfix List\", 'c')<CR>", G_SILENT_NO_REMAP )
  --vim.keymap.set("n", "<C-c>", ":copen<CR>", G_SILENT_NO_REMAP )
  vim.keymap.set("n", "<LEADER>uc", ":call ToggleList(\"Quickfix List\", 'c')<CR>", G_SILENT_NO_REMAP )

  vim.keymap.set("n", "<LEADER>ulz", ":Lazy<CR>", G_NO_REMAP ) -- open Lazy

  -- Lspinfo
  vim.keymap.set("n", "<LEADER>uhealth", ":CheckHealth<CR>", G_NO_REMAP )
  vim.keymap.set("n", "<LEADER>uli", ":LspInfo<CR>", G_NO_REMAP )
  vim.keymap.set("n", "<LEADER>ull", ":LspLog<CR>", G_NO_REMAP )
  vim.keymap.set("n", "<LEADER>uln", ":LspInstall<CR>", G_NO_REMAP )
  vim.keymap.set("n", "<LEADER>ulp", ":LspStop bufnr()<CR>", G_NO_REMAP )
  vim.keymap.set("n", "<LEADER>uml", ":MasonLog<CR>", G_NO_REMAP )
  vim.keymap.set("n", "<LEADER>umn", ":MasonInstall<space>", G_NO_REMAP )
  vim.keymap.set("n", "<LEADER>umu", ":MasonUpdate<CR>", G_NO_REMAP )

  -- buffer navigation
  vim.keymap.set("n", "<C-n>", ":bn<CR>", G_SILENT_NO_REMAP )
  vim.keymap.set("n", "<C-p>", ":bp<CR>", G_SILENT_NO_REMAP )
  vim.keymap.set("n", "<LEADER>==", "gg=G<CR>", G_SILENT_NO_REMAP ) -- format
  vim.keymap.set("n", "<LEADER>bl", ":ls<CR>", G_SILENT_NO_REMAP )
  vim.keymap.set("n", "<LEADER>sort", "mcggVG:sort<CR>`ck<CR>", G_SILENT_NO_REMAP )
  vim.keymap.set("n", "<LEADER>ujson", ":%!/opt/homebrew/bin/python3 -m json.tool<CR>", G_SILENT_NO_REMAP )
  vim.keymap.set("v", "<LEADER>sort", ":sort<CR>", G_SILENT_NO_REMAP )

  -- uploads
  vim.keymap.set("n", "<LEADER>uupcert", ":!callterminal.sh '%:p:h' upcert<CR>", G_NO_REMAP )

  -- visual move
  vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", G_NO_REMAP ) -- cool but like to join on visual mode
  vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", G_NO_REMAP )

  vim.keymap.set("n", "<LEADER>pp", ":PrettierAsync<CR>", G_SILENT_NO_REMAP ) -- prettier

  -- move windows
  -- nmap <LEADER>win :silent !callwin.sh md<CR>
  vim.keymap.set("n", "<LEADER>sx", ":call StripTrailingWhitespaces()<CR>", G_SILENT_NO_REMAP )

  -- markdown visual
  --vim.keymap.set("n", "<LEADER>mc", ":CocCommand markmap.create<CR>", G_SILENT_NO_REMAP ) -- never use
  vim.keymap.set("n", "<LEADER>md", ":MarkdownPreviewToggle<CR>", G_SILENT_NO_REMAP )
  vim.keymap.set("n", "<LEADER>mm", ":CocCommand markmap.watch<CR>", G_SILENT_NO_REMAP )
  vim.keymap.set("n", "<LEADER>mp", ":silent !callpx.sh<SPACE>-v<SPACE>%:p:h<SPACE>%:r<SPACE>", G_NO_REMAP ) -- get screenshot

  ---- wrapped text needs to be seen
  --vim.keymap.set("n", "j", "gj", G_SILENT_NO_REMAP )
  --vim.keymap.set("n", "k", "gk", G_SILENT_NO_REMAP )

  -- oil. directory edits in vim
  vim.keymap.set("n", "<LEADER>-", ":Oil --float<CR>", { desc = "open up" })
  vim.keymap.set("n", "<LEADER>olab", ":Oil --float ~/lab<CR>", { desc = "lab" })
  vim.keymap.set("n", "<LEADER>olua", ":Oil --float ~/.config/nvim/lua<CR>", { desc = "lab" })
  vim.keymap.set("n", "<LEADER>orepo", ":Oil --float ~/lab/repos<CR>", { desc = "repos" })
  vim.keymap.set("n", "<LEADER>oscript", ":Oil --float ~/lab/scripts<CR>", { desc = "Scripts" })

  ---- See `:help vim.diagnostic.*` for documentation on any of the below functions
  --vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
  --vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
  --vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
  --vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

  ---- tmux navigation covered by tmux setting
  --vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", G_SILENT_NO_REMAP )
  --vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", G_SILENT_NO_REMAP )
  --vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", G_SILENT_NO_REMAP )
  --vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", G_SILENT_NO_REMAP )

  -- harpoon shortcuts
  vim.keymap.set("n", "<C-h>", ':lua require("harpoon.ui").nav_next()<CR>', G_SILENT_NO_REMAP ) -- next
  vim.keymap.set("n", "<C-l>", ':lua require("harpoon.ui").nav_prev()<CR>', G_SILENT_NO_REMAP ) -- prev
  vim.keymap.set("n", "<LEADER>ha", ':lua require("harpoon.mark").add_file()<CR>', G_SILENT_NO_REMAP ) -- harpoon add
  vim.keymap.set("n", "<LEADER>hm", ':lua require("harpoon.ui").toggle_quick_menu()<CR>', G_SILENT_NO_REMAP ) -- harpoon menu

  -- telescope to move around
  vim.keymap.set("n", "<LEADER>jbig", ":lua require('tele').dirJump('bigip')<CR>", G_SILENT_NO_REMAP )
  vim.keymap.set("n", "<LEADER>jcert", ":lua require('tele').dirJump('cert')<CR>", G_SILENT_NO_REMAP ) -- forgot why it's important
  vim.keymap.set("n", "<LEADER>jlu", ":lua require('tele').dirJump('lua')<CR>", G_SILENT_NO_REMAP )
  vim.keymap.set("n", "<LEADER>jscript", ":lua require('tele').dirJump('script')<CR>", G_SILENT_NO_REMAP )
  vim.keymap.set("n", "<LEADER>jtm", ":lua require('tele').dirJump('tmuxp')<CR>", G_SILENT_NO_REMAP )
  vim.keymap.set("n", "<LEADER>jirule", ":lua require('tele').dirJump('irules')<CR>", G_SILENT_NO_REMAP )

  -- edits using :next instead of :e to open multiple files
  vim.keymap.set("n", "<LEADER>vidd", ":next ~/lab/repos/edge/dns-internal-dev/zones/paciolan.info.yaml <CR>", G_SILENT_NO_REMAP ) -- dns dev
  vim.keymap.set("n", "<LEADER>virule", ":next ~/lab/repos/irules-engine/modules/download_irule.py <CR>", G_SILENT_NO_REMAP ) -- dns dev
  vim.keymap.set("n", "<LEADER>vidp", ":next ~/lab/repos/nameserver/roles/nsupdate/templates/fwd/db.oc2.evenue.net.j2.zone.fwd ~/lab/repos/edge/dns-internal-prod/zones/oc2.evenue.net.yaml <CR>", G_SILENT_NO_REMAP ) -- dns prod
  vim.keymap.set("n", "<LEADER>vir", ":next ~/.config/nvim/init.lua ~/.config/nvim/lua/keymap.lua <CR>", G_SILENT_NO_REMAP ) -- edit init file
  vim.keymap.set("n", "<LEADER>vipd", ":next ~/lab/repos/edge/public-dns-repo/zones/evenue.net.yaml <CR>", G_SILENT_NO_REMAP ) -- dns public

end

return F
