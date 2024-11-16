-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- import/override with your plugins folder
  { import = "astrocommunity.color.transparent-nvim" },
  { import = "astrocommunity.diagnostics.error-lens-nvim" },
  { import = "astrocommunity.diagnostics.lsp_lines-nvim" },
  { import = "astrocommunity.fuzzy-finder.fzf-lua" },
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.motion.hop-nvim" },
  { import = "astrocommunity.pack.lean" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.rainbow-delimiter-indent-blankline" },
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.scrolling.cinnamon-nvim" },
  { import = "astrocommunity.scrolling.nvim-scrollbar" },
}
