" user's local vim config

"*****************************************************************************
"" User configs
"*****************************************************************************
" Disable python2
let g:loaded_python_provider = 0

" Set python virtualenv for vim
let g:python3_host_prog = expand('~/.config/nvim/env/bin/python3')

"" NERDTree configuration
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"" Deoplete configuration
" Turns on Deoplete at start-up of Vim
"let g:deoplete#enable_at_startup = 1

" Chooses backend for bibtex autocompletion
"let g:pandoc#completion#bib#mode = 'citeproc'

" Disables autocompletion while writing
""call deoplete#custom#option('auto_complete', v:false)

" Enables omnicompletion of citation keys
"call deoplete#custom#var('omni', 'input_patterns', {
"    			\ 'pandoc': '@'
"    			\})

" Enables deoplete for tex files
"call deoplete#custom#var('omni', 'input_patterns', {
"          \ 'tex': g:vimtex#re#deoplete
"          \})

"" vim-airline

" Enabling Powerline symbols
let g:airline_powerline_fonts = 1
" Allows word counting in the following filetypes
let g:airline#extensions#wordcount#filetypes = '\vasciidoc|help|mail|markdown|pandoc|org|rst|tex|text'
" Shows all buffers when only one tab open
"let g:airline#extensions#tabline#enabled = 0
" Handles file path displays
"let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" Sets theme for airline
let g:airline_theme='gruvbox'

""""""""""""""""""""""""""""""
" FZF-VIM
""""""""""""""""""""""""""""""

"let $FZF_DEFAULT_OPTS='--reverse' 
"let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

"""""""""""""""""
"MARKDOWN-PREVIEW
"""""""""""""""""

"" ${name} will be replace with the file name
"let g:mkdp_page_title = '「${name}」'
"let g:mkdp_preview_options = {
"    \ 'mkit': {},
"    \ 'katex': {},
"    \ 'uml': {},
"    \ 'maid': {},
"    \ 'disable_sync_scroll': 0,
"    \ 'sync_scroll_type': 'middle',
"    \ 'hide_yaml_meta': 1,
"    \ 'sequence_diagrams': {},
"    \ 'flowchart_diagrams': {}
"    \ }
"
"let g:mkdp_browser = 'vivaldi'

""""""""""""""""""""""""""""""
" VIM-FLOATERM
""""""""""""""""""""""""""""""

"let g:floaterm_open_command = 'tabe'

"""""""""""""""""""""
"JULIA FORMATTER
"""""""""""""""""""""

"let g:JuliaFormatter_options = {
"        \ 'indent'                    : 4,
"        \ 'margin'                    : 92,
"        \ 'always_for_in'             : v:false,
"        \ 'whitespace_typedefs'       : v:false,
"        \ 'whitespace_ops_in_indices' : v:true,
"        \ }

""""""""""""""""""""""""""""""
" VIM-JSBEAUTIFY 
""""""""""""""""""""""""""""""
"".vimrc
"autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
"" for json
"autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
"" for jsx
"autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
"" for html
"autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
"" for css or scss
"autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>

""""""""""""""""""""""""""""""
" VIM-TEX 
""""""""""""""""""""""""""""""

"let g:tex_flavor='latexmk'
"let g:vimtex_compiler_progname = 'nvr'
"let g:vimtex_view_enabled = 0
"let g:vimtex_view_general_viewer = 'zathura'
"let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
"let g:vimtex_view_general_options_latexmk = '--unique'
"let g:vimtex_quickfix_mode=0
"let g:vimtex_fold_enabled = 1
"let g:vimtex_fold_types = {
"           \ 'preamble' : {'enabled' : 1},
"           \ 'sections' : {'enabled' : 0},
"           \ 'envs' : {
"           \   'blacklist' : ['figures'],
"           \ },
"           \}

""""""""""""""""""""""""""""""
" VIM-LATEX-LIVE-PREVIEW 
""""""""""""""""""""""""""""""
"let g:livepreview_previewer = 'zathura'
"let g:livepreview_use_biber = 1

""" vim-easymotion
"" Maps easymotion jumps for lines
"map <leader><space>l <Plug>(easymotion-bd-jk)
"nmap <leader><space>l <Plug>(easymotion-overwin-line)
"
"" Maps easymotion jumps for words
"map  <leader><Space>w <Plug>(easymotion-bd-w)
"nmap <leader><Space>w <Plug>(easymotion-overwin-w)

""""""""""""""""""""""""""""""
" VIM-EMOJI
""""""""""""""""""""""""""""""
"set completefunc=emoji#complete

""""""""""""""""""""""""""""""
" VIMADE
""""""""""""""""""""""""""""""
"let g:vimade = {}
"let g:vimade.fadelevel = 0.1
"let g:vimade.basebg = [75, 75, 75]

""""""""""""""""""""""""""""""
" GRUVBOX
""""""""""""""""""""""""""""""
let g:gruvbox_termcolors=16
let g:gruvbox_contrast_dark = 'medium'
colorscheme gruvbox
"set background=dark " Setting dark mode
autocmd ColorScheme * highlight CocErrorFloat guifg=#ffffff
autocmd ColorScheme * highlight CocInfoFloat guifg=#ffffff
autocmd ColorScheme * highlight CocWarningFloat guifg=#ffffff
autocmd ColorScheme * highlight SignColumn guibg=#adadad

""""""""""""""""""""""""""""""
" RNVIMR
""""""""""""""""""""""""""""""

"" Set python environment
"let g:rnvimr_ranger_cmd='~/.config/nvim/env/bin/ranger'
"" Make Ranger replace Netrw and be the file explorer
"let g:rnvimr_ex_enable = 1
"" Make Ranger to be hidden after picking a file
"let g:rnvimr_enable_picker = 1
"" Customize the initial layout
"let g:rnvimr_layout = {
"            \ 'relative': 'editor',
"            \ 'width': float2nr(round(1.0 * &columns)),
"            \ 'height': float2nr(round(0.42 * &lines)),
"            \ 'col': float2nr(round(0.0 * &columns)),
"            \ 'row': float2nr(round(0.54 * &lines)),
"            \ 'style': 'minimal'
"            \ }

""""""""""""""""""""""""""""""
" TABULAR & VIM-MARKDOWN
""""""""""""""""""""""""""""""

"let g:vim_markdown_folding_level = 1

""""""""""""""""""""""""""""""
" VIM-PANDOC
""""""""""""""""""""""""""""""
"let g:pandoc#filetypes#handled = ['pandoc', 'markdown'] 
"let g:pandoc#modules#disabled = ['folding']
"let g:pandoc#folding#fold_fenced_codeblocks = 1
"let g:pandoc#folding#fold_yaml = 1
"let g:pandoc#biblio#bibs = ['/home/src/Knowledgebase/Zettelkasten/zettel.bib']
"let g:pandoc#toc#close_after_navigating = 0
"let g:pandoc#toc#position = 'bottom' 
"let g:pandoc#folding#fdc = 0

""""""""""""""""""""""""""""""
" VIM-PANDOC-SYNTAX
""""""""""""""""""""""""""""""
"let g:pandoc#syntax#conceal#blacklist = ['strikeout', 'list', 'quotes']

""""""""""""""""""""""""""""""
" VIM-TABLE-MODE
""""""""""""""""""""""""""""""

"let g:table_mode_corner = "|"
"let g:table_mode_align_char = ":"
"
"function! s:isAtStartOfLine(mapping)
"  let text_before_cursor = getline('.')[0 : col('.')-1]
"  let mapping_pattern = '\V' . escape(a:mapping, '\')
"  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
"  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
"endfunction
"
"inoreabbrev <expr> <bar><bar>
"          \ <SID>isAtStartOfLine('\|\|') ?
"          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
"inoreabbrev <expr> __
"          \ <SID>isAtStartOfLine('__') ?
"          \ '<c-o>:silent! TableModeDisable<cr>' : '__'

""""""""""""""""""""""""""""""
" VIMPENCIL
""""""""""""""""""""""""""""""

"" Automatically enable Pencil for files
"augroup pencil
"  autocmd!
"  autocmd FileType py call pencil#init({'wrap' : 'soft'})
"  autocmd FileType markdown call pencil#init({'wrap' : 'soft'})
"  autocmd FileType julia call pencil#init({'wrap' : 'soft'})
"  autocmd FileType tex call pencil#init({'wrap' : 'soft'})
"augroup END

""""""""""""""""""""""""""""""
" VIMWIKI
""""""""""""""""""""""""""""""
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
set autochdir                   " automatically change window's cwd to file's dir
set autoindent                  " align the new line indent with the previous line
"set cursorline
set relativenumber
set shiftround                  " round indent to multiple of 'shiftwidth'
set showmatch
set smartindent
set smarttab
set termencoding=utf-8
"set termguicolors

" more natural splits
set splitbelow                  " horizontal split below current
set splitright                  " vertical split to right of current

" trigger `autoread` when files changes on disk
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif

" enables a system-wide vimrc
set nocompatible 

" enable mouse use in all modes
set mouse=a

" enable saving of tab titles for sessions 
set sessionoptions+=tabpages,globals

" code/string searching tool for multifile exploration
let g:ackprg = 'ag --nogroup --nocolor --column'

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-o': ':r !echo',
  \ }

function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                                 " KEY REMAPS 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enables ripgrep for file completion via fzf
"inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')

" Maps leader to the spacebar
"map <Space> <Leader>

nnoremap   <silent>   <F9>    :FloatermNew --height=0.4 --width=0.98 --wintype=floating --position=bottom --autoclose=2 --title=
tnoremap   <silent>   <F9>    <C-\><C-n>:FloatermNew --height=0.4 --width=0.98 --wintype=floating --position=bottom --autoclose=2 --title=
nnoremap   <silent>   <F8>    :FloatermPrev<CR>
tnoremap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
nnoremap   <silent>   <F10>    :FloatermNext<CR>
tnoremap   <silent>   <F10>    <C-\><C-n>:FloatermNext<CR>
nnoremap   <silent>   <F12>   :FloatermToggle<CR>
tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>
tnoremap   <silent>   <F11>   <C-\><C-n><CR>

nnoremap   <C-c><C-c> :FloatermSend<CR>
vnoremap   <C-c><C-c> :FloatermSend<CR>

" Maps easymotion jumps for lines
map <leader><space>l <Plug>(easymotion-bd-jk)
nmap <leader><space>l <Plug>(easymotion-overwin-line)

" Maps easymotion jumps for words
map  <leader><Space>w <Plug>(easymotion-bd-w)
nmap <leader><Space>w <Plug>(easymotion-overwin-w)

" Maps Ranger 
nmap <leader><Space>r :RnvimrToggle<CR>

" Automatic formatting for Julia files
autocmd FileType julia nnoremap <buffer> <c-f> :JuliaFormatterFormat<cr>

" Maps quit
noremap <leader>q :q<cr>

" Maps quit all  
noremap <c-q> :qa<cr>

" Maps write
nnoremap <leader>w :w<cr>

" Maps ripgrep file searching function
nnoremap <C-g> :Rg<Cr>

" Maps display of current buffers 
nnoremap <C-b> :Buffers<Cr>

" Deselects currently highlighted searches 
nnoremap <Leader><BS> :noh<cr>

" Activates Twiddle case to switch between cases of selected text
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

" Configure yaml file
augroup vimrc-yaml
  autocmd!
  autocmd FileType yaml set tabstop=2|set shiftwidth=2|set expandtab softtabstop=2
augroup END

" Configure fortran
let fortran_free_source=1
let fortran_do_enddo=1
let fortran_more_precise=1

" Configure jsonc file
augroup vimrc-jsonc
    autocmd!
    autocmd BufRead,BufNewFile *.mycjson set filetype=jsonc
augroup END
