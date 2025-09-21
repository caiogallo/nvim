return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
			{
				"simrat39/rust-tools.nvim",
				ft = "rust"
			}
		},
		config = function()
			local cmp_lsp = require("cmp_nvim_lsp")

			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities()
			)

			require("lspconfig").lua_ls.setup { capabilities = capabilities }
			require("lspconfig").bashls.setup { capabilities = capabilities }
			require("lspconfig").gopls.setup {
				capabilities = capabilities,
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
							unusedvariables = true,
						}
					}
				}
			}

			require("rust-tools").setup({
				server = {
					capabilities = capabilities,
					settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
							procMacro = { enable = true },
							check = {
								command = "clippy"
							},
							checkOnSave = true,
							diagnostics = {
								enable = true
							},
							completion = {
								autoimport = {
									enable = true
								},
								postfix = {
									enable = true
								}
							}
						}
					}
				}
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then return end

					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = args.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
							end,
						})
					end
				end,
			})
		end,
	},
}
