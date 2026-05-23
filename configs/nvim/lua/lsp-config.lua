-- Optional: Only required if you need to update the language server settings
vim.lsp.config('ty', {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  -- We don't /need/ this but might want to implement later
  -- root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  settings = {
    ty = {
      -- ty language server settings go here
      diagnosticMode = 'openFilesOnly',
      -- enable inline type hints
      inlayHints = {
          variableTypes = true,
          parameterNames = true,
      },
    }
  }
})
-- Required: Enable the language server
vim.lsp.enable('ty')

-- vim.diagnostic.config({
--     virtual_text = true, -- Shows errors inline
--     signs = true,        -- Shows E/W signs
--     underline = true,    -- Underline error
--     update_in_insert = false,
-- })

-- -----------------------------------------------------------------------------
-- Inspection
-- -----------------------------------------------------------------------------
-- K (hover) and <C-S> (signature_help in insert) are 0.11 defaults; no map.
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

-- ─────────────────────────────────────────────────────────────────────────
--  Inspection — "what is this?"
-- ─────────────────────────────────────────────────────────────────────────
-- K (hover) and <C-S> (signature_help in insert) are 0.11 defaults; no map.
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

-- ─────────────────────────────────────────────────────────────────────────
--  Diagnostics — "take me to a problem"
-- ─────────────────────────────────────────────────────────────────────────
-- ]d / [d / ]D / [D are 0.11 defaults using vim.diagnostic.jump; no map.

-- ─────────────────────────────────────────────────────────────────────────
--  Jumps — "where is this?"
-- ─────────────────────────────────────────────────────────────────────────
-- <C-]> and :tag work via tagfunc — no map.
-- gri (implementation), grt (type def) are 0.11 defaults — no map.
vim.keymap.set('n', 'grd', vim.lsp.buf.definition)   -- symmetry with grD
vim.keymap.set('n', 'grD', vim.lsp.buf.declaration)

-- ─────────────────────────────────────────────────────────────────────────
--  Multi-target — "who/what touches this?"
-- ─────────────────────────────────────────────────────────────────────────
-- grr (references) is a 0.11 default — no map.
vim.keymap.set('n', 'grc', vim.lsp.buf.incoming_calls)  -- callers
vim.keymap.set('n', 'grC', vim.lsp.buf.outgoing_calls)  -- callees

-- ─────────────────────────────────────────────────────────────────────────
--  Structure — "show me the outline"
-- ─────────────────────────────────────────────────────────────────────────
-- gO (document_symbol) is a 0.11 default — no map.
vim.keymap.set('n', 'grs', function()
  vim.lsp.buf.workspace_symbol(vim.fn.input('Symbol: '))
end)

-- ─────────────────────────────────────────────────────────────────────────
--  Refactor — "change this"
-- ─────────────────────────────────────────────────────────────────────────
-- grn (rename), gra (code_action) are 0.11 defaults — no map.
-- gq{motion} formats via 'formatexpr' — no map.

-- ─────────────────────────────────────────────────────────────────────────
--  Misc
-- ─────────────────────────────────────────────────────────────────────────
vim.keymap.set('n', '<leader>hi', vim.lsp.buf.document_highlight)
vim.keymap.set('n', '<leader>hl', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- --  ----------------------------------------------------------------------------
-- --                                TY Functions
-- --  ----------------------------------------------------------------------------
-- -- 
-- -- Show diagnostics/errors
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- -- Jump to diagnostics/errors
-- vim.keymap.set('n', '[e', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']e', vim.diagnostic.goto_next)
-- -- Set hover
-- vim.keymap.set('n', 'K', vim.lsp.buf.hover)
-- -- Show signature on demand
-- vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help)
-- --  ------------------------------------
-- --            Jumps/Search
-- --  ------------------------------------
-- -- Goto definition
-- vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
-- -- Goto declaration
-- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
-- -- Goto referneces
-- vim.keymap.set('n', 'gr', vim.lsp.buf.references)
-- -- Goto Implementations (note 'gi' is already mapped)
-- vim.keymap.set('n', 'gI', vim.lsp.buf.implementation)
-- -- Goto Type definition
-- -- Find a better mapping because this overloads the tab movements
-- -- vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition)
-- -- Highlight all uses of symbol
-- vim.keymap.set('n', '<leader>hi', vim.lsp.buf.document_highlight)
-- --  ------------------------------------
-- --              Editing
-- --  ------------------------------------
-- --  Rename
-- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
-- --  Code Action
-- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
-- 
-- 
-- -- Toggle inlay hints
-- vim.keymap.set('n', '<leader>hl', function()
--     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
-- end)
