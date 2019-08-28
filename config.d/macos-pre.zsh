# # --------------------------------------------------------------------
# # Configuration file for Z Shell Specific for macOS system
# # By: Thiago Alves
# # Last Update: August, 16 2019
# # --------------------------------------------------------------------


# # --------------------------------------------------------------------
# # Contents:
# # --------
# # 2. Environment Options
# # --------------------------------------------------------------------

# Use this file to configure options specific for a macOS system. Notice
# that not all sessions are listed here. This is on purpose to prevent
# any override on sessions that were not intended to be overriden.

# # --------------------------------------------------------------------
# # 2. Environment Options
# # --------------------------------------------------------------------
# Environment variables and shell options specific for macOS

# search path for zsh functions  (fpath ==> function path)
fpath=(                                  \
        ${ZDOTDIR:-$HOME}/functions      \
        /usr/local/share/zsh-completions \
        ${fpath}                         \
      )
