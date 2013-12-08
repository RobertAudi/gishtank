# TAGS: merge
function gm --description="git merge"
  emit __gishtank_command_called_event

  # IMPROVE!
  git merge $argv
  gls
end
