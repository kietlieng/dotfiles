return {
  'hrsh7th/nvim-cmp',
  dependencies = {

		-- lsp and language 
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-nvim-lsp-signature-help',
		'hrsh7th/cmp-nvim-lua',

	  -- general
    'hrsh7th/cmp-path',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-cmdline',

		-- snippets
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',  -- LuaSnip completion source
    'rafamadriz/friendly-snippets',

		-- nice options
		'hrsh7th/cmp-calc',      -- Math
		'f3fora/cmp-spell',      -- Spelling
		'petertriho/cmp-git',    -- Git commits	

  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
			preselect = cmp.PreselectMode.Item,
      mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- cmp.select_next_item()
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<CR>'] = cmp.mapping.confirm({ 
					select = true,
					behavior = cmp.ConfirmBehavior.Replace
				}),
      }),

      sources = {

				{ name = 'nvim_lsp' },
				{ name = 'nvim_lua' },
				{ name = 'nvim_lsp_signature_help' },
				{ name = 'luasnip' },

				{ name = 'buffer' },
				{ name = 'path' },
        { name = 'calc' },
				{ name = 'spell' },
				{ name = 'git' },

			},

			formatting = {

				format = function(entry, vim_item)
					-- Verify buffer source shows up

					vim_item.menu = ({

						nvim_lsp                = '[LSP]',
						nvim_lua                = '[Lua]',
						nvim_lsp_signature_help = '[Sig]',
						luasnip                 = '[Snip]',
						buffer                  = '[Buf]',  -- Not [A]
						path                    = '[Path]',
						cmdline                 = '[Cmd]',
						calc                    = '[Calc]',
						spell                   = '[Spell]',
						git                     = '[Git]',

					})[entry.source.name] or ('[' .. entry.source.name .. ']')

					return vim_item
				end

			},
    })
  end,
}
