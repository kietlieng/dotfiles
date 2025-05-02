local F = {}

function F.setup()

  local map = vim.keymap.set
  vim.g.mapleader = " "                                     -- core remaps

  local G_REMAP = { silent = false, remap = true }        -- repetitive remaps.  Remap even if mapped
  local G_SILENT_REMAP = { silent = true, remap = true }  -- repetitive remaps.  Remap even if mapped
  local G_NO_REMAP = { silent = false, remap = false }        -- repetitive remaps
  local G_SILENT_NO_REMAP = { silent = true, remap = false }  -- repetitive remaps

  map("n", " ", "", G_SILENT_NO_REMAP)                 -- set leader to space
  map("n", "Q", "", G_SILENT_NO_REMAP)                 -- disable Q to avoid mode
  map("n", ";", ":", G_SILENT_NO_REMAP)                -- swap for : cause it's easier
  map("n", ":", ";", G_SILENT_NO_REMAP)                -- swap for ; cause I'm not using it often enough
  map("n", "*", "*``", G_SILENT_NO_REMAP)              -- search the word under cursor.  Stay where you were instead of jumping to the search term
  map("n", "n", ":norm! nzzzv<CR>", G_SILENT_NO_REMAP) -- Search but keep the view centered
  map("n", "N", ":norm! Nzzzv<CR>", G_SILENT_NO_REMAP) -- Search but keep the view centered

  -- find files with telescope
  map("n", "<LEADER>/", "<cmd>lua require('tele').dirDepthJump(0)<CR>", G_SILENT_NO_REMAP)      -- search from current directory
  map("n", "<LEADER>-", "<cmd>lua require('tele').dirDepthJump(-1)<CR>", G_SILENT_NO_REMAP)     -- search from git root directory
  map("n", "<LEADER>0", "<cmd>lua require('tele').dirDepthJump(-99)<CR>", G_SILENT_NO_REMAP)    -- search from current open file root directory
  map("n", "<LEADER>1/", "<cmd>lua require('tele').dirDepthJump(1)<CR>", G_SILENT_NO_REMAP)     -- search from 1 up
  map("n", "<LEADER>2/", "<cmd>lua require('tele').dirDepthJump(2)<CR>", G_SILENT_NO_REMAP)     -- search from 2 up
  map("n", "<LEADER>4/", "<cmd>lua require('tele').dirDepthJump(-2)<CR>", G_SILENT_NO_REMAP)    -- search from cwd

  -- grep string in file
  --map( "n", "<LEADER>", ":Rg<CR>", G_NO_REMAP ) -- ripgrep current directory
  map("n", "<LEADER>gr", "<cmd>lua require('ripgrepper').grepLevel(0)<CR>", G_NO_REMAP)    -- grep from current directory
  map("n", "<LEADER>gR", "<cmd>lua require('ripgrepper').grepLevel(-1)<CR>", G_NO_REMAP)   -- grep from git root
  map("n", "<LEADER>1r", "<cmd>lua require('ripgrepper').grepLevel(1)<CR>", G_NO_REMAP)   -- grep from 1 parent up
  map("n", "<LEADER>2r", "<cmd>lua require('ripgrepper').grepLevel(2)<CR>", G_NO_REMAP)   -- grep from 2 parent up
  map("n", "<LEADER>4r", "<cmd>lua require('ripgrepper').grepLevel(-2)<CR>", G_NO_REMAP)  -- grep from cwd

  map("n", "<LEADER>V", 'viw"*y<ESC>', G_SILENT_NO_REMAP)  -- copy word
  map("n", "<LEADER>v", 'viW"*y<ESC>', G_SILENT_NO_REMAP)  -- copy WORD

  -- save and quit override
  --map( "n", "QQ", "<cmd>lua require('buffer').CloseBufferOrVim(0)<CR>", G_SILENT_NO_REMAP ) -- Quit without saving. Buffer aware. Will close 1 buffer at a time.
  map("n", "QQ", ":call CloseBufferOrVim(0)<CR>", G_SILENT_NO_REMAP)  -- Quit without saving. Buffer aware. Will close 1 buffer at a time.
  map("n", "ZZ", ":call CloseBufferOrVim(1)<CR>", G_SILENT_NO_REMAP)  -- Save and close
  map("n", "qQ", ":silent! :qall!<CR>", G_SILENT_NO_REMAP)                -- Quit regardless of buffers
  map("n", "zZ", ":wqall!<CR>", G_SILENT_NO_REMAP)                       -- save and quit

  -- clipboard copy

  map("n", "<LEADER>**", ":lua require('reg').toClipboard('/')<CR>", G_SILENT_NO_REMAP) -- yank to clipboard register
  map("n", "<LEADER>Y", 'mcggVG"*y<CR>`c', G_SILENT_NO_REMAP)                           -- copy everything
  map("n", "<LEADER>y", "mlviWy:lua require('word').word()<CR>`l", G_SILENT_NO_REMAP)   -- copy WORD strip set characters from both ends
  map("n", "<LEADER>l", 'mlV"*y<CR>`l', G_SILENT_NO_REMAP)                              -- copy current line to clipboard
  map("v", "<LEADER>y", '"*y', G_SILENT_NO_REMAP)                                       -- copy everything in visual
  map("n", "<LEADER>d", 'V"*y<CR>dd', G_SILENT_NO_REMAP)                                -- cut to clipboard
  map("v", "<LEADER>d", '"*ygvd', G_SILENT_NO_REMAP)                                    -- cut to clipboard

  map("n", "<LEADER>.", 'mlvg_"*y<CR>`l', G_SILENT_NO_REMAP)                            -- copy current position to end of line to clipboard
  map("n", "<LEADER>,", 'mlv^"*y<CR>`l', G_SILENT_NO_REMAP)                             -- copy current position to beginning of line to clipboard

  -- read in values from file
  map("n", "<LEADER>rt", "<cmd>lua require('lua-fzf').readFiles('tmp')<CR>", G_SILENT_NO_REMAP)     -- search from git root
  map("n", "<LEADER>rr", "<cmd>lua require('lua-fzf').readFiles('')<CR>", G_SILENT_NO_REMAP)     -- search from git root
  map("n", "<LEADER>RR", "<cmd>lua require('lua-fzf').readFiles('currentFileDirectory')<CR>", G_SILENT_NO_REMAP)     -- search from git root
  map("n", "<LEADER>rj", "<cmd>lua require('lua-fzf').readJumpFiles()<CR>", G_SILENT_NO_REMAP)     -- search from git root

  map("n", "<LEADER>jj", "<cmd>lua require('lua-fzf').openJumpFiles()<CR>", G_SILENT_NO_REMAP)     -- Jump script to vim :) 
  map("n", "<LEADER>jw", "<cmd>lua require('lua-fzf').openWorkingJumpFile()<CR>", G_SILENT_NO_REMAP)     -- Jump script to vim :) 

  map("n", "<C-c>", "ciw", G_SILENT_NO_REMAP) -- change a word
  map("n", "<C-y>", "yygccp", G_SILENT_REMAP) -- duplicate line and commentout
  map("n", "<LEADER>wr", ":set wrap!<CR>", G_SILENT_NO_REMAP) -- zk copy

  ----- comment code
  -- tips to comment out code use gcc.  Dude this just deleted my comment lua script

  map("n", "<LEADER>cc", "mcVgc<CR>`c", G_SILENT_REMAP)                                                                     -- comment out selected normal
  map("v", "<LEADER>cc", "mcgc<CR>k`c", G_SILENT_REMAP)                                                                     -- comment out selected visual
  map("n", "<LEADER>CC", "mcggVGgc<CR>`c", G_SILENT_REMAP)                                                                  -- global comment
  map("n", "<LEADER>CU", ":lua require('comments').comments(false, true, true, false, false)<CR>", G_SILENT_NO_REMAP)       -- glubal uncomment invert
  map("v", "<LEADER>CC", ":lua require('comments').comments(false, false, true, true, true)<CR>", G_SILENT_NO_REMAP)        -- global comment invert
  map("n", "<LEADER>bc", "mcvipgc<CR>`c", G_SILENT_REMAP)                                                                   -- block comment
  map("n", "<LEADER>bC", ":lua require('comments').comments(true, true, false, true, false, true)<CR>", G_SILENT_NO_REMAP)  -- select block, comment out invert of block
  map("n", "<LEADER>bU", ":lua require('comments').comments(true, true, false, false, false, true)<CR>", G_SILENT_NO_REMAP) -- select block, uncomment invert of block
  map("v", "<LEADER>bc", ":lua require('comments').comments(false, false, false, true, true)<CR>", G_SILENT_NO_REMAP)       -- block comment invert

  map("n", "<LEADER>ba", "vip<C-v>$A", G_SILENT_NO_REMAP)             -- block insert end
  map("n", "<LEADER>bb", "vip<C-v>^o", G_SILENT_NO_REMAP)             -- block
  map("n", "<LEADER>bi", "Vip<C-v>I", G_SILENT_NO_REMAP)              -- block insert beginning
  map("n", "<LEADER>bs", "mcvip:'<,'>sort<CR>`c", G_SILENT_NO_REMAP)  -- block sort
  map("n", "<LEADER>bt", "mcvip:'<,'>Tabularize/=", G_NO_REMAP)       -- table
  map("n", "<LEADER>bT", "mcvip:'<,'>Tabularize/=<LEFT>", G_NO_REMAP) -- table. Position at the beginning
  map("v", "<LEADER>bt", ":Tabularize/=", G_NO_REMAP)                 -- table visual
  map("v", "<LEADER>bT", ":Tabularize/=<LEFT>", G_NO_REMAP)           -- table visual. Position at beginning

  -- search and replace
  --map( "n", "<LEADER>bd", ":bufdo %s//<C-r>./gc<CR>", G_NO_REMAP ) -- repeat replace
  -- https://github.com/kaddkaka/vim_examples/blob/main/README.md#repeat-last-change-in-all-of-file-global-repeat-similar-to-g
  -- map("n", "<LEADER>sG", ":%s//<C-r>./gc<CR>", G_NO_REMAP)          -- repeat replace from normal mode
  -- map("n", "<LEADER>sg", ":%s//<C-r>./g<CR>", G_NO_REMAP)           -- repeat replace from normal mode
  -- map("n", "<LEADER>sc", ":%s///gn<CR>", G_NO_REMAP)                -- search count

  map("n", "<LEADER>sR", ":%s///gc<LEFT><LEFT><LEFT>", G_NO_REMAP) -- search and replace with prompt
  map("n", "<LEADER>sr", ":%s///g<LEFT><LEFT>", G_NO_REMAP)        -- search and replace all
  map("v", "<LEADER>sR", ":s///gc<LEFT><LEFT><LEFT>", G_NO_REMAP)  -- tab visual
  map("v", "<LEADER>sr", ":s///g<LEFT><LEFT>", G_NO_REMAP)         -- tab visual

  map("n", "<LEADER>su", ":!callterminal '%:p:h'  slackuserscopy l=", G_NO_REMAP)          -- tab visual

  map("n", "<C-t>", ":!callterminal '%:p:h' ", G_NO_REMAP)  -- terminal runs

--  map("v", "<LEADER>zget", ":'<,'>lua require('zookeeper').zkget()<CR>", G_SILENT_NO_REMAP) -- zk copy
--  map("v", "<LEADER>zget", ':!callzkfetch <C-R>"<ENTER>', G_SILENT_NO_REMAP) -- zk copy
  map("v", "<LEADER>zg", ":lua require('zookeeper').zkget()<CR>", G_SILENT_NO_REMAP) -- zk copy
  map("n", "<LEADER>ze", ":lua require('zookeeper').zkenv('')<LEFT><LEFT>", G_SILENT_NO_REMAP) -- zk copy

  map("n", "<C-s>", ":silent !callsearchprivate ''<LEFT>", G_NO_REMAP)  -- terminal runs
  map("n", "<LEADER>tr", ":silent !callsearch ''<LEFT>", G_NO_REMAP)  -- terminal runs
  map("n", "<LEADER>ts", ":silent !callsearchthesaurus ''<LEFT>", G_NO_REMAP)  -- terminal runs thesaurus

  -- G KEYS: git commands

  -- git conventions: [Gg][action]
  -- g: git
  -- G: CAPITAL G means do the command and push 
  -- example:
  --   - ga: add current file
  --   - Ga: add current file, commit and push
  --   - GA: add all, commit and push
  --   - gc: git commit message
  --   - Gc: git commit message and push
-- map("n", "<LEADER>gd", ":Git diff<CR>", G_NO_REMAP)                            -- diff

  map("n", "<LEADER>gn", ":GitGutterNextHunk<CR>", G_NO_REMAP)                                               -- next githunk
  map("n", "<LEADER>Gp", ":GitGutterPreviousHunk<CR>", G_NO_REMAP)                                           -- next githunk
  map("n", "<LEADER>gB", ":!callterminal '%:p:h' g ", G_NO_REMAP)                                            -- create branch
                                                                                                             -- map("n", "<LEADER>gl", ":!callterminalless '%:p:h' glog<CR>", G_NO_REMAP)   -- git log but it's not working out for me
  map("n", "<LEADER>gl", ":silent !callterminal '%:p:h' glink<CR>", G_NO_REMAP)                              -- link
  map("n", "<LEADER>gpull", ":!callterminal '%:p:h' gp<CR>", G_NO_REMAP)                                     -- pull
  map("n", "<LEADER>ga", ":Git add %<CR>", G_NO_REMAP)                                                       -- add current file
  map("n", "<LEADER>Ga", ':lua require("taskrunner").gitAddCommentAndPush(\'\')<LEFT><LEFT>', G_NO_REMAP)    -- Add, commit and push
  map("n", "<LEADER>GA", ':lua require("taskrunner").gitAddAllCommentAndPush(\'\')<LEFT><LEFT>', G_NO_REMAP) -- Add, commit and push
  map("n", "<LEADER>gb", ":!callterminal '%:p:h' g $(pbpaste) ", G_NO_REMAP)                                 -- create new branch
  map("n", "<LEADER>gc", ":Git commit<CR>", G_NO_REMAP)                                                      -- commit
  map("n", "<LEADER>Gc", ":!callterminal2count '%:p:h' gcpush ''<LEFT>", G_NO_REMAP)                         -- commit and push
  map("n", "<LEADER>gs", ":!callterminal2count '%:p:h' gcpushs ''<LEFT>", G_NO_REMAP)                        -- commit and push silent
  map("n", "<LEADER>gm", ":!callterminal '%:p:h' g master<CR>", G_NO_REMAP)                                  -- checkout master
                                                                                                             -- map("n", "<LEADER>gco", ":!callterminal '%:p:h' gco", G_NO_REMAP)           -- checkout a specific branch
  map("n", "<LEADER>gp", ":!callterminal '%:p:h' gpush -p '%:p:h'<CR>", G_NO_REMAP)                          -- push
  map("n", "<LEADER>gP", ":!callterminal '%:p:h' gpushs -p '%:p:h'<CR>", G_NO_REMAP)                         -- push silent
                                                                                                             -- map("n", "<LEADER>greset", ":!callterminal '%:p:h' greset<CR>", G_NO_REMAP) -- reset
  map("n", "<LEADER>G", ":!callterminal '%:p:h' g<CR>", G_NO_REMAP)                                          -- status
  map("n", "<LEADER>gA", ":G<CR>/Unstaged<CR>j", G_NO_REMAP)                                                 -- staging chunks
                                                                                                             -- Select file then >
                                                                                                             -- Add chunk via visual mode select
                                                                                                             -- s to add chunk

  -- U KEYS: Utility keys that are infrequently used

  map("n", "<LEADER><SPACE>source", ":source ~/.config/nvim/init.lua<CR>", G_SILENT_NO_REMAP) -- source file not working as expecting
  map("n", "<LEADER>sp", ":%!cat -s<CR>", G_SILENT_NO_REMAP)                                  -- trim mulitple consecutive lines to one
  map("v", "<LEADER>sp", ":'<,'>!cat -s<CR>", G_SILENT_NO_REMAP)                              -- trim multiple consecutive lines to one

  --map( "n", "<C-c>", ":call ToggleList(\"Quickfix List\", 'c')<CR>", G_SILENT_NO_REMAP )
  --map( "n", "<C-c>", ":copen<CR>", G_SILENT_NO_REMAP )
  map("n", "<LEADER>zc", ":call ToggleList(\"Quickfix List\", 'c')<CR>", G_SILENT_NO_REMAP)

  map("n", "<LEADER>Olz", ":Lazy<CR>", G_NO_REMAP) -- open Lazy

  -- Lspinfo
  map("n", "<LEADER>Ost", ":LspStop bufnr()<CR>", G_NO_REMAP) -- disable lsp
  map("n", "<LEADER>Ohealth", ":checkHealth<CR>", G_NO_REMAP)
  map("n", "<LEADER>Oinfo", ":LspInfo<CR>", G_NO_REMAP)
  map("n", "<LEADER>Olog", ":LspLog<CR>", G_NO_REMAP)
  map("n", "<LEADER>Oinstall", ":LspInstall<CR>", G_NO_REMAP)
  map("n", "<LEADER>Oma", ":Mason<CR>", G_NO_REMAP)
  map("n", "<LEADER>Oml", ":MasonLog<CR>", G_NO_REMAP)
  map("n", "<LEADER>Omi", ":MasonInstall<SPACE>", G_NO_REMAP)
  map("n", "<LEADER>Omu", ":MasonUpdate<CR>", G_NO_REMAP)

  -- map("n", "<C-b>", ":b#<CR>", G_SILENT_NO_REMAP) -- switch back to previous buffer
  map("n", "<C-n>", ":bn<CR>", G_SILENT_NO_REMAP)      -- buffer next
  map("n", "<C-p>", ":bp<CR>", G_SILENT_NO_REMAP)      -- buffer previous
  map("n", "<LEADER>bd", ":bd<CR>", G_SILENT_NO_REMAP) -- buffer delete
  map("n", "<LEADER>bl", ":ls<CR>", G_SILENT_NO_REMAP) -- buffer list

  map("n", "<LEADER>ss", "mcggVG:sort<CR>`ck<CR>", G_SILENT_NO_REMAP) -- sort
  map("v", "<LEADER>ss", ":sort<CR>", G_SILENT_NO_REMAP)              -- sort

  map("n", "<LEADER>ff", "mcvi{c<CR><CR><CR><UP><UP><ESC>p<CR>vi{:'<,'>!cat -s<CR>`c<DOWN>", G_SILENT_NO_REMAP)                         -- format the function
  map("n", "<LEADER>FF", "mcvi{c<CR><CR><CR><UP><UP><ESC>p<CR>vi{:'<,'>!cat -s<CR>`c<DOWN><DOWN>vip:'<,'>Tabularize/=<CR>", G_NO_REMAP) -- format the function and paragraph
  map("n", "<LEADER>fblack", "mc:%!black - -q<CR>`c", G_SILENT_NO_REMAP)                                                                -- python format stytle black

  map("n", "gV", "`[V`]", G_NO_REMAP)  -- select what got pasted
  map("n", "<LEADER>==", "gg=G<CR>", G_SILENT_NO_REMAP) -- format
--  map("n", "<LEADER>zjson", ":%!/opt/homebrew/opt/python@3.11/libexec/bin/python3 -m json.tool<CR>", G_SILENT_NO_REMAP)
  map("n", "<LEADER><SPACE>fjson", ":%!jq<CR>", G_SILENT_NO_REMAP)  -- jq format
  map("v", "<LEADER><SPACE>fjson", ":!jq<CR>", G_NO_REMAP)             -- jq format 

  map("n", "<LEADER>uad", ":!callterminal '%:p:h' upad21<CR>", G_NO_REMAP)       -- uploads
  map("n", "<LEADER>ucert", ":!callterminal '%:p:h' upcert<CR>", G_NO_REMAP)     -- uploads
  map("n", "<LEADER>uocto", ":!callterminal '%:p:h' upocto<CR>", G_NO_REMAP)     -- uploads
  map("n", "<LEADER>udot", ":!callterminal '%:p:h' cpdot<CR>", G_NO_REMAP)       -- uploads syncdot
  map("n", "<LEADER>umedia", ":!callterminal '%:p:h' upmedia<CR>", G_NO_REMAP)   -- uploads syncdot
  map("n", "<LEADER>upmedia", ":!callterminal '%:p:h' uppmedia<CR>", G_NO_REMAP) -- uploads syncdot
  map("n", "<LEADER>upi", ":!callterminal '%:p:h' upivanti<CR>", G_NO_REMAP)     -- uploads syncdot

  map("n", "<LEADER><SPACE>alpha", ":set nrformats=bin,hex,alpha<CR>", G_NO_REMAP) -- change incremental alpha
  -- map("n", "<LEADER><SPACE>number", ":set nrformats=bin,hex<CR>", G_NO_REMAP)      -- change incremental number: default
  map("n", "<LEADER>nu", ":call NumberToggle()<CR>", G_NO_REMAP)      -- change incremental number: default

--  map("v", "J", ":m '>+1<CR>gv=gv", G_NO_REMAP)                               -- visual move down
--  map("v", "K", ":m '<-2<CR>gv=gv", G_NO_REMAP)                               -- visual move up


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
  map("n", "<LEADER>mp", ":silent !callterminal '%:p:h' mpx -v '%:p:h' '%:r' ", G_NO_REMAP)  -- get screenshot

  --map( "n", "j", "gj", G_SILENT_NO_REMAP ) -- wrapped text movement. Be careful the regular j needs to be expressed elsewhere
  --map( "n", "k", "gk", G_SILENT_NO_REMAP ) -- wrapped text movement. Be careful the regular k needs to be expressed elsewhere

  -- oil. directory edits in vim
  map("n", "<LEADER>oo", ":Oil --float<CR>", { desc = "open up" })
  map("n", "<LEADER>olab", ":Oil --float ~/lab<CR>", { desc = "lab" })
  map("n", "<LEADER>olua", ":Oil --float ~/.config/nvim/lua<CR>", { desc = "lab" })
  map("n", "<LEADER>orepo", ":Oil --float ~/lab/repos<CR>", { desc = "repos" })
  map("n", "<LEADER>oscript", ":Oil --float ~/lab/scripts<CR>", { desc = "Scripts" })


  map({"n", "v"}, "<leader>oz", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" }) -- 👇 in this section, choose your own keymappings!
  -- map("n", "<leader>zc", "<cmd>Yazi cwd<cr>", { desc = "Open the file manager in nvim's working directory" }), -- Open in the current working directory


  ---- See `:help vim.diagnostic.*` for documentation on any of the below functions

  --map( "n", '<SPACE>e', vim.diagnostic.open_float )
  --map( "n", '<SPACE>q', vim.diagnostic.setloclist )
  --map( "n", '[d', vim.diagnostic.goto_prev )
  --map( "n", ']d', vim.diagnostic.goto_next )

  -- telescope to move around
  map("n", "<LEADER>jbig", ":lua require('tele').dirJump('bigip')<CR>", G_SILENT_NO_REMAP)
  map("n", "<LEADER>jcert", ":lua require('tele').dirJump('cert')<CR>", G_SILENT_NO_REMAP) -- forgot why it's important
  map("n", "<LEADER>jlua", ":lua require('tele').dirJump('lua')<CR>", G_SILENT_NO_REMAP)
  map("n", "<LEADER>jrule", ":lua require('tele').dirJump('irules')<CR>", G_SILENT_NO_REMAP)
  map("n", "<LEADER>jscript", ":lua require('tele').dirJump('script')<CR>", G_SILENT_NO_REMAP)
  map("n", "<LEADER>jtm", ":lua require('tele').dirJump('tmuxp')<CR>", G_SILENT_NO_REMAP)

  -- edits using :next instead of :e to open multiple files
  map("n", "<LEADER>vicomments", ":next ~/.config/nvim/lua/comments.lua <CR>", G_SILENT_NO_REMAP)  -- edit init file
  map("n", "<LEADER>vidd", ":next ~/lab/repos/edge/dns-internal-dev/zones/*info.yaml <CR>", G_SILENT_NO_REMAP) -- dns dev
  map("n", "<LEADER>vidp", ":next ~/lab/repos/nameserver/roles/nsupdate/templates/fwd/db.oc2.evenue.net.j2.zone.fwd ~/lab/repos/edge/dns-internal-prod/zones/oc2.evenue.net.yaml <CR>", G_SILENT_NO_REMAP)                                                                                                               -- dns prod
  map("n", "<LEADER>vijob", ":next ~/lab/repos/sre-jobqueue/src/index.js <CR>", G_SILENT_NO_REMAP) -- dns dev
  map("n", "<LEADER>vipd", ":next ~/lab/repos/edge/public-dns-repo/zones/evenue.net.yaml <CR>", G_SILENT_NO_REMAP) -- dns public
  map("n", "<LEADER>vipopup", ":next ~/lab/scripts/calls/popup <CR>", G_SILENT_NO_REMAP) -- interactive popup
  map("n", "<LEADER>vir", ":next ~/.config/nvim/lua/keymap.lua ~/.config/nvim/init.lua <CR>", G_SILENT_NO_REMAP)  -- edit init file
  map("n", "<LEADER>virule", ":next ~/lab/repos/irules-engine/modules/download_irule.py <CR>", G_SILENT_NO_REMAP) -- dns dev
  map("n", "<LEADER>visre", ":next ~/lab/repos/srebot/src/index.js <CR>", G_SILENT_NO_REMAP) -- dns dev

  map("n", "<LEADER>nre", ":set rnu!<CR>", G_SILENT_NO_REMAP) -- math
  map("n", "<LEADER>ma", ":MdMath enable<CR>", G_SILENT_NO_REMAP) -- math

  -- flash 
  --map("n", "<c-s>", "<cmd>lua require('flash').toggle()<CR>", G_NO_REMAP)    -- flash toggle

--  USER <C-w><C-w> to toggle between them
--  map("n", "<C-k>", ":wincmd k<CR>", G_SILENT_NO_REMAP) -- up
--  map("n", "<C-j>", ":wincmd j<CR>", G_SILENT_NO_REMAP) -- down
--  map("n", "<C-l>", ":wincmd l<CR>", G_SILENT_NO_REMAP) -- right 
--  map("n", "<C-h>", ":wincmd h<CR>", G_SILENT_NO_REMAP) -- left

--  map("n", "<LEADER>wj", ":only<CR>", G_SILENT_NO_REMAP) -- join all windows

--  map("n", "<LEADER>pt", ":lua require('precognition').toggle()<CR>", G_SILENT_NO_REMAP) -- precog toggle
--  map("n", "<LEADER>pp", ":lua require('precognition').peek()<CR>", G_SILENT_NO_REMAP)   -- precog peek

  --map("n", "<LEADER>gf", vim.lsp.buf.format, {})                                                                  -- have no idea what this does right now

  -- gitlab duo
  ---- Toggle Code Suggestions on/off with CTRL-g in normal mode:
--  map('n', '<LEADER>du', '<Plug>(GitLabToggleCodeSuggestions)')

end

return F
