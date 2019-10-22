## Make sure apps know about `.config`
XDG_CONFIG_HOME=$HOME/.config

## Define a place for all ZSH configuration files
ZDOTDIR=$XDG_CONFIG_HOME/zsh
## Define a place for all TMux configuration files
TMUXDIR=$XDG_CONFIG_HOME/tmux
## Define a place for all iTerm2 integration files
ITERMDIR=$XDG_CONFIG_HOME/iterm2
## Make GnuPG to use XDG configuration dir
GNUPGHOME=$XDG_CONFIG_HOME/gnupg

## Define a place for local installation of tools
USER_LOCAL_HOME=$HOME/.local

## Define where the available JDK is installed
JAVA_HOME=$USER_LOCAL_HOME/opt/jenv/versions/1.8
## Define where the Android SDK should be installed
ANDROID_HOME=/usr/local/share/android-sdk
