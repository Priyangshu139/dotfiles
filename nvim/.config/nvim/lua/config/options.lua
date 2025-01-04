-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

--UnderCurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Cs = "\e[4:0m"]])
-- Function to open the folder selected in netrw in Neo-tree
function OpenNetrwFolderInNeoTree()
  -- Prompt the user to choose a folder using fzf or any other file picker.
  local folder = vim.fn.input("Select folder: ", vim.fn.expand("%:p:h"), "dir")
  if folder ~= "" then
    vim.cmd("Neotree dir=" .. folder) -- Open Neo-tree with the selected directory
    vim.cmd("bd") -- Close the netrw window
  end
end

-- Map a key to open Neo-tree with the current netrw directory
vim.api.nvim_set_keymap("n", "<leader>m", ":lua OpenNetrwFolderInNeoTree()<CR>", { noremap = true, silent = true })
