# TAGS: reset, hard
function gdanger --description="git reset --hard"
  emit __gishtank_command_called_event

  set -l revision

  if test (count $argv) -ne 1
    set revision "HEAD"
  else
    set revision $argv[1]
  end

  git reset --hard $revision
  gls
end
