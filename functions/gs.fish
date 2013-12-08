# TAGS: status
function gs --description="git status"
  emit __gishtank_command_called_event

  # IMPROVE!
  git status
end
