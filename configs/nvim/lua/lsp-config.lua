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

-- Required: Enable the language server
vim.lsp.enable('ty')
-- 
-- Show diagnostics/errors
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- Jump to diagnostics/errors
vim.keymap.set('n', '[e', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']e', vim.diagnostic.goto_next)
