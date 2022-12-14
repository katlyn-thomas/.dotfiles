-- Set up nvim-cmp.

-- local tabnine = require('cmp_tabnine.config')
local cmp = require 'cmp'
local lspkind = require 'lspkind'
local luasnip = require 'luasnip'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

vim.cmd("set completeopt=menuone,noinsert,noselect")

cmp.setup({
    preselect = cmp.PreselectMode.None,
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = lspkind.cmp_format({
            mode = 'symbol',
            menu = ({
                buffer = "~Buffer",
                nvim_lsp = "~LSP",
                luasnip = "~LuaSnip",
                cmp_tabnine = "~Tab9",
            }),
        })
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        -- ['<Tab>'] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_next_item()
        --     elseif luasnip.expand_or_jumpable() then
        --         luasnip.expand_or_jump()
        --     elseif has_words_before() then
        --         cmp.complete()
        --     else
        --         fallback()
        --     end
        -- end, { 'i', 's' }),
        -- ['<S-Tab>'] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_prev_item()
        --     elseif luasnip.expand_or_jumpable() then
        --         luasnip.expand_or_jump()
        --     elseif has_words_before() then
        --         cmp.complete()
        --     else
        --         fallback()
        --     end
        -- end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end),
        ['<C-j>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end),
        ['<C-l>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
                cmp.select_prev_item()
                cmp.select_prev_item()
            else
                fallback()
            end
        end),
        ['<C-h>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                cmp.select_next_item()
                cmp.select_next_item()
            else
                fallback()
            end
        end),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'nvim-lsp-signature-help'},
        -- { name = 'cmp_tabnine' },
    }, {
        { name = 'buffer' },
    }),
    experimental = {
        ghost_text = true
    }
})

-- tabnine.setup({
--     max_lines = 1000,
--     max_num_results = 20,
--     sort = true,
--     run_on_every_keystroke = true,
--     snippet_placeholder = '..',
--     ignored_file_types = {
--         -- default is not to ignore
--         -- uncomment to ignore in lua:
--         -- lua = true
--     },
--     show_prediction_strength = false
-- })

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- AUTOPAIRS
-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)
