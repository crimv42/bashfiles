source ~/.bashrc.d/kube-ps1.bash
# Git prompt
prompt_git() {
        local s='';
        local branchName='';

        # Check if the current directory is in a Git repository.
        if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

                # check if the current directory is in .git before running git checks
                if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

                        # Ensure the index is up to date.
                        git update-index --really-refresh -q &>/dev/null;

                        # Check for uncommitted changes in the index.
                        if ! $(git diff --quiet --ignore-submodules --cached); then
                                s+='+';
                        fi;

                        # Check for unstaged changes.
                        if ! $(git diff-files --quiet --ignore-submodules --); then
                                s+='!';
                        fi;

                        # Check for untracked files.
                        if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                                s+='?';
                        fi;

                        # Check for stashed files.
                        if $(git rev-parse --verify refs/stash &>/dev/null); then
                                s+='$';
                        fi;

                fi;

                # Get the short symbolic ref.
                # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
                # Otherwise, just give up.
                branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
                        git rev-parse --short HEAD 2> /dev/null || \
                        echo '(unknown)')";

                [ -n "${s}" ] && s=" [${s}]";

                echo -e "${1}${branchName}${blue}${s}";
        else
                return;
        fi;
}

TITLEBAR='\[\e]0;\u@\h:\w\a\]'

# Colors
teal="\[\033[38;5;45m\]";
pink="\[\033[38;5;163m\]";
pink2="\[\033[38;5;207m\]";
purple="\[\033[38;5;99m\]";
green="\[\033[38;5;49m\]";
white="\[\033[38;5;15m\]";
reset="\[$(tput sgr0)\]";
bold="\[$(tput bold)\]";

# This will be the deafult prompt
if ! [ -x "$(command -v kubectl)" ]; then
    PS1="${pink}[";
else
    PS1="\$(kube_ps1)";
    PS1+="${pink}[";
fi
PS1+="${TITLEBAR}${teal}\u";
PS1+="${reset}${pink}@";
PS1+="${reset}${pink2}${bold}\h";
PS1+="${reset}${pink}:";
PS1+="${reset}${purple}${bold}\w";
PS1+="\$(prompt_git \"${white} on ${purple}\")";
PS1+="${reset}${pink}]";
PS1+="${reset}${green}\n\\$";
PS1+="${reset} ";
export PS1

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

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
