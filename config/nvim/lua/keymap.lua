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
map("n", "*", "*N", G_SILENT_NO_REMAP)               -- search the word under cursor.  Stay where you were instead of jumping to the search term
map("n", "n", ":norm! nzzzv<CR>", G_SILENT_NO_REMAP) -- Search but keep the view centered
map("n", "N", ":norm! Nzzzv<CR>", G_SILENT_NO_REMAP) -- Search but keep the view centered
map("n", "}", ":norm! }k<CR>", G_SILENT_NO_REMAP)    -- Jump to last line of paragraph
map("n", "{", ":norm! {j<CR>", G_SILENT_NO_REMAP)    -- Jump to last line of paragraph

-- find files with fzf

map("n", "<LEADER>/", "<cmd>lua require('custom/fzf').dirDepthJump(0)<CR>", G_SILENT_NO_REMAP)   -- search from current directory
map("n", "<LEADER>-", "<cmd>lua require('custom/fzf').dirDepthJump(-1)<CR>", G_SILENT_NO_REMAP)  -- search from git root directory
map("n", "<LEADER>1-", "<cmd>lua require('custom/fzf').dirDepthJump(-1, 1)<CR>", G_SILENT_NO_REMAP)  -- search 1 level above git root directory
map("n", "<LEADER>2-", "<cmd>lua require('custom/fzf').dirDepthJump(-1, 2)<CR>", G_SILENT_NO_REMAP)  -- search 1 level above git root directory
map("n", "<LEADER>0", "<cmd>lua require('custom/fzf').dirDepthJump(-99)<CR>", G_SILENT_NO_REMAP) -- search from current open file root directory
map("n", "<LEADER>1/", "<cmd>lua require('custom/fzf').dirDepthJump(1)<CR>", G_SILENT_NO_REMAP)  -- search from 1 up
map("n", "<LEADER>2/", "<cmd>lua require('custom/fzf').dirDepthJump(2)<CR>", G_SILENT_NO_REMAP)  -- search from 2 up
map("n", "<LEADER>4/", "<cmd>lua require('custom/fzf').dirDepthJump(-2)<CR>", G_SILENT_NO_REMAP) -- search from cwd
-- map("n", "<LEADER>uu", "<cmd>lua require('custom/fzf').buffers()<CR>", G_SILENT_NO_REMAP)        -- search from current directory

-- grep string in file
--map( "n", "<LEADER>", ":Rg<CR>", G_NO_REMAP ) -- fzf current directory

map("n", "<LEADER>gr", "<cmd>lua require('custom/fzf').grepLevel(0)<CR>", G_NO_REMAP)  -- fuzzy grep cwd
map("n", "<LEADER>ggr", ":lua require('custom/fzf').grepLevel()<LEFT>", G_NO_REMAP)    -- fuzzy grep level up from cwd (default is 1)
map("n", "<LEADER>gR", "<cmd>lua require('custom/fzf').grepLevel(-1)<CR>", G_NO_REMAP) -- fuzzy grep git root

-- live grep means no fuzzy feature.  Most likely not use this
map("n", "<LEADER>Gr", "<cmd>lua require('custom/fzf').liveGrepLevel(0)<CR>", G_NO_REMAP)                  -- live grep cwd
map("n", "<LEADER>GGr", ":lua require('custom/fzf').liveGrepLevel()<LEFT>", G_NO_REMAP) -- live grep level up from cwd (default is 1)
map("n", "<LEADER>GR", "<cmd>lua require('custom/fzf').liveGrepLevel(-1)<CR>", G_NO_REMAP)                 -- live grep git root

-- map("n", "<LEADER>V", 'viw"*y<ESC>', G_SILENT_NO_REMAP)  -- copy word
-- map("n", "<LEADER>v", 'viW"*y<ESC>', G_SILENT_NO_REMAP)  -- copy WORD

-- save and quit override
--map( "n", "QQ", "<cmd>lua require('buffer').CloseBufferOrVim(0)<CR>", G_SILENT_NO_REMAP ) -- Quit without saving. Buffer aware. Will close 1 buffer at a time.

map("n", "QQ", ":call CloseBufferOrVim(0)<CR>", G_SILENT_NO_REMAP) -- Quit without saving. Buffer aware. Will close 1 buffer at a time.
map("n", "ZZ", ":call CloseBufferOrVim(1)<CR>", G_SILENT_NO_REMAP) -- Save and close
map("n", "qQ", ":silent! :qall!<CR>", G_SILENT_NO_REMAP)           -- Quit regardless of buffers
map("n", "zZ", ":wqall!<CR>", G_SILENT_NO_REMAP)                   -- save and quit

-- clipboard copy

map("n", "<LEADER>**", ":lua require('reg').toClipboard('/')<CR>", G_SILENT_NO_REMAP)     -- yank to clipboard register
map("n", "<LEADER>Y", 'mcggVG"*y<CR>`c', G_SILENT_NO_REMAP)                               -- copy everything
-- map("n", "<LEADER>y", ":lua require('custom/select').word()<CR>", G_SILENT_NO_REMAP)      -- copy WORD
map("n", "<LEADER>y", 'mlviW"*y<CR>`l', G_SILENT_NO_REMAP)      -- copy WORD
map("n", "<LEADER>l", 'ml0vg_"*y<CR>`l', G_SILENT_NO_REMAP)                               -- copy current line to clipboard without newline
map("n", "<LEADER>L", ":silent! lua require('custom/select').openLink()<CR>", G_NO_REMAP) -- open url link under cursor
map("v", "<LEADER>y", '"*y', G_SILENT_NO_REMAP)                                           -- copy everything in visual

-- map("n", "<LEADER>d", 'V"*y<CR>dd', G_SILENT_NO_REMAP)                                -- cut to clipboard
-- map("v", "<LEADER>d", '"*ygvd', G_SILENT_NO_REMAP)                                    -- cut to clipboard

map("n", "<LEADER>.", 'mlvg_"*y<CR>`l', G_SILENT_NO_REMAP)                            -- copy current position to end of line to clipboard
map("n", "<LEADER>,", 'mlv^"*y<CR>`l', G_SILENT_NO_REMAP)                             -- copy current position to beginning of line to clipboard

-- read in values from file

map("n", "<LEADER>rt", "<cmd>lua require('custom/fzf').listDir('/tmp')<CR>", G_SILENT_NO_REMAP)                  -- search from git root
map("n", "<LEADER>jj", "<cmd>lua require('custom/fzf').openJumpFiles()<CR>", G_SILENT_NO_REMAP)                   -- Jump script to vim :)
map("n", "<LEADER>jw", "<cmd>lua require('custom/fzf').openWorkingJumpFile()<CR>", G_SILENT_NO_REMAP)             -- Jump script to vim :)

-- fzf to move around

map("n", "<LEADER>jbig", ":lua require('custom/fzf').dirJump('bigip')<CR>", G_SILENT_NO_REMAP)
map("n", "<LEADER>jcert", ":lua require('custom/fzf').dirJump('cert')<CR>", G_SILENT_NO_REMAP)     -- forgot why it's important
map("n", "<LEADER>jlua", ":lua require('custom/fzf').dirJump('lua')<CR>", G_SILENT_NO_REMAP)
map("n", "<LEADER>jrule", ":lua require('custom/fzf').dirJump('irules')<CR>", G_SILENT_NO_REMAP)
map("n", "<LEADER>jscript", ":lua require('custom/fzf').dirJump('script')<CR>", G_SILENT_NO_REMAP)
map("n", "<LEADER>jtm", ":lua require('custom/fzf').dirJump('tmuxp')<CR>", G_SILENT_NO_REMAP)

                                                            -- kl custom

-- map("n", "<C-c>", "ciw", G_SILENT_NO_REMAP)            -- change a word

map("n", "<C-c>", ":ClaudeCode<CR>", G_SILENT_NO_REMAP)     -- change a word
map("n", "<C-y>", "yygccp", G_SILENT_REMAP)                 -- duplicate line and commentout
map("n", "<LEADER>wr", ":set wrap!<CR>", G_SILENT_NO_REMAP) -- set word wrap
map("n", "<LEADER>D", "mcDO<ESC>p`c", G_SILENT_NO_REMAP)    -- delete from current to beginning
map("n", '<LEADER>"', 'mlvi""*y`l', G_SILENT_NO_REMAP)      -- copy within single quotes
map("n", "<LEADER>'", "mlvi'\"*y`l", G_SILENT_NO_REMAP)     -- copy within double quotes
map("n", "<LEADER>(", 'mlvi("*y`l', G_SILENT_NO_REMAP)      -- copy within parenthesis
map("n", "<LEADER>[", 'mlvi["*y`l', G_SILENT_NO_REMAP)      -- copy within parenthesis
                                                            -- map("n", "<LEADER>B", 'mlviB"*y`l', G_SILENT_NO_REMAP) -- copy whole function call
map("n", "<LEADER>p", 'mlvip"*y`l', G_SILENT_NO_REMAP)      -- copy whole block
map("n", "<LEADER>W", 'mlviW"*y`l', G_SILENT_NO_REMAP)      -- copy WORD

-- comment code
-- tips to comment out code use gcc.  Dude this just deleted my comment lua script

map("n", "<LEADER>ba", "mcvip<c-V>$A", G_SILENT_REMAP)                                                                          -- block edit at the end
map("n", "<LEADER>bA", "mcvip<c-V>I", G_SILENT_REMAP)                                                                           -- block edit at the end
map("n", "<LEADER>cc", "mcVgc<CR>`c", G_SILENT_REMAP)                                                                           -- comment out selected normal
map("v", "<LEADER>cc", "mcgc<CR>k`c", G_SILENT_REMAP)                                                                           -- comment out selected visual
map("n", "<LEADER>CC", "mcggVGgc<CR>`c", G_SILENT_REMAP)                                                                        -- global comment
map("v", "<LEADER>CC", ":lua require('custom/comments').comments(false, false, true, true, true)<CR>", G_SILENT_NO_REMAP)       -- global comment invert
map("n", "<LEADER>bc", "mcvipgc<CR>`c", G_SILENT_REMAP)                                                                         -- block comment
map("n", "<LEADER>bC", ":lua require('custom/comments').comments(true, true, false, true, false, true)<CR>", G_SILENT_NO_REMAP) -- select block, comment out invert of block
map("v", "<LEADER>bc", "gc<CR>", G_SILENT_REMAP)                                                                                -- block comment

map("n", "<LEADER>ba", "vip<C-v>$A", G_SILENT_NO_REMAP)                    -- block insert end
map("n", "<LEADER>bb", "vip<C-v>^o", G_SILENT_NO_REMAP)                    -- block
map("n", "<LEADER>bi", "Vip<C-v>I", G_SILENT_NO_REMAP)                     -- block insert beginning
map("n", "<LEADER>bs", "mcvip:'<,'>sort<CR>`c", G_SILENT_NO_REMAP)         -- block sort
map("v", "<LEADER>bs", ":'<,'>sort<CR>", G_SILENT_NO_REMAP)                -- block sort

map("n", "<LEADER>bt", "mcvip:'<,'>Tabularize/=", G_NO_REMAP)       -- table
map("n", "<LEADER>bT", "mcvip:'<,'>Tabularize/=<LEFT>", G_NO_REMAP) -- table. Position at the beginning
map("n", "<LEADER>Bt", "mcvip:'<,'>Tabularize/|", G_NO_REMAP)       -- table visual |
map("n", "<LEADER>BT", "mcvip:'<,'>Tabularize/|<LEFT>", G_NO_REMAP) -- table visual |. Position at beginning

map("v", "<LEADER>bt", ":Tabularize/=", G_NO_REMAP)                 -- table visual =
map("v", "<LEADER>bT", ":Tabularize/=<LEFT>", G_NO_REMAP)           -- table visual =. Position at beginning
map("v", "<LEADER>Bt", ":Tabularize/|", G_NO_REMAP)       -- table visual |
map("v", "<LEADER>BT", ":Tabularize/|<LEFT>", G_NO_REMAP) -- table visual |. Position at beginning

-- search and replace
-- map( "n", "<LEADER>bd", ":bufdo %s//<C-r>./gc<CR>", G_NO_REMAP ) -- repeat replace
-- https://github.com/kaddkaka/vim_examples/blob/main/README.md#repeat-last-change-in-all-of-file-global-repeat-similar-to-g
-- map("n", "<LEADER>sG", ":%s//<C-r>./gc<CR>", G_NO_REMAP)          -- repeat replace from normal mode
-- map("n", "<LEADER>sg", ":%s//<C-r>./g<CR>", G_NO_REMAP)           -- repeat replace from normal mode
-- map("n", "<LEADER>sc", ":%s///gn<CR>", G_NO_REMAP)                -- search count

map("n", "<LEADER>sR", ":%s///gc<LEFT><LEFT><LEFT>", G_NO_REMAP) -- search and replace with prompt
map("n", "<LEADER>sr", ":%s///g<LEFT><LEFT>", G_NO_REMAP)        -- search and replace all
map("v", "<LEADER>sR", ":s///gc<LEFT><LEFT><LEFT>", G_NO_REMAP)  -- tab visual
map("v", "<LEADER>sr", ":s///g<LEFT><LEFT>", G_NO_REMAP)         -- tab visual

map("n", "<LEADER>SR", ":/\\([a-zA-Z0-9\\-\\[\\]\\(\\)_]\\) \\([a-zA-Z0-9\\-\\[\\]\\(\\)_]\\)<CR>", G_NO_REMAP) -- search for spaces in filenames

-- map("n", "<LEADER>su", ":!callterminal '%:p:h'  slackuserscopy l=", G_NO_REMAP)          -- tab visual.  Currently this is not working properly

map("n", "<C-t>", ":!callterminal '%:p:h' ", G_NO_REMAP)  -- terminal runs
map("n", "<C-q>", ":!callterminal '%:p:h' qc ", G_NO_REMAP)  -- terminal runs

-- map("v", "<LEADER>zget", ":'<,'>lua require('custom/zookeeper').zkget()<CR>", G_SILENT_NO_REMAP) -- zk copy
-- map("v", "<LEADER>zget", ':!callzkfetch <C-R>"<ENTER>', G_SILENT_NO_REMAP) -- zk copy
-- map("v", "<LEADER>zg", ":lua require('custom/zookeeper').zkget()<CR>", G_SILENT_NO_REMAP) -- zk copy
-- map("n", "<LEADER>ze", ":lua require('custom/zookeeper').zkenv('')<LEFT><LEFT>", G_SILENT_NO_REMAP) -- zk copy

map("n", "<C-s>", ":silent !callsearchprivate ''<LEFT>", G_NO_REMAP)  -- terminal runs
-- map("n", "<LEADER>tr", ":silent !callsearch ''<LEFT>", G_NO_REMAP)  -- terminal runs
-- map("n", "<LEADER>ts", ":silent !callsearchthesaurus ''<LEFT>", G_NO_REMAP)  -- terminal runs thesaurus

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

-- map( "n", "<C-c>", ":call ToggleList(\"Quickfix List\", 'c')<CR>", G_SILENT_NO_REMAP )
-- map( "n", "<C-c>", ":copen<CR>", G_SILENT_NO_REMAP )
-- map("n", "<LEADER>zc", ":call ToggleList(\"Quickfix List\", 'c')<CR>", G_SILENT_NO_REMAP)

map("n", "<LEADER>OZ", ":Lazy<CR>", G_NO_REMAP) -- open Lazy

-- Lspinfo
map("n", "<LEADER>Ost", ":LspStop bufnr()<CR>", G_NO_REMAP) -- disable lsp
map("n", "<LEADER>Ohealth", ":checkHealth<CR>", G_NO_REMAP)
map("n", "<LEADER>Oinfo", ":LspInfo<CR>", G_NO_REMAP)
map("n", "<LEADER>Olog", ":LspLog<CR>", G_NO_REMAP)
map("n", "<LEADER>Oinstall", ":LspInstall<CR>", G_NO_REMAP)
map("n", "<LEADER>OM", ":Mason<CR>", G_NO_REMAP)
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

map("n", "gV", "`[V`]", G_NO_REMAP)                   -- select what got pasted
map("n", "<LEADER>==", "gg=G<CR>", G_SILENT_NO_REMAP) -- format
--  map("n", "<LEADER>zjson", ":%!/opt/homebrew/opt/python@3.11/libexec/bin/python3 -m json.tool<CR>", G_SILENT_NO_REMAP)
map("n", "<LEADER><SPACE>fjson", ":%!jq<CR>", G_SILENT_NO_REMAP) -- jq format
map("v", "<LEADER><SPACE>fjson", ":!jq<CR>", G_NO_REMAP)         -- jq format

map("n", "<LEADER>sk", ":!callterminal '%:p:h' sk<CR>", G_NO_REMAP)       -- uploads
-- map("n", "<LEADER>Uocto", ":!callterminal '%:p:h' upocto<CR>", G_NO_REMAP)     -- uploads

map("n", "<LEADER><SPACE>alpha", ":set nrformats=bin,hex,alpha<CR>", G_NO_REMAP) -- change incremental alpha
-- map("n", "<LEADER><SPACE>number", ":set nrformats=bin,hex<CR>", G_NO_REMAP)      -- change incremental number: default
map("n", "<LEADER>nu", ":call NumberToggle()<CR>", G_NO_REMAP)      -- change incremental number: default

 -- map("v", "J", ":m '>+1<CR>gv=gv", G_NO_REMAP)                     -- visual move down
 -- map("v", "K", ":m '<-2<CR>gv=gv", G_NO_REMAP)                     -- visual move up
 -- map( "n", "<LEADER>pp", ":PrettierAsync<CR>", G_SILENT_NO_REMAP ) -- prettier
 -- nmap <LEADER>win :silent !callwin md<CR> move windows             -- test

map("n", "<LEADER>xx", ":call StripTrailingWhitespaces()<CR>", G_SILENT_NO_REMAP)

-- marks

map({ "n", "v" }, "<LEADER>mv", "dd`tp``", G_SILENT_NO_REMAP) -- paste to mark t and jump back to last location
map("n", "<LEADER>ml", ":marks<CR>", G_SILENT_NO_REMAP)       -- list marks

-- markdown visual
--map( "n", "<LEADER>mc", ":CocCommand markmap.create<CR>", G_SILENT_NO_REMAP ) -- never use

map("n", "<LEADER>md", ":MarkdownPreviewToggle<CR>", G_SILENT_NO_REMAP)                   -- regular preview
map("n", "<LEADER>mm", ":CocCommand markmap.watch<CR>", G_SILENT_NO_REMAP)                -- mind map
map("n", "<LEADER>mp", ":silent !callterminal '%:p:h' mpx -v '%:p:h' '%:r' ", G_NO_REMAP) -- get screenshot

 -- map("n", "<LEADER>mp", ":!callterminal '%:p:h' mpx -v '%:p:h' '%:r' ", G_NO_REMAP) -- get screenshot
 -- map( "n", "j", "gj", G_SILENT_NO_REMAP )                                           -- wrapped text movement. Be careful the regular j needs to be expressed elsewhere
 -- map( "n", "k", "gk", G_SILENT_NO_REMAP )                                           -- wrapped text movement. Be careful the regular k needs to be expressed elsewhere

-- oil. directory edits in vim
map("n", "<LEADER>oo", ":Oil --float<CR>", { desc = "open up" })
map("n", "<LEADER>olab", ":Oil --float ~/lab<CR>", { desc = "lab" })
map("n", "<LEADER>olua", ":Oil --float ~/.config/nvim/lua<CR>", { desc = "lab" })
map("n", "<LEADER>orepo", ":Oil --float ~/lab/repos<CR>", { desc = "repos" })
map("n", "<LEADER>oscript", ":Oil --float ~/lab/scripts<CR>", { desc = "Scripts" })


map({"n", "v"}, "<leader>oz", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" }) -- 👇 in this section, choose your own keymappings!
-- map("n", "<leader>zc", "<cmd>Yazi cwd<cr>", { desc = "Open the file manager in nvim's working directory" }), -- Open in the current working directory


---- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- map( "n", '<SPACE>e', vim.diagnostic.open_float )
-- map( "n", '<SPACE>q', vim.diagnostic.setloclist )
-- map( "n", '[d', vim.diagnostic.goto_prev )
-- map( "n", ']d', vim.diagnostic.goto_next )

-- edits using :next instead of :e to open multiple files

map("n", "<LEADER>vicomments", ":next ~/.config/nvim/lua/custom/comments.lua <CR>", G_SILENT_NO_REMAP)                                                                                                   -- edit init file
map("n", "<LEADER>vidd", ":next ~/lab/repos/edge/dns-internal-dev/zones/*info.yaml <CR>", G_SILENT_NO_REMAP)                                                                                             -- dns dev
map("n", "<LEADER>vidp", ":next ~/lab/repos/nameserver/roles/nsupdate/templates/fwd/db.oc2.evenue.net.j2.zone.fwd ~/lab/repos/edge/dns-internal-prod/zones/oc2.evenue.net.yaml <CR>", G_SILENT_NO_REMAP) -- dns prod
map("n", "<LEADER>vijob", ":next ~/lab/repos/sre-jobqueue/src/index.js <CR>", G_SILENT_NO_REMAP)                                                                                                         -- dns dev
map("n", "<LEADER>vipd", ":next ~/lab/repos/edge/public-dns-repo/zones/evenue.net.yaml <CR>", G_SILENT_NO_REMAP)                                                                                         -- dns public
map("n", "<LEADER>vipopup", ":next ~/lab/scripts/calls/popup <CR>", G_SILENT_NO_REMAP)                                                                                                                   -- interactive popup
map("n", "<LEADER>vir", ":next ~/.config/nvim/lua/keymap.lua ~/.config/nvim/init.lua <CR>", G_SILENT_NO_REMAP)                                                                                           -- edit init file
map("n", "<LEADER>virule", ":next ~/lab/repos/irules-engine/modules/download_irule.py <CR>", G_SILENT_NO_REMAP)                                                                                          -- dns dev
map("n", "<LEADER>visre", ":next ~/lab/repos/srebot/src/index.js <CR>", G_SILENT_NO_REMAP)                                                                                                               -- dns dev
map("n", "<LEADER>ma", ":MdMath enable<CR>", G_SILENT_NO_REMAP)                                                                                                                                          -- math
map("n", "<LEADER>tt", ":TidalSend<CR>", G_SILENT_NO_REMAP)                                                                                                                                              -- math
map("n", "<LEADER>TT", "mlvip:'<,'>TidalSend<CR>`l", G_SILENT_NO_REMAP)                                                                                                                                  -- math
map("v", "<LEADER>tt", ":'<,'>TidalSend<CR>", G_SILENT_NO_REMAP)                                                                                                                                         -- math
map("n", "<LEADER>td", ":TidalSilence ", G_SILENT_NO_REMAP)                                                                                                                                              -- math
map("n", "<LEADER>th", ":TidalHush<CR>", G_SILENT_NO_REMAP)                                                                                                                                              -- math

-- flash
-- map("n", "<c-s>", "<cmd>lua require('flash').toggle()<CR>", G_NO_REMAP)    -- flash toggle

--  USER <C-w><C-w> to toggle between them
map("n", "<C-k>", ":wincmd k<CR>", G_SILENT_NO_REMAP) -- up
map("n", "<C-j>", ":wincmd j<CR>", G_SILENT_NO_REMAP) -- down
map("n", "<C-l>", ":wincmd l<CR>", G_SILENT_NO_REMAP) -- right
map("n", "<C-h>", ":wincmd h<CR>", G_SILENT_NO_REMAP) -- left

 -- map("n", "<LEADER>wj", ":only<CR>", G_SILENT_NO_REMAP)                                 -- join all windows
 -- map("n", "<LEADER>pt", ":lua require('precognition').toggle()<CR>", G_SILENT_NO_REMAP) -- precog toggle
 -- map("n", "<LEADER>pp", ":lua require('precognition').peek()<CR>", G_SILENT_NO_REMAP)   -- precog peek

--map("n", "<LEADER>gf", vim.lsp.buf.format, {}) -- have no idea what this does right now

map("n", "<LEADER>d", ":lua require('custom/select').bracket()<CR>", G_SILENT_NO_REMAP)    -- select block, comment out invert of block
map("n", "<LEADER>D", ":lua require('custom/select').definition()<CR>", G_SILENT_NO_REMAP) -- select block, comment out invert of block
