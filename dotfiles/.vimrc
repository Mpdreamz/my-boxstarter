set nobackup
set nowritebackup
set noswapfile
set noundofile
set autoread
set hidden

set laststatus=2
let g:airline_powerline_fonts = 1

map <C-m> :CtrlPMRU<cr>
nmap gw        :InteractiveWindow<CR>

if !has("gui_running")
   set fillchars+=vert:│
endif

let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

execute pathogen#infect()
syntax on

filetype plugin indent on

