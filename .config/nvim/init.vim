"      _ _____ John Zlotek
"     | |__  / Neovim rc file
"  _  | | / /  Copy this into ~/.config/nvim/init.vim to get started then run 'nvim'
" | |_| |/ /_  Installation of main packages should take place
"  \___//____|

set encoding=utf-8

if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !mkdir -p ~/.config/nvim/autoload/
  silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.config/nvim/autoload/plug.vim
  autocmd VimEnter * PlugInstall
endif

if ! filereadable(expand('~/.config/coc/extensions/package.json'))
  echo "Downloading coc plugins..."
  autocmd VimEnter * CocInstall coc-tsserver coc-json coc-python coc-vetur coc-go coc-highlight coc-pairs coc-go
endif

" leader
let mapleader = ','

" vim-plug
call plug#begin('~/.config/nvim/plugged')
  " auto-complete-esque section
  Plug 'dense-analysis/ale'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'sheerun/vim-polyglot'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'lervag/vimtex'


  " File systems and git
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'junegunn/goyo.vim'
  Plug 'tpope/vim-fugitive'

  " Themes and extra
  Plug 'vim-airline/vim-airline-themes'
  Plug 'vim-airline/vim-airline'
  Plug 'ryanoasis/powerline-extra-symbols'
  Plug 'flazz/vim-colorschemes'
  Plug 'dylanaraps/wal.vim'
  Plug 'ryanoasis/vim-devicons'
  Plug 'yggdroot/indentline'
call plug#end()


" Plugin Options
let g:go_fmt_command = 'goimports'
let g:NERDTreeGitStatusWithFlags = 1

let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
let g:ale_fixers = {
  \ 'markdown': ['prettier'],
  \ 'javascript': ['prettier'],
  \ 'typescript': ['prettier'],
  \ 'vue': ['prettier'],
  \ 'python': ['autopep8']
\ }
let g:ale_fix_on_save = 1

let g:airline_theme='deus'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#vimtex#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s:'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#fnamecollapse = 1
let g:airline#extensions#tabline#fnametruncate = 0
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_powerline_fonts = 1
let g:airline_left_sep = "\uE0B4"
let g:airline_right_sep = "\uE0B6"
let g:Powerline_symbols='fancy'

let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_leadingSpaceChar = '.'


nnoremap <C-p> :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>t :BTags<CR>
nnoremap <Leader>T :Tags<CR>
nnoremap <Leader>l :Lines<CR>


let g:gutentags_cache_dir = expand('/tmp/.cache/vim/ctags/')
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_exclude_filetypes=[
  \ 'css',
  \ 'json',
  \ 'vim',
  \ 'vimwiki',
  \ 'tex',
  \ 'pdf',
  \ 'markdown',
\]
let g:gutentags_exclude=[
  \ '*.css',
  \ '*.json',
  \ '*.*rc*',
\]
let g:gutentags_ctags_extra_args=[
  \ '--langmap=javascript:.js.es6.es.jsx',
  \ '--langmap=typescript:.ts.es6.es.tsx',
  \ '--javascript-kinds=-c-f-m-p-v',
\]
set statusline+=%{gutentags#statusline()}

" don't use arrowkeys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" really, just don't
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>
inoremap <Left>  <NOP>
inoremap <Right> <NOP>

" tab sizing
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Coc Configuration
inoremap <silent><expr> <c-space> coc#refresh()
autocmd CursorHold * silent call CocActionAsync('highlight')
set updatetime=300
set signcolumn=yes


" Some basics:
set nocompatible
filetype plugin on
syntax on
highlight EndOfBuffer ctermfg=black ctermbg=black
colorscheme Tomorrow-Night
set number
set relativenumber

" Push <leader>F2 to rename current symbol
nmap <leader><F2> <Plug>(coc-rename)

" Push F3 to make md friendly paragraph indent
" map <F3> :r! space_indent<CR>

" Reset
map <F5> :e<CR> :pc<CR> :noh<CR>

" Spell-check set to F6:
map <F6> :setlocal spell! spelllang=en_us,es<CR>

" NERDTree
let NERDTreeShowHidden=1
map <silent> <F9> :NERDTreeToggle<CR>

let g:NERDTreeQuitOnOpen=1

" Goyo plugin makes text more readable when writing prose:
map <F10> :Goyo<CR>
inoremap <F10> <esc>:Goyo<CR>a

" Enable autocompletion:
set wildmode=longest,list,full
set wildmenu
set incsearch
set nohlsearch

vmap < <gv
vmap > >gv

" Automatically deletes all tralling whitespace on save.
autocmd BufWritePre * %s/\s\+$//e

" Use urlview to choose and open a url:
:noremap <leader>u :w<Home>silent <End> !urlview<CR>

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" C-T for new tab
nnoremap <C-t> :tabnew<cr>

" Navigating with guides
inoremap <leader><Tab> <Esc>/<++><Enter>"_c4l
vnoremap <leader><Tab> <Esc>/<++><Enter>"_c4l
map <leader><Tab> <Esc>/<++><Enter>"_c4l
inoremap ;gui <++>

" For normal mode when in terminals (in X I have caps mapped to esc, this replaces it when I don't have X)
inoremap jw <Esc>
inoremap wj <Esc>

"Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"Replace all is aliased to S. Visual mode shortcut doesn't work yet for some
"reason...
nnoremap S :%s//g<Left><Left>
vnoremap S noop
vnoremap S :s//g<Left><Left>

autocmd FileType vue nnoremap <leader>s :0r! cat ~/.scripts/templates/vue.template<CR>/<++><Enter>"_c4l
autocmd FileType c,C nnoremap <leader>s :0r! cat ~/.scripts/templates/c.template<CR>/<++><Enter>"_c4l
autocmd FileType python nnoremap <leader>s :0r! cat ~/.scripts/templates/py.template<CR>/<++><Enter>"_c4l

" Terminal Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
  if win_gotoid(g:term_win)
    hide
  else
    botright new
    exec "resize " . a:height
    try
      exec "buffer " . g:term_buf
    catch
      call termopen("/bin/zsh", {"detach": 0})
      let g:term_buf = bufnr("")
      set nonumber
      set norelativenumber
      set signcolumn=no
    endtry
    startinsert!
    let g:term_win = win_getid()
  endif
endfunction

" floating fzf
if has('nvim')
  let $FZF_DEFAULT_OPTS=' --layout=reverse --margin=1,4 --color fg:242,bg:233,hl:65,fg+:15,bg+:234,hl+:108,info:108,prompt:109,spinner:108,pointer:168,marker:168'
  function! FloatingFZF()
    let width = float2nr(&columns * 0.9)
    let height = float2nr(&lines * 0.6)
    let opts = {
      \ 'relative': 'editor',
      \ 'row': (&lines - height) / 2,
      \ 'col': (&columns - width) / 2,
      \ 'width': width,
      \ 'height': height,
      \ 'style': 'minimal'
    \}
    let buf = nvim_create_buf(v:false, v:true)
    let win = nvim_open_win(buf, v:true, opts)
    call setwinvar(win, '&winhl', 'NormalFloat:TabLine')
  endfunction
  let g:fzf_layout = { 'window': 'call FloatingFZF()' }
endif

" Toggle terminal on/off (neovim)
nnoremap <A-t> :call TermToggle(12)<CR>
inoremap <A-t> <Esc>:call TermToggle(12)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>
