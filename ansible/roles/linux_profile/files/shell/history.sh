# Append instead of overwrite
shopt -s histappend

# Preserve multiline commands
shopt -s cmdhist
shopt -s lithist

# Unlimited history
HISTSIZE=
HISTFILESIZE=

# Timestamps
HISTTIMEFORMAT="%F %T "

# Keep everything (no filtering)
unset HISTCONTROL
unset HISTIGNORE

# Real-time persistence + sync
PROMPT_COMMAND="history -a; history -n"