-- plugins/lsp-inlayhints.lua

-- Disable lsp-inlayhints if that is nightly version, will remove when 0.10.0 is stable
local enabled_inlay_hints = true
return {
  {
    'lvimuser/lsp-inlayhints.nvim',
    ft = { 'javascript', 'javascriptreact', 'json', 'jsonc', 'typescript', 'typescriptreact', 'svelte' },
    enabled = enabled_inlay_hints,
    opts = {
      debug_mode = true,
    },
    config = function(_, options)
      vim.api.nvim_create_augroup('LspAttach_inlayhints', {})
      vim.api.nvim_create_autocmd('LspAttach', {
        group = 'LspAttach_inlayhints',
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            require('lsp-inlayhints').on_attach(client, bufnr)
          end
        end,
      })
      require('lsp-inlayhints').setup(options)
      vim.api.nvim_set_keymap('n', '<leader>uI', "<cmd>lua require('lsp-inlayhints').toggle()<CR>", { noremap = true, silent = true })
    end,
  },
}
