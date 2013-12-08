# TAGS: diff, commit
function gdl --description="git diff last commit"
  emit __gishtank_command_called_event

  # TODO: Add the option to diff a particular file in the last commit
  git diff HEAD^..HEAD
end
