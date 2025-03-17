return {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		},
		config = function()
			require('telescope').setup {
				pickers = {
					find_files = {
						theme = "ivy",
					},
				},
				extensions = {
					fzf = {}
				},
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
					}
				}
			}

			require('telescope').load_extension('fzf')

			vim.keymap.set("n", "<space>fd", require('telescope.builtin').find_files)
			vim.keymap.set("n", "<space>en", function()
				require('telescope.builtin').find_files {
					cwd = vim.fn.stdpath("config")
				}
			end)

			local builtin = require('telescope.builtin')
			vim.keymap.set("n", "<space>pws", function()
				local word = vim.fn.expand("<cword>")
				builtin.grep_string({ search = word })
			end)
			vim.keymap.set("n", "<space>pWs", function()
				local word = vim.fn.expand("<cWORD>")
				builtin.grep_string({ search = word })
			end)
			vim.keymap.set("n", "<space>ps", function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end)

			require "config.telescope.multigrep".setup()
		end

	}
}
