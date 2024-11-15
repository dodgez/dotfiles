-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  lazy = false, -- disable lazy loading
  priority = 10000, -- load AstroCore first
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      n = {
        ["s"] = { function() require("hop").hint_char1() end, desc = "Hop hint char1" },
        ["<S-s>"] = { function() require("hop").hint_lines() end, desc = "Hop hint lines" },
      },
      v = {
        ["s"] = { function() require("hop").hint_char1 { extend_visual = true } end, desc = "Hop hint char1" },
        ["<S-s>"] = {
          function() require("hop").hint_lines { extend_visual = true } end,
          desc = "Hop hint lines",
        },
      },
    },
    -- set configuration options  as described below
    rooter = {
      -- list of detectors in order of prevalence, elements can be:
      --   "lsp" : lsp detection
      --   string[] : a list of directory patterns to look for
      --   fun(bufnr: integer): string|string[] : a function that takes a buffer number and outputs detected roots
      detector = {
        "lsp", -- highest priority is getting workspace from running language servers
        { ".git", "_darcs", ".hg", ".bzr", ".svn" }, -- next check for a version controlled parent directory
        { "lua", "MakeFile", "package.json" }, -- lastly check for known project root files
      },
      -- ignore things from root detection
      ignore = {
        servers = {}, -- list of language server names to ignore (Ex. { "efm" })
        dirs = {}, -- list of directory patterns (Ex. { "~/.cargo/*" })
      },
      -- automatically update working directory (update manually with `:AstroRoot`)
      autochdir = true,
      -- scope of working directory to change ("global"|"tab"|"win")
      scope = "global",
      -- show notification on every working directory change
      notify = false,
    },
  },
}
