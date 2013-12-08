# TAGS: push
function gps --description="git push"
  emit __gishtank_command_called_event

  # IMPROVE!
  git push $argv
  gls
end
