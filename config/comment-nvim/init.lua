require("Comment").setup({
  extra = {
    ---Add comment on the line above
    above = "gcO",
    ---Add comment on the line below
    below = "gco",
    ---Add comment at the end of line
    eol = "gcA",
  },
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
