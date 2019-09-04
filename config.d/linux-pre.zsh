# # --------------------------------------------------------------------
# # Configuration file for Z Shell Specific for Linux system
# # By: Thiago Alves
# # Last Update: August, 16 2019
# # --------------------------------------------------------------------


# # --------------------------------------------------------------------
# # Contents:
# # --------
# # 2. Environment Options
# # --------------------------------------------------------------------

# Use this file to configure options specific for a Linux system. Notice
# that not all sessions are listed here. This is on purpose to prevent
# any override on sessions that were not intended to be overriden.

# # --------------------------------------------------------------------
# # 2. Environment Options
# # --------------------------------------------------------------------
# Environment variables and shell options specific for Linux

# search path for zsh functions  (fpath ==> function path)
fpath=(                                     \
        "${fpath[@]}"                       \
        /usr/local/share/zsh/site-functions \
      )
