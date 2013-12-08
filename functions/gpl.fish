# TAGS: pull
function gpl --description="git pull"
  emit __gishtank_command_called_event

  # IMPROVE!
  git pull $argv
  gls
end
