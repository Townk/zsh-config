ITERMDIR=$HOME/.config/iterm2
ZDOTDIR=$HOME/.config/zsh
PATH=$HOME/.local/bin:$PATH
if [[ -a $ZDOTDIR/.zshenv ]]; then
    . $ZDOTDIR/.zshenv
fi
