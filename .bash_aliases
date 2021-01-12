export LS_OPTIONS='--color=auto -h'
eval "`dircolors`"
alias ll='ls $LS_OPTIONS -la'
alias ls='ls $LS_OPTIONS'
alias l='ls $LS_OPTIONS -l'
# Some more alias to avoid making mistakes:
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'

# faster navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias llw='ls $LS_OPTIONS --group-directories-first -la'

# debian commands
alias architecture='dpkg --print-architecture'

# system
alias fd=fdfind