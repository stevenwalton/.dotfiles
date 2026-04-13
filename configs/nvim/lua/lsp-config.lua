-- Optional: Only required if you need to update the language server settings
vim.lsp.config('ty', {
  cmd = { 'ty', 'server' },
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

-- vim.diagnostic.config({
--     virtual_text = true, -- Shows errors inline
--     signs = true,        -- Shows E/W signs
--     underline = true,    -- Underline error
--     update_in_insert = false,
-- })

--  ----------------------------------------------------------------------------
--                                TY Functions
--  ----------------------------------------------------------------------------
-- Required: Enable the language server
vim.lsp.enable('ty')
-- 
-- Show diagnostics/errors
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- Jump to diagnostics/errors
vim.keymap.set('n', '[e', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']e', vim.diagnostic.goto_next)
-- Set hover
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
-- Show signature on demand
vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help)
--  ------------------------------------
--            Jumps/Search
--  ------------------------------------
-- Goto definition
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
-- Goto declaration
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
-- Goto referneces
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
-- Goto Implementations (note 'gi' is already mapped)
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation)
-- Goto Type definition
-- Find a better mapping because this overloads the tab movements
-- vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition)
-- Highlight all uses of symbol
vim.keymap.set('n', '<leader>hi', vim.lsp.buf.document_highlight)
--  ------------------------------------
--              Editing
--  ------------------------------------
--  Rename
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
--  Code Action
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)


-- Toggle inlay hints
vim.keymap.set('n', '<leader>hl', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)
