" user's extra bundles

"*****************************************************************************
"" User bundles
"*****************************************************************************
" NERDTree icons
Plug 'ryanoasis/vim-devicons'

" asynchronous completion
"if has('nvim')
"  Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
"else
"  Plug 'Shougo/deoplete.nvim'
"  Plug 'roxma/nvim-yarp'
"  Plug 'roxma/vim-hug-neovim-rpc'
"endif

" completion for golang
"Plug 'deoplete-plugins/deoplete-go', {'do': 'make'}

" Preview markdown on your modern browser with synchronised scrolling and flexible configuration.
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

" Terminal in floating window
Plug 'voldikss/vim-floaterm'

" Support for Julia
Plug 'JuliaEditorSupport/julia-vim'

" Formatting Julia Files
Plug 'kdheepak/JuliaFormatter.vim'

" Automatic pane resizing
Plug 'camspiers/lens.vim'

" Formatting of HTML, JS, CSS, JSON, and JSX Files
Plug 'maksimr/vim-jsbeautify'

" Adding support for LaTeX
Plug 'lervag/vimtex'

" Live Previewing of LaTeX Documents
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

" Moving through Vim easily
Plug 'easymotion/vim-easymotion'

" Emoji support
"Plug 'fszymanski/deoplete-emoji'

" Easy commenting for Vim
Plug 'preservim/nerdcommenter'

" Fade inactive buffers and preserve syntax highlighting
Plug 'TaDaa/vimade'

" Support for Todo.txt files
Plug 'freitass/todo.txt-vim'

" Gruvbox color theme for Vim 
Plug 'morhetz/gruvbox'

" Ranger file browser integration
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}

" Surrounding words with characters in Vim
Plug 'tpope/vim-surround'

" BibTeX Handling
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax' "Also used for Markdown formatting

" VIM Table Mode for instant table creation.
Plug 'dhruvasagar/vim-table-mode'

" Tab naming powers
Plug 'gcmt/taboo.vim'

" Multiple cursors for editing
Plug 'mg979/vim-visual-multi'

" Distraction-free writing in Vim
Plug 'junegunn/goyo.vim'

" Vim session saving
Plug 'tpope/vim-obsession'

" Rethinking Vim as a tool for writing
Plug 'preservim/vim-pencil'

" Vimwiki
Plug 'vimwiki/vimwiki'

" JSX and TSX syntax highlighting
Plug 'maxmellon/vim-jsx-pretty'

" Replace deoplete with CoC
" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Vim syntax highlighting plugin for JSON with C-style line (//) and block (/* */) comments.
Plug 'kevinoid/vim-jsonc'

" Vim plugin for Rego OPA
Plug 'tsandall/vim-rego'
