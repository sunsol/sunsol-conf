#!/bin/bash

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -i'
alias cp='cp -i -v'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias du='du -kh'
alias df='df -kTh'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias cctags='ctags --language-force=c++ --c++-kinds=+p --fields=+iaS --extra=+q -I "__nonnull __dead2 __pure2 __unused __packed __aligned __section __always_inline __wur __THROW __attribute_pure__ __attribute__ __asm G_GNUC_PURE G_GNUC_MALLOC G_GNUC_NULL_TERMINTED G_GNUC_ALLOC_SIZE G_GNUC_ALLOC_SIZE2 G_GNUC_PRINTF G_GNUC_SCANF G_GNUC_FORMAT G_GNUC_NORETURN G_GNUC_CONST G_GNUC_UNUSED G_GNUC_NO_INSTRUMENT" '
