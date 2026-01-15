return {
  "gruvw/strudel.nvim",
  cmd = "StrudelLaunch",
  build = "npm install",
  config = function()
    require("strudel").setup()
  end,
}
