require'nvim-treesitter.configs'.setup {
  ensure_installed = { -- one of "all", "maintained" (parsers with maintainers), or a list of languages
      "javascript",
      "html",
      "css",
      "php",
      "bash",
      "cpp"
  },
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false -- Whether the query persists across vim sessions
  },
  rainbow = {
    enable = false
  }
}
