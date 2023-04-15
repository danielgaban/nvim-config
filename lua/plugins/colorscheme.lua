-- return {
--   'folke/tokyonight.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function ()
--     require('tokyonight').setup({
--       style = 'night',
--       transparent = true
--     })
--     vim.cmd('colorscheme tokyonight')
--   end
-- }
return {
  'svrana/neosolarized.nvim',
  lazy = false,
  priority = 1000,
  dependencies = {
    {'tjdevries/colorbuddy.nvim'}
  },
  opts = {
    comment_italics = true,
    background_set = false
  }
}
