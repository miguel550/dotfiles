syntax on
filetype plugin on
set completeopt=menuone,noinsert,noselect
set colorcolumn=120
set expandtab
set noswapfile
set tabstop=2
set shiftwidth=2
set autoindent
set copyindent      " copy indent from the previous line
if ($TMUX) " if we are in a tmux set term gui colors
  set termguicolors
endif
set rnu
set nu
set cursorline
" START coc.nvim configurations
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=50

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes


call plug#begin('~/.vim/plugged')
  Plug 'vim-test/vim-test'
  Plug 'ap/vim-css-color'
  Plug 'liuchengxu/vista.vim'
  Plug 'puremourning/vimspector'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-vinegar'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/completion-nvim'
  Plug 'steelsojka/completion-buffers'
  Plug 'sainnhe/gruvbox-material'
  Plug 'vim-airline/vim-airline'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'ThePrimeagen/vim-be-good'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'nvim-treesitter/completion-treesitter'
  Plug 'p00f/nvim-ts-rainbow'
call plug#end()

" vim-test plugin
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
let g:vimspector_enable_mappings = 'HUMAN'

autocmd CursorHold * if (&filetype == 'netrw' && &number == 0) | set nu | set rnu | endif
set background=dark

let g:gruvbox_material_background = 'hard'
colorscheme gruvbox-material
let g:completion_sorting = "none"
let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp']},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'}
\]
let g:completion_auto_change_source = 1
imap <c-k> <Plug>(completion_next_source)
let g:rainbow_active = 1
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
set list lcs=tab:\|\ 
nnoremap <M-t> <C-t>
nnoremap <A-w> <C-w>

" Telescope bindings
nnoremap <leader>ff <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap <leader>fa <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fw <cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>


" Remap keys for gotos
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gtd   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <space>e       <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <space>q       <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <space>f       <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gs    <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gw    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> [d   <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d   <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nmap     <leader>rn    <cmd>lua vim.lsp.buf.rename()<CR>
nmap     <leader>ac    <cmd>lua vim.lsp.buf.code_action()<CR>

" tnoremap <Esc> <C-\><C-n>
" Enable the list of buffers

let g:netrw_localrmdir='rm -r'
let g:netrw_keepdir = 0
set rtp+=/usr/local/opt/fzf
" tsserver sucks, code action sucks
lua << EOF
function OrgImports()
      local wait_ms = 1000
      local params = vim.lsp.util.make_range_params()
      params.context = {only = {"source.organizeImports"}}
      local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
      for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
          if r.edit then
            vim.lsp.util.apply_workspace_edit(r.edit)
          else
            vim.lsp.buf.execute_command(r.command)
          end
        end
      end
      vim.lsp.buf.formatting()
    end
local nvim_lsp = require'lspconfig'
nvim_lsp.tsserver.setup{on_attach=require'completion'.on_attach}
nvim_lsp.pyright.setup{on_attach=require'completion'.on_attach}
nvim_lsp.diagnosticls.setup{
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  on_attach=require'completion'.on_attach,
  init_options = {
    filetypes = {
      javascript = "eslint",
      javascriptreact = "eslint",
      typescript = "eslint",
      typescriptreact = "eslint"
    },
    linters = {
      eslint = {
        command = './node_modules/.bin/eslint',
        rootPatterns = { '.git' },
        debounce = 100,
        args = {'--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        sourceName = 'eslint',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[eslint] ${message} [${ruleId}]',
          security = 'severity'
        },
        securities = {
          [2] = 'error',
          [1] = 'warning'
        }
      },
    }
  }
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",     -- one of "all", "language", or a list of languages
  ignore_install = { "haskell" }, -- it's throwing errors for some reason
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  indent = {
    enable = true
  },
  textobjects = {
    move = {
      enable = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
  rainbow = {
    enable = true
  },
}
EOF
