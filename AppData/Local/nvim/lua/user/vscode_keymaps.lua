local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- remap leader key
keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- yank to system clipboard
keymap({"n", "v"}, "<leader>y", '"+y', opts)

-- paste from system clipboard
keymap({"n", "v"}, "<leader>p", '"+p', opts)

-- better indent handling
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- move text up and down
keymap("v", "J", ":m .+1<CR>==", opts)
keymap("v", "K", ":m .-2<CR>==", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- paste preserves primal yanked piece
keymap("v", "p", '"_dP', opts)

-- removes highlighting after escaping vim search
keymap("n", "<Esc>", "<Esc>:noh<CR>", opts)

-- Call VSCode commands from Neovim

-- General keymaps
keymap({"n", "v"}, "<leader>d", "<cmd>lua require('vscode').action('editor.action.showHover')<CR>", opts)
keymap({"n", "v"}, "<leader>a", "<cmd>lua require('vscode').action('editor.action.quickFix')<CR>", opts)
keymap({"n", "v"}, "<leader>sp", "<cmd>lua require('vscode').action('workbench.actions.view.problems')<CR>", opts)
keymap({"n", "v"}, "<leader>cn", "<cmd>lua require('vscode').action('notifications.clearAll')<CR>", opts)
keymap({"n", "v"}, "<leader>ff", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>", opts)
keymap({"n", "v"}, "<leader> ", "<cmd>lua require('vscode').action('workbench.action.showCommands')<CR>", opts)
keymap({"n", "v"}, "<leader>pr", "<cmd>lua require('vscode').action('code-runner.run')<CR>", opts)
keymap({"n", "v"}, "<leader>fd", "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>", opts)
keymap({"n", "v"}, "<leader>e", "<cmd>lua require('vscode').action('workbench.view.explorer')<CR>", opts)

-- Quit and Save Commands
--
keymap({"n"}, "<leader>qq", "<cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<CR>", opts)  -- Close the current buffer (active editor)
keymap({"n"}, "<leader>qa", "<cmd>lua require('vscode').action('workbench.action.quit')<CR>", opts)  -- Quit VSCode
keymap({"n"}, "<leader>ww", "<cmd>lua require('vscode').action('workbench.action.files.save')<CR>", opts)  -- Save file
keymap({"n"}, "<leader>wa", "<cmd>lua require('vscode').action('workbench.action.files.saveAll')<CR>", opts)  -- Save all open files
keymap({"n"}, "<leader>wx", "<cmd>lua require('vscode').action('workbench.action.files.save')<CR><cmd>lua require('vscode').action('workbench.action.closeWindow')<CR>", opts)  -- Save and close window

-- Buffer Navigation
keymap({"n"}, "<leader>bn", "<cmd>lua require('vscode').action('workbench.action.nextEditor')<CR>", opts)  -- Go to next editor
keymap({"n"}, "<leader>bp", "<cmd>lua require('vscode').action('workbench.action.previousEditor')<CR>", opts)  -- Go to previous editor
keymap({"n"}, "<leader>bd", "<cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<CR>", opts)  -- Close active editor

-- Git Commands
keymap({"n"}, "<leader>gs", "<cmd>lua require('vscode').action('git.stage')<CR>", opts)  -- Git stage changes
keymap({"n"}, "<leader>gc", "<cmd>lua require('vscode').action('git.commit')<CR>", opts)  -- Git commit changes
keymap({"n"}, "<leader>gp", "<cmd>lua require('vscode').action('git.push')<CR>", opts)  -- Git push changes
keymap({"n"}, "<leader>gl", "<cmd>lua require('vscode').action('git.pull')<CR>", opts)  -- Git pull changes
keymap({"n"}, "<leader>gd", "<cmd>lua require('vscode').action('git.openChange')<CR>", opts)  -- Show git diff
keymap({"n"}, "<leader>gb", "<cmd>lua require('vscode').action('git.checkout')<CR>", opts)  -- Git checkout branch
keymap({"n"}, "<leader>gr", "<cmd>lua require('vscode').action('git.sync')<CR>", opts)  -- Git sync (pull, push)

-- Window Navigation and Management
keymap({"n"}, "<leader>ws", "<cmd>lua require('vscode').action('workbench.action.splitEditor')<CR>", opts)  -- Split window
keymap({"n"}, "<leader>wc", "<cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<CR>", opts)  -- Close window
keymap({"n"}, "<leader>wh", "<cmd>lua require('vscode').action('workbench.action.navigateLeft')<CR>", opts)  -- Move to left editor group
keymap({"n"}, "<leader>wj", "<cmd>lua require('vscode').action('workbench.action.navigateDown')<CR>", opts)  -- Move to editor below
keymap({"n"}, "<leader>wk", "<cmd>lua require('vscode').action('workbench.action.navigateUp')<CR>", opts)  -- Move to editor above
keymap({"n"}, "<leader>wl", "<cmd>lua require('vscode').action('workbench.action.navigateRight')<CR>", opts)  -- Move to right editor group