return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  dependencies = {
    -- LSP Support
    { 'neovim/nvim-lspconfig' },             -- Required
    { 'williamboman/mason.nvim' },           -- Optional
    { 'williamboman/mason-lspconfig.nvim' }, -- Optional

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },     -- Required
    { 'hrsh7th/cmp-nvim-lsp' }, -- Required
    { 'L3MON4D3/LuaSnip' },     -- Required
    { 'hrsh7th/cmp-buffer'  },
    { 'hrsh7th/cmp-path'  },
    { 'hrsh7th/cmp-cmdline' },

    -- Formatter
    { 'jose-elias-alvarez/null-ls.nvim' },
    { 'jay-babu/mason-null-ls.nvim' },

    -- UI
    {
      'glepnir/lspsaga.nvim',
      dependencies = {
        {'kyazdani42/nvim-web-devicons'},
        {'nvim-treesitter/nvim-treesitter'}
      }
    },

    --Vscode lsp icons
    {
      'onsails/lspkind-nvim',
      init = function ()
        require('lspkind').init({
          -- enables text annotations
          --
          -- default: true
          mode = 'symbol',
          -- default symbol map
          -- can be either 'default' (requires nerd-fonts font) or
          -- 'codicons' for codicon preset (requires vscode-codicons font)
          --
          -- default: 'default'
          preset = 'codicons',
          -- override preset symbols
          --
          -- default: {}
          symbol_map = {
            Text = "",
            Method = "",
            Function = "",
            Constructor = "",
            Field = "ﰠ",
            Variable = "",
            Class = "ﴯ",
            Interface = "",
            Module = "",
            Property = "ﰠ",
            Unit = "塞",
            Value = "",
            Enum = "",
            Keyword = "",
            Snippet = "",
            Color = "",
            File = "",
            Reference = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "פּ",
            Event = "",
            Operator = "",
            TypeParameter = ""
          },
        })
      end
    }
  },
  config = function()
    local lsp = require('lsp-zero').preset({
      manage_nvim_cmp = {
        set_sources = 'recommended'
      }
    })
    lsp.on_attach(function(client, bufnr)
      lsp.default_keymaps({ buffer = bufnr })
    end)
    lsp.ensure_installed({
      'tsserver',
      'lua_ls',
      'cssls',
      'tailwindcss',
      'svelte',
      'astro',
      'jsonls',
      'solc',
      'pyright',
    })


    -- Autocomplete

    local cmp = require('cmp')
    lsp.setup_nvim_cmp({
      mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      }),
      formatting = {
        fields = {'abbr', 'kind', 'menu'},
        format = require('lspkind').cmp_format({
          mode = 'symbol', -- show only symbol annotations
          maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        })
      }
    })

    lsp.setup()

    -- Formatter

    local null_ls = require('null-ls')
    local null_opts = lsp.build_options('null-ls', {})
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    null_ls.setup({
      on_attach = function(client, bufnr)
        null_opts.on_attach(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    vim.lsp.buf.format()
                end,
            })
        end
      end,
      sources = {
        null_ls.builtins.formatting.prettierd.with({
          extra_filetypes = { 'svelte', 'astro', 'toml', 'solidity' },
          env = {
            PRETTIERD_DEFAULT_CONFIG = vim.fn.expand('~/AppData/Local/nvim/utils/.prettierrc.json')
          }
        }),
        null_ls.builtins.formatting.autopep8
      }
    })

    local mnls = require('mason-null-ls')
    mnls.setup({
      automatic_installation = true, -- You can still set this to `true`
      automatic_setup = false
    })

    -- UI
    require('lspsaga').setup({
        ui = {
            winblend = 10,
            border = 'rounded',
            colors = {
                normal_bg = '#002b36'
            }
        }
    })

    local diagnostic = require('lspsaga.diagnostic')
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<C-j>', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
    vim.keymap.set('n', 'gl', '<Cmd>Lspsaga show_diagnostic<CR>', opts)
    vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', opts)
    vim.keymap.set('n', 'gd', '<Cmd>Lspsaga lsp_finder<CR>', opts)
    -- vim.keymap.set('i', '<C-k>', '<Cmd>Lspsaga signature_help<CR>', opts)
    vim.keymap.set('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.keymap.set('n', 'gp', '<Cmd>Lspsaga peek_definition<CR>', opts)
    vim.keymap.set('n', 'gr', '<Cmd>Lspsaga rename<CR>', opts)

    -- code action
    local codeaction = require("lspsaga.codeaction")
    vim.keymap.set("n", "<leader>ca", function() codeaction:code_action() end, { silent = true })
    vim.keymap.set("v", "<leader>ca", function()
      vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, false, true))
      codeaction:range_code_action()
    end, { silent = true })

  end
}
