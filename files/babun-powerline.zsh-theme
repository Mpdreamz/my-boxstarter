local return_code="%(?..%{$fg[white]%}%?%{$reset_color%})"

readonly PS_SYMBOL_OTHER=''
SEP=$(echo '\ue0b0')
SEPHALF=$(echo '\ue0b1')
SEPREV=$(echo '\ue0b2')

FG1=black
BG1=cyan

FG2=white
BG2=black

FG3=black
BG3=green

FG4=yellow
BG4=black
function gitb() {
  DEFAULTICON=$(echo -ne '\ue818')
  if [[ "$PWD" = "$HOME" ]] then
    DEFAULTICON=$(echo -ne '\ue81A')
  fi
  echo "${$( echo $(git rev-parse --abbrev-ref HEAD 2> /dev/null || echo '_') | sed 's/^\([^_]\)/\\ue822 \0/' )/_/$DEFAULTICON}"
}

PROMPT='%{$bg[$BG1]%}%{$fg[$FG1]%} %(!.#.ʎ) %{$bg[$BG2]%}%{$fg[$BG1]%}$SEP%{$bg[$BG2]%}%{$fg[$BG1]%} %c %{$bg[$BG3]%}%{$fg[$BG2]%}$SEP \
%{$fg[$FG3]%}$(gitb) %k%{$fg[$BG3]%}$SEP%(!.#.)%{$reset_color%} '

PROMPT2='%{$fg[red]%}\ %{$reset_color%}'


#/mnt/c/Users
RPS1='%{$bg[$BG4]%}%{$fg[$FG4]%} ${${PWD/$HOME/~}//\// $SEPHALF } %k%{$fg[$BG4]%}$SEP%{$reset_color%}${return_code}'


ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}:: %{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$fg[yellow]%}"
