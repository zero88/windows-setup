#### Based on zsh half life them

# prompt style and colors based on Steve Losh's Prose theme:
# https://github.com/sjl/oh-my-zsh/blob/master/themes/prose.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# https://briancarper.net/blog/570/git-info-in-your-zsh-prompt

#use extended color palette if available
if [[ $TERM = (*256color|*rxvt*) ]]; then
  turquoise="%{${(%):-"%F{81}"}%}"
  orange="%{${(%):-"%F{166}"}%}"
  yellow="%{${(%):-"%F{011}"}%}"
  purple="%{${(%):-"%F{135}"}%}"
  hotpink="%{${(%):-"%F{124}"}%}"
  limegreen="%{${(%):-"%F{118}"}%}"
  emerald="%{${(%):-"%F{028}"}%}"
else
  turquoise="%{${(%):-"%F{cyan}"}%}"
  orange="%{${(%):-"%F{yellow}"}%}"
  yellow="%{${(%):-"%F{yellow}"}%}"
  purple="%{${(%):-"%F{magenta}"}%}"
  hotpink="%{${(%):-"%F{red}"}%}"
  limegreen="%{${(%):-"%F{green}"}%}"
  emerald="%{${(%):-"%F{green}"}%}"
fi

autoload -Uz vcs_info
# enable VCS systems you use
zstyle ':vcs_info:*' enable git svn

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
function vcs_status {
  echo "${turquoise}(%b$1${turquoise})"
}

# stagedstr-unstagedstr-untrack
FMT_STATUS="%c%u"
PR_RST="%{${reset_color}%}"
FMT_BRANCH=$(vcs_status ${FMT_STATUS})${PR_RST}
FMT_ACTION=" performing a ${limegreen}%a${PR_RST}"
FMT_STAGED=" ${limegreen}●${PR_RST}"
FMT_UNSTAGED="${yellow}●${PR_RST}"
FMT_UNTRACK="${hotpink}●${PR_RST}"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""


function steeef_chpwd {
  PR_GIT_UPDATE=1
}

function steeef_preexec {
  case "$2" in
  *git*|*svn*) PR_GIT_UPDATE=1 ;;
  esac
}

function steeef_precmd {
  (( PR_GIT_UPDATE )) || return

  # check for untracked files or updated submodules, since vcs_info doesn't
  if [[ -n "$(git ls-files --other --exclude-standard 2>/dev/null)" ]]; then
    PR_GIT_UPDATE=1
    FMT_BRANCH="${PM_RST}$(vcs_status "${FMT_STATUS}${FMT_UNTRACK}")${PR_RST}"
  else
    FMT_BRANCH="${PM_RST}$(vcs_status "${FMT_STATUS}")${PR_RST}"
  fi
  zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"

  vcs_info 'prompt'
  PR_GIT_UPDATE=
}

# vcs_info running hooks
PR_GIT_UPDATE=1

autoload -U add-zsh-hook
add-zsh-hook chpwd steeef_chpwd
add-zsh-hook precmd steeef_precmd
add-zsh-hook preexec steeef_preexec

setopt prompt_subst
_USER="%B${emerald}%n%{$PR_RST%}"
_DIR="${orange}%c/%b%{$PR_RST%}"
_STATUS="\$vcs_info_msg_0_"
_HALFLIFE="${orange}λ%{$PR_RST%}"
PROMPT="$_USER:$_DIR $_STATUS $_HALFLIFE "
