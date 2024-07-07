#compdef cheat


_fzf_cheat_complete_personal_cheatsheets()
{
  cheats=("${(f)$(cheat -l -t personal | tail -n +2 | cut -d' ' -f1)}")
  _describe -t cheats 'cheats' cheats


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

  _arguments -C \
      ': :->personal' \

  case $state in
    (none)
      ;;
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
    (*)
      ;;
  esac
}

compdef _cheat cheat
