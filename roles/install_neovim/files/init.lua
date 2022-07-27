-- ----------------------------------------------------------
-- Utilities
-- ----------------------------------------------------------

-- ----------------------------------------------------------
-- ENV setttings
-- ----------------------------------------------------------
-- neovim python pathes
local home_path = os.getenv('HOME')
vim.g.python_host_prog = home_path .. '/.pyenv/versions/neovim2/bin/python'
vim.g.python3_host_prog = home_path .. '/.pyenv/versions/neovim3/bin/python'

-- ----------------------------------------------------------
-- Plugins
-- ----------------------------------------------------------
-- Bootstrap packer
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local packer = require('packer').startup(function(use)
    -- let packer update itself
    use 'wbthomason/packer.nvim'

    -- color schemes
    use 'KeitaNakamura/neodark.vim'

    -- git
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'

    -- tree-sitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    -- comments
    use 'tpope/vim-commentary'

    -- searching / navigation
    use {'junegunn/fzf', run = './install --bin', }
    use {'ibhagwan/fzf-lua', requires = 'kyazdani42/nvim-web-devicons'}

    -- cpp plugins
    use 'vim-scripts/a.vim'

    -- python plugins
    use 'Vimjas/vim-python-pep8-indent'

    -- lsp
    -- lsp configs
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    
    -- lsp UI
    use 'tami5/lspsaga.nvim'

    -- -- -- lsp autocompletion
    -- use 'hrsh7th/cmp-nvim-lsp'
    -- use 'hrsh7th/cmp-buffer'
    -- use 'hrsh7th/cmp-path'
    -- use 'hrsh7th/cmp-cmdline'
    -- use 'hrsh7th/nvim-cmp'

    -- -- -- lsp diagnostic pane on the bottom
    -- use {'folke/lsp-trouble.nvim', requires = "kyazdani42/nvim-web-devicons"}

    -- -- lsp (missing) diagnostic colors
    -- use 'folke/lsp-colors.nvim'

    -- automatically set up your configuration after cloning packer.nvim
    -- put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- ----------------------------------------------------------
-- Plugins configs
-- ----------------------------------------------------------
-- ----------------------------------------------------------
-- LSP
-- ----------------------------------------------------------
-- lspsaga
local saga = require('lspsaga')
saga.init_lsp_saga()

-- Install LSP serves
local lsp_installer = require('nvim-lsp-installer')
local lsp_installer_servers = require('nvim-lsp-installer.servers')
lsp_servers = {'pyright', 'dockerls', 'bashls', 'clangd'}

for _, lsp_server in ipairs(lsp_servers) do
    local success, server = lsp_installer_servers.get_server(server_name)
    if success and not server:is_installed() then
        server:install()
    end
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = {noremap=true, silent=true}
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = {noremap=true, silent=true, buffer=bufnr}
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "gd", "<cmd>Lspsaga preview_definition<CR>", {silent = true, noremap = true})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", '<C-k>', "<cmd>Lspsaga signature_help<CR>", bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", {silent = true, noremap = true})
    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local lsp_config = require('lspconfig')

lsp_config['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

lsp_config['bashls'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

lsp_config['clangd'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

-- require('lsp-colors').setup({
--   Error = '#F44747',
--   Warning = '#FF8800',
--   Hint = '#4FC1FF',
--   Information = '#FFCC66'
-- })

-- ----------------------------------------------------------
-- tree-sitter
-- ----------------------------------------------------------
require('nvim-treesitter.configs').setup {
    ensure_installed = {"c", "cpp", "python", "lua", "bash", "json", "yaml"},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
    },
}

-- ----------------------------------------------------------
-- fzf-lua
-- ----------------------------------------------------------
local function fzf_lua_set_keymap(key_map_lhs, fzf_lua_verb)
    key_map_rhs = string.format("<cmd>lua require('fzf-lua').%s()<CR>", fzf_lua_verb)
    vim.api.nvim_set_keymap('n', key_map_lhs, key_map_rhs, {noremap = true, silent = true})
end

-- files
fzf_lua_set_keymap('<leader>f', 'files')
-- buffers
fzf_lua_set_keymap('<leader>b', 'buffers')
-- buffer lines
fzf_lua_set_keymap('<leader>/', 'blines')
-- tags
fzf_lua_set_keymap('<leader>t', 'tags')
-- git grep
fzf_lua_set_keymap('<leader>g', 'git_files')
-- marks
fzf_lua_set_keymap('<leader>m', 'marks')

-- ----------------------------------------------------------
-- a.vim
-- ----------------------------------------------------------
vim.api.nvim_set_keymap('n', '<leader>a', ':A<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<leader>A', ':AV<CR>', {silent = true})

-- ----------------------------------------------------------
-- Customizations
-- ----------------------------------------------------------

-- ----------------------------------------------------------
-- Looks
-- ----------------------------------------------------------
-- colorscheme
vim.cmd('colorscheme neodark')
vim.o.termguicolors = true

-- ----------------------------------------------------------
-- General
-- ----------------------------------------------------------

-- 
--
--
--
-- _____ looks like default values for neovim - start
-- Keep the indentation level of previous line
vim.o.autoindent = true
vim.bo.autoindent = true

-- Search opts
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Better command-line completion
vim.o.wildmenu = true

-- Display the cursor position on the last line of the screen or in the status line of a window
vim.o.ruler = true

-- filetype options
vim.cmd('filetype indent plugin on')

-- Hide windows (instead of close when they lose focus)
vim.o.hidden = true

-- Show partial commands in the last line of the screen
vim.o.showcmd = true

-- Allow backspacing over autoindent, line breaks and start of insert action
vim.o.backspace = 'indent,eol,start'

-- Stop certain movements from always going to the first character of a line.
-- While this behaviour deviates from that of Vi, it does what most users
-- coming from other editors would expect.
vim.o.startofline = false

-- Always display the status line, even if only one window is displayed
vim.o.laststatus = 2

-- Autoread buffer on change
vim.o.autoread = true
vim.api.nvim_create_autocmd({"BufEnter", "CursorHold", "CursorHoldI", "FocusGained"}, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = "*",
})

-- enable syntax highlighting
vim.cmd('syntax enable')

-- _____ looks like default values for neovim - end
--
--
--
--

-- Lines visible when scrolling
vim.o.scrolloff = 3

-- More natural splits
vim.o.splitbelow = true
vim.o.splitright = true

-- Don't beark long lines
--vim.o.formatoptions = vim.o.formatoptions:gsub('tc', '')
vim.o.wrap = false

-- hide diff when winbdow lose focus
vim.o.diffopt = vim.o.diffopt .. ',hiddenoff'

-- Instead of failing a command because of unsaved changes, instead raise a
-- dialogue asking if you wish to save changed files.
vim.o.confirm = true

-- Use visual bell instead of beeping when doing something wrong
vim.o.visualbell = true

-- And reset the terminal code for the visual bell. If visualbell is set, and
-- this line is also included, vim will neither flash nor beep. If visualbell
-- is unset, this does nothing.
vim.o.t_vb = ''

-- Enable use of the mouse for all modes
vim.o.mouse = 'a'

-- Display line numbers on the left
vim.o.number = true

-- Relative line numbers
vim.o.relativenumber = true

-- Quickly time out on keycodes, but never time out on mappings
vim.o.timeout = false
vim.o.ttimeout = true  --neovim default
vim.o.ttimeoutlen = 200

-- Use <F11> to toggle between 'paste' and 'nopaste'
vim.o.pastetoggle = '<F11>'

-- Highlight currentline
vim.o.cursorline = true
vim.cmd('highlight CursorLine guibg=#323940')
vim.o.colorcolumn = '120'

-- Consistent visual selection highlight
vim.cmd('highlight Visual term=reverse cterm=reverse')

-- Search highlight colors
vim.cmd('highlight Search guibg=peru guifg=wheat')

-- Interactive substitute command
vim.o.inccommand = 'nosplit'

-- ----------------------------------------------------------
-- Global indentation options
-- ----------------------------------------------------------
local tab_value = 4
vim.o.tabstop = tab_value  -- maximum width of tab character (measured in spaces)
vim.bo.tabstop = vim.o.tabstop
vim.o.shiftwidth = tab_value  -- size of indent (measured in spaces), should equal tabstop
vim.bo.shiftwidth = vim.o.shiftwidth
vim.o.softtabstop = tab_value  -- should be the same as the other two above
vim.bo.softtabstop = vim.o.softtabstop
vim.o.expandtab = true  -- expand tabs to spaces
vim.bo.expandtab = vim.o.expandtab

-- c/cpp long arg indentation
vim.o.cino = '(0'

-- ----------------------------------------------------------
-- General mappings
-- ----------------------------------------------------------
-- Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy, which is the default
vim.api.nvim_set_keymap('', 'Y', 'y$', {})

-- Map <C-L> (redraw screen) to also turn off search highlighting until the next search
vim.api.nvim_set_keymap('n', '<C-L>', ':nohl<CR><C-L>', {noremap = true})

-- Multi paste form buffer in visual mode
vim.api.nvim_set_keymap('x', 'p', "p:if v:register == '\"'<Bar>let @@=@0<Bar>endif<cr>", {noremap = true, silent = true})

-- Copy current buffer path to clipboard
vim.api.nvim_set_keymap('n', '<leader>c', ':let @+ = expand("%")<cr>', {noremap = true})

-- Count matches of last search
vim.api.nvim_set_keymap('', ',*', '*<C-O>:%s///gn<CR>', {})

-- Yank file contents to system clipboard
vim.api.nvim_set_keymap('n', '<leader>Y', ':%y+<CR>', {noremap = true})

-- Open tag under cursor in vertical split
vim.api.nvim_set_keymap('n', '<C-w>]', ':vert winc ]<cr>', {noremap = true, silent = true})

-- ----------------------------------------------------------
-- General commands
-- ----------------------------------------------------------
-- Tag current dir
vim.api.nvim_create_user_command('CTags', "!ctags -R " .. 
                                          "--exclude='build*' --exclude='venv/**' --exclude='**/site-packages/**' " .. 
                                          "--exclude='dist/**' --exclude='*.json' --python-kinds=-i *", {})

-- ----------------------------------------------------------
-- Clipborad settings
-- ----------------------------------------------------------
if vim.loop.os_uname().sysname:upper() == 'DARWIN' then
    vim.o.clipboard = 'unnamed'
end

-- ----------------------------------------------------------
-- Filetype customizations
-- ----------------------------------------------------------
local ft_detect_augroup = vim.api.nvim_create_augroup('filetypedetect', {clear = false})

-- Dockerfile
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
    pattern = '*Dockerfile*',
    command = 'setfiletype dockerfile',
    group = ft_detect_augroup
})

-- SConstruct
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
    pattern = '*SConstruct*',
    command = 'setfiletype python',
    group = ft_detect_augroup
})

-- vproto
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
    pattern = '*vproto',
    command = 'setfiletype c',
    group = ft_detect_augroup
})

