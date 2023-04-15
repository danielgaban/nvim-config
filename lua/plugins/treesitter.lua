return {
  'nvim-treesitter/nvim-treesitter',
  version = false,
  build = ':TSUpdate',
  event = {'BufReadPost', 'BufNewFile'},
  opts = {
    ensure_installed = {
      'c',
      'cpp',
      'lua',
      'vim',
      'vimdoc',
      'markdown',
      'markdown_inline',
      'tsx',
      'toml',
      'json',
      'yaml',
      'html',
      'css',
      'astro',
      'javascript',
      'typescript',
      'svelte',
      'python',
      'solidity'
    },
    highlight = {
      enable = true
    },
    indent = {
      enable = true
    },
    autotag = {
      enable = true
    }
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
