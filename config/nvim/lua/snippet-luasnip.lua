-- https://dev.to/rishavmngo/how-to-setup-lsp-in-neovim-nh1
-- https://github-wiki-see.page/m/neovim/nvim-lspconfig/wiki/Snippets

local F = {}

function F.setup()

  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local cmp = require("cmp")
  local ls  = require("luasnip")

  local choice   = ls.choice_node
  local dynamicn = ls.dynamic_node
  local func     = ls.function_node
  local insert   = ls.insert_node
  local node     = ls.snippet_node
  local snip     = ls.snippet
  local text     = ls.text_node

  local function dateShift(argShiftYear, argShiftMonth, argShiftDay) -- date shift
    local currentDate = os.date("*t", os.time())
    local endtime = os.time({year = currentDate.year + argShiftYear, month = currentDate.month + argShiftMonth, day = currentDate.day + argShiftDay})
    return { os.date("%y-%m-%d", endtime) }
  end


  local function nextWeekday(argDayofTheWeek)
    local currentDate = os.date("*t", os.time())
    local dayOffset = 1
    local endTime = os.time({year = currentDate.year, month = currentDate.month, day = currentDate.day})

    while(dayOffset < 8)
    do
      endTime = os.time({year = currentDate.year, month = currentDate.month, day = currentDate.day + dayOffset})

      if tonumber(endTime.wday) == tonumber(argDayOfTheWeek) then
        break
      end
    end

    return { os.date("%y-%m-%d", endTime) }
  end


  cmp.setup({

    mapping = cmp.mapping.preset.insert({

      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--      ["<Tab>"] = cmp.mapping(function(fallback) -- cycle through suggestions via tab
--         if cmp.visible() then
--           cmp.select_next_item()
--         elseif luasnip.expand_or_jumpable() then
--           luasnip.expand_or_jump()
--         elseif has_words_before() then
--           cmp.complete()
--         else
--           fallback()
--         end
--      end, { "i", "s" }),
--      ["<S-Tab>"] = cmp.mapping(function(fallback)
--        if cmp.visible() then
--          cmp.select_prev_item()
--        elseif luasnip.jumpable(-1) then
--          luasnip.jump(-1)
--        else
--          fallback()
--        end
--      end, { "i", "s" }),
    }),

    snippet = {

      expand = function(args)

        if not ls then
          return
        end

        ls.lsp_expand(args.body)

      end,

    },

    window = {

      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),

    },
    sources = cmp.config.sources({

      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
      { name = "nvim_lua" },
      { name = "luasnip", option = { show_autosnippets = true } },
      { name = "path" },

    },
    {
      { name = "buffer", keyword_length = 3 },
    }),

  })

  ls.add_snippets(nil, {

    all = {

      -- days of the week
      snip({ trig = "nextmonday" }, { func( function() return nextWeekday(1) end, {}), }),

      -- update day
      snip({ trig = "today" }, { func( function() return dateShift(0, 0, 0) end, {}), }),
      snip({ trig = "day1" }, { func( function() return dateShift(0, 0, 1) end, {}), }),
      snip({ trig = "day2" }, { func( function() return dateShift(0, 0, 2) end, {}), }),
      snip({ trig = "day3" }, { func( function() return dateShift(0, 0, 3) end, {}), }),
      snip({ trig = "day3" }, { func( function() return dateShift(0, 0, 3) end, {}), }),
      snip({ trig = "day4" }, { func( function() return dateShift(0, 0, 4) end, {}), }),
      snip({ trig = "day5" }, { func( function() return dateShift(0, 0, 5) end, {}), }),
      snip({ trig = "day6" }, { func( function() return dateShift(0, 0, 6) end, {}), }),
      snip({ trig = "day7" }, { func( function() return dateShift(0, 0, 7) end, {}), }),
      snip({ trig = "day8" }, { func( function() return dateShift(0, 0, 8) end, {}), }),
      snip({ trig = "day9" }, { func( function() return dateShift(0, 0, 9) end, {}), }),
      snip({ trig = "day10" }, { func( function() return dateShift(0, 0, 10) end, {}), }),
      snip({ trig = "day11" }, { func( function() return dateShift(0, 0, 11) end, {}), }),
      snip({ trig = "day12" }, { func( function() return dateShift(0, 0, 12) end, {}), }),
      snip({ trig = "day13" }, { func( function() return dateShift(0, 0, 13) end, {}), }),
      snip({ trig = "day14" }, { func( function() return dateShift(0, 0, 14) end, {}), }),
      snip({ trig = "day15" }, { func( function() return dateShift(0, 0, 15) end, {}), }),
      snip({ trig = "day16" }, { func( function() return dateShift(0, 0, 16) end, {}), }),
      snip({ trig = "day17" }, { func( function() return dateShift(0, 0, 17) end, {}), }),
      snip({ trig = "day18" }, { func( function() return dateShift(0, 0, 18) end, {}), }),
      snip({ trig = "day19" }, { func( function() return dateShift(0, 0, 19) end, {}), }),
      snip({ trig = "day20" }, { func( function() return dateShift(0, 0, 20) end, {}), }),
      snip({ trig = "day21" }, { func( function() return dateShift(0, 0, 21) end, {}), }),
      snip({ trig = "day22" }, { func( function() return dateShift(0, 0, 22) end, {}), }),
      snip({ trig = "day23" }, { func( function() return dateShift(0, 0, 23) end, {}), }),
      snip({ trig = "day24" }, { func( function() return dateShift(0, 0, 24) end, {}), }),
      snip({ trig = "day25" }, { func( function() return dateShift(0, 0, 25) end, {}), }),
      snip({ trig = "day26" }, { func( function() return dateShift(0, 0, 26) end, {}), }),
      snip({ trig = "day27" }, { func( function() return dateShift(0, 0, 27) end, {}), }),
      snip({ trig = "day28" }, { func( function() return dateShift(0, 0, 28) end, {}), }),
      snip({ trig = "day29" }, { func( function() return dateShift(0, 0, 29) end, {}), }),
      snip({ trig = "day30" }, { func( function() return dateShift(0, 0, 30) end, {}), }),
      snip({ trig = "day31" }, { func( function() return dateShift(0, 0, 31) end, {}), }),

      -- month
      snip({ trig = "month" }, { func( function() return dateShift(0, 0, 0) end, {}), }),
      snip({ trig = "month1" }, { func( function() return dateShift(0, 1, 0) end, {}), }),
      snip({ trig = "month2" }, { func( function() return dateShift(0, 2, 0) end, {}), }),
      snip({ trig = "month3" }, { func( function() return dateShift(0, 3, 0) end, {}), }),
      snip({ trig = "month4" }, { func( function() return dateShift(0, 4, 0) end, {}), }),
      snip({ trig = "month5" }, { func( function() return dateShift(0, 5, 0) end, {}), }),
      snip({ trig = "month6" }, { func( function() return dateShift(0, 6, 0) end, {}), }),
      snip({ trig = "month7" }, { func( function() return dateShift(0, 7, 0) end, {}), }),
      snip({ trig = "month8" }, { func( function() return dateShift(0, 8, 0) end, {}), }),
      snip({ trig = "month9" }, { func( function() return dateShift(0, 9, 0) end, {}), }),
      snip({ trig = "month10" }, { func( function() return dateShift(0, 10, 0) end, {}), }),
      snip({ trig = "month11" }, { func( function() return dateShift(0, 11, 0) end, {}), }),
      snip({ trig = "month12" }, { func( function() return dateShift(0, 12, 0) end, {}), }),

      -- year
      snip({ trig = "year" }, { func( function() return dateShift(0, 0, 0) end, {}), }),
      snip({ trig = "year1" }, { func( function() return dateShift(1, 0, 0) end, {}), }),
      snip({ trig = "year2" }, { func( function() return dateShift(2, 0, 0) end, {}), }),
      snip({ trig = "year3" }, { func( function() return dateShift(3, 0, 0) end, {}), }),
      snip({ trig = "year4" }, { func( function() return dateShift(4, 0, 0) end, {}), }),
      snip({ trig = "year5" }, { func( function() return dateShift(5, 0, 0) end, {}), }),
      snip({ trig = "year6" }, { func( function() return dateShift(6, 0, 0) end, {}), }),
      snip({ trig = "year7" }, { func( function() return dateShift(7, 0, 0) end, {}), }),
      snip({ trig = "year8" }, { func( function() return dateShift(8, 0, 0) end, {}), }),
      snip({ trig = "year9" }, { func( function() return dateShift(9, 0, 0) end, {}), }),
      snip({ trig = "year10" }, { func( function() return dateShift(10, 0, 0) end, {}), }),
      snip({ trig = "year15" }, { func( function() return dateShift(15, 0, 0) end, {}), }),
      snip({ trig = "year20" }, { func( function() return dateShift(20, 0, 0) end, {}), }),
      snip({ trig = "year25" }, { func( function() return dateShift(25, 0, 0) end, {}), }),
      snip({ trig = "year30" }, { func( function() return dateShift(30, 0, 0) end, {}), }),

      snip({ trig = "argloop", namr = "argloop", dscr = "Create while loop" },
      {

        text({

          "local modeSome=''",
          "local someTarget='.*'",
          "local key=''",
          "",
          "while [[ $# -gt 0 ]]; do",
          "",
          "  key=\"$1\"",
          "  shift",
          "",
          "  case \"$key\" in",
          "    '-x') modeSome='t' ;;",
          "    *) someTarget=\"${someTarget}$key.*\" ;;",
          "  esac",
          "",
          "done",
          "",
          "if [[ $someTarget == '.*' ]]; then",
          "  echo 'no value'",
          "  return",
          "fi",

        }),

      }),

    },

  })

  vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, { silent = true })

  vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true })

  vim.keymap.set("i", "<C-l>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end)

end

return F
