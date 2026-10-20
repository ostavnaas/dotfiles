#compdef cheat


_fzf_cheat_complete_personal_cheatsheets()
{
  cheats=("${(f)$(cheat -l -t personal | tail -n +2 | cut -d' ' -f1)}")
  _describe -t cheats 'cheats' cheats
}


_cheat_complete_full_cheatsheets()
{
  cheats=("${(f)$(cheat -l | tail -n +2 | cut -d' ' -f1)}")
  _describe -t cheats 'cheats' cheats
}

_cheat_complete_tags()
{
  taglist=("${(f)$(cheat -T)}")
  _describe -t taglist 'taglist' taglist
}

_cheat_complete_paths()
{
  pathlist=("${(f)$(cheat -d | cut -d':' -f1)}")
  _describe -t pathlist 'pathlist' pathlist
}

_cheat() {
  local curcontext="$curcontext" state line
  typeset -A opt_args

  # -A '-*': stop offering flags once the cheatsheet has been given
  _arguments -C -s -A '-*' \
      '(-a --all)'{-a,--all}'[search among all cheatpaths]' \
      '(-b --brief)'{-b,--brief}'[list cheatsheets without file paths]' \
      '(-c --colorize)'{-c,--colorize}'[colorize output]' \
      '(- :)--completion[generate shell completion script]:shell:(bash zsh fish powershell)' \
      '(- :)--conf[display the config file path]' \
      '(- :)'{-d,--directories}'[list cheatsheet directories]' \
      '(- :)'{-e,--edit}'[edit cheatsheet]:cheatsheet:->full' \
      '(- :)'{-h,--help}'[help for cheat]' \
      '(- :)--init[write a default config file to stdout]' \
      '(-l --list)'{-l,--list}'[list cheatsheets]' \
      '(-p --path)'{-p,--path}'[return only sheets found on cheatpath]:cheatpath:->pathlist' \
      '(-r --regex)'{-r,--regex}'[treat search phrase as a regex]' \
      '(- :)--rm[remove (delete) cheatsheet]:cheatsheet:->full' \
      '(-s --search)'{-s,--search}'[search cheatsheets for phrase]:phrase: ' \
      '(-t --tag)'{-t,--tag}'[return only sheets matching tag]:tag:->taglist' \
      '(- :)'{-T,--tags}'[list all tags in use]' \
      '(- :)'{-u,--update}'[update git-backed cheatpaths]' \
      '(- :)'{-v,--version}'[print the version number]' \
      ':cheatsheet:->personal' \
    && return 0

  case $state in
    (full)
      _cheat_complete_full_cheatsheets
      ;;
    (personal)
      _fzf_cheat_complete_personal_cheatsheets
      ;;
    (taglist)
      _cheat_complete_tags
      ;;
    (pathlist)
      _cheat_complete_paths
      ;;
  esac
}

compdef _cheat cheat
