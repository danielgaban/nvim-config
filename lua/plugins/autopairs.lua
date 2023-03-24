return {
  'windwp/nvim-autopairs',
  event = {'BufReadPost', 'BufNewFile'},
  opts = {
    disable_filetype = { "TelescopePrompt" , "vim" }
  }
}
